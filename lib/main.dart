import 'dart:async';

import 'Secret/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:freehit/Authentication/AuthMethod.dart';
import 'package:freehit/Database/UserDatabase.dart';
import 'package:freehit/Screens/HomeScreen.dart';
import 'package:freehit/Screens/LoginScreen.dart';
import 'package:freehit/Utils/AppConstant.dart';
import 'package:freehit/Database/SecurityStorageServices.dart';
import 'package:freehit/Utils/AppRoutes.dart';


Future<void>_firebaseMessagingBackgroundHandler(RemoteMessage message)async{
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  await runStartupCode();
  startRepeatingTask();
  runApp(const MyApp());
}

Future<void> runStartupCode() async {
  SecurityStorageServices.instance;
  Userdatabase.instance;
}

Future<void> startRepeatingTask() async {
  final secureDB = SecurityStorageServices.instance;
  final authmethod=Authmethod.instance;

  Timer.periodic(const Duration(minutes: 10), (timer) async {
    String? currentUser = await secureDB.getCurrentUserEmail();
    String? password = await secureDB.getPassword(currentUser!);
    if (password == null) return;
    String? messages=await authmethod.loginUser(currentUser, password);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // initialRoute:AppRoutes.login,
      routes: {
        AppRoutes.home:(context)=>Homescreen(),
        AppRoutes.login:(context)=>LoginScreen(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Insta',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.brown,
      ),
      home:const _ScreenInitializer(
        child: LoginScreen(),
      ),
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
