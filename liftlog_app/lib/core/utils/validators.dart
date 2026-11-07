import 'package:flutter/material.dart';

class Validators {
  static String? required(String? v, [String label = 'Kolom ini']) =>
      (v == null || v.trim().isEmpty) ? '$label wajib diisi' : null;

  static String? email(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email wajib diisi';
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim());
    return ok ? null : 'Format email tidak valid';
  }

  static String? password(String? v) {
    if (v == null || v.isEmpty) return 'Kata sandi wajib diisi';
    return v.length < 8 ? 'Minimal 8 karakter' : null;
  }

  static String? Function(String?) match(TextEditingController other) =>
      (v) => v != other.text ? 'Kata sandi tidak sama' : null;

  static String? Function(String?) number(String label, double min, double max) => (v) {
        final n = double.tryParse((v ?? '').trim().replaceAll(',', '.'));
        if (n == null) return '$label wajib diisi';
        return (n < min || n > max) ? '$label ${min.toInt()}–${max.toInt()}' : null;
      };
}