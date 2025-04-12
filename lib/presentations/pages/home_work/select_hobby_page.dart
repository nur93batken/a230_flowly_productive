import 'package:a230_flowly/core/app_colors_flowly.dart';
import 'package:a230_flowly/presentations/models/category_model.dart';
import 'package:a230_flowly/presentations/models/hobby_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

class SelectHobbyPage extends StatefulWidget {
  const SelectHobbyPage({super.key});

  @override
  State<SelectHobbyPage> createState() => _SelectHobbyPageState();
}

class _SelectHobbyPageState extends State<SelectHobbyPage> {
  List<HobbyModel> allHobbies = [];
  List<HobbyModel> filteredHobbies = [];
  List<CategoryModel> categories = [];
  String searchQuery = '';
  CategoryModel? selectedCategory;

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
    // Uncomment this line if you want to show all hobbies initially
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
            bottom: Radius.circular(12), // ← Бул бурчту тегеректейт
          ),
          child: AppBar(
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
              "Hobbies",
              style: GoogleFonts.instrumentSans(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          16.verticalSpace,
          // Category Chips
          if (allHobbies.isNotEmpty)
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

          // Search Field
          if (allHobbies.isNotEmpty)
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
                    borderSide: BorderSide(color: Colors.transparent, width: 0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: Colors.transparent, width: 0),
                  ),
                ),
                onChanged:
                    allHobbies.isNotEmpty
                        ? (value) => _onSearchChanged(value)
                        : null,
              ),
            ),

          // Hobby List
          Expanded(
            child: Builder(
              builder: (_) {
                if (allHobbies.isEmpty) {
                  return Center(
                    child: Text(
                      "No hobbies yet.\nTry adding some first!",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.instrumentSans(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  );
                }

                if (filteredHobbies.isEmpty) {
                  return Center(
                    child: Text(
                      "No results found.",
                      style: GoogleFonts.instrumentSans(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: filteredHobbies.length,
                  itemBuilder: (_, index) {
                    final hobby = filteredHobbies[index];
                    final duration = hobby.endTime.difference(DateTime.now());

                    String timeLeftText;
                    if (duration.inDays >= 1) {
                      timeLeftText = '${duration.inDays} days left';
                    } else if (duration.inHours >= 1) {
                      timeLeftText = '${duration.inHours} hours left';
                    } else {
                      timeLeftText = 'Less than an hour left';
                    }

                    return GestureDetector(
                      onTap: () => Navigator.pop(context, hobby),
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
                              hobby.image.isNotEmpty
                                  ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      hobby.image,
                                      height: 150,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                  : Container(),
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
                                    style: GoogleFonts.instrumentSans(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              4.verticalSpace,
                              Text(
                                hobby.description,
                                style: GoogleFonts.instrumentSans(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              6.verticalSpace,
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                        horizontal: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          230,
                                        ),
                                        border: Border.all(
                                          color: _getBorderColorForCategory(
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
                                            style: GoogleFonts.instrumentSans(
                                              color: _getBorderColorForCategory(
                                                hobby.status ?? 'Unknown',
                                              ),
                                              fontSize: 12,
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
                                  6.horizontalSpace,

                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        timeLeftText,
                                        style: GoogleFonts.instrumentSans(
                                          color: Color(0xFF797979),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        "${hobby.startTime.toLocal().toString().split(' ')[0]} → ${hobby.endTime.toLocal().toString().split(' ')[0]}",
                                        style: GoogleFonts.instrumentSans(
                                          color: Color(0xFF797979),
                                          fontSize: 12,
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
    );
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
