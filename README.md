# keyframes_tween

A tween that allow defining keyframes for various properties.

## Quickstart

```dart
import 'package:keyframes_tween/keyframes_tween.dart';

class Example extends StatefulWidget {
  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<Example> with TickerProviderStateMixin {
  late final controller = AnimationController(
    duration: const Duration(seconds: 10),
    vsync: this,
  );

  final tween = KeyframesTween([
    KeyframeProperty<Size>(
      [
        Size(10, 10).keyframe(0),
        Size(100, 100).keyframe(0.5, Curves.easeInOut),
        Size(200, 200).keyframe(1.0),
      ],
    ),
    KeyframeProperty<Color>(
      [
        Colors.black.keyframe(0.0),
        Colors.red.keyframe(0.8, Curves.easeInOut),
        Colors.blue.keyframe(1.0),
      ],
      name: 'background',
    ),
  ]);

  @override
  void initState() {
    controller.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<KeyframeValue>(
      valueListenable: tween.animate(controller),
      builder: (context, values, _) => Container(
        width: values<Size>().width,
        height: values<Size>().height,
        color: values<Color>('background'),
      ),
    );
  }
}
```

## Usage

### Using durations

```dart
final tween = KeyframesTween.fromTime(
  properties: [
    TimeKeyframeProperty<Size>(
      [
        Size(10, 10).timeframe(milliseconds: 0),
        Size(100, 100).timeframe(milliseconds: 500, Curves.easeInOut),
        Size(200, 200).timeframe(seconds: 1),
      ],
    ),
    TimeKeyframeProperty<Color>(
      [
        Colors.black.timeframe(milliseconds: 0),
        Colors.red.timeframe(milliseconds: 800, Curves.easeInOut),
        Colors.blue.timeframe(seconds: 1),
      ],
      name: 'background',
    ),
  ],
);
```

### Custom lerp

```dart
final tween = KeyframesTween(
  properties: [
      KeyframeProperty<MyType>(
        [
          // ...
        ],
        lerp: (begin,end,t) =>  MyType.lerp(begin, end, t),
      )
  ],
);
```

### Builder

```dart
return ValueListenableBuilder<KeyframeValue>(
  valueListenable: tween.animate(controller),
  builder: (context, values, _) => Container(
    width: values<Size>().width,
    height: values<Size>().height,
    color: values<Color>('background'),
  ),
);
```