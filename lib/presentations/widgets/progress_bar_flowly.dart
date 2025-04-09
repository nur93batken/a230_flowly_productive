import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final double progress;

  const ProgressBar({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    Color progressColor;
    if (progress < 30) {
      progressColor = Colors.red; // 1-30% кызыл
    } else if (progress >= 30 && progress < 71) {
      progressColor = Colors.yellow; // 31-70% сары
    } else {
      progressColor = Colors.green; // 71-100% жашыл
    }

    return LinearProgressIndicator(
      value: progress / 100,
      backgroundColor: Colors.grey[300],
      valueColor: AlwaysStoppedAnimation(progressColor),
    );
  }
}
