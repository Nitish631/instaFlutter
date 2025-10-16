import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:freehit/Authentication/AuthMethod.dart';
import 'package:freehit/Authentication/GoogleSignInService.dart';
import 'package:freehit/Screens/OtpVerificationScreen.dart';
import 'package:freehit/Utils/AppConstant.dart';
import 'package:freehit/Utils/AppRoutes.dart';
import 'package:freehit/Utils/Colors.dart';
import 'package:freehit/Widget/CustomSnackBar.dart';
import 'package:freehit/Widget/TextFieldInput.dart';

class SignupScreen extends StatefulWidget {
  final bool forReset;
  const SignupScreen({super.key, required this.forReset});

  @override
  State<SignupScreen> createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  String? emailError;
  final Authmethod authMethod = Authmethod.instance;
  bool _isLoading = false;

  @override
  void dispose() {
    emailFocusNode.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleOtpRequest() async {
    emailError = null;
    if (_emailController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      String email = _emailController.text;
      String? messages = await authMethod.requestOtp(email, widget.forReset);

      setState(() {
        _isLoading = false;
      });

      if (messages != null) {
        if (messages.startsWith("No ") ||
            messages.startsWith("User ") ||
            messages.startsWith("Failed") ||
            messages.startsWith("Invalid email")) {
          if (messages.startsWith("No")) {
            setState(() {
              emailError = messages;
            });
          } else {
            showCustomSnackBar(context, messages);
          }
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpVerificationScreen(
                email: email,
                token: messages,
                forReset: widget.forReset,
              ),
            ),
          );
        }
      } else {
        showCustomSnackBar(context, "Request failed! Please try again");
      }
    }
  }

  final double? height = screenHeight;
  final double? width = screenWidth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: AppColors.black,
          child: SafeArea(
            bottom: false,
            child: Container(
              color: Colors.white,
              child: Align(
                alignment: isWidthShrinkable
                    ? Alignment.topCenter
                    : Alignment.center,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: isWidthShrinkable ? double.infinity : 730,
                    maxWidth: isWidthShrinkable ? double.infinity : 360,
                  ),
                  child: Container(
                    width: isWidthShrinkable ? double.infinity : width! * 0.5,
                    height: isWidthShrinkable
                        ? double.infinity
                        : (0.65 * height! < 650 && width! > 912)
                        ? 650
                        : 0.65 * height!,
                    decoration: isWidthShrinkable
                        ? null
                        : BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: isDarkMode
                                  ? AppColors.primaryColor
                                  : AppColors.black,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                    padding: EdgeInsets.symmetric(
                      horizontal: isWidthShrinkable ? 50 : 30,
                      vertical: 10,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: isWidthShrinkable ? height! * 0.03 : 35,
                                width: double.infinity,
                              ),
                              SizedBox(
                                height: isWidthShrinkable
                                    ? 200
                                    : height! * 0.15,
                                width: double.infinity,
                                child: Center(
                                  child: SvgPicture.asset(
                                    "assets/instagram.svg",
                                    height: isWidthShrinkable ? 70 : 50,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                              TextfieldInput(
                                focusNode: emailFocusNode,
                                label: "Email address",
                                textEditingController: _emailController,
                                textInputType: TextInputType.emailAddress,
                                errorText: emailError,
                                onSubmit: _handleOtpRequest,
                              ),
                              SizedBox(height: isWidthShrinkable ? 150 : 100),
                              InkWell(
                                onTap: _handleOtpRequest,
                                child: Center(
                                  child: _isLoading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: AppColors.greyTextColor,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Container(
                                          height: isWidthShrinkable ? 40 : 36,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            border: Border.all(width: 0.5),
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                            color: AppColors.blueColor,
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Next",
                                              style: GoogleFonts.poppins(
                                                fontSize: isWidthShrinkable
                                                    ? 16
                                                    : 12,
                                                color: AppColors.primaryColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: 36,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Container(
                                      width: isWidthShrinkable
                                          ? (width! < 435)
                                                ? width! * 0.3
                                                : width! * 0.36
                                          : 130,
                                      height: 0.5,
                                      color: isDarkMode
                                          ? AppColors.borderColour
                                          : AppColors.black,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "OR",
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: AppColors.greyTextColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Center(
                                    child: Container(
                                      width: isWidthShrinkable
                                          ? (width! < 435)
                                                ? width! * 0.3
                                                : width! * 0.36
                                          : 130,
                                      height: 0.5,
                                      color: isDarkMode
                                          ? AppColors.borderColour
                                          : AppColors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            (!widget.forReset)
                                ? InkWell(
                                    onTap: () async {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SignupScreen(forReset: true),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "Forgot password?",
                                      style: GoogleFonts.poppins(
                                        fontSize: isWidthShrinkable ? 15 : 13,
                                        color: AppColors.black,
                                      ),
                                    ),
                                  )
                                : InkWell(
                                    onTap: () async {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SignupScreen(forReset: false),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "Signup",
                                      style: GoogleFonts.poppins(
                                        fontSize: isWidthShrinkable ? 15 : 13,
                                        color: AppColors.black,
                                      ),
                                    ),
                                  ),
                            SizedBox(height: isWidthShrinkable ? 20 : 15),
                            Column(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    final googleSigninService =
                                        GoogleSignInService.instance;
                                    await googleSigninService.signOut();
                                    Map<String, dynamic>? result =
                                        await googleSigninService
                                            .signInWithGoogle();
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    if (result!['success'] == true) {
                                      Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        AppRoutes.home,
                                        (route) => false,
                                      );
                                    } else {
                                      showCustomSnackBar(
                                        context,
                                        result['message'],
                                      );
                                    }
                                  },
                                  child: Container(
                                    height: isWidthShrinkable ? 40 : 30,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 0.5,
                                        color: isDarkMode
                                            ? AppColors.borderColour
                                            : AppColors.black,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons8-google.svg',
                                          height: isWidthShrinkable ? 50 : 20,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          "Continue with Google",
                                          style: GoogleFonts.poppins(
                                            fontSize: (width! < 400)
                                                ? 14
                                                : isWidthShrinkable
                                                ? 16
                                                : 12,
                                            color: isDarkMode
                                                ? AppColors.primaryColor
                                                : AppColors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    height: isWidthShrinkable ? 40 : 30,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: AppColors.blueColor,
                                        width: 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Login",
                                        style: GoogleFonts.poppins(
                                          fontSize: isWidthShrinkable ? 16 : 12,
                                          color: AppColors.blueColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            SvgPicture.asset(
                              'assets/Meta_Platforms_Inc._logo.svg',
                              height: 10,
                              colorFilter: ColorFilter.mode(
                                isDarkMode
                                    ? AppColors.primaryColor
                                    : AppColors.black,
                                BlendMode.srcIn,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
