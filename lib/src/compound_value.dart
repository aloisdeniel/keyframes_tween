import 'property.dart';

/// A value that contains a wet of values associated to properties
class KeyframeValue {
  const KeyframeValue._(
    this._values,
  );

  factory KeyframeValue.evaluate(List<KeyframeProperty> properties, double t) {
    final values = <PropertyKey, dynamic>{};

    for (var property in properties) {
      values[property.key] = property.evaluate(t);
    }

    return KeyframeValue._(values);
  }

  final Map<PropertyKey, dynamic> _values;

  /// Read one of the inner property from its type [T].
  ///
  /// The property can also be identified with an additional [name]. This can be useful when there are
  /// multiples properties of type [T].
  T call<T>([String? name]) {
    if (name == null) {
      return _values[TypedPropertyKey(T)];
    }

    final key = NamedAndTypedPropertyKey(T, name);

    if (!_values.containsKey(key))
      throw Exception('No property found with name `$name`');

    return _values[key];
  }
}
