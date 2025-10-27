import 'package:flutter/material.dart';
import 'package:freehit/Utils/AppConstant.dart';
import 'package:freehit/Utils/Colors.dart';
import 'package:freehit/Widget/ClampContainerBox.dart';
class ScreenSizeContainer extends StatefulWidget {
  final Widget child;
  final double? verticalPadding;
  final double? horizontalPadding;
  const ScreenSizeContainer({super.key,required this.child,this.horizontalPadding=0,this.verticalPadding=0});

  @override
  State<ScreenSizeContainer> createState() => ScreenSizeContainerState();
}

class ScreenSizeContainerState extends State<ScreenSizeContainer> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          color: isDarkMode ? AppColors.dark : AppColors.primaryColor,
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: ClampContainerBox(
              maxWidth: isWidthShrinkable ? double.infinity : 360,
              maxHeight: isWidthShrinkable ? double.infinity : 600,
              decoration: BoxDecoration(
                border: isWidthShrinkable
                    ? null
                    : Border.all(
                        color: isDarkMode ? Colors.white : AppColors.dark,
                        width: 0.5,
                      ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: LayoutBuilder(
                builder: (context, constraint) {
                  return Container(
                    height: constraint.maxHeight,
                    width: constraint.maxWidth,
                    padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding!,vertical: widget.verticalPadding!),
                    child:widget.child,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}