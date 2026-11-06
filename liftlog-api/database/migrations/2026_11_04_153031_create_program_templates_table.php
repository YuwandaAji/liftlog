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
        Schema::create('program_templates', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->enum('level', ['beginner', 'intermediate', 'advanced']);
            $table->enum('goal', ['muscle', 'stamina', 'general']);
            $table->unsignedTinyInteger('days');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('program_templates');
    }
};
