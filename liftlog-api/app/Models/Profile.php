<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;


class Profile extends Model
{
    protected $casts = [
        'weight_kg'       => 'float',
        'height_cm'       => 'float',
        'activity_factor' => 'float',
    ];
    public function user() 
    { 
        return $this->belongsTo(User::class); 
    }
    
}
