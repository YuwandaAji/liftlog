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
        Schema::create('workout_sets', function (Blueprint $table) {
            $table->id();
            $table->foreignId('workout_session_id')->constrained()->cascadeOnDelete();
            $table->foreignId('exercise_id')->constrained();
            $table->unsignedTinyInteger('set_number');
            $table->unsignedSmallInteger('valid_reps')->default(0);
            $table->unsignedSmallInteger('total_reps')->default(0);
            $table->unsignedSmallInteger('duration_seconds')->nullable();
            $table->decimal('weight_kg', 5, 1)->nullable();
            $table->decimal('form_score', 4, 3)->nullable();   // 0.000 - 1.000
            $table->unsignedSmallInteger('actual_rest_seconds')->nullable();
            $table->index(['exercise_id', 'workout_session_id']);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('workout_sets');
    }
};
