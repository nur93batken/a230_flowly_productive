import 'package:a230_flowly/core/app_colors_flowly.dart';
import 'package:a230_flowly/presentations/bloc/user_cubit.dart';
import 'package:a230_flowly/presentations/models/user_model.dart';
import 'package:a230_flowly/presentations/pages/main/main_screen_flowly.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'dart:io';

class AddOrEditUserScreen extends StatefulWidget {
  final bool isEditing;
  final int? index;
  final UserModel? user;

  const AddOrEditUserScreen({
    super.key,
    this.isEditing = false,
    this.index,
    this.user,
  });

  @override
  State<AddOrEditUserScreen> createState() => _AddOrEditUserScreenState();
}

class _AddOrEditUserScreenState extends State<AddOrEditUserScreen> {
  final _nameController = TextEditingController();
  String _imagePath = '';
  bool get _isButtonEnabled => _nameController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.user != null) {
      _nameController.text = widget.user!.name;
      _imagePath = widget.user!.userImage;
    }
    _nameController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final status = await Permission.storage.request();
      if (status.isGranted) {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          setState(() => _imagePath = pickedFile.path);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Разрешение берилген жок!')),
        );
      }
    } catch (e) {
      print("Ката: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final userCubit = context.read<UserCubit>();

    return Scaffold(
      appBar:
          widget.isEditing
              ? AppBar(
                title: Text(
                  'Edit profile',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              )
              : null,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Enter some information about yourself',
                style: TextStyle(
                  color: AppColorsFlowly.black,
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: GestureDetector(
                onTap: () {
                  if (_imagePath.isEmpty) {
                    _pickImage();
                  } else {
                    _showEditPhotoDialog(context);
                  }
                },
                child: CircleAvatar(
                  backgroundColor: AppColorsFlowly.backroundColor,

                  radius: 70,
                  backgroundImage:
                      _imagePath.isNotEmpty
                          ? FileImage(File(_imagePath))
                          : null,
                  child:
                      _imagePath.isEmpty
                          ? Image.asset(
                            'assets/icons/Gallery.png',
                            height: 33,
                            width: 33,
                          )
                          : null,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Name',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.name,
              controller: _nameController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                filled: true,
                fillColor: AppColorsFlowly.backroundColor,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(15),
                ),
                hintText: 'What is your name?',
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColorsFlowly.blueColor,
                disabledBackgroundColor: Color(0xffC1E1FF),
                minimumSize: Size(double.infinity, 48),
              ),
              onPressed:
                  _isButtonEnabled
                      ? () {
                        final name = _nameController.text.trim();
                        if (widget.isEditing && widget.index != null) {
                          userCubit.updateUser(widget.index!, name, _imagePath);
                        } else {
                          userCubit.addUser(name, _imagePath);
                        }
                        if (widget.isEditing && widget.index != null) {
                          Navigator.pop(context);
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainScreenFlowly(),
                            ),
                          );
                        }
                      }
                      : null,
              child: Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  _showEditPhotoDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext ctx) {
        return Center(
          child: Container(
            width: MediaQuery.of(ctx).size.width * 0.8,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColorsFlowly.backroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            // Используем Material, чтобы InkWell/GestureDetector работали поверх
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Заголовок + кнопка "X"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 20),
                      const Text(
                        'Edit photo',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(ctx).pop(),
                        child: const Icon(
                          Icons.close,
                          color: AppColorsFlowly.blueColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Кнопка "Change the photo"
                  InkWell(
                    onTap: () {
                      Navigator.of(ctx).pop(); // Закрываем диалог
                      _pickImage(); // Открываем галерею
                    },
                    child: Container(
                      height: 45,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColorsFlowly.whiteColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Center(child: const Text('Change the photo')),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Кнопка "Delete"
                  InkWell(
                    onTap: () {
                      Navigator.of(ctx).pop(); // Закрываем диалог
                      setState(() {
                        _imagePath = ''; // Удаляем текущее фото
                      });
                    },
                    child: Container(
                      height: 45,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColorsFlowly.redColor.withAlpha(25),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Center(
                        child: Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                  10.verticalSpace,
                  Container(height: 1, color: Colors.grey[300]),
                  10.verticalSpace,

                  // Кнопка "Back"
                  InkWell(
                    onTap: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Container(
                      height: 45,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColorsFlowly.whiteColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Center(child: const Text('Back')),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
