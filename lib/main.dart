import 'dart:async';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:freehit/Screens/OtpVerificationScreen.dart';
import 'package:freehit/Screens/PasswordChangerScreen.dart';
import 'package:freehit/Screens/SignupScreen.dart';

import 'Secret/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:freehit/Authentication/AuthMethod.dart';
import 'package:freehit/Database/UserDatabase.dart';
import 'package:freehit/Screens/AppScreen.dart';
import 'package:freehit/Screens/LoginScreen.dart';
import 'package:freehit/Utils/AppConstant.dart';
import 'package:freehit/Database/SecurityStorageServices.dart';
import 'package:freehit/Utils/AppRoutes.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Future<void> getDeviceInformation() async {
  final deviceInfoPlugin = DeviceInfoPlugin();
  try {
    if (kIsWeb) {
      final info = await deviceInfoPlugin.webBrowserInfo;
      deviceName = info.browserName.name;
      deviceId = info.userAgent ?? 'unknown';
      os = 'Web';
    } else if (Platform.isAndroid) {
      final info = await deviceInfoPlugin.androidInfo;
      deviceName = '${info.brand} ${info.model}';
      deviceId = info.id ?? info.fingerprint;
      os = 'Android ${info.version.release}';
    } else if (Platform.isIOS) {
      final info = await deviceInfoPlugin.iosInfo;
      deviceName = info.name ?? 'iphoe';
      deviceId = info.identifierForVendor ?? 'unknown';
      os = 'ios ${info.systemVersion}';
    } else if (Platform.isWindows) {
      final info = await deviceInfoPlugin.windowsInfo;
      deviceName = info.computerName;
      deviceId = info.deviceId ?? 'unknown';
      os = 'Windows ${info.majorVersion}.${info.minorVersion}';
    } else if (Platform.isMacOS) {
      final info = await deviceInfoPlugin.macOsInfo;
      deviceName = info.computerName ?? 'Mac';
      deviceId = info.systemGUID ?? 'unknown';
      os = 'macOS ${info.osRelease}';
    } else if (Platform.isLinux) {
      final info = await deviceInfoPlugin.linuxInfo;
      deviceName = info.name ?? 'Linux';
      deviceId = info.machineId ?? 'unknown';
      os = 'Linux ${info.version ?? ''}';
    } else {
      deviceName = 'Unknown';
      deviceId = 'unknown';
      os = 'unknown';
    }
  } catch (e) {}
}

Future<void> requestNotificationPermission() async {
  String? existingToken = await SecurityStorageServices.instance
      .getNotificationToken();
  if (existingToken == null) {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();
    if (token != null) {
      await SecurityStorageServices.instance.saveNotificationToken(token);
    }
    await messaging.requestPermission(alert: true, badge: true, sound: true);
  }
}

Future<void> runStartupCode() async {
  SecurityStorageServices.instance;
  Userdatabase.instance;
}

Future<void> startRepeatingTask() async {
  final secureDB = SecurityStorageServices.instance;
  final authmethod = Authmethod.instance;

  Timer.periodic(const Duration(minutes: 10), (timer) async {
    String? currentUser = await secureDB.getCurrentUserEmail();
    String? password = await secureDB.getPassword(currentUser!);
    if (password == null) return;
    await authmethod.loginUserAuto(currentUser, password);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    )
  );
  await runStartupCode();
  runApp(const MyApp());
  await getDeviceInformation();
  startRepeatingTask();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await requestNotificationPermission();
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        AppRoutes.appScreen: (context) => AppScreen(),
        AppRoutes.login: (context) => LoginScreen(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Insta',
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.brown),
      home: const _ScreenInitializer(child: AppScreen()),
    );
  }
}

class _ScreenInitializer extends StatefulWidget {
  final Widget child;
  const _ScreenInitializer({required this.child});

  @override
  State<_ScreenInitializer> createState() => __ScreenInitializerState();
}

class __ScreenInitializerState extends State<_ScreenInitializer> {
  bool isInitialized = false;

  @override
  Widget build(BuildContext context) {
    if (!isInitialized) {
      final size = MediaQuery.of(context).size;
      screenHeight = size.height;
      screenWidth = size.width;
      isInitialized = true;
    }
    return widget.child;
  }
}
