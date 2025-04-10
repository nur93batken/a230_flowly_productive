import 'dart:io';
import 'package:a230_flowly/core/app_colors_flowly.dart';
import 'package:a230_flowly/presentations/bloc/hobby_cubit.dart';
import 'package:a230_flowly/presentations/models/category_model.dart';
import 'package:a230_flowly/presentations/models/hobby_model.dart';
import 'package:a230_flowly/presentations/pages/hobby/add_hobbies_flowly.dart';
import 'package:a230_flowly/presentations/pages/hobby/detail_screen_flowly.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class MyHobbyScreenFlowly extends StatefulWidget {
  const MyHobbyScreenFlowly({super.key});

  @override
  State<MyHobbyScreenFlowly> createState() => _MyHobbyScreenFlowlyState();
}

class _MyHobbyScreenFlowlyState extends State<MyHobbyScreenFlowly> {
  final _searchController = TextEditingController();
  List<CategoryModel> _availableCategories = [];
  final Set<String> _selectedCategoryTitles = {};
  @override
  void initState() {
    super.initState();
    context.read<HobbyCubit>().loadHobbies(); // Загружаем хобби при старте
  }

  final List<CategoryModel> _categories = [
    CategoryModel(imagePath: 'assets/icons/done.png', title: 'Done'),
    CategoryModel(
      imagePath: 'assets/icons/in_progress.png',
      title: 'In Progress',
    ),
    CategoryModel(imagePath: 'assets/icons/frozen.png', title: 'Frozen'),
  ];
  CategoryModel? _selectedCategory;
  int? _currentEditingIndex;

  bool _showCategoryDropdown = false;

  void _showCategoryDialog() {
    setState(() {
      _showCategoryDropdown = !_showCategoryDropdown;
    });
  }

  String _getCategoryIcon(String status) {
    switch (status) {
      case 'Done':
        return 'assets/icons/done.png';
      case 'In Progress':
        return 'assets/icons/in_progress.png';
      case 'Frozen':
        return 'assets/icons/frozen.png';
      default:
        return 'assets/icons/default.png'; // Стандартное изображение на случай ошибки
    }
  }

  List<CategoryModel> _getUniqueCategories(List<HobbyModel> hobbies) {
    Set<String> uniqueTitles = {};
    List<CategoryModel> categories = [];

    for (var hobby in hobbies) {
      if (!uniqueTitles.contains(hobby.categoryModel.title)) {
        uniqueTitles.add(hobby.categoryModel.title);
        categories.add(hobby.categoryModel);
      }
    }
    return categories;
  }

  List<HobbyModel> _filterHobbies(
    List<HobbyModel> hobbies,
    String query,
    Set<String> selectedCategories,
  ) {
    return hobbies.where((hobby) {
      final nameMatches = hobby.name.toLowerCase().contains(
        query.toLowerCase(),
      );
      final categoryMatches =
          selectedCategories.isEmpty ||
          selectedCategories.contains(hobby.categoryModel.title);

      return nameMatches &&
          categoryMatches; // Only show hobbies that match selected categories
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorsFlowly.backroundColor,
      appBar: AppBar(
        backgroundColor: AppColorsFlowly.whiteColor,
        title: const Text(
          'My hobby',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        actions: [
          Image.asset(
            'assets/icons/Star2.png',
            color: AppColorsFlowly.black,
            height: 32,
            width: 32,
          ),
          const SizedBox(width: 16),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
          side: BorderSide(color: AppColorsFlowly.backroundColor),
        ),
      ),
      body: BlocBuilder<HobbyCubit, List<HobbyModel>>(
        builder: (context, hobbies) {
          _availableCategories = _getUniqueCategories(hobbies);
          bool showFilters = hobbies.length >= 3;

          List<HobbyModel> filteredHobbies = _filterHobbies(
            hobbies,
            _searchController.text,
            _selectedCategoryTitles,
          );

          if (filteredHobbies.isEmpty) {
            return _EmptyPlaceHolder();
          }
          return Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showFilters)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            SizedBox(
                              height: 80,
                              child: ListView.separated(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final category = _availableCategories[index];
                                  final isSelected = _selectedCategoryTitles
                                      .contains(category.title);
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (isSelected) {
                                          _selectedCategoryTitles
                                              .clear(); // Remove if already selected
                                        } else {
                                          _selectedCategoryTitles.clear();
                                          _selectedCategoryTitles.add(
                                            category.title,
                                          ); // Add to selected categories
                                        }
                                      });
                                    },

                                    child: Container(
                                      height: 78,
                                      width: 74,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color:
                                              isSelected
                                                  ? AppColorsFlowly.blueColor
                                                  : AppColorsFlowly
                                                      .whiteColor, // Highlight selected category
                                        ),
                                        color: AppColorsFlowly.whiteColor,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            category.imagePath,
                                            height: 36,
                                            width: 36,
                                          ),
                                          Text(
                                            category.title,
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder:
                                    (context, index) => 10.horizontalSpace,
                                itemCount: _availableCategories.length,
                              ),
                            ),
                            16.verticalSpace,
                            TextFormField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                prefixIcon: Icon(Icons.search),
                                fillColor: Colors.white,
                                filled: true,
                                hintText: 'Search',
                                hintStyle: const TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              // validator не нужен, т.к. необязательное поле
                            ),
                            16.verticalSpace,
                          ],
                        ),

                      ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final hobby = hobbies[index];
                          final status =
                              hobby.status!.isNotEmpty
                                  ? hobby.status
                                  : 'In Progress';

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => DetailScreenFlowly(
                                        hobby: hobby,
                                        hobbyIndex: index,
                                      ),
                                ),
                              );
                            },
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: AppColorsFlowly.whiteColor,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    hobby.image.isNotEmpty
                                        ? ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: Image.file(
                                            File(hobby.image),
                                            height: 150,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                        : Container(),
                                    12.verticalSpace,
                                    Row(
                                      children: [
                                        Image.asset(
                                          hobby.categoryModel.imagePath,
                                          height: 24,
                                          width: 24,
                                          fit: BoxFit.cover,
                                        ),
                                        10.horizontalSpace,
                                        Text(
                                          hobby.name,
                                          style: TextStyle(
                                            color: AppColorsFlowly.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    12.verticalSpace,

                                    Text(
                                      hobby.description,
                                      style: TextStyle(
                                        color: AppColorsFlowly.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    12.verticalSpace,

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            _currentEditingIndex = index;
                                            _showCategoryDialog();
                                          },
                                          child: SizedBox(
                                            height: 40.h,
                                            width: 169,
                                            child: DecoratedBox(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color:
                                                      _getBorderColorForCategory(
                                                        status!,
                                                      ),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                              ),
                                              child: Row(
                                                spacing: 5.w,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
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
                                        ),
                                        Column(
                                          children: [
                                            if (status !=
                                                'Done') // Скрываем для Done
                                              Text(
                                                status == 'Frozen'
                                                    ? '− day later'
                                                    : '${_getDeadlineText(hobby.startTime, hobby.endTime, status)} day${_getDeadlineText(hobby.startTime, hobby.endTime, status) == "1" ? "" : "s"} left',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      AppColorsFlowly.iconGrey,
                                                ),
                                              ),
                                            Text(
                                              status == 'Frozen'
                                                  ? '${DateFormat('dd.MM.yy').format(hobby.startTime)} → −'
                                                  // ignore: unnecessary_null_comparison
                                                  : '${DateFormat('dd.MM.yy').format(hobby.startTime)} → ${hobby.endTime != null ? DateFormat('dd.MM.yy').format(hobby.endTime) : ""}',
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
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => 10.verticalSpace,
                        itemCount: filteredHobbies.length,
                      ),
                    ],
                  ),
                ),
              ),
              if (_showCategoryDropdown)
                Positioned(
                  top: 60,
                  left: 20,
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

                                    if (_currentEditingIndex != null) {
                                      context.read<HobbyCubit>().updateHobbyStatus(
                                        _currentEditingIndex!, // Используем сохраненный индекс
                                        _categories[index].title,
                                      );
                                    }
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
                                                      AppColorsFlowly
                                                          .whiteColor,
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
          );
        },
      ),
      floatingActionButton: SizedBox(
        height: 52.h,
        width: 136.w,
        child: FloatingActionButton(
          elevation: 0,
          backgroundColor: AppColorsFlowly.blueColor,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddHobbiesFlowly()),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Add hobby',
                style: TextStyle(
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
    );
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

  Color _getBorderColorForCategory(String status) {
    if (status == 'Done') {
      return Colors.green; // Зеленый для Done
    } else if (status == 'In Progress') {
      return Colors.orange; // Оранжевый для In Progress
    } else if (status == 'Frozen') {
      return Colors.blue; // Синий для Frozen
    } else {
      return Colors.black; // Черный по умолчанию
    }
  }
}

class _EmptyPlaceHolder extends StatelessWidget {
  const _EmptyPlaceHolder();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Image.asset(
            'assets/icons/Star_Big.png',
            height: 130,
            width: 130,
          ),
        ),
        Text(
          "You don't have a hobby yet",
          style: TextStyle(
            color: AppColorsFlowly.iconGrey,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
