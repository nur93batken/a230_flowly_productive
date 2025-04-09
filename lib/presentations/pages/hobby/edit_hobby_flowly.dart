// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:a230_flowly/core/widgets/cupertino_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:a230_flowly/core/app_colors_flowly.dart';
import 'package:a230_flowly/presentations/bloc/hobby_cubit.dart';
import 'package:a230_flowly/presentations/models/category_model.dart';
import 'package:a230_flowly/presentations/models/hobby_model.dart';

class EditHobbiesFlowly extends StatefulWidget {
  final HobbyModel hobby;
  final int hobbyIndex;

  const EditHobbiesFlowly({
    super.key,
    required this.hobby,
    required this.hobbyIndex,
  });

  @override
  State<EditHobbiesFlowly> createState() => _EditHobbiesFlowlyState();
}

class _EditHobbiesFlowlyState extends State<EditHobbiesFlowly> {
  final _formKey = GlobalKey<FormState>();

  // Text controllers
  final _projectNameController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Selected image
  XFile? _selectedPhoto;

  // Date fields
  DateTime? _startDate;
  DateTime? _endDate;

  // Selected category
  CategoryModel? _selectedCategory;

  // Categories list for selection
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
      title: 'Programming',
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

  @override
  void initState() {
    super.initState();
    _selectedPhoto = XFile(widget.hobby.image);
    _projectNameController.text = widget.hobby.name;
    _descriptionController.text = widget.hobby.description;
    _startDate = widget.hobby.startTime;
    _endDate = widget.hobby.endTime;
    _selectedCategory = widget.hobby.categoryModel;
  }

  bool get _isFormValid {
    return _selectedCategory != null &&
        _projectNameController.text.isNotEmpty &&
        _selectedPhoto != null &&
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
      print("Error selecting image: $e");
    }
  }

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
        if (_endDate != null && _endDate!.isBefore(_startDate!)) {
          _endDate = null;
        }
      });
    }
  }

  Future<void> _pickEndDate() async {
    if (_startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select Start date first')),
      );
      return;
    }

    final newDate = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate!,
      firstDate: _startDate ?? DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (newDate != null) {
      setState(() {
        _endDate = newDate;
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate() || _selectedPhoto == null) return;
    if (_startDate == null || _endDate == null) return;

    final hobby = HobbyModel(
      image: _selectedPhoto!.path,
      categoryModel: _selectedCategory!,
      name: _projectNameController.text,
      description: _descriptionController.text,
      startTime: _startDate!,
      endTime: _endDate!,
    );

    await context.read<HobbyCubit>().updateHobby(widget.hobbyIndex, hobby);

    if (mounted) Navigator.pop(context);
    if (mounted) Navigator.pop(context);
  }

  void _showCategoryDialog() {
    setState(() {
      _showCategoryDropdown = !_showCategoryDropdown;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorsFlowly.backroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            showExitandDeleteDialog(context);
          },
          icon: Icon(Icons.keyboard_arrow_left),
        ),
        title: const Text('Edit Hobby'),
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
                        const Text(
                          'Add a cover',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        12.verticalSpace,
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            height: 150,
                            width: 303,
                            decoration: BoxDecoration(
                              color: AppColorsFlowly.whiteColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child:
                                _selectedPhoto == null
                                    ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                    )
                                    : ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        File(_selectedPhoto!.path),
                                        height: 150,
                                        width: 303,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                          ),
                        ),
                        12.verticalSpace,

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

                        // Hobby name
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
                                      ? 'Please enter a hobby name'
                                      : null,
                        ),
                        const SizedBox(height: 20),

                        // Hobby description
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
                        ),
                        const SizedBox(height: 20),

                        // Start date
                        const Text(
                          'Start date*',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _startDate == null
                                      ? 'Select date'
                                      : '${_startDate!.day.toString().padLeft(2, '0')}.'
                                          '${_startDate!.month.toString().padLeft(2, '0')}.'
                                          '${_startDate!.year}',
                                  style: TextStyle(color: Colors.black),
                                ),
                                Icon(Icons.arrow_forward, size: 15),
                              ],
                            ),
                          ),
                        ),
                        20.verticalSpace,

                        // End date
                        const Text(
                          'End date*',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _endDate == null
                                      ? 'Select date'
                                      : '${_endDate!.day.toString().padLeft(2, '0')}.'
                                          '${_endDate!.month.toString().padLeft(2, '0')}.'
                                          '${_endDate!.year}',
                                  style: TextStyle(color: Colors.black),
                                ),
                                Icon(Icons.arrow_forward, size: 15),
                              ],
                            ),
                          ),
                        ),
                        20.verticalSpace,

                        // Save button
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
                            'Save',
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
                height: 406.h, // or any height you prefer
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
}
