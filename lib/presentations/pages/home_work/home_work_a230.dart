import 'package:a230_flowly/core/app_colors_flowly.dart';
import 'package:a230_flowly/presentations/bloc/homework_cubit.dart';
import 'package:a230_flowly/presentations/bloc/homework_state.dart';
import 'package:a230_flowly/presentations/models/home_work_model_a230.dart';
import 'package:a230_flowly/presentations/pages/home_work/add_homework_page.dart';
import 'package:a230_flowly/presentations/widgets/homework_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeWorkPageA230 extends StatefulWidget {
  const HomeWorkPageA230({super.key});

  @override
  State<HomeWorkPageA230> createState() => _HomeWorkPageA230State();
}

class _HomeWorkPageA230State extends State<HomeWorkPageA230> {
  bool _checkedDeadline = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_checkedDeadline) {
      final homeworks = context.read<HomeworkCubit>().state.allHomeworks;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        checkDeadlineAndShowPopup(context, homeworks);
      });
      _checkedDeadline = true;
    }
  }

  void checkDeadlineAndShowPopup(
    BuildContext context,
    List<HomeworkModel> homeworks,
  ) async {
    for (final hw in homeworks) {
      final isOverdue = hw.endDate.isBefore(DateTime.now());
      final notCompleted = hw.status != HomeworkStatus.completed;

      if (isOverdue && notCompleted) {
        await Future.delayed(const Duration(milliseconds: 500));
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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xffeeeeee),
        appBar: AppBar(
          backgroundColor: AppColorsFlowly.whiteColor,
          centerTitle: true,
          title: const Text(
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
            if (state.allHomeworks.isEmpty) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/homrwork.png", height: 130),
                    const Text(
                      "You don't have homework yet",
                      style: TextStyle(
                        color: Color(0xFF797979),
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
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      top: 16,
                      bottom: 8,
                    ),
                    child: TextField(
                      cursorColor: Color(0xFF797979),
                      style: TextStyle(
                        color: const Color(0xFF797979),
                        fontSize: 16,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: 12,
                          ),
                          child: SvgPicture.asset(
                            "assets/icons/search.svg",
                            height: 16,
                            width: 16,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Search",

                        hintStyle: TextStyle(
                          color: const Color(0xFF797979),
                          fontSize: 16,
                          fontFamily: 'SF Pro',
                          fontWeight: FontWeight.w400,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 0,
                          ),
                        ),
                      ),
                      onChanged: (query) {
                        context.read<HomeworkCubit>().searchHomeworks(query);
                      },
                    ),
                  ),
                8.verticalSpace,
                Expanded(
                  child: ListView.builder(
                    itemCount: state.filteredHomeworks.length,
                    itemBuilder: (context, index) {
                      final homework = state.filteredHomeworks[index];
                      return HomeworkCard(
                        key: ValueKey(homework.key), //  ✅
                        homework: homework,
                      );
                    },
                  ),
                ),
                25.verticalSpace,
              ],
            );
          },
        ),
        floatingActionButton: SizedBox(
          height: 52.h,
          width: 168.w,
          child: FloatingActionButton(
            elevation: 0,
            backgroundColor: AppColorsFlowly.blueColor,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditHomeworkPage()),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Add homework',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColorsFlowly.whiteColor,
                  ),
                ),
                Icon(Icons.add, size: 20, color: AppColorsFlowly.whiteColor),
              ],
            ),
          ),
        ),
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
  }

  void _onStatusUpdated(HomeworkStatus status) async {
    setState(() => selectedStatus = status);

    if (status == HomeworkStatus.atWork) {
      // UI бир кадр жаңыргандан кийин
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        _showNewDeadlineDialog(context, widget.homework); // диалогду ачабыз
      });
    } else {
      context.read<HomeworkCubit>().updateHomeworkStatus(
        widget.homework,
        selectedStatus,
      );
    }
  }

  Future<void> _showNewDeadlineDialog(
    BuildContext context,
    HomeworkModel homework,
  ) async {
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              insetPadding: const EdgeInsets.symmetric(horizontal: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title + Close Icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Select a new deadline",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Calendar
                    CalendarDatePicker(
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                      onDateChanged: (newDate) {
                        setState(() => selectedDate = newDate);
                      },
                    ),
                    const SizedBox(height: 16),

                    // Done Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF64B3FD),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          context.read<HomeworkCubit>().updateHomeworkdedline(
                            homework,
                            selectedDate,
                          );
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Done',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Cancel Button
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Cancel the status changing",
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xffeeeeee),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              "The deadline for your “${widget.homework.title}” is out!",
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontFamily: 'Instrument Sans',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: SvgPicture.asset(
              "assets/icons/close.svg",
              height: 36,
              width: 36,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: const Text(
                  "If you are not finished, change your activity status",
                  style: TextStyle(
                    color: Color(0xFF181818),
                    fontSize: 20,
                    fontFamily: 'Instrument Sans',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...HomeworkStatus.values.map((status) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: AppColorsFlowly.whiteColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: SvgPicture.asset(
                  status == HomeworkStatus.completed
                      ? 'assets/icons/done.svg'
                      : status == HomeworkStatus.atWork
                      ? 'assets/icons/loading.svg'
                      : 'assets/icons/report.svg',
                  height: 24,
                  width: 24,
                ),
                title: Text(
                  status == HomeworkStatus.completed
                      ? "Done"
                      : status == HomeworkStatus.atWork
                      ? "At work"
                      : "Overdue",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Instrument Sans',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing:
                    selectedStatus == status
                        ? SvgPicture.asset(
                          "assets/icons/check1.svg",
                          height: 24,
                          width: 24,
                        )
                        : SvgPicture.asset(
                          "assets/icons/check2.svg",
                          height: 24,
                          width: 24,
                        ),
                onTap: () => _onStatusSelected(status),
              ),
            );
          }),
        ],
      ),
      actions: [
        GestureDetector(
          onTap: () {
            _onStatusUpdated(selectedStatus);
          },
          child: Container(
            width: double.infinity,
            height: 45.h,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: const Color(0xFF64B3FD),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 159,
              children: [
                Text(
                  'Okay',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
