import 'package:flutter/material.dart';

class ClampContainerBox extends StatelessWidget {
  final double? maxHeight;
  final double? maxWidth;
  final double heightPercent;
  final double widthPercent;
  final Widget child;
  final BoxDecoration? decoration;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  const ClampContainerBox({
    super.key,
    required this.child,
    this.heightPercent = 100,
    this.widthPercent = 100,
    this.maxHeight,
    this.maxWidth,
    this.decoration,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double parentWidth = constraints.maxWidth;
        final double parentHeight = constraints.maxHeight;

        // Ensure we have finite constraints
        final double boundedWidth =
            (maxWidth != null && maxWidth!.isFinite) ? maxWidth! : parentWidth;
        final double boundedHeight =
            (maxHeight != null && maxHeight!.isFinite) ? maxHeight! : parentHeight;

        final double boxWidth = boundedWidth * (widthPercent / 100);
        final double boxHeight = boundedHeight * (heightPercent / 100);

        return ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: boundedWidth,
            maxHeight: boundedHeight,
          ),
          child: Container(
            width: boxWidth,
            height: boxHeight,
            decoration: decoration,
            padding: padding,
            margin: margin,
            child: child,
          ),
        );
      },
    );
  }
}
