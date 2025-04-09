import 'dart:async';
import 'dart:io';
import 'package:a230_flowly/core/app_colors_flowly.dart';
import 'package:a230_flowly/presentations/pages/hobby/edit_hobby_flowly.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:a230_flowly/presentations/models/hobby_model.dart';
import 'package:a230_flowly/presentations/bloc/hobby_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DetailScreenFlowly extends StatefulWidget {
  final HobbyModel hobby;
  final int hobbyIndex;

  const DetailScreenFlowly({
    super.key,
    required this.hobby,
    required this.hobbyIndex,
  });

  @override
  State<DetailScreenFlowly> createState() => _DetailScreenFlowlyState();
}

class _DetailScreenFlowlyState extends State<DetailScreenFlowly> {
  late TextEditingController _progressController;
  final ImagePicker _picker = ImagePicker();
  final _debounceDuration = const Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    context.read<HobbyCubit>().loadHobbies();
    _progressController = TextEditingController(
      text: widget.hobby.progressNotes?.lastOrNull ?? '',
    );
    _setupAutoSave();
  }

  void _setupAutoSave() {
    _progressController.addListener(() {
      _debounce(() => _saveProgress());
    });
  }

  Timer? _debounceTimer;
  void _debounce(VoidCallback callback) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounceDuration, callback);
  }

  Future<void> _saveProgress() async {
    final newNote = _progressController.text;
    if (newNote.isEmpty) return;

    final updatedHobby = widget.hobby.copyWith(
      progressNotes: [...widget.hobby.progressNotes ?? [], newNote],
    );

    context.read<HobbyCubit>().updateHobby(widget.hobbyIndex, updatedHobby);
  }

  Future<void> _addImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    // Используйте копию списка для иммутабельности
    final updatedImages = List<String>.from(widget.hobby.progressImages)
      ..add(image.path);

    final updatedHobby = widget.hobby.copyWith(progressImages: updatedImages);
    setState(() {
      widget.hobby.progressImages =
          updatedHobby.progressImages; // Жаңыртылган сүрөттөр тизмесин көрсөтүү
    });

    context.read<HobbyCubit>().updateHobby(widget.hobbyIndex, updatedHobby);
  }

  void _showEditPhotoDialog(BuildContext context, int index) {
    if (widget.hobby.progressImages.isEmpty ||
        index < 0 ||
        index >= widget.hobby.progressImages.length) {
      return; // Бош болсо же индекс туура эмес болсо, эч нерсе кылбоо
    }

    showCupertinoDialog(
      context: context,
      builder: (BuildContext ctx) {
        final imagePath = widget.hobby.progressImages[index];

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
                    onTap: () async {
                      Navigator.of(ctx).pop();
                      await _changeImage(index); // Сүрөттү өзгөртүүгө чакыруу
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
                      _deleteImage(imagePath); // Сүрөттү өчүрүү
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

  // Сүрөттү өзгөртүү
  // Change the image by adding it to the list of progress images
  Future<void> _changeImage(int index) async {
    // Эгерде индекс туура эмес болсо, аракет кылбоо керек
    if (index < 0 || index >= widget.hobby.progressImages.length) return;

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    // Индекс боюнча сүрөттүн ордуна жаңы сүрөттү кошо алабыз
    final updatedImages = List<String>.from(widget.hobby.progressImages);
    updatedImages[index] = image.path;

    final updatedHobby = widget.hobby.copyWith(progressImages: updatedImages);

    setState(() {
      widget.hobby.progressImages = updatedHobby.progressImages;
    });

    context.read<HobbyCubit>().updateHobby(widget.hobbyIndex, updatedHobby);
  }

  // Delete an image from progressImages
  void _deleteImage(String imagePath) {
    final updatedImages =
        widget.hobby.progressImages
            .where((path) => path != imagePath) // Өчүрүлгөн сүрөттү алып салуу
            .toList();

    final updatedHobby = widget.hobby.copyWith(
      progressImages: updatedImages, // Тизмени жаңыртуу
    );

    setState(() {
      widget.hobby.progressImages =
          updatedHobby.progressImages; // Жаңыртылган сүрөттөр тизмесин көрсөтүү
    });

    context.read<HobbyCubit>().updateHobby(widget.hobbyIndex, updatedHobby);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorsFlowly.backroundColor,
      appBar: AppBar(
        title: Text(widget.hobby.name),
        actions: [
          IconButton(
            onPressed: () {
              _showEditHobbyDialog(context);
            },
            icon: Icon(Icons.more_horiz),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Основная информация
            _buildMainInfo(),
            20.verticalSpace,
            // Поле ввода прогресса
            _buildImageGallery(),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String? status) {
    switch (status) {
      case 'Done':
        return Colors.green;
      case 'In Progress':
        return Colors.orange;
      case 'Frozen':
        return Colors.blue;
      default:
        return Colors.grey; // Эгерде статус жок болсо
    }
  }

  String _getCategoryIcon(String status) {
    switch (status) {
      case 'Done':
        return 'assets/icons/done.png'; // Icon for Done status
      case 'In Progress':
        return 'assets/icons/in_progress.png'; // Icon for In Progress status
      case 'Frozen':
        return 'assets/icons/frozen.png'; // Icon for Frozen status
      default:
        return 'assets/icons/default.png'; // Default icon for unknown statuses
    }
  }

  String _getDeadlineText(
    DateTime startTime,
    DateTime? endTime,
    String status,
  ) {
    switch (status) {
      case 'Done':
        return ''; // For Done, we don't show anything

      case 'Frozen':
        return '−'; // For Frozen, we show a minus sign

      case 'In Progress':
        if (endTime == null)
          return ''; // If there's no end time, we don't show anything
        final difference = endTime.difference(startTime).inDays;
        return '$difference'; // Show the difference in days

      default:
        return '';
    }
  }

  Widget _buildMainInfo() {
    final status =
        widget.hobby.status!.isNotEmpty ? widget.hobby.status : 'In Progress';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child:
              widget.hobby.image.isNotEmpty
                  ? Image.file(
                    File(widget.hobby.image),
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                  : Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey[200], // Фон түсү
                    child: Center(
                      child: Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  ),
        ),
        const SizedBox(height: 16),
        Text(widget.hobby.description),
        const SizedBox(height: 16),
        Row(
          children: [
            Image.asset(
              widget.hobby.categoryModel.imagePath,
              height: 24,
              width: 24,
            ),
            const SizedBox(width: 8),
            Text(widget.hobby.categoryModel.title),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 40.h,
              width: 169,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: _getCategoryColor(status!)),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  spacing: 5.w,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(status),
                    Image.asset(
                      _getCategoryIcon(status),
                      height: 24,
                      width: 24,
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                if (status != 'Done') // Скрываем для Done
                  Text(
                    status == 'Frozen'
                        ? '− day later'
                        : '${_getDeadlineText(widget.hobby.startTime, widget.hobby.endTime, status)} day${_getDeadlineText(widget.hobby.startTime, widget.hobby.endTime, status) == "1" ? "" : "s"} left',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColorsFlowly.iconGrey,
                    ),
                  ),
                Text(
                  status == 'Frozen'
                      ? '${DateFormat('dd.MM.yy').format(widget.hobby.startTime)} → −'
                      // ignore: unnecessary_null_comparison
                      : '${DateFormat('dd.MM.yy').format(widget.hobby.startTime)} → ${widget.hobby.endTime != null ? DateFormat('dd.MM.yy').format(widget.hobby.endTime) : ""}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColorsFlowly.iconGrey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImageGallery() => GestureDetector(
    onTap: () {
      if (widget.hobby.progressImages.isNotEmpty ||
          widget.hobby.progressNotes!.isNotEmpty) {
        _showdDeleteDialog(context);
      }
    },
    child: DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColorsFlowly.whiteColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _progressController,
              decoration: InputDecoration(
                hintText: 'Write about your progress',
                border: const OutlineInputBorder(borderSide: BorderSide.none),
              ),
              maxLines: 3,
            ),

            10.verticalSpace,
            if (widget.hobby.progressImages.isNotEmpty)
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.hobby.progressImages.length,
                separatorBuilder: (_, __) => 10.verticalSpace,
                itemBuilder: (context, index) {
                  final imagePath = widget.hobby.progressImages[index];

                  if (index < 0 ||
                      index >= widget.hobby.progressImages.length ||
                      !File(widget.hobby.progressImages[index]).existsSync()) {
                    return const SizedBox.shrink();
                  }
                  return GestureDetector(
                    onTap: () {
                      // Добавили проверку индекса
                      if (index >= 0 &&
                          index < widget.hobby.progressImages.length) {
                        _showEditPhotoDialog(context, index);
                      }
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(imagePath),
                        width: double.infinity,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            10.verticalSpace,
            GestureDetector(
              onTap: _addImage,
              child: Image.asset(
                'assets/icons/Gallery.png',
                height: 30,
                width: 30,
              ),
            ),
          ],
        ),
      ),
    ),
  );

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _progressController.dispose();
    super.dispose();
  }

  void _showEditHobbyDialog(BuildContext context) {
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
                        'Edit hobby',
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
                      if (mounted) Navigator.pop(context);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => EditHobbiesFlowly(
                                hobbyIndex: widget.hobbyIndex,
                                hobby: widget.hobby,
                              ),
                        ),
                      );
                    },
                    child: Container(
                      height: 45,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColorsFlowly.whiteColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: const Center(child: Text('Edit')),
                    ),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      Navigator.of(ctx).pop();
                      context.read<HobbyCubit>().deleteHobby(widget.hobbyIndex);
                      Navigator.popUntil(context, (route) => route.isFirst);
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

  void _showdDeleteDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext ctx) {
        return Center(
          // Фон с полупрозрачной подложкой
          child: Container(
            width: MediaQuery.of(ctx).size.width * 0.8,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColorsFlowly.backroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            // Используем Material для InkWell/нажатий (иначе можно GestureDetector)
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Заголовок + кнопка "X" справа
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      15.horizontalSpace,
                      const Text(
                        'Deletion?',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(ctx).pop(),
                        child: const Icon(
                          CupertinoIcons.xmark,
                          color: AppColorsFlowly.blueColor,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () {
                      Navigator.of(ctx).pop();

                      _deleteAllImagesAndText();
                    },
                    child: Container(
                      height: 45,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColorsFlowly.redColor.withAlpha(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Center(
                        child: const Text(
                          'Delete',
                          style: TextStyle(color: AppColorsFlowly.redColor),
                        ),
                      ),
                    ),
                  ),
                  10.verticalSpace,
                  InkWell(
                    onTap: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Container(
                      height: 45,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColorsFlowly.whiteColor,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),

                      child: Center(
                        child: const Text(
                          'Back',
                          style: TextStyle(color: AppColorsFlowly.black),
                        ),
                      ),
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

  void _deleteAllImagesAndText() {
    final updatedHobby = widget.hobby.copyWith(
      progressImages: [], // Бош сүрөттөр тизмеси
      progressNotes: [], // Бош прогресс тексттери
    );

    setState(() {
      widget.hobby.progressImages = updatedHobby.progressImages;
      widget.hobby.progressNotes =
          updatedHobby.progressNotes; // Тексттер дагы өчүрүлөт
    });

    context.read<HobbyCubit>().updateHobby(widget.hobbyIndex, updatedHobby);
  }
}
