import 'package:a230_flowly/core/app_colors_flowly.dart';
import 'package:a230_flowly/presentations/pages/main/main_screen_flowly.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingFlowly extends StatefulWidget {
  const OnboardingFlowly({super.key});

  @override
  State<OnboardingFlowly> createState() => _OnboardingFlowlyState();
}

class _OnboardingFlowlyState extends State<OnboardingFlowly> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  void _completeOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('first_launch', false);

    if (!mounted) return;

    Navigator.pushReplacement(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(builder: (_) => const MainScreenFlowly()),
    );
  }

  void _goToNextPage() {
    if (currentPage < 2) {
      setState(() {
        currentPage++;
      });
      _pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            children: const [
              OnboardingPageAniPro(imagePath: 'assets/images/frame1.png'),
              OnboardingPageAniPro(imagePath: 'assets/images/frame2.png'),
              OnboardingPageAniPro(imagePath: 'assets/images/frame3.png'),
            ],
          ),

          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: _buildPageIndicator(currentPage),
          ),

          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: _buildBottomButton(context),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    bool isLastPage = (currentPage == 2);

    return ElevatedButton(
      onPressed: _goToNextPage,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColorsFlowly.whiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        minimumSize: const Size(double.infinity, 48),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isLastPage ? 'Start' : 'Next',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColorsFlowly.black,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.arrow_forward,
            color: AppColorsFlowly.black,
            size: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(int currentIndex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          width: currentIndex == index ? 48 : 16,
          height: 4,
          decoration: BoxDecoration(
            color: currentIndex == index ? AppColorsFlowly.black : Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

class OnboardingPageAniPro extends StatelessWidget {
  final String imagePath;
  const OnboardingPageAniPro({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Image.asset(imagePath.toString(), fit: BoxFit.cover);
  }
}
