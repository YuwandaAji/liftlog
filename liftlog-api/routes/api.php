<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\ExerciseController;
use App\Http\Controllers\Api\ProfileController;
use App\Http\Controllers\Api\ProgramTemplateController;
use App\Http\Controllers\Api\RecommendationController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/profile', [ProfileController::class, 'show']);
    Route::put('/profile', [ProfileController::class, 'update']);
    Route::get('/exercises', [ExerciseController::class, 'index']);
    Route::get('/exercises/{exercise}', [ExerciseController::class, 'show']);
    Route::get('/program-templates', [ProgramTemplateController::class, 'index']);
    Route::get('/program-templates/{programTemplate}', [ProgramTemplateController::class, 'show']);
    Route::get('/recommendation', RecommendationController::class);
});