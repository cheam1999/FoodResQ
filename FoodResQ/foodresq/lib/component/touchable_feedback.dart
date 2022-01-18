import 'dart:async';

import 'package:flutter/material.dart';

// Source: https://stackoverflow.com/a/60363146/11204120

delayExecution(int milliseconds, VoidCallback cbFunction) async {
  var duration = new Duration(milliseconds: milliseconds);
  return new Timer(duration, cbFunction);
}

class TouchableFeedback extends StatefulWidget {
  final Widget child;
  final Function? onTapDown;
  final Function? onTap;
  final Duration duration = const Duration(milliseconds: 500);
  final double opacity = 0.5;
  final double paddingVertical;
  final double topLeftBorderRadius;
  final double topRightBorderRadius;
  final double bottomLeftBorderRadius;
  final double bottomRightBorderRadius;
  final bool center;

  TouchableFeedback(
      {required this.child,
      this.onTapDown,
      this.onTap,
      this.paddingVertical = 0,
      this.topLeftBorderRadius = 0,
      this.topRightBorderRadius = 0,
      this.bottomLeftBorderRadius = 0,
      this.bottomRightBorderRadius = 0,
      this.center = false});

  @override
  _TouchableFeedbackState createState() => _TouchableFeedbackState();
}

class _TouchableFeedbackState extends State<TouchableFeedback> {
  bool isTappedDown = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => isTappedDown = true);
        if (widget.onTapDown != null) widget.onTapDown!();
      },
      onTapUp: (_) {
        delayExecution(100, () => setState(() => isTappedDown = false));
      },
      onTapCancel: () => setState(() => isTappedDown = false),
      onTap: () {
        setState(() => isTappedDown = true);
        widget.onTap!();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(widget.topLeftBorderRadius),
              topRight: Radius.circular(widget.topRightBorderRadius),
              bottomLeft: Radius.circular(widget.bottomLeftBorderRadius),
              bottomRight: Radius.circular(widget.bottomRightBorderRadius)),
          color: isTappedDown
              ? Colors.black.withOpacity(0.12)
              : Colors.transparent,
        ),
        padding: EdgeInsets.symmetric(vertical: widget.paddingVertical),
        width: double.infinity,
        child: widget.center ? Center(child: widget.child) : widget.child,
      ),
      // AnimatedOpacity(
      //   child: widget.child,
      //   duration: widget.duration,
      //   opacity: isTappedDown ? widget.opacity : 1,
      // ),
    );
  }
}
