import 'package:a230_flowly/core/app_colors_flowly.dart';
import 'package:flutter/material.dart';

class MainScreenFlowly extends StatefulWidget {
  const MainScreenFlowly({super.key});

  @override
  State<MainScreenFlowly> createState() => _MainScreenFlowlyState();
}

class _MainScreenFlowlyState extends State<MainScreenFlowly> {
  int currentIndex = 0;
  final List<Widget> pages = [Scaffold(), Scaffold(), Scaffold(), Scaffold()];

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
      unselectedItemColor: AppColorsFlowly.backroundColor,
      selectedItemColor: Color(0xff2F99E1),
      backgroundColor: AppColorsFlowly.backroundColor,
      currentIndex: currentIndex,
      onTap: (index) => setState(() => currentIndex = index),
      items: _navBarItems(currentIndex),
    );
  }

  List<BottomNavigationBarItem> _navBarItems(int currentIndex) {
    return [
      _buildNavItem(
        'Tracker',
        currentIndex == 0 ? 'assets/icons/Home2.png' : 'assets/icons/Home.png',
        0,
      ),
      _buildNavItem(
        'History',
        currentIndex == 1 ? 'assets/icons/Star2.png' : 'assets/icons/Star.png',
        1,
      ),
      _buildNavItem(
        'Calculator',
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
}
