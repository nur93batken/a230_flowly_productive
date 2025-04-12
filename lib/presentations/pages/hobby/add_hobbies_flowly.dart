import 'dart:io';
import 'package:a230_flowly/core/app_colors_flowly.dart';
import 'package:a230_flowly/presentations/bloc/hobby_cubit.dart';
import 'package:a230_flowly/presentations/models/category_model.dart';
import 'package:a230_flowly/presentations/models/hobby_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:table_calendar/table_calendar.dart';

class AddHobbiesFlowly extends StatefulWidget {
  const AddHobbiesFlowly({super.key});

  @override
  State<AddHobbiesFlowly> createState() => _AddHobbiesFlowlyState();
}

class _AddHobbiesFlowlyState extends State<AddHobbiesFlowly> {
  final _formKey = GlobalKey<FormState>();

  final _projectNameController = TextEditingController();
  final _descriptionController = TextEditingController();

  XFile? _selectedPhoto;

  DateTime? _startDate;
  DateTime? _endDate;

  CategoryModel? _selectedCategory;

  final List<CategoryModel> _categories = [
    CategoryModel(
      imagePath: 'assets/category_icons/Group.png',
      title: 'Outdoor sport',
    ),
    CategoryModel(
      imagePath: 'assets/category_icons/Frame.png',
      title: 'Science',
    ),
    CategoryModel(
      imagePath: 'assets/category_icons/Frame1.png',
      title: 'Design',
    ),
    CategoryModel(
      imagePath: 'assets/category_icons/Frame2.png',
      title: 'Programing',
    ),
    CategoryModel(
      imagePath: 'assets/category_icons/Frame3.png',
      title: 'Cooking',
    ),
    CategoryModel(
      imagePath: 'assets/category_icons/Frame4.png',
      title: 'Handicrafts',
    ),
    CategoryModel(
      imagePath: 'assets/category_icons/Frame5.png',
      title: 'Music',
    ),
    CategoryModel(
      imagePath: 'assets/category_icons/Frame6.png',
      title: 'Sport',
    ),
    CategoryModel(
      imagePath: 'assets/category_icons/Frame7.png',
      title: 'Drawing',
    ),
    CategoryModel(
      imagePath: 'assets/category_icons/Frame8.png',
      title: 'Others',
    ),
  ];

  bool _showCategoryDropdown = false;

  bool get _isFormValid {
    return _selectedCategory != null &&
        _projectNameController.text.isNotEmpty &&
        _startDate != null &&
        _endDate != null;
  }

  Future<void> _pickImage() async {
    try {
      final status = await Permission.storage.request();
      if (status.isGranted) {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          setState(() {
            _selectedPhoto = pickedFile;
          });
        }
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_startDate == null || _endDate == null) return;

    final hobby = HobbyModel(
      image: _selectedPhoto?.path ?? '',
      categoryModel: _selectedCategory!,
      name: _projectNameController.text,
      description: _descriptionController.text,
      startTime: _startDate!,
      endTime: _endDate!,
    );

    await context.read<HobbyCubit>().addHobby(hobby);

    if (mounted) Navigator.pop(context);
  }

  void _showCategoryDialog() {
    setState(() {
      _showCategoryDropdown = !_showCategoryDropdown;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColorsFlowly.backroundColor,
        appBar: AppBar(
          centerTitle: false,
          leading: IconButton(
            icon: SvgPicture.asset(
              'assets/icons/arrow.svg',
              width: 24,
              height: 24,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'New Hobby',
            style: GoogleFonts.instrumentSans(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(15),
            ),
            side: BorderSide(color: AppColorsFlowly.backroundColor),
          ),
        ),
        body: Stack(
          children: [
            Container(
              color:
                  _showCategoryDropdown == true
                      ? Colors.black87.withAlpha(50)
                      : Colors.transparent,
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Add a cover',
                            style: GoogleFonts.instrumentSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          12.verticalSpace,

                          if (_selectedPhoto == null)
                            GestureDetector(
                              onTap: _pickImage,
                              child: Container(
                                height: 150,
                                width: 303,
                                decoration: BoxDecoration(
                                  color: AppColorsFlowly.whiteColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/icons/Gallery.png',
                                      height: 28,
                                      width: 28,
                                      color: AppColorsFlowly.iconGrey,
                                    ),
                                    Text(
                                      'Add photo',
                                      style: GoogleFonts.instrumentSans(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppColorsFlowly.iconGrey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(_selectedPhoto!.path),
                                height: 150,
                                width: 303,
                                fit: BoxFit.cover,
                              ),
                            ),
                          12.verticalSpace,

                          Text(
                            'Hobby category*',
                            style: GoogleFonts.instrumentSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: _showCategoryDialog,
                            child: Container(
                              height: 48,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _selectedCategory != null
                                      ? Row(
                                        spacing: 5.w,
                                        children: [
                                          Image.asset(
                                            _selectedCategory!.imagePath,
                                          ),
                                          Text(
                                            _selectedCategory!.title,

                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      )
                                      : Text(
                                        'Select category',
                                        style: GoogleFonts.instrumentSans(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                  Icon(Icons.arrow_forward, size: 15),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          Text(
                            'Hobby name*',
                            style: GoogleFonts.instrumentSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          10.verticalSpace,
                          TextFormField(
                            controller: _projectNameController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 15,
                              ),

                              fillColor: Colors.white,
                              filled: true,
                              hintText: 'Name',
                              hintStyle: const TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator:
                                (value) =>
                                    (value == null || value.isEmpty)
                                        ? 'Please enter a project name'
                                        : null,
                          ),
                          const SizedBox(height: 20),

                          Text(
                            'Hobby description',
                            style: GoogleFonts.instrumentSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColorsFlowly.black,
                            ),
                          ),
                          10.verticalSpace,
                          TextFormField(
                            controller: _descriptionController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 15,
                              ),

                              fillColor: Colors.white,
                              filled: true,
                              hintText: 'Description',
                              hintStyle: const TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          Text(
                            'Start date*',
                            style: GoogleFonts.instrumentSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColorsFlowly.black,
                            ),
                          ),
                          8.verticalSpace,
                          GestureDetector(
                            onTap: () {
                              _showNewDeadlineDialog(isStart: true);
                            },
                            child: Container(
                              width: double.infinity,
                              height: 48,

                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                    style: GoogleFonts.instrumentSans(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Icon(Icons.arrow_forward, size: 15),
                                ],
                              ),
                            ),
                          ),
                          20.verticalSpace,

                          Text(
                            'End date*',
                            style: GoogleFonts.instrumentSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          8.verticalSpace,
                          GestureDetector(
                            onTap: () {
                              _showNewDeadlineDialog(isStart: false);
                            },
                            child: Container(
                              width: double.infinity,
                              height: 48,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                    style: GoogleFonts.instrumentSans(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Icon(Icons.arrow_forward, size: 15),
                                ],
                              ),
                            ),
                          ),
                          20.verticalSpace,

                          ElevatedButton(
                            onPressed: _isFormValid ? _submitForm : null,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 56),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              disabledBackgroundColor: Color(0xffB8D7F4),
                              backgroundColor:
                                  _isFormValid
                                      ? const Color(0xFF4FC3F7)
                                      : Colors.grey,
                            ),
                            child: Text(
                              'Add',
                              style: GoogleFonts.instrumentSans(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (_showCategoryDropdown)
              Positioned(
                top: 80,
                left: 15,

                child: Container(
                  decoration: BoxDecoration(
                    color: AppColorsFlowly.backroundColor,

                    borderRadius: BorderRadius.circular(12),
                  ),
                  height: 406.h,
                  width: 335.w,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        spacing: 50.w,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Hobby category',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _showCategoryDropdown = false;
                              });
                            },
                            icon: Icon(
                              Icons.close,
                              color: AppColorsFlowly.blueColor,
                            ),
                          ),
                        ],
                      ),

                      Expanded(
                        child: ListView.builder(
                          itemCount: _categories.length,
                          itemBuilder: (context, index) {
                            final category = _categories[index];
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedCategory = category;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                margin: EdgeInsets.all(8),
                                height: 48,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppColorsFlowly.whiteColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          category.imagePath,
                                          height: 24.h,
                                          width: 24.h,
                                        ),
                                        3.horizontalSpace,
                                        Text(category.title),
                                      ],
                                    ),
                                    Container(
                                      width: 22,
                                      height: 22,
                                      decoration: BoxDecoration(
                                        color:
                                            category == _selectedCategory
                                                ? Color(0xFF4FC3F7)
                                                : Colors.white,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color:
                                              category == _selectedCategory
                                                  ? Color(0xFF4FC3F7)
                                                  : AppColorsFlowly.black,
                                        ),
                                      ),
                                      child:
                                          category == _selectedCategory
                                              ? Icon(
                                                Icons.check,
                                                size: 13,
                                                color:
                                                    AppColorsFlowly.whiteColor,
                                              )
                                              : null,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),

                      ElevatedButton(
                        onPressed:
                            _selectedCategory != null
                                ? () => setState(
                                  () => _showCategoryDropdown = false,
                                )
                                : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColorsFlowly.blueColor,
                          disabledBackgroundColor: Color(0xffB8D7F4),
                          minimumSize: Size(double.infinity, 45.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Select',
                          style: TextStyle(color: AppColorsFlowly.whiteColor),
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
  }

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
                    TableCalendar(
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
                    12.verticalSpace,

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Reset',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColorsFlowly.blueColor,
                              fontSize: 16,
                              fontFamily: 'Instrument Sans',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
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
                          child: Text(
                            'Done',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColorsFlowly.blueColor,
                              fontSize: 16,
                              fontFamily: 'Instrument Sans',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    12.verticalSpace,
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
}
