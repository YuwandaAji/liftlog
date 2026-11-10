<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class WorkoutPlan extends Model
{
    protected $guarded = [];

    protected $casts = [
        'is_active' => 'boolean',
        'days_per_week' => 'integer',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function items(): HasMany
    {
        return $this->hasMany(PlanItem::class);
    }

    public function schedules(): HasMany
    {
        return $this->hasMany(PlanSchedule::class);
    }
}