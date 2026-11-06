<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class WorkoutSet extends Model
{
    public function session()  
    { 
        return $this->belongsTo(WorkoutSession::class, 'workout_session_id'); 
    }
    public function exercise() 
    { 
        return $this->belongsTo(Exercise::class); 
    }
}
