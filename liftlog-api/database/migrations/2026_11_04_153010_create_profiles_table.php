<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('profiles', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->unique()->constrained()->cascadeOnDelete();
            $table->enum('goal', ['muscle', 'stamina', 'general'])->nullable();
            $table->unsignedTinyInteger('experience')->nullable();          // 0-2
            $table->unsignedTinyInteger('frequency')->nullable();           // 0-2
            $table->unsignedTinyInteger('training_days_count')->nullable(); // 2-4
            $table->decimal('weight_kg', 5, 2)->nullable();
            $table->decimal('height_cm', 5, 2)->nullable();
            $table->unsignedTinyInteger('age')->nullable();
            $table->enum('gender', ['male', 'female'])->nullable();
            $table->decimal('activity_factor', 4, 3)->nullable();           // 1.2 / 1.375 / 1.55 / 1.725
            $table->enum('level', ['beginner', 'intermediate', 'advanced'])->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('profiles');
    }
};