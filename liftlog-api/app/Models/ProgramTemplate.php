<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ProgramTemplate extends Model
{
    public function items() 
    { 
        return $this->hasMany(ProgramTemplateItem::class); 
    }
}
