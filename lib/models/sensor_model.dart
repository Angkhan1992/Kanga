import 'dart:math';

class AccelerometerModel {
  final double x;
  final double y;
  final double z;

  AccelerometerModel({
    this.x = 0.0,
    this.y = 0.0,
    this.z = 0.0,
  });

  double getSum() {
    return sqrt(x * x + y * y + z * z);
  }
}

class SensorType {
  static const String ACCELEROMETER = 'accelerometer';
  static const String LINEAR_ACCELERATION = 'linear_accelerometer';
  static const String GRAVITY = 'gravity';
  static const String GYROSCOPE = 'gyroscope';
  static const String MAGNETIC = 'magnetic';
  static const String STEP_COUNTER = 'step_counter';
  static const String STEP_DETECTOR = 'step_detector';
  static const String ROTATION_VECTOR = 'rotation_vector';
  static const String DEFAULT = 'default';
}