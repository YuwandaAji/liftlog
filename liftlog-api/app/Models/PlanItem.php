<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class PlanItem extends Model
{
    public function exercise() 
    { 
        return $this->belongsTo(Exercise::class); 
    }
    public function plan()     
    { 
        return $this->belongsTo(WorkoutPlan::class, 'workout_plan_id'); 
    }  
}
