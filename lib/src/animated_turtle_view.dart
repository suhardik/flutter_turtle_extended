import 'package:flutter/material.dart';

import 'painter.dart';
import 'turtle_commands.dart';

/// A widget takes [commands] and draw Turtle Graphics with animations.
///
/// The widget animated when you build it. You can use the [animationDuration]
/// property to set the duration of the animations.
class AnimatedTurtleView extends StatefulWidget {
  /// The commands.
  final List<TurtleCommand> commands;

  /// The child widget.
  final Widget? child;

  /// Size of the canvas.
  final Size size;

  /// Whether the painting is complex enough to benefit from caching.
  final bool isComplex;

  final AnimationController controller;

  /// Creates a new instance.
  const AnimatedTurtleView({
    Key? key,
    required this.commands,
    this.child,
    this.isComplex = false,
    this.size = Size.zero,
    required this.controller,
  }) : super(key: key);

  @override
  _AnimatedTurtleViewState createState() => _AnimatedTurtleViewState();
}

class _AnimatedTurtleViewState extends State<AnimatedTurtleView>
    with SingleTickerProviderStateMixin {
  List<Instruction> _instructions = [];
  // late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _instructions = TurtleCompiler.compile(widget.commands);
    // _controller = AnimationController(duration: Duration(seconds: 3), vsync: this);
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AnimatedTurtleView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.commands != oldWidget.commands) {
      setState(() => _instructions = TurtleCompiler.compile(widget.commands));
    }
  }

  @override
  Widget build(BuildContext context) {
    // _controller.forward(from: 0);
    return AnimatedBuilder(
        child: widget.child,
        // animation: _controller,
        animation: widget.controller,
        builder: (context, child) {
          // final value = _controller.value;
          final value = widget.controller.value;
          final instructions =
              _instructions.sublist(0, (_instructions.length * value).toInt());
          return CustomPaint(
            painter: TurtlePainter(instructions),
            size: widget.size,
            isComplex: widget.isComplex,
            child: child,
          );
        });
  }
}
