import 'dart:math' as math;

/// Satu titik sendi dalam koordinat gambar (2D) beserta keyakinan modelnya.
class Point2 {
  const Point2(this.x, this.y, [this.likelihood = 1.0]);

  final double x;
  final double y;
  final double likelihood; // 0..1
}

class AngleCalculator {
  /// Sudut di titik [b] antara garis b->a dan b->c, dalam derajat (0..180).
  /// Mengembalikan NaN bila salah satu garis panjangnya nol.
  static double degrees(Point2 a, Point2 b, Point2 c) {
    final bax = a.x - b.x, bay = a.y - b.y;
    final bcx = c.x - b.x, bcy = c.y - b.y;
    final magA = math.sqrt(bax * bax + bay * bay);
    final magC = math.sqrt(bcx * bcx + bcy * bcy);
    if (magA == 0 || magC == 0) return double.nan;
    final cos = ((bax * bcx + bay * bcy) / (magA * magC)).clamp(-1.0, 1.0);
    return math.acos(cos) * 180 / math.pi;
  }

  /// true bila sisi kiri lebih meyakinkan (rata-rata likelihood). Seri memilih kiri.
  static bool leftIsBetter(List<Point2> left, List<Point2> right) {
    double avg(List<Point2> p) =>
        p.isEmpty ? 0 : p.map((e) => e.likelihood).reduce((a, b) => a + b) / p.length;
    return avg(left) >= avg(right);
  }
}