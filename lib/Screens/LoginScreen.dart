import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freehit/Authentication/AuthMethod.dart';
import 'package:freehit/Authentication/GoogleSignInService.dart';
import 'package:freehit/Database/SecurityStorageServices.dart';
import 'package:freehit/Screens/SignupScreen.dart';
import 'package:freehit/Utils/AppConstant.dart';
import 'package:freehit/Utils/AppRoutes.dart';
import 'package:freehit/Utils/Colors.dart';
import 'package:freehit/Widget/CustomSnackBar.dart';
import 'package:freehit/Widget/TextFieldInput.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final SecurityStorageServices secureDB = SecurityStorageServices.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  String? emailError;
  String? passwordError;
  final Authmethod authMethod = Authmethod.instance;
  bool _isLoading = false;
  late bool anycurrentUser = false;
  @override
  void dispose() {
    passwordFocusNode.dispose();
    emailFocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    findCurrentUser();
    // TODO: implement initState
    super.initState();
  }

  Future<void> findCurrentUser() async {
    anycurrentUser = await secureDB.anycurrentUser();
    setState(() {
      anycurrentUser = anycurrentUser;
    });
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
                                height: isWidthShrinkable ? 110 : 35,
                                width: double.infinity,
                              ),
                              SizedBox(
                                height: isWidthShrinkable
                                    ? 200
                                    : height! * 0.15,
                                width: double.infinity,
                                child: Center(
                                  child: anycurrentUser
                                      ? Container(
                                          child: Icon(
                                            Icons.person,
                                            size: 80,
                                            color: AppColors.greyTextColor,
                                          ), //UPDATE LATER
                                        )
                                      : SvgPicture.asset(
                                          "assets/instagram.svg",
                                          height: isWidthShrinkable ? 70 : 50,
                                        ),
                                ),
                              ),
                              TextfieldInput(
                                focusNode: emailFocusNode,
                                label: "Email address",
                                textEditingController: _emailController,
                                textInputType: TextInputType.emailAddress,
                                errorText: emailError,
                              ),
                              SizedBox(height: isWidthShrinkable ? 15 : 10),
                              TextfieldInput(
                                focusNode: passwordFocusNode,
                                label: "Password",
                                textEditingController: _passwordController,
                                textInputType: TextInputType.text,
                                errorText: passwordError,
                                obscureText: true,
                              ),
                              SizedBox(height: isWidthShrinkable ? 30 : 20),
                              InkWell(
                                onTap: () async {
                                  passwordError = null;
                                  emailError = null;
                                  if (_emailController.text.isNotEmpty &&
                                      _passwordController.text.isNotEmpty) {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    String? messages = await authMethod
                                        .loginUser(
                                          _emailController.text,
                                          _passwordController.text,
                                        );
                                    if (messages == "Login successful") {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        AppRoutes.home,
                                        (route) => false,
                                      );
                                    } else if (messages == "Invalid password") {
                                      setState(() {
                                        _isLoading = false;
                                        passwordError = messages;
                                      });
                                    } else if (messages!.startsWith(
                                      "User not found",
                                    )) {
                                      setState(() {
                                        _isLoading = false;
                                        emailError = "Invalid Email";
                                      });
                                    } else {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      showCustomSnackBar(context, messages);
                                    }
                                  }
                                },
                                child: _isLoading
                                    ? Container(
                                        height: isWidthShrinkable ? 40 : 30,
                                        decoration: BoxDecoration(
                                          color: AppColors.blueColor,
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                        child: Center(
                                          child: SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              color: AppColors.primaryColor,
                                              strokeWidth: 2,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Center(
                                        child: Text(
                                          "Login",
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primaryColor,
                                          ),
                                        ),
                                      ),
                              ),
                              SizedBox(height: isWidthShrinkable ? 20 : 10),
                              InkWell(
                                onTap: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SignupScreen(forReset: true),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Forgotten password?",
                                  style: GoogleFonts.poppins(
                                    fontSize: isWidthShrinkable ? 15 : 13,
                                    color: AppColors.black,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 36,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Container(
                                        width: isWidthShrinkable ? 170 : 130,
                                        height: 0.5,
                                        color: isDarkMode
                                            ? AppColors.borderColour
                                            : AppColors.black,
                                      ),
                                    ),
                                    Text(
                                      "OR",
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: AppColors.greyTextColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Center(
                                      child: Container(
                                        width: isWidthShrinkable ? 170 : 130,
                                        height: 0.5,
                                        color: isDarkMode
                                            ? AppColors.borderColour
                                            : AppColors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: isWidthShrinkable ? 20 : 10),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons8-google.svg',
                                        height: isWidthShrinkable ? 50 : 20,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "Continue with with Google",
                                        style: GoogleFonts.poppins(
                                          fontSize: isWidthShrinkable ? 16 : 12,
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
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          SignupScreen(forReset: false),
                                    ),
                                  );
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
                                      "Create new account",
                                      style: GoogleFonts.poppins(
                                        fontSize: isWidthShrinkable ? 16 : 12,
                                        color: AppColors.blueColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              Container(
                                child: SvgPicture.asset(
                                  'assets/Meta_Platforms_Inc._logo.svg',
                                  height: 10,
                                  colorFilter: ColorFilter.mode(
                                    isDarkMode
                                        ? AppColors.primaryColor
                                        : AppColors.black,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
