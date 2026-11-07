<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\ProgramTemplate;
use Illuminate\Http\Request;

class ProgramTemplateController extends Controller
{

    public function index(Request $request)
    {
        $request->validate([
            'level' => 'sometimes|in:beginner,intermediate,advanced',
            'goal' => 'sometimes|in:muscle,stamina,general',
            'days' => 'sometimes|integer|between:2,4',
        ]);

        return ProgramTemplate::query()
            ->when($request->filled('level'), fn ($q) => $q->where('level', $request->input('level')))
            ->when($request->filled('goal'), fn ($q) => $q->where('goal', $request->input('goal')))
            ->when($request->filled('days'), fn ($q) => $q->where('days', $request->integer('days')))
            ->with([
                'items' => fn ($q) => $q->orderBy('day_number')->orderBy('position'),
                'items.exercise:id,name,type,kind,camera_position',
            ])
            ->withCount('items')
            ->orderBy('days')
            ->orderBy('id')
            ->get();
    }

    public function show(ProgramTemplate $programTemplate)
    {
        return $programTemplate->load([
            'items' => fn ($q) => $q->orderBy('day_number')->orderBy('position'),
            'items.exercise',
        ]);
    }
}