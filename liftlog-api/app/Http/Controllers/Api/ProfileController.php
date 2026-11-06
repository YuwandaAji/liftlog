<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Arr;

class ProfileController extends Controller
{
    private const ACTIVITY = [
        'sedentary' => 1.2,
        'light'     => 1.375,
        'moderate'  => 1.55,
        'active'    => 1.725,
    ];

    public function show(Request $request)
    {
        return $request->user()->profile;
    }

    public function update(Request $request)
    {
        $data = $request->validate([
            'goal'                => 'sometimes|in:muscle,stamina,general',
            'experience'          => 'sometimes|integer|between:0,2',
            'frequency'           => 'sometimes|integer|between:0,2',
            'training_weekdays'   => 'sometimes|array|min:2|max:4',
            'training_weekdays.*' => 'integer|between:1,7|distinct',
            'weight_kg'           => 'sometimes|numeric|between:20,300',
            'height_cm'           => 'sometimes|numeric|between:100,250',
            'age'                 => 'sometimes|integer|between:13,100',
            'gender'              => 'sometimes|in:male,female',
            'activity_level'      => 'sometimes|in:sedentary,light,moderate,active',
        ]);

        $profile = $request->user()->profile;
        $profile->fill(Arr::except($data, ['training_weekdays', 'activity_level']));

        if (isset($data['training_weekdays'])) {
            $profile->training_days_count = count($data['training_weekdays']);
        }

        if (isset($data['activity_level'])) {
            $profile->activity_factor = self::ACTIVITY[$data['activity_level']];
        }

        // Level: score = experience + frequency (0-4)
        if ($profile->experience !== null && $profile->frequency !== null) {
            $score = $profile->experience + $profile->frequency;
            $profile->level = $score <= 1 ? 'beginner' : ($score <= 3 ? 'intermediate' : 'advanced');
        }

        $profile->save();

        return $profile;
    }
}