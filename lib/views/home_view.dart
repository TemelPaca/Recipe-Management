import 'package:flutter/material.dart';
import 'package:recipe_management/constants/routes.dart';
import 'dart:math' as math;

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 3000),
    vsync: this,
  )
    ..forward()
    ..addListener(() async {
      if (_controller.isCompleted) {
        _controller.stop();
        await Future.delayed(const Duration(milliseconds: 5000));
        _controller
          ..reset()
          ..forward();
      }
    });

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Visibility(
            visible: false,
            child: IconButton(
              onPressed: () {
                setState(() {
                  _controller.value = _controller.value * 0.95;
                });
              },
              icon: const Icon(Icons.fast_rewind),
            ),
          ),
          Visibility(
            visible: false,
            child: IconButton(
              onPressed: () {
                setState(() {
                  if (_controller.isAnimating) {
                    _controller.stop();
                  } else {
                    _controller.forward();
                  }
                });
              },
              icon: _controller.isAnimating
                  ? const Icon(Icons.pause)
                  : const Icon(Icons.play_arrow),
            ),
          ),
          Visibility(
            visible: false,
            child: IconButton(
              onPressed: () {
                setState(() {
                  _controller.reset();
                });
              },
              icon: const Icon(Icons.stop),
            ),
          ),
          Visibility(
            visible: false,
            child: IconButton(
              onPressed: () {
                setState(() {
                  _controller.value = _controller.value * 1.05;
                });
              },
              icon: const Icon(Icons.fast_forward),
            ),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _controller,
        child: GestureDetector(
          onTap: () => Navigator.of(context)
              .pushNamedAndRemoveUntil(recipesRoute, (route) => false),
          child: Container(
            color: Colors.transparent,
            child: const Center(
              child: Image(
                image: AssetImage('assets/images/2560px-OMRON_Logo.png'),
              ),
            ),
          ),
        ),
        builder: (context, child) {
          return Transform.scale(
            scale: _controller.value,
            child: Transform.rotate(
              angle: _controller.value * 2.0 * math.pi,
              child: child,
            ),
          );
        },
      ),
    );
  }
}
