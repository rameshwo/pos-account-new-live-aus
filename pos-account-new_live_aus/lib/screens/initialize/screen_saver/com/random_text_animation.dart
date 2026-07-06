import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';

class RandomTextAnimation extends StatefulWidget {
  final Widget child;
  const RandomTextAnimation({
    super.key,
    required this.child,
  });

  @override
  _RandomTextAnimationState createState() => _RandomTextAnimationState();
}

class _RandomTextAnimationState extends State<RandomTextAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat(reverse: false);

    _animation = Tween<Offset>(
      begin: Offset(-7, 0),
      end: Offset(7, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Center(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (BuildContext context, Widget? child) {
          return Transform.translate(
            offset: _animation.value * size.getW(150),
            child: widget.child,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
