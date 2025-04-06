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
        _selectedPhoto != null &&
        _startDate != null &&
        _endDate != null;
  }

  /// Проверка/запрос разрешений камеры/галереи
  Future<bool> _checkPermissions() async {
    final cameraStatus = await Permission.camera.status;
    final photoStatus = await Permission.photos.status;

    if (!cameraStatus.isGranted || !photoStatus.isGranted) {
      final cameraReq = await Permission.camera.request();
      final photoReq = await Permission.photos.request();

      return cameraReq.isGranted && photoReq.isGranted;
    }
    return true;
  }

  /// Выбрать одно изображение
  Future<void> _pickImage() async {
    final hasPermissions = await _checkPermissions();
    if (!hasPermissions) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Permission denied to access photos or camera'),
        ),
      );
      return;
    }

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() => _selectedPhoto = image);
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  /// Выбор даты начала
  Future<void> _pickStartDate() async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (newDate != null) {
      setState(() {
        _startDate = newDate;

        // Если вдруг endDate уже выбрана и оказалась раньше startDate,
        // обнулим endDate, чтобы заставить пользователя пере-выбрать
        if (_endDate != null && _endDate!.isBefore(_startDate!)) {
          _endDate = null;
        }
      });
    }
  }

  /// Выбор даты окончания
  Future<void> _pickEndDate() async {
    if (_startDate == null) {
      // Если юзер не выбрал startDate, сообщим об этом
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select Start date first')),
      );
      return;
    }

    final newDate = await showDatePicker(
      context: context,
      // Если нет _endDate, берём текущую, иначе уже выбранную
      initialDate: _endDate ?? _startDate!,
      // Заставляем юзера выбирать не раньше _startDate
      firstDate: _startDate ?? DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (newDate != null) {
      setState(() {
        _endDate = newDate;
      });
    }
  }

  /// Сохранение данных хобби
  Future<void> _submitForm() async {
    // Сначала валидируем поля
    if (!_formKey.currentState!.validate() || _selectedPhoto == null) return;
    if (_startDate == null || _endDate == null) return; // safety-check

    final hobby = HobbyModel(
      image: _selectedPhoto!.path,
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
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // скрыть клавиатуру
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
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
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
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(_selectedPhoto!.path),
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedPhoto = null),
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  12.verticalSpace,

                  // Категория
                  const Text(
                    'Hobby category*',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showCategoryDropdown = !_showCategoryDropdown;
                      });
                    },
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
                          Text(
                            _selectedCategory?.title ?? 'Select category',
                            style: TextStyle(
                              color:
                                  _selectedCategory == null
                                      ? Colors.grey
                                      : Colors.black,
                            ),
                          ),
                          const Icon(Icons.arrow_drop_down, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                  if (_showCategoryDropdown)
                    Container(
                      height: 48,

                      padding: const EdgeInsets.all(16),
                      color: Colors.white,
                      child: Column(
                        children:
                            _categories.map((category) {
                              return ListTile(
                                leading: Image.asset(
                                  category.imagePath,
                                  width: 30,
                                  height: 30,
                                ),
                                title: Text(category.title),
                                onTap: () {
                                  setState(() {
                                    _selectedCategory = category;
                                    _showCategoryDropdown = false;
                                  });
                                },
                              );
                            }).toList(),
                      ),
                    ),
                  const SizedBox(height: 20),

                  // Название хобби
                  const Text(
                    'Hobby name*',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                  10.verticalSpace,
                  TextFormField(
                    controller: _projectNameController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 15,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Colors.lightBlueAccent,
                        ),
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
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                  10.verticalSpace,
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 15,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Colors.lightBlueAccent,
                        ),
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
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                  8.verticalSpace,
                  GestureDetector(
                    onTap: _pickStartDate,
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
                      child: Text(
                        _startDate == null
                            ? 'Select date'
                            : '${_startDate!.day.toString().padLeft(2, '0')}.'
                                '${_startDate!.month.toString().padLeft(2, '0')}.'
                                '${_startDate!.year}',
                        style: TextStyle(
                          color:
                              _startDate == null ? Colors.grey : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  20.verticalSpace,

                  // Дата окончания
                  const Text(
                    'End date*',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                  8.verticalSpace,
                  GestureDetector(
                    onTap: _pickEndDate,
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
                      child: Text(
                        _endDate == null
                            ? 'Select date'
                            : '${_endDate!.day.toString().padLeft(2, '0')}.'
                                '${_endDate!.month.toString().padLeft(2, '0')}.'
                                '${_endDate!.year}',
                        style: TextStyle(
                          color: _endDate == null ? Colors.grey : Colors.black,
                        ),
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
                      disabledBackgroundColor: const Color(0xFF8E8E93),
                      backgroundColor:
                          _isFormValid ? const Color(0xFF4FC3F7) : Colors.grey,
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
    );
  }
}
