import 'package:flutter/material.dart';
import 'package:freehit/Utils/AppConstant.dart';
import 'package:freehit/Utils/Colors.dart';

class TextfieldInput extends StatefulWidget {
  final TextEditingController textEditingController;
  final bool obscureText;
  final String label;
  final TextInputType textInputType;
  final FocusNode focusNode;
  final String? errorText;
  final VoidCallback? onSubmit;

  const TextfieldInput({
    super.key,
    required this.label,
    this.obscureText = false,
    required this.textEditingController,
    required this.textInputType,
    required this.focusNode,
    this.errorText,
    this.onSubmit
  });

  @override
  State<TextfieldInput> createState() => _TextfieldInputState();
}

class _TextfieldInputState extends State<TextfieldInput> {
      Color? labelRedColor;
  late bool isPasswordVisible;
  bool isFocused=false;
  bool hasError=false;

  @override
  void initState() {
    super.initState();
    isPasswordVisible = false;
    widget.focusNode.addListener((){
      setState(() {
        isFocused=widget.focusNode.hasFocus;
      });
    });
    hasError=widget.errorText!=null && widget.errorText!.isNotEmpty;
  }

  @override
  void didUpdateWidget(covariant TextfieldInput oldWidget) {
    if(oldWidget.errorText!=widget.errorText){
      setState(() {
        hasError=widget.errorText!=null&& widget.errorText!.isNotEmpty;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isWidthShrinkable ? 64 : 55,
      decoration: BoxDecoration(
        border: Border.all(
          color: isDarkMode ? AppColors.primaryColor : AppColors.black,
          width: isFocused?1.5:0.5,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: TextField(
          onChanged: (value){
            if(hasError){
              setState(() {
                hasError=false;
              });
            }
          },
          focusNode: widget.focusNode,
          controller: widget.textEditingController,
          onSubmitted: (_){
            if(widget.onSubmit !=null) widget.onSubmit!();
          },
          style: TextStyle(
            fontSize:isWidthShrinkable? 19:16,
            fontWeight: FontWeight.normal,
            color:isDarkMode? AppColors.primaryColor:AppColors.black,
            height: 1.0,
          ),
          cursorColor:isDarkMode? AppColors.primaryColor:AppColors.black,
          decoration: InputDecoration(
            labelText:hasError?widget.errorText:widget.label,
            labelStyle: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: isWidthShrinkable?16:14,
              color:hasError?AppColors.red: isDarkMode? AppColors.greyTextColor:AppColors.black,
            ),
            // filled: true,
            // fillColor: AppColors.mobileSearchColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide:BorderSide.none
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none
            ),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
              vertical:isWidthShrinkable? 13:10,
              horizontal: 3,
            ),
            suffixIcon: (widget.obscureText && isFocused)
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                    icon: Icon(
                      isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color:isDarkMode? Colors.white70:AppColors.black,
                    ),
                  )
                : null,
          ),
          keyboardType: widget.textInputType,
          obscureText: widget.obscureText ? !isPasswordVisible : false,
        ),
      ),
    );
  }
}
