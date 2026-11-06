<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class WorkoutPlan extends Model
{
    protected $casts = ['is_active' => 'boolean'];
    public function user()      
    { 
        return $this->belongsTo(User::class); 
    }
    public function items()     
    { 
        return $this->hasMany(PlanItem::class); 
    }
    public function schedules() 
    { 
        return $this->hasMany(PlanSchedule::class); 
    }
}
