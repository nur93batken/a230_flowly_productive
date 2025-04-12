import 'package:a230_flowly/core/app_colors_flowly.dart';
import 'package:a230_flowly/presentations/bloc/homework_cubit.dart';
import 'package:a230_flowly/presentations/bloc/homework_state.dart';
import 'package:a230_flowly/presentations/models/achievement_a230.dart'
    show AchievementModel;
import 'package:a230_flowly/presentations/models/home_work_model_a230.dart';
import 'package:a230_flowly/presentations/pages/home_work/achievementsPage.dart';
import 'package:a230_flowly/presentations/pages/home_work/add_homework_page.dart';
import 'package:a230_flowly/presentations/widgets/homework_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeWorkPageA230 extends StatefulWidget {
  const HomeWorkPageA230({super.key});

  @override
  State<HomeWorkPageA230> createState() => _HomeWorkPageA230State();
}

class _HomeWorkPageA230State extends State<HomeWorkPageA230> {
  bool _checkedDeadline = false;

  void _checkNewAchievementsPopup(BuildContext context) async {
    final box = Hive.box<AchievementModel>('achievements');
    final newOnes =
        box.values.where((a) => a.isUnlocked && !a.isShown).toList();

    for (final achievement in newOnes) {
      await Future.delayed(const Duration(milliseconds: 300));

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => _AchievementPopup(achievement: achievement),
      );

      achievement.isShown = true;
      await achievement.save();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_checkedDeadline) {
      final cubit = context.read<HomeworkCubit>();
      cubit.loadHomeworks();
      cubit.checkAchievementsData(context);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkNewAchievementsPopup(context);
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
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(12),
            ),
            child: AppBar(
              backgroundColor: AppColorsFlowly.whiteColor,
              centerTitle: true,
              title: Text(
                "Homework",
                style: GoogleFonts.instrumentSans(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AchievementsPage(),
                        ),
                      );
                    },
                    child: SvgPicture.asset(
                      "assets/icons/star.svg",
                      height: 24,
                      width: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
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
                    Text(
                      "You don't have homework yet",
                      style: GoogleFonts.instrumentSans(
                        color: Color(0xFF797979),
                        fontSize: 16,
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
                      style: GoogleFonts.instrumentSans(
                        color: const Color(0xFF797979),
                        fontSize: 16,
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

                        hintStyle: GoogleFonts.instrumentSans(
                          color: const Color(0xFF797979),
                          fontSize: 16,
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
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      EditHomeworkPage(homework: homework),
                            ),
                          );
                        },
                        child: HomeworkCard(
                          key: ValueKey(homework.key),
                          homework: homework,
                        ),
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
                  style: GoogleFonts.instrumentSans(
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        _showNewDeadlineDialog(context, widget.homework);
      });
    } else {
      context.read<HomeworkCubit>().updateHomeworkStatus(
        widget.homework,
        selectedStatus,
      );
      Navigator.pop(context);
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
              backgroundColor: Color(0xffeeeeee),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              insetPadding: const EdgeInsets.symmetric(horizontal: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            "Select a new\ndeadline",
                            style: GoogleFonts.instrumentSans(
                              color: Colors.black,
                              fontSize: 28,
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
                    16.verticalSpace,

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColorsFlowly.whiteColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TableCalendar(
                        firstDay: DateTime.now(),
                        lastDay: DateTime.now().add(const Duration(days: 365)),
                        focusedDay: selectedDate,
                        selectedDayPredicate:
                            (day) => isSameDay(selectedDate, day),
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            selectedDate = selectedDay;
                          });
                        },
                        calendarStyle: CalendarStyle(
                          todayDecoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            shape: BoxShape.circle,
                          ),
                          selectedDecoration: BoxDecoration(
                            color: AppColorsFlowly.blueColor,
                            shape: BoxShape.circle,
                          ),
                          selectedTextStyle: TextStyle(color: Colors.white),
                        ),
                        headerStyle: HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                        ),
                      ),
                    ),
                    12.verticalSpace,

                    GestureDetector(
                      onTap: () {
                        context.read<HomeworkCubit>().updateHomeworkdedline(
                          homework,
                          selectedDate,
                          context,
                        );
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: double.infinity,
                        height: 45.h,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 13,
                        ),
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
                          spacing: 8,
                          children: [
                            Text(
                              'Done',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.instrumentSans(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    12.verticalSpace,

                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: double.infinity,
                        height: 45,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 9,
                        ),
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Cancel the status changing',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.instrumentSans(
                                color: const Color(0xFF181818),
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
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
              style: GoogleFonts.instrumentSans(
                color: Colors.black,
                fontSize: 24,
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
                child: Text(
                  "If you are not finished, change your activity status",
                  style: GoogleFonts.instrumentSans(
                    color: Color(0xFF181818),
                    fontSize: 20,
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
                  style: GoogleFonts.instrumentSans(
                    color: Colors.black,
                    fontSize: 16,
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
                  style: GoogleFonts.instrumentSans(
                    color: Colors.white,
                    fontSize: 16,
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

class _AchievementPopup extends StatelessWidget {
  final AchievementModel achievement;
  const _AchievementPopup({required this.achievement});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.all(16),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "You have a new achievement!",
                  style: GoogleFonts.instrumentSans(
                    color: Color(0xFF797979),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              6.horizontalSpace,
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
          16.verticalSpace,
          Image.asset('assets/achievements/${achievement.id}.png', height: 120),
          16.verticalSpace,
          Text(
            achievement.title,
            style: GoogleFonts.instrumentSans(
              color: const Color(0xFF181818),
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          8.verticalSpace,
          Text(
            achievement.description,
            textAlign: TextAlign.center,
            style: GoogleFonts.instrumentSans(
              color: const Color(0xFF797979),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          20.verticalSpace,
          GestureDetector(
            onTap: () {
              achievement.isShown = true;
              achievement.save();
              Navigator.pop(context);
            },
            child: Container(
              width: double.infinity,
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
                spacing: 10,
                children: [
                  Text(
                    'Okay',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.instrumentSans(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
