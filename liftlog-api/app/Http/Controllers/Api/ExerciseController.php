<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Exercise;
use Illuminate\Http\Request;

class ExerciseController extends Controller
{
    public function index(Request $request)
    {
        return Exercise::query()
            ->when($request->type, fn ($q, $type) => $q->where('type', $type))
            ->orderBy('id')
            ->get();
    }

    public function show(Exercise $exercise)
    {
        return $exercise;
    }
}