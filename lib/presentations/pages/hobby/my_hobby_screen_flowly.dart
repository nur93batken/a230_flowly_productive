import 'package:a230_flowly/core/app_colors_flowly.dart';
import 'package:a230_flowly/presentations/pages/hobby/add_hobbies_flowly.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyHobbyScreenFlowly extends StatefulWidget {
  const MyHobbyScreenFlowly({super.key});

  @override
  State<MyHobbyScreenFlowly> createState() => _MyHobbyScreenFlowlyState();
}

class _MyHobbyScreenFlowlyState extends State<MyHobbyScreenFlowly> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorsFlowly.backroundColor,
      appBar: AppBar(
        backgroundColor: AppColorsFlowly.whiteColor,
        title: const Text(
          'My hobby',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        actions: [
          Image.asset(
            'assets/icons/Star2.png',
            color: AppColorsFlowly.black,
            height: 32,
            width: 32,
          ),
          10.horizontalSpace,
        ],
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
          side: BorderSide(color: AppColorsFlowly.backroundColor),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              'assets/icons/Star_Big.png',
              height: 130,
              width: 130,
            ),
          ),
          Text(
            "You don't have a hobby yet",
            style: TextStyle(
              color: AppColorsFlowly.iconGrey,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),

      floatingActionButton: SizedBox(
        height: 52.h,
        width: 136.w,
        child: FloatingActionButton(
          elevation: 0,
          backgroundColor: AppColorsFlowly.blueColor,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddHobbiesFlowly()),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Add hobby',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColorsFlowly.whiteColor,
                ),
              ),
              Icon(Icons.add, size: 20, color: AppColorsFlowly.whiteColor),
            ],
          ),
        ),
      ),
    );
  }
}
