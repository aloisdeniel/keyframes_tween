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
