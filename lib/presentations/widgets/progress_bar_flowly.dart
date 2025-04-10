import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final double progress;

  const ProgressBar({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    // progress мааниси 0дан 100гө чейин келгенин болжолдойбуз
    Color progressColor;

    // 0 → толук көк
    if (progress <= 0) {
      progressColor = Colors.blue;
    }
    // 1–30 → кызыл
    else if (progress > 0 && progress <= 30) {
      progressColor = Colors.red;
    }
    // 31–70 → сары
    else if (progress > 30 && progress <= 70) {
      progressColor = Colors.yellow;
    }
    // 71–100 → жашыл
    else {
      progressColor = Colors.green;
    }

    return LinearProgressIndicator(
      borderRadius: BorderRadius.circular(12),
      minHeight: 8,
      value: progress / 100, // 0.0 → 1.0
      backgroundColor: Colors.grey[300],
      valueColor: AlwaysStoppedAnimation(progressColor),
    );
  }
}
