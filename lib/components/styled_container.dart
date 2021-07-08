import 'package:flutter/material.dart';
import 'package:lilo/config/config.dart';
import 'package:time/time.dart';

/// A container that will animate when you change colors.
class StyledContainer extends StatelessWidget {
  final Color? color;
  final BorderRadiusGeometry? borderRadius;
  final List<BoxShadow>? shadows;
  final Widget child;
  final double? width;
  final double? height;
  final Alignment? align;
  final EdgeInsets? margin;
  final Duration? duration;
  final BoxBorder? border;

  const StyledContainer(this.color,
      {Key? key,
      this.borderRadius,
      this.shadows,
      required this.child,
      this.width,
      this.height,
      this.align,
      this.margin,
      this.duration,
      this.border})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        width: width,
        height: height,
        child: child,
        margin: margin,
        alignment: align,
        duration: duration ?? .35.seconds,
        decoration: BoxDecoration(
            color: color,
            borderRadius: borderRadius,
            boxShadow: shadows,
            border: border));
  }
}
