<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('program_template_items', function (Blueprint $table) {
            $table->id();
            $table->foreignId('program_template_id')->constrained()->cascadeOnDelete();
            $table->foreignId('exercise_id')->constrained();
            $table->unsignedTinyInteger('day_number');
            $table->unsignedTinyInteger('position');
            $table->unsignedTinyInteger('target_sets');
            $table->unsignedSmallInteger('target_reps')->nullable();
            $table->unsignedSmallInteger('target_duration_seconds')->nullable();
            $table->decimal('weight_kg', 5, 1)->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('program_template_items');
    }
};
