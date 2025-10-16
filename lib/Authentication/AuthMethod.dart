import 'dart:convert';

import 'package:freehit/Database/SecurityStorageServices.dart';
import 'package:freehit/Utils/Uri.dart';
import 'package:http/http.dart' as http;

class Authmethod {
  static final Authmethod instance = Authmethod._init();
  final SecurityStorageServices secureDB = SecurityStorageServices.instance;
  Authmethod._init();
  
  Future<String?> loginUser(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        const String loginUrl = "${BASE_URI}auth/login";
        Map<String, String> body = {"username": email, "password": password};
        final response = await http.post(
          Uri.parse(loginUrl),
          headers: {"content-type": "application/json"},
          body: jsonEncode(body),
        );
        final data = jsonDecode(response.body);
        if (response.statusCode == 200) {
          String token = "Bearer ${data['token']}";
          if (token.isNotEmpty) {
            await secureDB.saveSensitiveData(email, password, token);
            return "Login successful";
          }
        }
        if (response.statusCode == 404 || response.statusCode == 400) {
          String message = data['message'];
          return message;
        }
        if (response.statusCode == 500) {
          print("SERVER ERROR");
          return "Fail to login";
        }
        return "Server error";
      }
    } catch (e) {
      return "Server error";
    }
    return null;
  }

  Future<String?> requestOtp(String email, bool forReset) async {
    try {
      if (email.isNotEmpty) {
        Map<String, dynamic> body = {"email": email, "forReset": forReset};
        const String otpRequestUrl = "${BASE_URI}auth/request-otp";
        final response = await http.post(
          Uri.parse(otpRequestUrl),
          headers: {"content-type": "application/json"},
          body: jsonEncode(body),
        );
        final data = jsonDecode(response.body);
        if (response.statusCode == 200) {
          String token = data['message'];
          if (token.isNotEmpty) {
            return token;
          }
        }
        if (response.statusCode == 400) {
          if(data['email']!=null){
            String message=data['email'];
            return message;
          }
          String message = data['message'];
          return message;
        }
        return null;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<String?> verifyOtp(String email, String otpToken, String otp) async {
    try {
      if (email.isNotEmpty && otp.isNotEmpty && otpToken.isNotEmpty) {
        Map<String, String> body = {
          "email": email,
          "otpToken": otpToken,
          "otp": otp,
        };
        String verificationUrl = "${BASE_URI}auth/verify-otp";
        final response = await http.post(
          Uri.parse(verificationUrl),
          headers: {"content-type": "application/json"},
          body: jsonEncode(body),
        );
        if (response.statusCode == 200) {
          return "OTP successful";
        } else if (response.statusCode == 400) {
          final data = jsonDecode(response.body);
          if(data['password']!=null){
            String message=data['password'];
            return message;
          }
          String message = data['message'];
          return message;
        } else {
          return "Request fail";
        }
            }
    } catch (e) {
      return "Request fail";
    }
    return null;
  }
  Future<String?> registerUser({
    required String email,
    required String password,
    required String otpToken,
    required String fullName,
  }) async {
    print("REGISTER USER TRIGGED");
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          otpToken.isNotEmpty ||
          fullName.isNotEmpty) {
        const String signupUri = "${BASE_URI}auth/register";
        final Map<String, dynamic> body = {
          "email": email,
          "password": password,
          "otpToken": otpToken,
          "fullName": fullName,
        };
        final response = await http.post(
          Uri.parse(signupUri),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body),
        );
        if (response.statusCode == 201) {
          final data = jsonDecode(response.body);
          String token="Bearer ${data['token']}";
          await secureDB.saveSensitiveData(email, password, token);
          await secureDB.updateCurrentUserEmail(email);
          return "User registered successfully";
        }
        if (response.statusCode == 400) {
          final data = jsonDecode(response.body);
          if(data['password']!=null){
            String message=data['password'];
            return message;
          }
          if(data['fullName']!=null){
            String message=data['fullName'];
            return message;
          }
          String message=data['message'];
          return message;
        }
          return "Server error. try again.";
      }
    } catch (err) {
      return null;
    }
    return null;
  }
  Future<String?> forgetPasswordReset({
    required String email,
    required String password,
    required String otpToken,
  }) async {
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          otpToken.isNotEmpty) {
        const String signupUri = "${BASE_URI}auth/forgot-password";
        final Map<String, dynamic> body = {
          "email": email,
          "password": password,
          "otpToken": otpToken,
        };
        final response = await http.post(
          Uri.parse(signupUri),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body),
        );
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          String token="Bearer ${data['token']}";
          await secureDB.saveSensitiveData(email, password, token);
          await secureDB.updateCurrentUserEmail(email);
          return "Password changed successfully";
        }
        if (response.statusCode == 400) {
          final data = jsonDecode(response.body);
          if(data['password']!=null){
            String message=data['password'];
            return message;
          }
          if(data['fullName']!=null){
            String message=data['fullName'];
            return message;
          }
          String message=data['message'];
          return message;
        }
        return "Server error. try again.";
      }
    } catch (err) {
      return "Server error";
    }
    return null;
  }
}
