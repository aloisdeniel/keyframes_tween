import 'package:flutter/animation.dart';

class Keyframe<T> {
  const Keyframe(
    this.time,
    this.value, {
    this.curve = Curves.linear,
  });

  factory Keyframe.fromTime({
    required Duration time,
    required Duration total,
    required T value,
    Curve curve = Curves.linear,
  }) =>
      Keyframe(
        time.inMilliseconds / total.inMilliseconds,
        value,
        curve: curve,
      );

  final double time;
  final Curve curve;
  final T value;

  @override
  int get hashCode => Object.hash(time, curve, value);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Keyframe<T> &&
        other.time == time &&
        other.curve == curve &&
        other.value == value;
  }
}

extension KeyframeExtension<T> on T {
  Keyframe<T> keyframe(double time, [Curve curve = Curves.linear]) {
    return Keyframe(time, this, curve: curve);
  }
}

class TimeKeyframe<T> {
  const TimeKeyframe(
    this.time,
    this.value, {
    this.curve = Curves.linear,
  });

  final Duration time;
  final Curve curve;
  final T value;

  Keyframe<T> toKeyframe(Duration totalDuration) => Keyframe<T>(
        time.inMilliseconds / totalDuration.inMilliseconds,
        value,
        curve: curve,
      );

  @override
  int get hashCode => Object.hash(time, curve, value);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Keyframe<T> &&
        other.time == time &&
        other.curve == curve &&
        other.value == value;
  }
}

extension TimeKeyframeExtension<T> on T {
  TimeKeyframe<T> timeframe(
      {int days = 0,
      int hours = 0,
      int minutes = 0,
      int seconds = 0,
      int milliseconds = 0,
      int microseconds = 0,
      Curve curve = Curves.linear}) {
    return TimeKeyframe(
        Duration(
          days: days,
          hours: hours,
          minutes: minutes,
          seconds: seconds,
          milliseconds: milliseconds,
          microseconds: microseconds,
        ),
        this,
        curve: curve);
  }
}
