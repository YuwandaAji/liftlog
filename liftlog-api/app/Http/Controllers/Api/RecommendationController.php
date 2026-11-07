<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Services\TemplateRecommender;
use Illuminate\Http\Request;

class RecommendationController extends Controller
{
    public function __invoke(Request $request, TemplateRecommender $recommender)
    {
        $request->validate(['days' => 'sometimes|integer|between:2,4']);

        $profile = $request->user()->profile;
        $result = $profile
            ? $recommender->recommend($profile, $request->integer('days') ?: null)
            : null;

        if ($result === null) {
            return response()->json(['message' => 'Lengkapi onboarding terlebih dahulu.'], 422);
        }

        if ($result['template'] === null) {
            return response()->json(['message' => 'Belum ada template program.'], 404);
        }

        return response()->json($result);
    }
}