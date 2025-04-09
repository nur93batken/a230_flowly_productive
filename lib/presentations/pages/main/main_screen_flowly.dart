import 'package:a230_flowly/core/app_colors_flowly.dart';

import 'package:a230_flowly/presentations/pages/home_work/home_work_a230.dart';

import 'package:a230_flowly/presentations/pages/hobby/my_hobby_screen_flowly.dart';
import 'package:a230_flowly/presentations/pages/user_profile.dart/my_hobby_profile.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainScreenFlowly extends StatefulWidget {
  const MainScreenFlowly({super.key});

  @override
  State<MainScreenFlowly> createState() => _MainScreenFlowlyState();
}

class _MainScreenFlowlyState extends State<MainScreenFlowly> {
  int currentIndex = 0;
  final List<Widget> pages = [
    MyHobbyProfile(),
    MyHobbyScreenFlowly(),
    HomeWorkPageA230(),
    Scaffold(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],

      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      elevation: 20,
      type: BottomNavigationBarType.fixed,
      selectedIconTheme: const IconThemeData(
        color: AppColorsFlowly.backroundColor,
      ),
      unselectedItemColor: AppColorsFlowly.whiteColor,
      selectedItemColor: Color(0xff2F99E1),
      backgroundColor: AppColorsFlowly.whiteColor,
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() => currentIndex = index);
        if (index == 1) {
          _showFirstDialog(context); // Вызываем диалог здесь
        }
      },
      items: _navBarItems(currentIndex),
    );
  }

  List<BottomNavigationBarItem> _navBarItems(int currentIndex) {
    return [
      _buildNavItem(
        'Home',
        currentIndex == 0 ? 'assets/icons/Home2.png' : 'assets/icons/Home.png',
        0,
      ),
      _buildNavItem(
        'Hobbies',
        currentIndex == 1 ? 'assets/icons/Star2.png' : 'assets/icons/Star.png',
        1,
      ),
      _buildNavItem(
        'Homework',
        currentIndex == 2
            ? 'assets/icons/Checklist2.png'
            : 'assets/icons/Checklist.png',
        2,
      ),
      _buildNavItem(
        'Settings',
        currentIndex == 3
            ? 'assets/icons/Setting2.png'
            : 'assets/icons/Setting.png',
        3,
      ),
    ];
  }

  BottomNavigationBarItem _buildNavItem(String label, String icon, int index) {
    return BottomNavigationBarItem(
      icon: Image.asset(
        icon,
        height: 30,
        width: 30,

        color:
            currentIndex == index
                ? Color(0xff2F99E1)
                : AppColorsFlowly.iconGrey,
      ),
      label: label,
    );
  }

  void _showFirstDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext ctx) {
        return Center(
          // Фон с полупрозрачной подложкой
          child: Container(
            width: 335,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColorsFlowly.backroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            // Используем Material для InkWell/нажатий (иначе можно GestureDetector)
            child: Material(
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Заголовок + кнопка "X" справа
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      15.horizontalSpace,
                      Row(
                        children: [
                          const Text(
                            'My hobby?',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Image.asset(
                            'assets/category_icons/Frame7.png',
                            height: 24,
                            width: 24,
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(ctx).pop(),
                        child: const Icon(
                          CupertinoIcons.xmark,
                          color: AppColorsFlowly.blueColor,
                        ),
                      ),
                    ],
                  ),
                  10.verticalSpace,
                  Text(
                    'Here you can create your hobby with a category',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                  ),
                  Divider(),
                  Text(
                    'Set deadlines to organize your time wisely',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                  ),
                  10.verticalSpace,
                  InkWell(
                    onTap: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Container(
                      height: 45,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColorsFlowly.blueColor,
                      ),

                      child: Center(
                        child: const Text(
                          'Okay',
                          style: TextStyle(color: AppColorsFlowly.whiteColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
