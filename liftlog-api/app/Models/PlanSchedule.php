<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class PlanSchedule extends Model
{
    protected $guarded = [];

    protected $casts = [
        'weekday' => 'integer',
        'day_number' => 'integer',
    ];

    public function plan(): BelongsTo
    {
        return $this->belongsTo(WorkoutPlan::class, 'workout_plan_id');
    }
}