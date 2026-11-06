<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class WorkoutSession extends Model
{
    protected $casts = ['started_at' => 'datetime', 'ended_at' => 'datetime'];
    public function user() 
    { 
        return $this->belongsTo(User::class); 
    }
    public function plan() 
    { 
        return $this->belongsTo(WorkoutPlan::class, 'workout_plan_id'); 
    }
    public function sets() 
    { 
        return $this->hasMany(WorkoutSet::class); 
    }
}
