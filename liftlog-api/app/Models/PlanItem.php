<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class PlanItem extends Model
{
    protected $guarded = [];

    protected $casts = [
        'day_number' => 'integer',
        'position' => 'integer',
        'target_sets' => 'integer',
        'target_reps' => 'integer',
        'target_duration_seconds' => 'integer',
        'weight_kg' => 'float',
        'rest_seconds' => 'integer',
    ];

    public function exercise(): BelongsTo
    {
        return $this->belongsTo(Exercise::class);
    }

    public function plan(): BelongsTo
    {
        return $this->belongsTo(WorkoutPlan::class, 'workout_plan_id');
    }
}