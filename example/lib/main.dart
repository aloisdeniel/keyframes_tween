import 'package:flutter/material.dart';
import 'package:keyframes_tween/keyframes_tween.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Keyframes Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Container(
        color: Colors.white,
        child: Center(
          child: Example(),
        ),
      ),
    );
  }
}

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
    KeyframeProperty<Matrix4>(
      [
        Matrix4.identity().keyframe(0.0),
        Matrix4.identity().keyframe(0.6),
        (Matrix4.rotationZ(4)..translate(-200.0, -100.0)).keyframe(
          1.0,
          Curves.easeInOut,
        ),
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
        transform: values<Matrix4>(),
        transformAlignment: Alignment.center,
        width: values<Size>().width,
        height: values<Size>().height,
        color: values<Color>('background'),
      ),
    );
  }
}
