import 'package:a230_flowly/core/app_colors_flowly.dart';
import 'package:a230_flowly/presentations/bloc/hobby_cubit.dart';
import 'package:a230_flowly/presentations/models/category_model.dart';
import 'package:a230_flowly/presentations/models/hobby_model.dart';
import 'package:a230_flowly/presentations/pages/hobby/add_hobbies_flowly.dart';
import 'package:a230_flowly/presentations/pages/hobby/detail_screen_flowly.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';

class MyHobbyScreenA230 extends StatefulWidget {
  const MyHobbyScreenA230({super.key});

  @override
  State<MyHobbyScreenA230> createState() => _SelectHobbyPageState();
}

class _SelectHobbyPageState extends State<MyHobbyScreenA230> {
  List<HobbyModel> allHobbies = [];
  List<HobbyModel> filteredHobbies = [];
  List<CategoryModel> categories = [];
  String searchQuery = '';
  CategoryModel? selectedCategory;
  int? _currentEditingIndex;
  CategoryModel? _selectedCategory;

  final List<CategoryModel> _categories = [
    CategoryModel(imagePath: 'assets/icons/done.png', title: 'Done'),
    CategoryModel(
      imagePath: 'assets/icons/in_progress.png',
      title: 'In Progress',
    ),
    CategoryModel(imagePath: 'assets/icons/frozen.png', title: 'Frozen'),
  ];

  void _showStatusDialog(BuildContext context) async {
    if (_currentEditingIndex == null) {
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AppColorsFlowly.backroundColor,

              content: Container(
                decoration: BoxDecoration(
                  color: AppColorsFlowly.backroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                height: 280.h,
                width: 335.w,
                child: Column(
                  children: [
                    Row(
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
                            Navigator.pop(context);
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
                                context.read<HobbyCubit>().updateHobbyStatus(
                                  _currentEditingIndex!,
                                  category.title,
                                );
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
                                      SizedBox(width: 3.w),
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
                              ? () {
                                Navigator.pop(context);
                              }
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
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    final hobbyBox = Hive.box<HobbyModel>('hobbies');
    allHobbies = hobbyBox.values.toList();

    final categorySet = <String, CategoryModel>{};
    for (var hobby in allHobbies) {
      categorySet[hobby.categoryModel.title] = hobby.categoryModel;
    }
    categories = categorySet.values.toList();

    _applyFilters();
  }

  void _applyFilters() {
    filteredHobbies =
        allHobbies.where((hobby) {
          final matchesSearch = hobby.name.toLowerCase().contains(
            searchQuery.toLowerCase(),
          );
          final matchesCategory =
              selectedCategory == null ||
              hobby.categoryModel.title == selectedCategory!.title;
          return matchesSearch && matchesCategory;
        }).toList();
    setState(() {});
  }

  void _onCategorySelected(CategoryModel? category) {
    setState(() {
      selectedCategory = selectedCategory == category ? null : category;
    });
    _applyFilters();
  }

  void _onSearchChanged(String query) {
    setState(() {
      searchQuery = query;
    });
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorsFlowly.backroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(12),
          ),
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              "My hobby",
              style: TextStyle(
                color: Colors.black,
                fontSize: 28,
                fontFamily: 'Instrument Sans',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              16.verticalSpace,

              if (allHobbies.isNotEmpty &&
                  categories.isNotEmpty &&
                  categories.length >= 3)
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: categories.length,
                    itemBuilder: (_, index) {
                      final cat = categories[index];
                      final isSelected = selectedCategory?.title == cat.title;

                      return GestureDetector(
                        onTap: () => _onCategorySelected(cat),
                        child: Container(
                          width: 100,
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color:
                                  isSelected
                                      ? const Color(0xFF64B3FD)
                                      : Colors.transparent,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(cat.imagePath, width: 34, height: 34),
                              6.verticalSpace,
                              Expanded(
                                child: Text(
                                  cat.title,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

              if (allHobbies.isNotEmpty && allHobbies.length >= 3)
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    top: 16,
                    bottom: 8,
                  ),
                  child: TextField(
                    cursorColor: Color(0xFF797979),
                    style: TextStyle(
                      color: const Color(0xFF797979),
                      fontSize: 16,
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SvgPicture.asset(
                          "assets/icons/search.svg",
                          height: 16,
                          width: 16,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Search",

                      hintStyle: TextStyle(
                        color: const Color(0xFF797979),
                        fontSize: 16,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w400,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 12,
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
                    onChanged:
                        allHobbies.isNotEmpty
                            ? (value) => _onSearchChanged(value)
                            : null,
                  ),
                ),

              Expanded(
                child: Builder(
                  builder: (_) {
                    if (allHobbies.isEmpty) {
                      return const Center(
                        child: Text(
                          "No hobbies yet.\nTry adding some first!",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      );
                    }

                    if (filteredHobbies.isEmpty) {
                      return const Center(
                        child: Text(
                          "No results found.",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: filteredHobbies.length,
                      itemBuilder: (_, index) {
                        final hobby = filteredHobbies[index];
                        final duration = hobby.endTime.difference(
                          DateTime.now(),
                        );

                        String timeLeftText;
                        if (duration.inDays >= 1) {
                          timeLeftText = '${duration.inDays} days left';
                        } else if (duration.inHours >= 1) {
                          timeLeftText = '${duration.inHours} hours left';
                        } else {
                          timeLeftText = 'Less than an hour left';
                        }

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
                          child: Card(
                            color: Colors.white,
                            elevation: 0,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      hobby.image,
                                      height: 150,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  8.verticalSpace,
                                  Row(
                                    children: [
                                      Image.asset(
                                        hobby.categoryModel.imagePath,
                                        width: 24,
                                      ),
                                      8.horizontalSpace,
                                      Text(
                                        hobby.categoryModel.title,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontFamily: 'Instrument Sans',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  4.verticalSpace,
                                  Text(
                                    hobby.description,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontFamily: 'Instrument Sans',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  6.verticalSpace,
                                  Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            _currentEditingIndex = index;
                                            _showStatusDialog(context);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 8,
                                              horizontal: 12,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(230),
                                              border: Border.all(
                                                color:
                                                    _getBorderColorForCategory(
                                                      hobby.status ?? 'Unknown',
                                                    ),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '${hobby.status}',
                                                  style: TextStyle(
                                                    color:
                                                        _getBorderColorForCategory(
                                                          hobby.status ??
                                                              'Unknown',
                                                        ),
                                                    fontSize: 12,
                                                    fontFamily:
                                                        'Instrument Sans',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                4.horizontalSpace,
                                                Image.asset(
                                                  _getCategoryIcon(
                                                    hobby.status ?? 'Unknown',
                                                  ),
                                                  width: 24.w,
                                                  height: 24.h,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      6.horizontalSpace,

                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            timeLeftText,
                                            style: const TextStyle(
                                              color: Color(0xFF797979),
                                              fontSize: 16,
                                              fontFamily: 'Instrument Sans',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            "${hobby.startTime.toLocal().toString().split(' ')[0]} → ${hobby.endTime.toLocal().toString().split(' ')[0]}",
                                            style: const TextStyle(
                                              color: Color(0xFF797979),
                                              fontSize: 12,
                                              fontFamily: 'Instrument Sans',
                                              fontWeight: FontWeight.w500,
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
                    );
                  },
                ),
              ),
            ],
          ),
        ],
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
}

Color _getBorderColorForCategory(String status) {
  if (status == 'Done') {
    return Colors.green;
  } else if (status == 'In Progress') {
    return Colors.orange;
  } else if (status == 'Frozen') {
    return Colors.blue;
  } else {
    return Colors.black;
  }
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
      return 'assets/icons/default.png';
  }
}
