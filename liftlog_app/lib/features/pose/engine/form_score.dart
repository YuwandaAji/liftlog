enum FormLevel { valid, attention }

/// valid_reps / total_reps (0..1). null bila belum ada rep.
double? computeFormScore(int validReps, int totalReps) =>
    totalReps <= 0 ? null : validReps / totalReps;

/// Valid bila >= 0,8; Perhatian bila < 0,8.
FormLevel formLevel(double score) => score >= 0.8 ? FormLevel.valid : FormLevel.attention;