import 'package:a230_flowly/presentations/bloc/homework_cubit.dart';
import 'package:a230_flowly/presentations/models/home_work_model_a230.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeworkCard extends StatelessWidget {
  final HomeworkModel homework;

  const HomeworkCard({super.key, required this.homework});

  Color _statusColor(HomeworkStatus status) {
    switch (status) {
      case HomeworkStatus.atWork:
        return Colors.orange;
      case HomeworkStatus.completed:
        return Colors.green;
      case HomeworkStatus.overdue:
        return Colors.red;
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

  IconData _statusIcon(HomeworkStatus status) {
    switch (status) {
      case HomeworkStatus.atWork:
        return Icons.wb_sunny;
      case HomeworkStatus.completed:
        return Icons.check_circle;
      case HomeworkStatus.overdue:
        return Icons.flag;
    }
  }

  void _showStatusPopup(BuildContext context) {
    HomeworkStatus? selected = homework.status;

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (_) => StatefulBuilder(
            builder: (context, setState) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Homework status",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...HomeworkStatus.values.map((status) {
                      final isSelected = selected == status;
                      return ListTile(
                        leading: Icon(
                          _statusIcon(status),
                          color: _statusColor(status),
                        ),
                        title: Text(_statusText(status)),
                        trailing:
                            isSelected
                                ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.blue,
                                )
                                : const Icon(Icons.radio_button_off),
                        onTap: () => setState(() => selected = status),
                      );
                    }),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        homework.status = selected!;
                        homework.save();
                        context.read<HomeworkCubit>().loadHomeworks();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade200,
                      ),
                      child: const Text("Select"),
                    ),
                  ],
                ),
              );
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(homework.status);
    final statusText = _statusText(homework.status);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(
          homework.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(homework.description),
            const SizedBox(height: 4),
            Text(
              "From ${homework.startDate.toLocal().toString().split(' ')[0]} to ${homework.endDate.toLocal().toString().split(' ')[0]}",
            ),
            Text("Hobby: ${homework.hobby.name}"),
          ],
        ),
        trailing: GestureDetector(
          onTap: () => _showStatusPopup(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(_statusIcon(homework.status), color: statusColor),
              Text(
                statusText,
                style: TextStyle(color: statusColor, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
