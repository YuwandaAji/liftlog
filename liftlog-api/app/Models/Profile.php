<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Profile extends Model
{
    protected $guarded = [];

    protected $casts = [
        'experience' => 'integer',
        'frequency' => 'integer',
        'training_days_count' => 'integer',
        'age' => 'integer',
        'weight_kg' => 'float',
        'height_cm' => 'float',
        'activity_factor' => 'float',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
}