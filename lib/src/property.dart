import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'keyframe.dart';

typedef T Lerp<T>(T a, T b, double t);

/// A property that can be animated with keyframes.
///
/// See also :
///
/// * [Keyframe] which is a value associated to a time.
class KeyframeProperty<T> extends Equatable {
  /// Create a property from a set of keyframes.
  KeyframeProperty(
    List<Keyframe<T>> keyframes, {
    this.name,
    this.lerp,
  }) : this.keyframes = [
          ...keyframes,
        ]..sort((x, y) => x.time.compareTo(y.time));

  /// The property type.
  Type get type => T;

  /// A unique key that idenfies the property from its type, and its name if not empty.
  PropertyKey get key {
    if (name != null) {
      return NamedAndTypedPropertyKey(type, name!);
    }
    return TypedPropertyKey(type);
  }

  /// A name that identifies this property.
  ///
  /// This is useful to differentiate this property from another one of the same type. If this property is the
  /// only one of type [T], the name isn't needed.
  final String? name;

  /// The lerping function used to interpolate a value of [T].
  ///
  /// Defaults to [defaultLerp].
  final Lerp<T>? lerp;

  /// The list of all the keyframes.
  final List<Keyframe<T>> keyframes;

  /// Evaluate a value for the given time [t].
  ///
  /// The value will be lerped from the nearest keyframe before, and the nearest keyframe after.
  ///
  /// If there's no keyframe before [t], the value will be the value of the next keyframe.
  ///
  /// If there's no keyframe after [t], the value will be the value of the previous keyframe.
  T evaluate(double t) {
    if (t <= 0 || keyframes.length == 1) {
      return keyframes.first.value;
    }
    if (t >= 1) {
      return keyframes.last.value;
    }
    final afterIndex = keyframes.indexWhere((x) => t < x.time);
    if (afterIndex == -1) {
      return keyframes.last.value;
    }
    if (afterIndex == 0) {
      return keyframes.first.value;
    }

    final before = keyframes[afterIndex - 1];
    final after = keyframes[afterIndex];
    final intervalTime = (t - before.time) / (after.time - before.time);
    return (lerp ?? defaultLerp).call(
      before.value,
      after.value,
      after.curve.transform(intervalTime),
    );
  }

  @override
  List<Object?> get props => [name, lerp, keyframes];
}

class TimeKeyframeProperty<T> extends Equatable {
  /// Create a property from a set of keyframes.
  TimeKeyframeProperty(
    List<TimeKeyframe<T>> keyframes, {
    this.name,
    this.lerp,
  }) : this.keyframes = [
          ...keyframes,
        ]..sort((x, y) => x.time.compareTo(y.time));

  /// The property type.
  Type get type => T;

  /// A unique key that idenfies the property from its type, and its name if not empty.
  PropertyKey get key {
    if (name != null) {
      return NamedAndTypedPropertyKey(type, name!);
    }
    return TypedPropertyKey(type);
  }

  /// A name that identifies this property.
  ///
  /// This is useful to differentiate this property from another one of the same type. If this property is the
  /// only one of type [T], the name isn't needed.
  final String? name;

  /// The lerping function used to interpolate a value of [T].
  ///
  /// Defaults to [defaultLerp].
  final Lerp<T>? lerp;

  /// The list of all the keyframes.
  final List<TimeKeyframe<T>> keyframes;

  KeyframeProperty<T> toKeyframeProperty(Duration totalDuration) =>
      KeyframeProperty(
        [
          ...keyframes.map(
            (e) => e.toKeyframe(totalDuration),
          ),
        ],
        lerp: lerp,
        name: name,
      );

  @override
  List<Object?> get props => [name, lerp, keyframes];
}

/// A default lerp function that support all base types (`Color`, `Size`, `Decoration`, ...).
T defaultLerp<T>(T begin, T end, double time) {
  final dynamic b = begin;
  final dynamic e = end;
  if (T == double) {
    return lerpDouble(b, e, time) as T;
  }
  if (T == Color) {
    return Color.lerp(b, e, time) as T;
  }
  if (T == Size) {
    return Size.lerp(b, e, time) as T;
  }
  if (T == Decoration) {
    return Decoration.lerp(b, e, time) as T;
  }
  if (T == Rect) {
    return Rect.lerp(b, e, time) as T;
  }
  if (T == EdgeInsets) {
    return EdgeInsets.lerp(b, e, time) as T;
  }
  if (T == RelativeRect) {
    return RelativeRect.lerp(b, e, time) as T;
  }
  if (T == Alignment) {
    return Alignment.lerp(b, e, time) as T;
  }
  if (T == TextStyle) {
    return TextStyle.lerp(b, e, time) as T;
  }
  if (T == Radius) {
    return Radius.lerp(b, e, time) as T;
  }
  if (T == BoxShadow) {
    return BoxShadow.lerp(b, e, time) as T;
  }
  if (T == BorderRadius) {
    return BorderRadius.lerp(b, e, time) as T;
  }
  if (T == Matrix4) {
    return Matrix4Tween(begin: b, end: e).transform(time) as T;
  }
  if (T == Border) {
    return Border.lerp(b, e, time) as T;
  }
  if (T == BorderSide) {
    return BorderSide.lerp(b, e, time) as T;
  }
  if (T == ShapeBorder) {
    return ShapeBorder.lerp(b, e, time) as T;
  }
  if (T == BoxConstraints) {
    return BoxConstraints.lerp(b, e, time) as T;
  }
  if (T == Duration) {
    return lerpDuration(b, e, time) as T;
  }

  throw Exception('Lerp not supported for begin type "$T"');
}

/// A key that identifies the property.
abstract class PropertyKey {
  const PropertyKey();
}

/// A property that is identified from its [type] only.
class TypedPropertyKey extends PropertyKey {
  const TypedPropertyKey(this.type);

  final Type type;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is TypedPropertyKey && other.type == type;
  }

  @override
  int get hashCode => runtimeType.hashCode ^ type.hashCode;
}

/// A property that is identified from its [type] and a [name].
class NamedAndTypedPropertyKey extends PropertyKey {
  const NamedAndTypedPropertyKey(this.type, this.name);
  final String name;
  final Type type;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is NamedAndTypedPropertyKey &&
        other.name == name &&
        other.type == type;
  }

  @override
  int get hashCode => runtimeType.hashCode ^ type.hashCode ^ name.hashCode;
}
