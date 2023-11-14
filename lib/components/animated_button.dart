// import 'package:flutter/material.dart';

// class AnimatedButton extends StatefulWidget {
//   const AnimatedButton({
//     super.key,
//     this.onPressed,
//     this.behavior = HitTestBehavior.deferToChild,
//     this.scale = 0.8,
//     required this.child,
//   });

//   final double scale;

//   final Widget child;
//   final void Function()? onPressed;
//   final HitTestBehavior behavior;

//   @override
//   State<StatefulWidget> createState() => AnimatedButtonState();
// }

// class AnimatedButtonState extends State<AnimatedButton> with TickerProviderStateMixin {
//   bool down = false;

//   void _onTapDown(TapDownDetails _) {
//     setState(() {
//       down = true;
//     });
//   }

//   void _onTap() {
//     widget.onPressed?.call();
//   }

//   void _onTapUp(TapUpDetails _) {
//     setState(() {
//       down = false;
//     });
//   }

//   void _onTapCancel() {
//     setState(() {
//       down = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       behavior: widget.behavior,
//       onTapDown: _onTapDown,
//       onTap: _onTap,
//       onTapUp: _onTapUp,
//       onTapCancel: _onTapCancel,
//       child: AnimatedScale(
//         scale: down ? widget.scale : 1,
//         duration: Duration(milliseconds: down ? 100 : 1000),
//         alignment: Alignment.center,
//         curve: down ? Curves.linear : Curves.elasticOut,
//         child: widget.child,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnimatedButton extends StatefulWidget {
  const AnimatedButton({
    super.key,
    this.onTapDown,
    this.onTap,
    this.onTapUp,
    this.onTapCancel,
    this.onEnter,
    this.onExit,
    this.behavior = HitTestBehavior.deferToChild,
    this.scale = 0.9,
    required this.childBuilder,
  });

  final double scale;

  // final Widget child;

  final Widget Function(BuildContext context, bool hover, bool pointerDown) childBuilder;

  final void Function()? onTapDown;
  final void Function()? onTap;
  final void Function()? onTapUp;
  final void Function()? onTapCancel;

  final void Function()? onEnter;
  final void Function()? onExit;

  final HitTestBehavior behavior;

  @override
  State<StatefulWidget> createState() => AnimatedButtonState();
}

class AnimatedButtonState extends State<AnimatedButton> with TickerProviderStateMixin {
  bool down = false;

  void _onTapDown(TapDownDetails _) {
    setState(() {
      down = true;
      cancel = false;
      widget.onTapDown?.call();
    });
  }

  void _onTap() {
    widget.onTap?.call();
  }

  void _onTapUp(TapUpDetails _) {
    setState(() {
      down = false;
      cancel = false;
      widget.onTapUp?.call();
    });
  }

  void _onTapCancel() {
    setState(() {
      down = false;
      cancel = true;
      widget.onTapCancel?.call();
    });
  }

  bool hover = false;
  bool cancel = false;

  void _onEnter(PointerEnterEvent _) {
    setState(() {
      hover = true;
      cancel = false;
      widget.onEnter?.call();
    });
  }

  void _onExit(PointerExitEvent _) {
    setState(() {
      hover = false;
      cancel = false;
      widget.onExit?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: _onEnter,
      onExit: _onExit,
      cursor: SystemMouseCursors.click, // Disabled button has to be handled upstream by IgnorePointers
      hitTestBehavior: widget.behavior,
      child: GestureDetector(
        behavior: widget.behavior,
        onTapDown: _onTapDown,
        onTap: _onTap,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: AnimatedScale(
          scale: down ? widget.scale : 1,
          duration: Duration(milliseconds: down ? 100 : 800),
          alignment: Alignment.center,
          // curve: down ? Curves.linear : Curves.elasticOut,
          curve: down ? Curves.linear : (cancel ? Curves.elasticOut : Curves.easeOutExpo),
          child: widget.childBuilder(context, hover, down),
        ),
      ),
    );
  }
}