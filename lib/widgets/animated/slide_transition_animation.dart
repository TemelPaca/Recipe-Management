import 'package:flutter/material.dart';

class SlideTransitionAnimation extends StatefulWidget {
  final AssetImage image;
  final Color color;
  final int duration;
  final Curve curve;
  const SlideTransitionAnimation({
    Key? key,
    required this.image,
    required this.color,
    required this.duration,
    required this.curve,
  }) : super(key: key);

  @override
  State<SlideTransitionAnimation> createState() =>
      _SlideTransitionAnimationState();
}

class _SlideTransitionAnimationState extends State<SlideTransitionAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
      duration: Duration(seconds: widget.duration), vsync: this)
    ..repeat(reverse: false);

  late final Animation<Offset> _animation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(1.5, 0.0),
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticIn));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.color,
      child: SlideTransition(
        position: _animation,
        child: Image(image: widget.image),
      ),
    );
  }
}
