import 'package:flutter_test/flutter_test.dart';
import '../../lib/features/pose/engine/angle_calculator.dart';

void main() {
  test('siku tegak lurus = 90 derajat', () {
    final d = AngleCalculator.degrees(const Point2(1, 0), const Point2(0, 0), const Point2(0, 1));
    expect(d, closeTo(90, 0.001));
  });

  test('lurus = 180 derajat', () {
    final d = AngleCalculator.degrees(const Point2(-1, 0), const Point2(0, 0), const Point2(1, 0));
    expect(d, closeTo(180, 0.001));
  });

  test('45 derajat', () {
    final d = AngleCalculator.degrees(const Point2(1, 0), const Point2(0, 0), const Point2(1, 1));
    expect(d, closeTo(45, 0.001));
  });

  test('titik berimpit menghasilkan NaN', () {
    final d = AngleCalculator.degrees(const Point2(0, 0), const Point2(0, 0), const Point2(1, 1));
    expect(d.isNaN, isTrue);
  });

  test('memilih sisi dengan likelihood lebih tinggi', () {
    final left = [const Point2(0, 0, 0.9), const Point2(0, 0, 0.8)];
    final right = [const Point2(0, 0, 0.4), const Point2(0, 0, 0.5)];
    expect(AngleCalculator.leftIsBetter(left, right), isTrue);
    expect(AngleCalculator.leftIsBetter(right, left), isFalse);
  });
}