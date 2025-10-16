import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:freehit/Utils/AppConstant.dart';
import 'package:freehit/Utils/Colors.dart';

void showCustomSnackBar(BuildContext context, String message, {double maxWidth=200}) {
  final screenWidth = MediaQuery.of(context).size.width;
  final viewInsets = MediaQuery.of(context).viewInsets.bottom;

  // Default max width (30% of screen or provided)
  final double effectiveMaxWidth = maxWidth;

  ScaffoldMessenger.of(context).hideCurrentSnackBar(); // hide old one first
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent, 
      elevation: 0,
      duration: const Duration(seconds: 2),
      margin: EdgeInsets.only(
        bottom: viewInsets > 0 ? viewInsets + 100 : screenWidth * 0.2, 
        left: 20,
        right: 20,
      ),
      content: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: effectiveMaxWidth, 
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.notificationBackground,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.secondaryColor,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize:isWidthShrinkable? 15:13,
                color: AppColors.primaryColor,
              ),
              softWrap: true,
            ),
          ),
        ),
      ),
    ),
  );
}
