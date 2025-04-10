import 'dart:io';
import 'package:a230_flowly/core/app_colors_flowly.dart';
import 'package:a230_flowly/presentations/bloc/hobby_cubit.dart';
import 'package:a230_flowly/presentations/models/category_model.dart';
import 'package:a230_flowly/presentations/models/hobby_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  // Текстовые поля
  final _projectNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  // ignore: unused_field
  String _imagePath = '';
  // Фото (обложка)
  XFile? _selectedPhoto;

  // Поля дат
  DateTime? _startDate;
  DateTime? _endDate;

  // Выбранная категория
  CategoryModel? _selectedCategory;

  // Список категорий для примера
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

  bool _showCategoryDropdown = false; // Для отображения выпадающего списка

  /// Проверяем, заполнены ли все обязательные поля
  bool get _isFormValid {
    return _selectedCategory != null &&
        _projectNameController.text.isNotEmpty &&
        _startDate != null &&
        _endDate != null;
  }

  /// Проверка/запрос разрешений камеры/галереи

  Future<void> _pickImage() async {
    try {
      final status = await Permission.storage.request();
      if (status.isGranted) {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          setState(() {
            _imagePath = pickedFile.path; // Сохраняем путь
            _selectedPhoto = pickedFile; // Сохраняем выбранное фото
          });
        }
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// Выбор даты начала
  /// Сохранение данных хобби
  Future<void> _submitForm() async {
    // Сначала валидируем поля
    if (!_formKey.currentState!.validate()) return;
    if (_startDate == null || _endDate == null) return; // safety-check

    final hobby = HobbyModel(
      image: _selectedPhoto?.path ?? '',
      categoryModel: _selectedCategory!,
      name: _projectNameController.text,
      description: _descriptionController.text,
      startTime: _startDate!,
      endTime: _endDate!,
    );

    // Отправляем через Cubit
    await context.read<HobbyCubit>().addHobby(hobby);

    // Закрываем экран, если всё ок
    if (mounted) Navigator.pop(context);
  }

  void _showCategoryDialog() {
    setState(() {
      _showCategoryDropdown = !_showCategoryDropdown;
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.ensureScreenSize(); // если вы используете screenutil
    return Scaffold(
      backgroundColor: AppColorsFlowly.backroundColor,
      appBar: AppBar(
        title: const Text('New Hobby'),
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
              onTap:
                  () => FocusScope.of(context).unfocus(), // скрыть клавиатуру
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    // на случай длинных форм
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Add a cover',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        12.verticalSpace,

                        // Обложка (фото)
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
                                    style: TextStyle(
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

                        // Категория
                        const Text(
                          'Hobby category*',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ],
                                    )
                                    : Text(
                                      'Select category',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                Icon(Icons.arrow_forward, size: 15),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Название хобби
                        const Text(
                          'Hobby name*',
                          style: TextStyle(
                            fontSize: 12,
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

                        // Описание хобби (опционально)
                        const Text(
                          'Hobby description',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
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
                          // validator не нужен, т.к. необязательное поле
                        ),
                        const SizedBox(height: 20),

                        // Дата начала
                        const Text(
                          'Start date*',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                Icon(Icons.arrow_forward, size: 15),
                              ],
                            ),
                          ),
                        ),
                        20.verticalSpace,

                        // Дата окончания
                        const Text(
                          'End date*',
                          style: TextStyle(
                            fontSize: 12,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                Icon(Icons.arrow_forward, size: 15),
                              ],
                            ),
                          ),
                        ),
                        20.verticalSpace,

                        // Кнопка "Add"
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
                          child: const Text(
                            'Add',
                            style: TextStyle(fontSize: 18, color: Colors.white),
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
                height: 406.h, // или любая другая высота
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
                    // Прокручиваемый список категорий
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
                                              color: AppColorsFlowly.whiteColor,
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
                              ? () =>
                                  setState(() => _showCategoryDropdown = false)
                              : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColorsFlowly.blueColor,
                        disabledBackgroundColor: Color(0xffB8D7F4),
                        minimumSize: Size(double.infinity, 56.h),
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
                    // Title + Close Icon

                    // Calendar
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

                    // Done Button
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

                    // Cancel Button
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
