<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class ProgramTemplate extends Model
{
    protected $guarded = [];

    protected $casts = [
        'days' => 'integer',
    ];

    public function items(): HasMany
    {
        return $this->hasMany(ProgramTemplateItem::class);
    }
}