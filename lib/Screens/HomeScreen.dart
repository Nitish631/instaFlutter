import 'package:flutter/material.dart';
import 'package:freehit/Utils/AppConstant.dart';
import 'package:freehit/Utils/Colors.dart';
import 'package:freehit/Widget/HomeScreenMainWidget.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
  double width=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: isDarkMode?AppColors.dark:AppColors.primaryColor,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              height: double.infinity,
              color: isDarkMode?AppColors.dark:AppColors.primaryColor,
              child:Center(
                child:HomeScreenMainWidget(),
              ) ,
            ),
          ),
          width>=1160?SizedBox(width: 5,):SizedBox(width: 0,),
          width>=1160?
          Container(
            height: double.infinity,
            color: Colors.blue,
            width: 383,
          ):SizedBox(width: 0,)
        ],
      ),
    );
  }
}