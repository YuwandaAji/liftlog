<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class PlanSchedule extends Model
{
    public function plan() 
    { 
        return $this->belongsTo(WorkoutPlan::class, 'workout_plan_id'); 
    }
}
