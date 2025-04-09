import 'package:a230_flowly/core/app_colors_flowly.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showExitandDeleteDialog(BuildContext context) {
  showCupertinoDialog(
    context: context,
    builder: (BuildContext ctx) {
      return Center(
        // Фон с полупрозрачной подложкой
        child: Container(
          width: MediaQuery.of(ctx).size.width * 0.8,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColorsFlowly.backroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          // Используем Material для InkWell/нажатий (иначе можно GestureDetector)
          child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Заголовок + кнопка "X" справа
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    15.horizontalSpace,
                    const Text(
                      'Exit?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
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
                  'Are you sure you want to come out? The entered data will be lost',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () {
                    Navigator.of(ctx).pop();
                    // Логика "Change the photo"
                  },
                  child: Container(
                    height: 45,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColorsFlowly.whiteColor,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Center(
                      child: const Text(
                        'Stay',
                        style: TextStyle(color: AppColorsFlowly.blueColor),
                      ),
                    ),
                  ),
                ),
                10.verticalSpace,
                InkWell(
                  onTap: () {
                    Navigator.of(ctx).pop();
                    Navigator.of(ctx).pop();
                    Navigator.of(ctx).pop();
                  },
                  child: Container(
                    height: 45,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColorsFlowly.whiteColor,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),

                    child: Center(
                      child: const Text(
                        'Leave',
                        style: TextStyle(color: AppColorsFlowly.blueColor),
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
