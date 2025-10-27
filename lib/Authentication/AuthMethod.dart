import 'dart:convert';
import 'dart:io';

import 'package:freehit/Database/SecurityStorageServices.dart';
import 'package:freehit/Utils/AppConstant.dart';
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
        String? notificationToken = await secureDB.getNotificationToken();
        Map<String, String> body = {
          "username": email,
          "password": password,
          "deviceId": deviceId!,
          "deviceName": deviceName!,
          "os": os!,
          "notificationToken": notificationToken!,
        };
        print("notificationToken: $notificationToken deviceName:$deviceName");
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
          return "Fail to login";
        }
        return "Network error";
      }
    }on SocketException {
      return "Network error.";
    }catch(e){
      return "Something went wrong";
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
          if (data['email'] != null) {
            String message = data['email'];
            return message;
          }
          String message = data['message'];
          return message;
        }
        return "Network error";
      }
    }on SocketException{
      return "Network error";
    }
     catch (e) {
      return "Network error";
    }
    return "Network error";
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
          if (data['password'] != null) {
            String message = data['password'];
            return message;
          }
          String message = data['message'];
          return message;
        } else {
          return "Network error";
        }
      }
    }on SocketException{
      return"Network error";
    }
     catch (e) {
      return "Network error";
    }
    return null;
  }

  Future<String?> registerUser({
    required String email,
    required String password,
    required String otpToken,
    required String fullName,
  }) async {
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          otpToken.isNotEmpty ||
          fullName.isNotEmpty) {
        const String signupUri = "${BASE_URI}auth/register";
        String? notificationToken=await secureDB.getNotificationToken();
        final Map<String, dynamic> body = {
          "email": email,
          "password": password,
          "otpToken": otpToken,
          "fullName": fullName,
          "deviceId": deviceId!,
          "deviceName": deviceName!,
          "os": os!,
          "notificationToken": notificationToken!,
        };
        final response = await http.post(
          Uri.parse(signupUri),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body),
        );
        if (response.statusCode == 201) {
          final data = jsonDecode(response.body);
          String token = "Bearer ${data['token']}";
          await secureDB.saveSensitiveData(email, password, token);
          await secureDB.updateCurrentUserEmail(email);
          return "User registered successfully";
        }
        if (response.statusCode == 400) {
          final data = jsonDecode(response.body);
          if (data['password'] != null) {
            String message = data['password'];
            return message;
          }
          if (data['fullName'] != null) {
            String message = data['fullName'];
            return message;
          }
          String message = data['message'];
          return message;
        }
        return "Network error";
      }
    }on SocketException{
      return "Network error";
    }
     catch (err) {
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
      if (email.isNotEmpty || password.isNotEmpty || otpToken.isNotEmpty) {
        const String signupUri = "${BASE_URI}auth/forgot-password";
        String? notificationToken=await secureDB.getNotificationToken();
        final Map<String, dynamic> body = {
          "email": email,
          "password": password,
          "otpToken": otpToken,
          "deviceId": deviceId!,
          "deviceName": deviceName!,
          "os": os!,
          "notificationToken": notificationToken!,
        };
        final response = await http.post(
          Uri.parse(signupUri),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body),
        );
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          String token = "Bearer ${data['token']}";
          await secureDB.saveSensitiveData(email, password, token);
          await secureDB.updateCurrentUserEmail(email);
          return "Password changed successfully";
        }
        if (response.statusCode == 400) {
          final data = jsonDecode(response.body);
          if (data['password'] != null) {
            String message = data['password'];
            return message;
          }
          if (data['fullName'] != null) {
            String message = data['fullName'];
            return message;
          }
          String message = data['message'];
          return message;
        }
        return "Network error";
      }
    }on SocketException{
      return "Network error";
    }
     catch (err) {
      return "Network error";
    }
    return null;
  }

  Future<void> loginUserAuto(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        const String loginUrl = "${BASE_URI}auth/login-auto";
        Map<String, String> body = {"username": email, "password": password};
        final response = await http.post(
          Uri.parse(loginUrl),
          headers: {"content-type": "application/json"},
          body: jsonEncode(body),
        );
        final data = jsonDecode(response.body);
        if (response.statusCode == 200) {
          String token = "Bearer ${data['token']}";
          if (data['token']) {
            await secureDB.saveSensitiveData(email, password, token);
          }
        }
      }
    } catch (e) {}
  }
}
