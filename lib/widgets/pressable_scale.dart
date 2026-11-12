import 'package:flutter/material.dart';
 
/// Gives any tappable child a quick "press in" feedback.
/// It only listens to pointer events, so taps still reach the child.
class PressableScale extends StatefulWidget {
  final Widget child;
  final double scale;
 
  const PressableScale({super.key, required this.child, this.scale = 0.96});
 
  @override
  State<PressableScale> createState() => _PressableScaleState();
}
 
class _PressableScaleState extends State<PressableScale> {
  bool _down = false;
 
  void _set(bool v) {
    if (_down != v) setState(() => _down = v);
  }
 
  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _set(true),
      onPointerUp: (_) => _set(false),
      onPointerCancel: (_) => _set(false),
      child: AnimatedScale(
        scale: _down ? widget.scale : 1,
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
 