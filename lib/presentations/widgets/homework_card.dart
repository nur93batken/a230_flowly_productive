import 'package:a230_flowly/presentations/bloc/homework_cubit.dart';
import 'package:a230_flowly/presentations/models/home_work_model_a230.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class HomeworkCard extends StatelessWidget {
  final HomeworkModel homework;

  const HomeworkCard({super.key, required this.homework});

  Color _statusColor(HomeworkStatus status) {
    switch (status) {
      case HomeworkStatus.atWork:
        return Color(0xFFEDBF00);
      case HomeworkStatus.completed:
        return Color(0xFF23AA02);
      case HomeworkStatus.overdue:
        return Color(0xFFFF6B6B);
    }
  }

  String _statusText(HomeworkStatus status) {
    switch (status) {
      case HomeworkStatus.atWork:
        return "At work";
      case HomeworkStatus.completed:
        return "Done";
      case HomeworkStatus.overdue:
        return "Overdue";
    }
  }

  String _statusIcon(HomeworkStatus status) {
    switch (status) {
      case HomeworkStatus.atWork:
        return 'loading';
      case HomeworkStatus.completed:
        return 'done';
      case HomeworkStatus.overdue:
        return 'report';
    }
  }

  void _showStatusDialog(BuildContext context) async {
    final selectedStatus = await showDialog<HomeworkStatus>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        HomeworkStatus? selected = homework.status;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              contentPadding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title + Close
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Homework status",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Options
                  ...HomeworkStatus.values.map((status) {
                    final isSelected = selected == status;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: SvgPicture.asset(
                          'assets/icons/${_statusIcon(status)}.svg',
                          width: 24.w,
                          height: 24.h,
                        ),
                        title: Text(_statusText(status)),
                        trailing:
                            isSelected
                                ? const Icon(
                                  Icons.radio_button_checked,
                                  color: Colors.blue,
                                )
                                : const Icon(Icons.radio_button_off),
                        onTap: () => setState(() => selected = status),
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                  // Select Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed:
                          selected == null
                              ? null
                              : () => Navigator.pop(context, selected),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            selected == null
                                ? Colors.blue.shade100
                                : Colors.blue.shade400,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Select"),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (selectedStatus != null && selectedStatus != homework.status) {
      context.read<HomeworkCubit>().updateHomeworkStatus(
        homework,
        selectedStatus,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print("🏷 HomeworkCard rebuilt: ${homework.title} with ${homework.status}");

    final statusColor = _statusColor(homework.status);
    final statusText = _statusText(homework.status);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            homework.title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontFamily: 'Instrument Sans',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              homework.description,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Instrument Sans',
                fontWeight: FontWeight.w500,
              ),
            ),
            12.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showStatusDialog(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(230),
                        border: Border.all(color: statusColor),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            statusText,
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 12,
                              fontFamily: 'Instrument Sans',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          8.horizontalSpace,
                          SvgPicture.asset(
                            'assets/icons/${_statusIcon(homework.status)}.svg',
                            width: 24.w,
                            height: 24.h,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                6.horizontalSpace,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '1 day left',
                      style: TextStyle(
                        color: const Color(0xFF797979),
                        fontSize: 16,
                        fontFamily: 'Instrument Sans',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "${homework.startDate.toLocal().toString().split(' ')[0]} to ",
                          style: TextStyle(
                            color: const Color(0xFF797979),
                            fontSize: 12,
                            fontFamily: 'Instrument Sans',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          homework.endDate.toLocal().toString().split(' ')[0],
                          style: TextStyle(
                            color: const Color(0xFF797979),
                            fontSize: 12,
                            fontFamily: 'Instrument Sans',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            8.verticalSpace,
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/arrowhobby.svg',
                  width: 20.w,
                  height: 20.h,
                ),
                4.horizontalSpace,
                Text(
                  homework.hobby.name,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Instrument Sans',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
