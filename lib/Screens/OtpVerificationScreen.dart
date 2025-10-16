import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:freehit/Authentication/AuthMethod.dart';
import 'package:freehit/Screens/PasswordChangerScreen.dart';
import 'package:freehit/Utils/AppConstant.dart';
import 'package:freehit/Utils/Colors.dart';
import 'package:freehit/Widget/ClampContainerBox.dart';
import 'package:freehit/Widget/CustomSnackBar.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;
  final token;
  final bool forReset;

  const OtpVerificationScreen({
    super.key,
    required this.email,
    required this.token,
    required this.forReset,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  late String requestToken = widget.token;
  late bool isFilled = false;
  final FocusNode otpNode = FocusNode();
  bool isRequesting = false;
  @override
  void dispose() {
    otpNode.dispose();
    for (var c in _controllers) {
      c.dispose();
    }
    for (var c in _focusNodes) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    _controllers = List.generate(6, (_) => TextEditingController());
    _focusNodes = List.generate(6, (_) => FocusNode());
    super.initState();
  }

  void _onChanged(int index, String value) {
    setState(() {
      isFilled = false;
    });
    if (value.length > 1) {
      _controllers[index].text = value[0];
    }

    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    final otp = _controllers.map((c) => c.text).join();
    if (_controllers.every((c) => c.text.isNotEmpty)) {
      setState(() {
        isFilled = true;
      });
      onCompleted(otp);
    }
  }

  Future<void> onCompleted(String otp) async {
    setState(() {
      isRequesting = true;
    });
    String? message = await Authmethod.instance.verifyOtp(
      widget.email,
      requestToken,
      otp,
    );
    if (message!.isNotEmpty) {
      setState(() {
        isRequesting = false;
        showCustomSnackBar(context, message);
      });
      if (message.startsWith("OTP successful")) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PasswordChangerScreen(
              forReset: widget.forReset,
              email: widget.email,
              otpToken: requestToken,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          color: isDarkMode ? AppColors.black : AppColors.primaryColor,
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
                        color: isDarkMode ? Colors.white : Colors.black,
                        width: 0.5,
                      ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: LayoutBuilder(
                builder: (context, constraint) {
                  return Container(
                    height: constraint.maxHeight,
                    width: constraint.maxWidth,
                    padding: EdgeInsets.all(30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 100,
                          width: double.infinity,
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "The otp is send to:",
                                  style: GoogleFonts.poppins(
                                    color: isDarkMode
                                        ? AppColors.primaryColor
                                        : AppColors.black,
                                    fontSize: isWidthShrinkable ? 16 : 14,
                                  ),
                                ),
                                Text(
                                  widget.email,
                                  style: GoogleFonts.poppins(
                                    color: AppColors.linkColor,
                                    fontSize: isWidthShrinkable ? 16 : 14,
                                  ),
                                ),
                                Text(
                                  "please check it and enter the OTP code.",
                                  style: GoogleFonts.poppins(
                                    color: isDarkMode
                                        ? AppColors.primaryColor
                                        : AppColors.black,
                                    fontSize: isWidthShrinkable ? 16 : 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 150,
                          width: double.infinity,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(6, (index) {
                              return SizedBox(
                                width: 40,
                                child: TextField(
                                  controller: _controllers[index],
                                  focusNode: _focusNodes[index],
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  maxLength: 1,
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 0,
                                      vertical: 2,
                                    ),
                                    counterText: '',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                        color: Colors.black,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  onChanged: (value) =>
                                      _onChanged(index, value),
                                ),
                              );
                            }),
                          ),
                        ),
                        SizedBox(height: 80),
                        !(isRequesting && isFilled)
                            ? Center(
                                child: InkWell(
                                  onTap: () async {
                                    setState(() {
                                      isRequesting = true;
                                    });
                                    String email = widget.email;
                                    String? messages = await Authmethod.instance
                                        .requestOtp(email, widget.forReset);
                                    if (messages != null) {
                                      setState(() {
                                        isRequesting = false;
                                      });
                                      if (messages.startsWith("No ") ||
                                          messages.startsWith("User ") ||
                                          messages.startsWith("Failed")) {
                                        showCustomSnackBar(context, messages);
                                      } else {
                                        requestToken = messages;
                                      }
                                    } else {
                                      showCustomSnackBar(
                                        context,
                                        "Server Error",
                                      );
                                      setState(() {
                                        isRequesting = false;
                                      });
                                    }
                                  },
                                  child: Container(
                                    height: isWidthShrinkable ? 40 : 36,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: AppColors.blueColor,
                                      border: Border.all(
                                        color: AppColors.blueColor,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Resend OTP",
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          fontSize: isWidthShrinkable ? 16 : 14,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : CircularProgressIndicator(
                                color: AppColors.greyTextColor,
                              ),
                      ],
                    ),
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
