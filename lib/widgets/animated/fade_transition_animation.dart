import 'package:flutter/material.dart';

class FadeTransitionAnimation extends StatefulWidget {
  final AssetImage image;
  final Color color;
  final int duration;
  final Curve curve;
  const FadeTransitionAnimation({
    Key? key,
    required this.image,
    required this.color,
    required this.duration,
    required this.curve,
  }) : super(key: key);

  @override
  State<FadeTransitionAnimation> createState() =>
      _FadeTransitionAnimationState();
}

class _FadeTransitionAnimationState extends State<FadeTransitionAnimation>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
      duration: Duration(seconds: widget.duration), vsync: this)
    ..repeat(reverse: false);

  late final Animation<double> _animation =
      CurvedAnimation(parent: _controller, curve: widget.curve);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.color,
      child: FadeTransition(
        opacity: _animation,
        child: Image(image: widget.image),
      ),
    );
  }
}
