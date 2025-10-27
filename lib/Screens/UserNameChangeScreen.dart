import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:freehit/Screens/ScreenSizeContainer.dart';
import 'package:freehit/Services/UserService.dart';
import 'package:freehit/Utils/AppConstant.dart';
import 'package:freehit/Utils/AppRoutes.dart';
import 'package:freehit/Utils/Colors.dart';
import 'package:freehit/Widget/ClampContainerBox.dart';
import 'package:freehit/Widget/CustomSnackBar.dart';
import 'package:freehit/Widget/TextFieldInput.dart';

class Usernamechangescreen extends StatefulWidget {
  final String? namefield;
  const Usernamechangescreen({super.key, this.namefield});

  @override
  State<Usernamechangescreen> createState() => _UsernamechangescreenState();
}

class _UsernamechangescreenState extends State<Usernamechangescreen> {
  TextEditingController usernameController = TextEditingController();
  FocusNode usernameFocusNode = FocusNode();
  bool isLoading = false;
  Future<void> usernamechanged() async {
    if (usernameController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      String? message = await Userservice.instance.updateUserName(
        usernameController.text,
      );
      showCustomSnackBar(context, message!);
      if (message == "Success") {
        setState(() {
          isLoading = false;
        });
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.appScreen,
          (route) => false,
        );
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    setState(() {
      usernameController.text = widget.namefield!;
    });
    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    usernameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenSizeContainer(
      verticalPadding: 30,
      horizontalPadding: 30,
      child: ClampContainerBox(
        heightPercent: 65,
        child: Column(
          children: [
            const SizedBox(height: 80),
            TextfieldInput(
              label: "Username",
              textEditingController: usernameController,
              textInputType: TextInputType.text,
              focusNode: usernameFocusNode,
              onSubmit: usernamechanged,
            ),
            const SizedBox(height: 150),
            InkWell(
              onTap: () {
                usernamechanged();
              },
              child: isLoading
                  ? CircularProgressIndicator(color: AppColors.greyTextColor)
                  : Container(
                      height: isWidthShrinkable ? 40 : 36,
                      decoration: BoxDecoration(
                        color: AppColors.blueColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
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
    );
  }
}
