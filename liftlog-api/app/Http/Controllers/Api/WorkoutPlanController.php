<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\ProgramTemplate;
use App\Models\WorkoutPlan;
use App\Services\TemplateRecommender;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class WorkoutPlanController extends Controller
{
    private const REST_SECONDS = ['bodyweight' => 60, 'dumbbell' => 90];

    public function index(Request $request)
    {
        return WorkoutPlan::where('user_id', $request->user()->id)
            ->withCount('items')
            ->orderByDesc('is_active')
            ->orderByDesc('id')
            ->get();
    }

    public function show(Request $request, WorkoutPlan $workoutPlan)
    {
        abort_unless($workoutPlan->user_id === $request->user()->id, 404);

        return $this->loaded($workoutPlan);
    }

    public function generate(Request $request, TemplateRecommender $recommender)
    {
        $data = $request->validate([
            'weekdays' => 'required|array|min:2|max:4',
            'weekdays.*' => 'integer|between:1,7|distinct',
            'template_id' => 'nullable|integer|exists:program_templates,id',
        ]);

        $user = $request->user();
        $weekdays = collect($data['weekdays'])->map(fn ($d) => (int) $d)->sort()->values();

        if (!empty($data['template_id'])) {
            $template = ProgramTemplate::with([
                'items' => fn ($q) => $q->orderBy('day_number')->orderBy('position'),
                'items.exercise',
            ])->findOrFail($data['template_id']);
        } else {
            $profile = $user->profile;
            $result = $profile ? $recommender->recommend($profile, $weekdays->count()) : null;

            if ($result === null) {
                return response()->json(['message' => 'Lengkapi onboarding terlebih dahulu.'], 422);
            }
            if ($result['template'] === null) {
                return response()->json(['message' => 'Belum ada template program.'], 404);
            }

            $template = $result['template'];
        }

        $used = min($weekdays->count(), $template->days);

        $plan = DB::transaction(function () use ($user, $template, $weekdays, $used) {
            // Rencana lama dinonaktifkan, tidak dihapus (riwayat sesi tetap punya acuan).
            WorkoutPlan::where('user_id', $user->id)
                ->where('is_active', true)
                ->update(['is_active' => false]);

            $plan = WorkoutPlan::create([
                'user_id' => $user->id,
                'name' => $template->name,
                'days_per_week' => $used,
                'is_active' => true,
            ]);

            foreach ($weekdays->take($used)->values() as $i => $weekday) {
                $plan->schedules()->create(['weekday' => $weekday, 'day_number' => $i + 1]);
            }

            foreach ($template->items->where('day_number', '<=', $used) as $item) {
                $plan->items()->create([
                    'exercise_id' => $item->exercise_id,
                    'day_number' => $item->day_number,
                    'position' => $item->position,
                    'target_sets' => $item->target_sets,
                    'target_reps' => $item->target_reps,
                    'target_duration_seconds' => $item->target_duration_seconds,
                    'weight_kg' => $item->weight_kg,
                    'rest_seconds' => self::REST_SECONDS[$item->exercise->type] ?? 60,
                ]);
            }

            return $plan;
        });

        return response()->json($this->loaded($plan), 201);
    }

    public function today(Request $request)
    {
        $plan = WorkoutPlan::where('user_id', $request->user()->id)
            ->where('is_active', true)
            ->latest('id')
            ->first();

        $weekday = now()->dayOfWeekIso; // Senin = 1

        if (!$plan) {
            return response()->json([
                'plan' => null,
                'weekday' => $weekday,
                'scheduled' => false,
                'day_number' => null,
                'schedules' => [],
                'items' => [],
            ]);
        }

        $schedules = $plan->schedules()->orderBy('weekday')->get(['weekday', 'day_number']);
        $todayRow = $schedules->firstWhere('weekday', $weekday);

        $items = $todayRow
            ? $plan->items()
                ->where('day_number', $todayRow->day_number)
                ->orderBy('position')
                ->with('exercise')
                ->get()
            : collect();

        return response()->json([
            'plan' => $plan->only(['id', 'name', 'days_per_week']),
            'weekday' => $weekday,
            'scheduled' => $todayRow !== null,
            'day_number' => $todayRow?->day_number,
            'schedules' => $schedules,
            'items' => $items,
        ]);
    }

    private function loaded(WorkoutPlan $plan): WorkoutPlan
    {
        return $plan->load([
            'items' => fn ($q) => $q->orderBy('day_number')->orderBy('position'),
            'items.exercise',
            'schedules' => fn ($q) => $q->orderBy('weekday'),
        ]);
    }
}