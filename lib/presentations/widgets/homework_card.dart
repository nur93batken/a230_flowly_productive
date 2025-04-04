import 'package:a230_flowly/presentations/models/home_work_model_a230.dart';
import 'package:flutter/material.dart';

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
        return "At Work";
      case HomeworkStatus.completed:
        return "Completed";
      case HomeworkStatus.overdue:
        return "Overdue";
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(homework.status);
    final statusText = _statusText(homework.status);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
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
            Text("Hobby: ${homework.hobby.name}"),
            Text(
              "From: ${homework.startDate.toLocal().toString().split(' ')[0]}",
            ),
            Text("To: ${homework.endDate.toLocal().toString().split(' ')[0]}"),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.circle, color: statusColor, size: 12),
            Text(
              statusText,
              style: TextStyle(color: statusColor, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
