// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class SizeTransitionAnimation extends StatefulWidget {
  final AssetImage image;
  final Color color;
  final int duration;
  final Curve curve;
  final Axis axis;
  const SizeTransitionAnimation({
    Key? key,
    required this.image,
    required this.color,
    required this.duration,
    required this.curve,
    required this.axis,
  }) : super(key: key);

  @override
  State<SizeTransitionAnimation> createState() =>
      _SizeTransitionAnimationState();
}

class _SizeTransitionAnimationState extends State<SizeTransitionAnimation>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
      duration: Duration(seconds: widget.duration), vsync: this)
    ..repeat(reverse: false);

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.color,
      child: SizeTransition(
        sizeFactor: _animation,
        axis: Axis.horizontal,
        axisAlignment: -1,
        child: Image(image: widget.image),
      ),
    );
  }
}
