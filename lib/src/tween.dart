import 'package:flutter/animation.dart';
import 'package:keyframes_tween/src/property.dart';

import 'compound_value.dart';

/// A tween that define multiple animated [properties].
///
/// See also :
///
/// * [KeyframeProperty] a property that is animated with a set of kerframes.
class KeyframesTween extends Tween<KeyframeValue> {
  /// Create a new tween from the given animated [properties].
  KeyframesTween(
    this.properties,
  ) : super(
          begin: KeyframeValue.evaluate(properties, 0),
          end: KeyframeValue.evaluate(properties, 1),
        );

  /// Creates a tween from durations instead of a double value.
  ///
  /// If [totalDuration] isn't defined, the time of the last keyframe is used.
  factory KeyframesTween.fromTime({
    required List<TimeKeyframeProperty> properties,
    Duration? totalDuration,
  }) {
    final Duration total = totalDuration ??
        properties.fold(
          Duration.zero,
          (max, property) {
            final Duration propertyMax = property.keyframes.fold(
              Duration.zero,
              (max, timeframe) =>
                  max.inMilliseconds < timeframe.time.inMilliseconds
                      ? timeframe.time
                      : max,
            );

            return max.inMilliseconds < propertyMax.inMilliseconds
                ? propertyMax
                : max;
          },
        );
    return KeyframesTween([
      ...properties.map(
        (e) => e.toKeyframeProperty(total),
      ),
    ]);
  }

  /// The animated properties.
  final List<KeyframeProperty> properties;

  @override
  KeyframeValue lerp(double t) {
    if (t <= 0) {
      return begin!;
    }
    if (t >= 1) {
      return end!;
    }

    return KeyframeValue.evaluate(
      properties,
      t,
    );
  }
}
