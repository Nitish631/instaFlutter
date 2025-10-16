import 'package:flutter/material.dart';
import 'package:freehit/Screens/ScreenSizeContainer.dart';
class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
    return ScreenSizeContainer(child: Container(child: Center(child: Text("Home"),),));
  }
}