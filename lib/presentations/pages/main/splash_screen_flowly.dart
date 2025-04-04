import 'package:a230_flowly/presentations/pages/main/main_screen_flowly.dart';
import 'package:a230_flowly/presentations/pages/main/onboarding_flowly.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenFlowly extends StatefulWidget {
  const SplashScreenFlowly({super.key});

  @override
  State<SplashScreenFlowly> createState() => _SplashScreenFlowlyState();
}

class _SplashScreenFlowlyState extends State<SplashScreenFlowly> {
  Future<void> _checkFirstFlowly() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool('first_launch') ?? true;

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (_) =>
                isFirstLaunch
                    ? const OnboardingFlowly()
                    : const MainScreenFlowly(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), _checkFirstFlowly);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Image(
        image: AssetImage('assets/images/splash_image.png'),
        height: double.infinity,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}
