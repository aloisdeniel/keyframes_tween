import 'package:flutter/animation.dart';

class Keyframe<T> {
  const Keyframe(
    this.time,
    this.value, {
    this.curve = Curves.linear,
  });

  final double time;
  final Curve curve;
  final T value;
}

extension KeyframeExtension<T> on T {
  Keyframe<T> keyframe(double time, [Curve curve = Curves.linear]) {
    return Keyframe(time, this, curve: curve);
  }
}
