<?php

namespace Database\Seeders;

use App\Models\Exercise;
use App\Models\ProgramTemplate;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class ProgramTemplateSeeder extends Seeder
{
    public function run(): void
    {
        $ids = Exercise::pluck('id', 'name');

        DB::transaction(function () use ($ids) {
            foreach ($this->templates() as $t) {
                $template = ProgramTemplate::updateOrCreate(
                    ['name' => $t['name']],
                    ['level' => $t['level'], 'goal' => $t['goal'], 'days' => count($t['plan'])],
                );

                $template->items()->delete();

                foreach ($t['plan'] as $dayIndex => $items) {
                    foreach ($items as $pos => $item) {
                        if (!isset($ids[$item['exercise']])) {
                            throw new \RuntimeException(
                                "Gerakan '{$item['exercise']}' tidak ditemukan. Jalankan ExerciseSeeder dulu."
                            );
                        }

                        $template->items()->create([
                            'exercise_id' => $ids[$item['exercise']],
                            'day_number' => $dayIndex + 1,
                            'position' => $pos + 1,
                            'target_sets' => $item['sets'],
                            'target_reps' => $item['reps'] ?? null,
                            'target_duration_seconds' => $item['seconds'] ?? null,
                            'weight_kg' => $item['kg'] ?? null,
                        ]);
                    }
                }
            }
        });
    }

    private static function reps(string $exercise, int $sets, int $reps, ?float $kg = null): array
    {
        return ['exercise' => $exercise, 'sets' => $sets, 'reps' => $reps, 'kg' => $kg];
    }

    private static function hold(string $exercise, int $sets, int $seconds): array
    {
        return ['exercise' => $exercise, 'sets' => $sets, 'seconds' => $seconds];
    }

    private function templates(): array
    {
        // Pemula: bodyweight saja, dua sesi full body bergantian (A dan B)
        $a = [
            self::reps('Squat', 3, 10),
            self::reps('Push-up', 3, 5),
            self::reps('Crunch', 3, 10),
            self::hold('Forearm Plank', 3, 20),
        ];
        $b = [
            self::reps('Squat', 3, 12),
            self::reps('Crunch', 3, 12),
            self::reps('Push-up', 3, 6),
            self::hold('Forearm Plank', 3, 25),
        ];

        return [
            [
                'name' => 'Pemula Full Body 2 Hari',
                'level' => 'beginner',
                'goal' => 'general',
                'plan' => [$a, $b],
            ],
            [
                'name' => 'Pemula Full Body 3 Hari',
                'level' => 'beginner',
                'goal' => 'general',
                'plan' => [$a, $b, $a],
            ],
            [
                'name' => 'Pemula Full Body 4 Hari',
                'level' => 'beginner',
                'goal' => 'general',
                'plan' => [$a, $b, $a, $b],
            ],
            [
                'name' => 'Menengah Kekuatan 3 Hari',
                'level' => 'intermediate',
                'goal' => 'muscle',
                'plan' => [
                    [
                        self::reps('Dumbbell Squat', 4, 10, 5),
                        self::reps('Crunch', 3, 15),
                        self::hold('Forearm Plank', 3, 40),
                    ],
                    [
                        self::reps('Push-up', 4, 10),
                        self::reps('Zottman Curl', 3, 10, 4),
                        self::reps('Dumbbell Lateral Raise', 3, 12, 2),
                    ],
                    [
                        self::reps('Dumbbell Squat', 3, 12, 5),
                        self::reps('Neutral Grip Front Raise', 3, 12, 2),
                        self::reps('Push-up', 3, 10),
                        self::hold('Forearm Plank', 3, 45),
                    ],
                ],
            ],
            [
                'name' => 'Lanjut Kekuatan 4 Hari',
                'level' => 'advanced',
                'goal' => 'muscle',
                'plan' => [
                    [
                        self::reps('Dumbbell Squat', 4, 12, 8),
                        self::reps('Crunch', 4, 20),
                        self::hold('Forearm Plank', 3, 60),
                    ],
                    [
                        self::reps('Push-up', 4, 15),
                        self::reps('Zottman Curl', 4, 10, 6),
                        self::reps('Dumbbell Lateral Raise', 4, 12, 3),
                    ],
                    [
                        self::reps('Squat', 4, 20),
                        self::reps('Dumbbell Squat', 3, 12, 8),
                        self::hold('Forearm Plank', 3, 60),
                    ],
                    [
                        self::reps('Push-up', 4, 15),
                        self::reps('Neutral Grip Front Raise', 4, 12, 3),
                        self::reps('Zottman Curl', 3, 12, 6),
                        self::reps('Crunch', 3, 20),
                    ],
                ],
            ],

                        [
                'name' => 'Menengah Kekuatan 2 Hari',
                'level' => 'intermediate',
                'goal' => 'muscle',
                'plan' => [
                    [
                        self::reps('Dumbbell Squat', 4, 10, 5),
                        self::reps('Push-up', 4, 10),
                        self::reps('Crunch', 3, 15),
                        self::hold('Forearm Plank', 3, 40),
                    ],
                    [
                        self::reps('Dumbbell Squat', 3, 12, 5),
                        self::reps('Zottman Curl', 3, 10, 4),
                        self::reps('Dumbbell Lateral Raise', 3, 12, 2),
                        self::reps('Neutral Grip Front Raise', 3, 12, 2),
                    ],
                ],
            ],
            [
                'name' => 'Menengah Kekuatan 4 Hari',
                'level' => 'intermediate',
                'goal' => 'muscle',
                'plan' => [
                    [
                        self::reps('Dumbbell Squat', 4, 10, 5),
                        self::reps('Crunch', 3, 15),
                        self::hold('Forearm Plank', 3, 40),
                    ],
                    [
                        self::reps('Push-up', 4, 10),
                        self::reps('Zottman Curl', 3, 10, 4),
                        self::reps('Dumbbell Lateral Raise', 3, 12, 2),
                    ],
                    [
                        self::reps('Dumbbell Squat', 3, 12, 5),
                        self::reps('Squat', 3, 15),
                        self::hold('Forearm Plank', 3, 45),
                    ],
                    [
                        self::reps('Push-up', 3, 12),
                        self::reps('Neutral Grip Front Raise', 3, 12, 2),
                        self::reps('Zottman Curl', 3, 10, 4),
                        self::reps('Crunch', 3, 15),
                    ],
                ],
            ],
            [
                'name' => 'Lanjut Kekuatan 2 Hari',
                'level' => 'advanced',
                'goal' => 'muscle',
                'plan' => [
                    [
                        self::reps('Dumbbell Squat', 4, 12, 8),
                        self::reps('Push-up', 4, 15),
                        self::reps('Crunch', 4, 20),
                        self::hold('Forearm Plank', 3, 60),
                    ],
                    [
                        self::reps('Dumbbell Squat', 3, 12, 8),
                        self::reps('Zottman Curl', 4, 10, 6),
                        self::reps('Dumbbell Lateral Raise', 4, 12, 3),
                        self::reps('Neutral Grip Front Raise', 3, 12, 3),
                    ],
                ],
            ],
            [
                'name' => 'Lanjut Kekuatan 3 Hari',
                'level' => 'advanced',
                'goal' => 'muscle',
                'plan' => [
                    [
                        self::reps('Dumbbell Squat', 4, 12, 8),
                        self::reps('Push-up', 4, 15),
                        self::reps('Zottman Curl', 3, 10, 6),
                        self::hold('Forearm Plank', 3, 60),
                    ],
                    [
                        self::reps('Push-up', 4, 15),
                        self::reps('Zottman Curl', 4, 10, 6),
                        self::reps('Dumbbell Lateral Raise', 4, 12, 3),
                        self::reps('Neutral Grip Front Raise', 3, 12, 3),
                    ],
                    [
                        self::reps('Dumbbell Squat', 4, 12, 8),
                        self::reps('Squat', 3, 20),
                        self::reps('Crunch', 4, 20),
                        self::hold('Forearm Plank', 3, 60),
                    ],
                ],
            ],
        ];
    }
}