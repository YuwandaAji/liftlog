<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class ProgramTemplateItem extends Model
{
    protected $guarded = [];

    protected $casts = [
        'day_number' => 'integer',
        'position' => 'integer',
        'target_sets' => 'integer',
        'target_reps' => 'integer',
        'target_duration_seconds' => 'integer',
        'weight_kg' => 'float',
    ];

    public function exercise(): BelongsTo
    {
        return $this->belongsTo(Exercise::class);
    }
}