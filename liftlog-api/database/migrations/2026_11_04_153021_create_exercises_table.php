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
        Schema::create('exercises', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->enum('type', ['bodyweight', 'dumbbell']);
            $table->enum('kind', ['reps', 'duration']);
            $table->string('joint_a'); $table->string('joint_b'); $table->string('joint_c');
            $table->unsignedSmallInteger('lower_angle');
            $table->unsignedSmallInteger('upper_angle');
            $table->string('target_muscle');
            $table->string('youtube_id')->nullable();
            $table->string('video_source')->nullable();
            $table->text('steps')->nullable();
            $table->text('common_mistakes')->nullable();
            $table->enum('camera_position', ['side', 'front']);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('exercises');
    }
};

