import 'dart:io';

import 'package:a230_flowly/core/app_colors_flowly.dart';
import 'package:a230_flowly/presentations/bloc/user_cubit.dart';
import 'package:a230_flowly/presentations/models/user_model.dart';
import 'package:a230_flowly/presentations/pages/main/main_screen_flowly.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

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
      if (_imagePath.isNotEmpty) {}
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

  Future<String> _copyImageToPermanentDirectory(String imagePath) async {
    final File imageFile = File(imagePath);
    final Directory appDir = await getApplicationDocumentsDirectory();
    final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final File permanentFile = await imageFile.copy('${appDir.path}/$fileName');
    return permanentFile.path;
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      final permanentPath = await _copyImageToPermanentDirectory(
        pickedFile.path,
      );
      setState(() {
        // Сүрөттү туруктуу папкага сактоо
        _imagePath = permanentPath; // Жолду сактоо
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userCubit = context.read<UserCubit>();

    return Scaffold(
      appBar:
          widget.isEditing
              ? AppBar(
                title: const Text(
                  'Edit profile',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              )
              : null,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
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
              const SizedBox(height: 24),
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
              const SizedBox(height: 24),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Name',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
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
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColorsFlowly.blueColor,
                  disabledBackgroundColor: const Color(0xffC1E1FF),
                  minimumSize: const Size(double.infinity, 48),
                ),
                onPressed:
                    _isButtonEnabled
                        ? () {
                          final name = _nameController.text.trim();
                          if (widget.isEditing && widget.index != null) {
                            userCubit.updateUser(
                              widget.index!,
                              name,
                              _imagePath,
                            );
                            Navigator.pop(context);
                          } else {
                            userCubit.addUser(name, _imagePath);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const MainScreenFlowly(),
                              ),
                            );
                          }
                        }
                        : null,
                child: const Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditPhotoDialog(BuildContext context) {
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
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 20),
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
                  InkWell(
                    onTap: () {
                      Navigator.of(ctx).pop();
                      _pickImage();
                    },
                    child: Container(
                      height: 45,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColorsFlowly.whiteColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: const Center(child: Text('Change the photo')),
                    ),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      Navigator.of(ctx).pop();
                      setState(() {
                        _imagePath = '';
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
                      child: const Center(
                        child: Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(height: 1, color: Colors.grey[300]),
                  const SizedBox(height: 10),
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
                      child: const Center(child: Text('Back')),
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
