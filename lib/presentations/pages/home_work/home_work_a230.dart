import 'package:a230_flowly/presentations/bloc/homework_cubit.dart';
import 'package:a230_flowly/presentations/bloc/homework_state.dart';
import 'package:a230_flowly/presentations/models/home_work_model_a230.dart';
import 'package:a230_flowly/presentations/pages/home_work/add_homework_page.dart';
import 'package:a230_flowly/presentations/widgets/homework_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeWorkPageA230 extends StatelessWidget {
  const HomeWorkPageA230({super.key});

  void checkDeadlineAndShowPopup(
    BuildContext context,
    List<HomeworkModel> homeworks,
  ) async {
    for (final hw in homeworks) {
      final isOverdue = hw.endDate.isBefore(DateTime.now());
      final notCompleted = hw.status != HomeworkStatus.completed;

      if (isOverdue && notCompleted) {
        await Future.delayed(
          Duration(milliseconds: 500),
        ); // аз кичине күтүп UI даяр болсун
        await showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          barrierDismissible: false,
          builder: (_) => _DeadlineExpiredPopup(homework: hw),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffeeeeee),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Homework",
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontFamily: 'Instrument Sans',
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: SvgPicture.asset(
              "assets/icons/star.svg",
              height: 24,
              width: 24,
            ),
          ),
        ],
      ),
      body: BlocBuilder<HomeworkCubit, HomeworkState>(
        builder: (context, state) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            checkDeadlineAndShowPopup(context, state.allHomeworks);
          });
          if (state.allHomeworks.isEmpty) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/homrwork.png", height: 130),
                  Text(
                    'You don\'t have homework yet',
                    style: TextStyle(
                      color: const Color(0xFF797979),
                      fontSize: 16,
                      fontFamily: 'Instrument Sans',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          final showSearch = state.allHomeworks.length >= 5;

          return Column(
            children: [
              if (showSearch)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: "Search by title",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (query) {
                      context.read<HomeworkCubit>().searchHomeworks(query);
                    },
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: state.filteredHomeworks.length,
                  itemBuilder: (context, index) {
                    final homework = state.filteredHomeworks[index];
                    return HomeworkCard(homework: homework);
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const EditHomeworkPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _DeadlineExpiredPopup extends StatefulWidget {
  final HomeworkModel homework;
  const _DeadlineExpiredPopup({required this.homework});

  @override
  State<_DeadlineExpiredPopup> createState() => _DeadlineExpiredPopupState();
}

class _DeadlineExpiredPopupState extends State<_DeadlineExpiredPopup> {
  late HomeworkStatus selectedStatus;

  @override
  void initState() {
    selectedStatus = widget.homework.status;
    super.initState();
  }

  void _onStatusSelected(HomeworkStatus status) async {
    setState(() => selectedStatus = status);

    widget.homework.status = status;
    await widget.homework.save();
    context.read<HomeworkCubit>().loadHomeworks();

    Navigator.pop(context);

    // Эгер "at work" тандаса — дедлайн тандаган попап ачылат
    if (status == HomeworkStatus.atWork) {
      await Future.delayed(Duration(milliseconds: 300));
      _showNewDeadlineDialog(context, widget.homework);
    }
  }

  void _showNewDeadlineDialog(
    BuildContext context,
    HomeworkModel homework,
  ) async {
    DateTime selectedDate = DateTime.now().add(Duration(days: 1));

    await showDialog(
      context: context,
      builder:
          (_) => StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text("Select a new deadline"),
                content: SizedBox(
                  height: 250,
                  child: CalendarDatePicker(
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                    onDateChanged:
                        (date) => setState(() => selectedDate = date),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context), // cancel
                    child: const Text("Cancel the status changing"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      homework.endDate = selectedDate;
                      await homework.save();
                      context.read<HomeworkCubit>().loadHomeworks();
                      Navigator.pop(context);
                    },
                    child: const Text("Done"),
                  ),
                ],
              );
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("The deadline for your\n“${widget.homework.title}” is out!"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("If you are not finished, change your activity status"),
          const SizedBox(height: 16),
          ...HomeworkStatus.values.map((status) {
            return ListTile(
              leading: Icon(
                status == HomeworkStatus.completed
                    ? Icons.check_circle
                    : status == HomeworkStatus.atWork
                    ? Icons.wb_sunny
                    : Icons.flag,
                color:
                    status == HomeworkStatus.completed
                        ? Colors.green
                        : status == HomeworkStatus.atWork
                        ? Colors.orange
                        : Colors.red,
              ),
              title: Text(
                status == HomeworkStatus.completed
                    ? "Done"
                    : status == HomeworkStatus.atWork
                    ? "At work"
                    : "Overdue",
              ),
              trailing:
                  selectedStatus == status
                      ? const Icon(Icons.check_circle, color: Colors.blue)
                      : null,
              onTap: () => _onStatusSelected(status),
            );
          }),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Okay"),
        ),
      ],
    );
  }
}
