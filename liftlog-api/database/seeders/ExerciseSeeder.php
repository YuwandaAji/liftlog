<?php

namespace Database\Seeders;

use App\Models\Exercise;
use Illuminate\Database\Seeder;

class ExerciseSeeder extends Seeder
{
    public function run(): void
    {
        // 1. Buat 8 gerakan
        $exercises = [
            [
                'name' => 'Squat', 'type' => 'bodyweight', 'kind' => 'reps',
                'joint_a' => 'hip', 'joint_b' => 'knee', 'joint_c' => 'ankle',
                'lower_angle' => 100, 'upper_angle' => 160,
                'target_muscle' => 'Paha depan, bokong', 'camera_position' => 'side',
                'steps' => "1. Berdiri dengan kaki selebar bahu.\n2. Turunkan pinggul seperti duduk, punggung tetap lurus.\n3. Turun sampai paha hampir sejajar lantai.\n4. Dorong lewat tumit untuk kembali berdiri.",
                'common_mistakes' => "Lutut masuk ke dalam.\nTumit terangkat.\nPunggung membungkuk.",
            ],
            [
                'name' => 'Push-up', 'type' => 'bodyweight', 'kind' => 'reps',
                'joint_a' => 'shoulder', 'joint_b' => 'elbow', 'joint_c' => 'wrist',
                'lower_angle' => 90, 'upper_angle' => 160,
                'target_muscle' => 'Dada, trisep, bahu depan', 'camera_position' => 'side',
                'steps' => "1. Letakkan tangan sedikit lebih lebar dari bahu.\n2. Luruskan tubuh dari kepala sampai tumit.\n3. Turunkan dada sampai siku sekitar 90 derajat.\n4. Dorong naik sampai lengan lurus.",
                'common_mistakes' => "Pinggul turun atau terlalu naik.\nSiku terlalu melebar.\nGerakan hanya setengah.",
            ],
            [
                // Crunch: selisih sudut dari baseline berbaring.
                // lower_angle = pengurangan sudut minimal agar rep valid,
                // upper_angle = toleransi untuk dianggap kembali ke baseline.
                'name' => 'Crunch', 'type' => 'bodyweight', 'kind' => 'reps',
                'joint_a' => 'shoulder', 'joint_b' => 'hip', 'joint_c' => 'knee',
                'lower_angle' => 22, 'upper_angle' => 8,
                'target_muscle' => 'Perut', 'camera_position' => 'side',
                'steps' => "1. Berbaring, lutut ditekuk, telapak kaki di lantai.\n2. Letakkan tangan di samping kepala.\n3. Angkat bahu dari lantai dengan mengencangkan perut.\n4. Turun perlahan ke posisi awal.",
                'common_mistakes' => "Menarik leher dengan tangan.\nPinggang ikut terangkat.\nGerakan terlalu cepat.",
            ],
            [
                // Forearm Plank: timer jalan hanya saat sudut tubuh di antara lower dan upper.
                'name' => 'Forearm Plank', 'type' => 'bodyweight', 'kind' => 'duration',
                'joint_a' => 'shoulder', 'joint_b' => 'hip', 'joint_c' => 'ankle',
                'lower_angle' => 160, 'upper_angle' => 180,
                'target_muscle' => 'Perut, punggung bawah', 'camera_position' => 'side',
                'steps' => "1. Tumpu pada lengan bawah, siku tepat di bawah bahu.\n2. Luruskan tubuh dari kepala sampai tumit.\n3. Kencangkan perut dan bokong.\n4. Tahan posisi sampai waktu habis.",
                'common_mistakes' => "Pinggul turun.\nPinggul terlalu naik.\nLeher mendongak.\nSiku terlalu jauh di depan bahu.",
            ],
            [
                'name' => 'Dumbbell Squat', 'type' => 'dumbbell', 'kind' => 'reps',
                'joint_a' => 'hip', 'joint_b' => 'knee', 'joint_c' => 'ankle',
                'lower_angle' => 100, 'upper_angle' => 160,
                'target_muscle' => 'Paha depan, bokong', 'camera_position' => 'side',
                'steps' => "1. Pegang satu dumbbell di depan dada dengan kedua tangan.\n2. Berdiri dengan kaki selebar bahu.\n3. Turunkan pinggul sampai paha hampir sejajar lantai.\n4. Dorong lewat tumit untuk kembali berdiri.",
                'common_mistakes' => "Dumbbell menjauh dari dada.\nPunggung membungkuk.\nTumit terangkat.",
            ],
            [
                'name' => 'Zottman Curl', 'type' => 'dumbbell', 'kind' => 'reps',
                'joint_a' => 'shoulder', 'joint_b' => 'elbow', 'joint_c' => 'wrist',
                'lower_angle' => 50, 'upper_angle' => 150,
                'target_muscle' => 'Bisep, lengan bawah', 'camera_position' => 'front',
                'steps' => "1. Berdiri dengan dumbbell di samping, telapak menghadap depan.\n2. Tekuk siku, angkat dumbbell ke arah bahu.\n3. Di puncak, putar telapak menghadap bawah.\n4. Turunkan perlahan dengan telapak menghadap bawah, lalu putar kembali.",
                'common_mistakes' => "Badan mengayun.\nSiku bergerak ke depan.\nBeban terlalu berat.",
            ],
            [
                'name' => 'Dumbbell Lateral Raise', 'type' => 'dumbbell', 'kind' => 'reps',
                'joint_a' => 'hip', 'joint_b' => 'shoulder', 'joint_c' => 'elbow',
                'lower_angle' => 30, 'upper_angle' => 80,
                'target_muscle' => 'Bahu samping', 'camera_position' => 'front',
                'steps' => "1. Berdiri dengan dumbbell di samping badan.\n2. Angkat kedua lengan ke samping, siku sedikit menekuk.\n3. Berhenti saat lengan sejajar bahu.\n4. Turunkan perlahan.",
                'common_mistakes' => "Badan mengayun.\nLengan naik melewati bahu.\nBahu terangkat ke arah telinga.",
            ],
            [
                'name' => 'Neutral Grip Front Raise', 'type' => 'dumbbell', 'kind' => 'reps',
                'joint_a' => 'hip', 'joint_b' => 'shoulder', 'joint_c' => 'elbow',
                'lower_angle' => 30, 'upper_angle' => 70,
                'target_muscle' => 'Bahu depan', 'camera_position' => 'side',
                'steps' => "1. Berdiri dengan dumbbell di depan paha, telapak saling berhadapan.\n2. Angkat lengan ke depan sampai sejajar bahu.\n3. Tahan sebentar.\n4. Turunkan perlahan.",
                'common_mistakes' => "Badan condong ke belakang.\nBeban diayun.\nLengan naik terlalu tinggi.",
            ],
        ];

        foreach ($exercises as $e) {
            Exercise::updateOrCreate(['name' => $e['name']], $e);
        }

        // 2. Isi video (harus setelah gerakan dibuat)
        $videos = [
            'Squat'                    => ['url' => 'https://youtu.be/l83R5PblSMA', 'source' => 'Leg exercise - How to bodyweight squat - PureGym'],
            'Push-up'                  => ['url' => 'https://youtu.be/WDIpL0pjun0', 'source' => 'How to do a Push-Up | Proper Form & Technique - NASM'],
            'Crunch'                   => ['url' => 'https://youtu.be/0t4t3IpiEao', 'source' => 'How To Do Crunches | The Right Way | Well+Good - Well+Good'],
            'Forearm Plank'            => ['url' => 'https://youtu.be/mH5Sfb_KTGg', 'source' => 'How to do a Forearm Plank | The Right Way | Well+Good - Well+Good'],
            'Dumbbell Squat'           => ['url' => 'https://youtu.be/v_c67Omje48', 'source' => 'How to Dumbbell Squat | Mike Hildebrandt - Bodybuilding.com'],
            'Zottman Curl'             => ['url' => 'https://youtu.be/FSGDM9-dZ9w', 'source' => 'Zottman Curl | Exercise Guide - Bodybuilding.com'],
            'Dumbbell Lateral Raise'   => ['url' => 'https://youtu.be/PzsMitRdI_8', 'source' => 'How to do the DUMBBELL LATERAL RAISE! | 2 Minute Tutorial - Max Euceda'],
            'Neutral Grip Front Raise' => ['url' => 'https://youtu.be/4hV-Qt11CSQ', 'source' => 'Standing Neutral Grip Dumbbell Front Raise Tutorial | Team Evolve - Vivian Ngo'],
        ];

        foreach ($videos as $name => $v) {
            Exercise::where('name', $name)->update([
                'youtube_id'   => $this->youtubeId($v['url']),
                'video_source' => $v['source'],
            ]);
        }
    }

    private function youtubeId(string $url): ?string
    {
        preg_match('~(?:youtu\.be/|v=|shorts/|embed/)([A-Za-z0-9_-]{11})~', $url, $m);

        return $m[1] ?? null;
    }
}