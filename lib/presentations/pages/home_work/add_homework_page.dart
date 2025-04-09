import 'package:a230_flowly/core/app_colors_flowly.dart';
import 'package:a230_flowly/presentations/bloc/homework_cubit.dart';
import 'package:a230_flowly/presentations/models/hobby_model.dart';
import 'package:a230_flowly/presentations/models/home_work_model_a230.dart';
import 'package:a230_flowly/presentations/pages/home_work/select_hobby_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:table_calendar/table_calendar.dart';

class EditHomeworkPage extends StatefulWidget {
  final HomeworkModel? homework; // nullable — жаңы же редакция

  const EditHomeworkPage({super.key, this.homework});

  @override
  State<EditHomeworkPage> createState() => _EditHomeworkPageState();
}

class _EditHomeworkPageState extends State<EditHomeworkPage> {
  final _formKey = GlobalKey<FormState>();

  late String _title;
  late String _description;
  DateTime? _startDate;
  DateTime? _endDate;
  HobbyModel? _selectedHobby;
  HomeworkStatus? _selectedStatus;

  bool get isEditMode => widget.homework != null;

  Future<void> _showNewDeadlineDialog({required bool isStart}) async {
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));

    final pickedDate = await showDialog<DateTime>(
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
                    // Title + Close Icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: const Text(
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            "Select a new\ndeadline",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 28,
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
                    16.verticalSpace,

                    // Calendar
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

                    // Done Button
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isStart) {
                            _startDate = selectedDate;
                          } else {
                            _endDate = selectedDate;
                          }
                        });
                        Navigator.pop(context, selectedDate);
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
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Instrument Sans',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    12.verticalSpace,

                    // Cancel Button
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
                              style: TextStyle(
                                color: const Color(0xFF181818),
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
                ),
              ),
            );
          },
        );
      },
    );
    if (pickedDate != null) {
      setState(() {
        if (isStart) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    final hw = widget.homework;

    _title = hw?.title ?? '';
    _description = hw?.description ?? '';
    _startDate = hw?.startDate;
    _endDate = hw?.endDate;
    _selectedHobby = hw?.hobby;
    _selectedStatus = hw?.status;
  }

  Future<void> _pickHobby() async {
    final hobby = await Navigator.push<HobbyModel>(
      context,
      MaterialPageRoute(builder: (_) => const SelectHobbyPage()),
    );
    if (hobby != null) {
      setState(() => _selectedHobby = hobby);
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
    _selectedStatus = await showDialog<HomeworkStatus>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        HomeworkStatus? selected = widget.homework!.status;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Color(0xffeeeeee),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
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
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'Instrument Sans',
                          fontWeight: FontWeight.w500,
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
                  const SizedBox(height: 16),
                  // Options
                  ...HomeworkStatus.values.map((status) {
                    final isSelected = selected == status;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: null,
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
                                ? SvgPicture.asset(
                                  'assets/icons/check1.svg',
                                  width: 24,
                                  height: 24,
                                )
                                : SvgPicture.asset(
                                  'assets/icons/check2.svg',
                                  width: 24,
                                  height: 24,
                                ),
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

    if (_selectedStatus != null && _selectedStatus != widget.homework!.status) {
      // ignore: use_build_context_synchronously
      _selectedStatus = _selectedStatus;
      setState(() {
        _selectedStatus = _selectedStatus;
      });
    }
  }

  bool get _isFormValid =>
      _title.isNotEmpty &&
          _startDate != null &&
          _endDate != null &&
          _selectedHobby != null &&
          _title != widget.homework?.title ||
      (_selectedStatus != null && _title != widget.homework?.title);

  void _submit() async {
    if (!_isFormValid) return;

    final cubit = context.read<HomeworkCubit>();

    if (isEditMode) {
      final hw = widget.homework!;

      cubit.updateHomework(
        hw,
        _title,
        _description,
        _selectedHobby!,
        _startDate!,
        _endDate!,
        _selectedStatus ?? HomeworkStatus.atWork,
      ); // Hive'ге сактайбыз
      cubit.loadHomeworks(); // Cubit аркылуу UI жаңыртабыз
    } else {
      // Жаңы тапшырма түзөбүз
      final newHw = HomeworkModel(
        title: _title,
        description: _description,
        startDate: _startDate!,
        endDate: _endDate!,
        hobby: _selectedHobby!,
        status: HomeworkStatus.atWork,
      );

      cubit.addHomework(newHw);
    }

    // ignore: use_build_context_synchronously
    Navigator.pop(context); // Форма жабылат
  }

  void showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title + Close icon
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Exit?",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(ctx),
                    child: const Icon(Icons.close, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Description
              const Text(
                "Are you sure you want to come out?\nThe entered data will be lost",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Color(0xFF5E5E5E)),
              ),
              const SizedBox(height: 24),

              // Stay button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    backgroundColor: const Color(0xFFF3F3F3),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    "Stay",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Leave button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx); // Close the dialog
                    Navigator.pop(context); // Go back
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF64B3FD),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    "Leave",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      // ignore: deprecated_member_use
      child: WillPopScope(
        onWillPop: () async {
          showExitDialog(context);
          return false;
        },
        child: Scaffold(
          backgroundColor: AppColorsFlowly.backroundColor,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: false,
            leading: IconButton(
              icon: SvgPicture.asset(
                'assets/icons/arrow.svg',
                width: 24,
                height: 24,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              isEditMode ? 'Edit task' : 'New task',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'Instrument Sans',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  16.verticalSpace,
                  Text(
                    'Task name*',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Instrument Sans',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  6.verticalSpace,
                  TextFormField(
                    initialValue: _title,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Task name*',

                      hintStyle: TextStyle(
                        color: const Color(0xFF181818),
                        fontSize: 16,
                        fontFamily: 'Instrument Sans',
                        fontWeight: FontWeight.w500,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
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
                    onChanged: (val) => setState(() => _title = val),
                  ),
                  16.verticalSpace,
                  Text(
                    'Task description',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Instrument Sans',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  6.verticalSpace,
                  TextFormField(
                    initialValue: _description,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Task description",

                      hintStyle: TextStyle(
                        color: const Color(0xFF181818),
                        fontSize: 16,
                        fontFamily: 'Instrument Sans',
                        fontWeight: FontWeight.w500,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
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
                    onChanged: (val) => setState(() => _description = val),
                  ),
                  16.verticalSpace,
                  Text(
                    'Start date* ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Instrument Sans',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  6.verticalSpace,
                  GestureDetector(
                    onTap: () => _showNewDeadlineDialog(isStart: true),
                    child: Container(
                      width: double.infinity,
                      height: 48.h,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            _startDate == null
                                ? 'Select date'
                                : _startDate!
                                    .toLocal()
                                    .toString()
                                    .split(' ')[0]
                                    .split('-')
                                    .reversed
                                    .join('.'),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Instrument Sans',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SvgPicture.asset(
                            'assets/icons/arrowleft.svg',
                            width: 24,
                            height: 24,
                          ),
                        ],
                      ),
                    ),
                  ),
                  16.verticalSpace,
                  Text(
                    'End date* ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Instrument Sans',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  6.verticalSpace,
                  GestureDetector(
                    onTap: () => _showNewDeadlineDialog(isStart: false),
                    child: Container(
                      width: double.infinity,
                      height: 48.h,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            _endDate == null
                                ? 'Select date'
                                : _endDate!
                                    .toLocal()
                                    .toString()
                                    .split(' ')[0]
                                    .split('-')
                                    .reversed
                                    .join('.'),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Instrument Sans',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SvgPicture.asset(
                            'assets/icons/arrowleft.svg',
                            width: 24,
                            height: 24,
                          ),
                        ],
                      ),
                    ),
                  ),
                  16.verticalSpace,
                  if (widget.homework != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Activity status* ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Instrument Sans',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        6.verticalSpace,
                        GestureDetector(
                          onTap: () => _showStatusDialog(context),
                          child: Container(
                            width: double.infinity,
                            height: 48.h,
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    _selectedHobby != null
                                        ? SvgPicture.asset(
                                          _selectedStatus?.name == 'completed'
                                              ? 'assets/icons/done.svg'
                                              : _selectedStatus?.name ==
                                                  'atWork'
                                              ? 'assets/icons/loading.svg'
                                              : _selectedStatus?.name ==
                                                  'overdue'
                                              ? 'assets/icons/report.svg'
                                              : 'assets/icons/loading.svg',
                                          width: 24,
                                          height: 24,
                                        )
                                        : const SizedBox(),
                                    const SizedBox(width: 8),
                                    Text(
                                      _selectedHobby == null
                                          ? 'Select category'
                                          : _selectedStatus!.name,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontFamily: 'Instrument Sans',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                SvgPicture.asset(
                                  'assets/icons/arrowleft.svg',
                                  width: 24,
                                  height: 24,
                                ),
                              ],
                            ),
                          ),
                        ),
                        16.verticalSpace,
                      ],
                    ),
                  Text(
                    'Hobby categorization* ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Instrument Sans',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  6.verticalSpace,
                  GestureDetector(
                    onTap: () => _pickHobby(),
                    child: Container(
                      width: double.infinity,
                      height: 48.h,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              _selectedHobby != null
                                  ? Image.asset(
                                    _selectedHobby!.categoryModel.imagePath,
                                    width: 24,
                                    height: 24,
                                  )
                                  : const SizedBox(),
                              const SizedBox(width: 8),
                              Text(
                                _selectedHobby == null
                                    ? 'Select hobby'
                                    : _selectedHobby!.name,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Instrument Sans',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          SvgPicture.asset(
                            'assets/icons/arrowleft.svg',
                            width: 24,
                            height: 24,
                          ),
                        ],
                      ),
                    ),
                  ),
                  30.verticalSpace,
                  GestureDetector(
                    onTap: () {
                      if (_isFormValid) {
                        _submit();
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        color:
                            _isFormValid
                                ? const Color(0xFF64B3FD)
                                : const Color.fromARGB(255, 147, 203, 255),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 10,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            spacing: 8,
                            children: [
                              Text(
                                'Save',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Instrument Sans',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
