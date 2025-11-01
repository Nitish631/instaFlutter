import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:freehit/Authentication/AuthMethod.dart';
import 'package:freehit/Widget/ScreenSizeContainer.dart';
import 'package:freehit/Screens/UserNameChangeScreen.dart';
import 'package:freehit/Utils/AppConstant.dart';
import 'package:freehit/Utils/AppRoutes.dart';
import 'package:freehit/Utils/Colors.dart';
import 'package:freehit/Widget/ClampContainerBox.dart';
import 'package:freehit/Widget/CustomSnackBar.dart';
import 'package:freehit/Widget/TextFieldInput.dart';

class PasswordChangerScreen extends StatefulWidget {
  final bool forReset;
  final String otpToken;
  final String email;
  const PasswordChangerScreen({
    super.key,
    required this.forReset,
    required this.email,
    required this.otpToken,
  });

  @override
  State<PasswordChangerScreen> createState() => _PasswordChangerScreenState();
}

class _PasswordChangerScreenState extends State<PasswordChangerScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FocusNode fullNameNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();
  String? confirmPasswordError;
  bool isLoading = false;
  @override
  void dispose() {
    fullNameNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    _confirmPasswordController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  Future<void> changePasswordCompleted() async {
    bool forwardProcessEverythingOK = false;
    if (widget.forReset) {
      if (_passwordController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty &&
          (_confirmPasswordController.text == _passwordController.text)) {
        forwardProcessEverythingOK = true;
      }
    } else if (!widget.forReset) {
      if (_fullNameController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty &&
          (_confirmPasswordController.text == _passwordController.text)) {
        forwardProcessEverythingOK = true;
      }
    }
    if (_fullNameController.text.isEmpty) {
      if (!widget.forReset) {
        showCustomSnackBar(context, "Enter full Name");
      }
    } else if (_passwordController.text.isEmpty) {
      showCustomSnackBar(context, "Enter password");
    } else if (_confirmPasswordController.text.isEmpty) {
      showCustomSnackBar(context, "Confirm password");
    } else if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        confirmPasswordError = "Mismatched password";
      });
    }
    if (forwardProcessEverythingOK) {
      setState(() {
        isLoading=true;
      });
      String? message;
      if (widget.forReset) {
        message = await Authmethod.instance.forgetPasswordReset(
          email: widget.email,
          otpToken: widget.otpToken,
          password: _passwordController.text,
        );
        if (message == "Password changed successfully") {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.appScreen,
            (route) => false,
          );
        }
      } else {
        message = await Authmethod.instance.registerUser(
          email: widget.email,
          otpToken: widget.otpToken,
          password: _passwordController.text,
          fullName: _fullNameController.text,
        );
        setState(() {
          isLoading=false;
        });
        if (message == "User registered successfully") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  Usernamechangescreen(namefield: _fullNameController.text),
            ),
          );
        }
        showCustomSnackBar(context, message!);
      }
      showCustomSnackBar(context, message!);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenSizeContainer(
      verticalPadding: 30,
      horizontalPadding: 30,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ClampContainerBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 50),
                  !widget.forReset
                      ? TextfieldInput(
                          label: "Full name",
                          textEditingController: _fullNameController,
                          textInputType: TextInputType.text,
                          focusNode: fullNameNode,
                          onSubmit: () async {
                            changePasswordCompleted();
                          },
                        )
                      : SizedBox(height: 0),
                  const SizedBox(height: 10),
                  TextfieldInput(
                    label: "Password",
                    textEditingController: _passwordController,
                    textInputType: TextInputType.text,
                    focusNode: passwordFocusNode,
                    onSubmit: () async {
                      changePasswordCompleted();
                    },
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),
                  TextfieldInput(
                    obscureText: true,
                    label: "Confirm password",
                    textEditingController: _confirmPasswordController,
                    textInputType: TextInputType.text,
                    focusNode: confirmPasswordFocusNode,
                    onSubmit: () async {
                      changePasswordCompleted();
                    },
                    errorText: confirmPasswordError,
                  ),
                  SizedBox(height: widget.forReset ? 130 : 80),
                  InkWell(
                    onTap: () {
                      changePasswordCompleted();
                    },
                    child: Container(
                      height: isWidthShrinkable ? 40 : 36,
                      decoration: BoxDecoration(
                        color: AppColors.blueColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child:isLoading?CircularProgressIndicator(color: AppColors.greyTextColor,): Text(
                          "Next",
                          style: GoogleFonts.poppins(
                            color: AppColors.primaryColor,
                            fontSize: isWidthShrinkable ? 16 : 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
