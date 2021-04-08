import 'package:equatable/equatable.dart';
import 'package:flutter/animation.dart';

class Keyframe<T> extends Equatable {
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
  List<Object?> get props => [time, curve, value];
}

extension KeyframeExtension<T> on T {
  Keyframe<T> keyframe(double time, [Curve curve = Curves.linear]) {
    return Keyframe(time, this, curve: curve);
  }
}

class TimeKeyframe<T> extends Equatable {
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
  List<Object?> get props => [time, curve, value];
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
