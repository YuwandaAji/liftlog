<?php

namespace App\Services;

use App\Models\Profile;
use App\Models\ProgramTemplate;

class TemplateRecommender
{
    private const LEVELS = ['beginner', 'intermediate', 'advanced'];

    /**
     * @return array{match: string, template: ?ProgramTemplate}|null
     *         null bila data profil belum lengkap (onboarding belum selesai);
     *         template null bila tabel template kosong.
     */
    public function recommend(Profile $profile, ?int $days = null): ?array
    {
        $days ??= $profile->training_days_count;

        if ($profile->level === null || $profile->goal === null || $days === null) {
            return null;
        }

        // Level sendiri dulu, lalu turun satu per satu sampai beginner.
        $index = array_search($profile->level, self::LEVELS, true);
        $levels = array_reverse(array_slice(self::LEVELS, 0, $index + 1));

        $attempts = [
            'exact' => fn ($q) => $q->where('level', $profile->level)
                ->where('goal', $profile->goal)
                ->where('days', $days),
        ];

        foreach ($levels as $i => $level) {
            $key = $i === 0 ? 'level_days' : ($level === 'beginner' ? 'beginner_days' : 'lower_level_days');
            $attempts[$key] = fn ($q) => $q->where('level', $level)->where('days', $days);
        }

        // CAST agar selisih negatif tidak error pada kolom UNSIGNED
        $attempts['beginner_nearest'] = fn ($q) => $q->where('level', 'beginner')
            ->orderByRaw('ABS(CAST(days AS SIGNED) - ?)', [$days]);

        foreach ($attempts as $match => $scope) {
            $query = ProgramTemplate::query();
            $scope($query);
            $template = $query->orderBy('days')->orderBy('id')->first();

            if ($template) {
                return [
                    'match' => $match,
                    'template' => $template->load([
                        'items' => fn ($q) => $q->orderBy('day_number')->orderBy('position'),
                        'items.exercise',
                    ]),
                ];
            }
        }

        return ['match' => 'none', 'template' => null];
    }
}