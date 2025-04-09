import 'package:a230_flowly/core/app_colors_flowly.dart';
import 'package:a230_flowly/presentations/bloc/homework_cubit.dart';
import 'package:a230_flowly/presentations/models/hobby_model.dart';
import 'package:a230_flowly/presentations/models/home_work_model_a230.dart';
import 'package:a230_flowly/presentations/pages/home_work/select_hobby_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

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

  bool get isEditMode => widget.homework != null;

  @override
  void initState() {
    super.initState();
    final hw = widget.homework;

    _title = hw?.title ?? '';
    _description = hw?.description ?? '';
    _startDate = hw?.startDate;
    _endDate = hw?.endDate;
    _selectedHobby = hw?.hobby;
  }

  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
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

  bool get _isFormValid =>
      _title.isNotEmpty &&
      _startDate != null &&
      _endDate != null &&
      _selectedHobby != null;

  void _submit() async {
    if (!_isFormValid) return;

    final cubit = context.read<HomeworkCubit>();

    if (isEditMode) {
      final hw = widget.homework!;

      // Маалыматтарды жаңыртабыз
      hw
        ..title = _title
        ..description = _description
        ..startDate = _startDate!
        ..endDate = _endDate!
        ..hobby = _selectedHobby!;

      await hw.save(); // Hive'ге сактайбыз
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

    Navigator.pop(context); // Форма жабылат
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
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
            'New task',
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
                  onTap: () => _pickDate(isStart: true),
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
                  onTap: () => _pickDate(isStart: false),
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
                  onTap: _isFormValid ? _submit : null,
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
    );
  }
}
