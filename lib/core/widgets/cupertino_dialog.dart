import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showEditPhotoDialog(BuildContext context) {
  showCupertinoDialog(
    context: context,
    builder: (BuildContext ctx) {
      return Center(
        // Фон с полупрозрачной подложкой
        child: Container(
          width: MediaQuery.of(ctx).size.width * 0.8,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: CupertinoColors.systemBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          // Используем Material для InkWell/нажатий (иначе можно GestureDetector)
          child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Заголовок + кнопка "X" справа
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Edit photo',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(ctx).pop(),
                      child: const Icon(CupertinoIcons.xmark),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Первый пункт
                InkWell(
                  onTap: () {
                    Navigator.of(ctx).pop();
                    // Логика "Change the photo"
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: const Text('Change the photo'),
                  ),
                ),
                Container(height: 1, color: CupertinoColors.separator),
                // Второй пункт (Delete)
                InkWell(
                  onTap: () {
                    Navigator.of(ctx).pop();
                    // Логика "Delete"
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: CupertinoColors.systemRed),
                    ),
                  ),
                ),
                Container(height: 1, color: CupertinoColors.separator),
                // Третий пункт (Back)
                InkWell(
                  onTap: () {
                    Navigator.of(ctx).pop();
                    // Логика "Back"
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: const Text('Back'),
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
