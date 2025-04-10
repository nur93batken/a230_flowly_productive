import 'dart:io' show File;

import 'package:a230_flowly/core/app_colors_flowly.dart';
import 'package:a230_flowly/presentations/bloc/hobby_cubit.dart';
import 'package:a230_flowly/presentations/models/actions_model_a230.dart';
import 'package:a230_flowly/presentations/pages/user_profile.dart/add_user_screen.dart';
import 'package:a230_flowly/presentations/widgets/progress_bar_flowly.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:a230_flowly/presentations/bloc/user_cubit.dart';
import 'package:a230_flowly/presentations/models/user_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class MyHobbyProfile extends StatefulWidget {
  const MyHobbyProfile({super.key});

  @override
  State<MyHobbyProfile> createState() => _MyHobbyProfileState();
}

class _MyHobbyProfileState extends State<MyHobbyProfile> {
  final TextEditingController _searchController = TextEditingController();
  List<ActionsModel> allHobbies = [];
  //HobbyModel? hobby; // Use nullable instead of late
  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().loadUsers();
    context.read<HobbyCubit>().loadHobbies();
    final hobbyBox = Hive.box<ActionsModel>('actions');
    allHobbies = hobbyBox.values.toList();
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool showSearch = allHobbies.length >= 3;

    // Текст, который пользователь ввёл в поиске
    final String searchText = _searchController.text.trim().toLowerCase();

    // Эгер издөө тереги бош болсо, бардык карточкаларды, эгер толтурулса,
    // аталышында издөө текстин камтыган карточкаларды гана фильтрлөйбүз
    List<ActionsModel> filteredHobbies =
        searchText.isEmpty
            ? allHobbies
            : allHobbies.where((hobby) {
              final String hobbyName = hobby.hobbyModel.name.toLowerCase();
              return hobbyName.contains(searchText);
            }).toList();

    // Эгер издөөда текст жазылган, бирок эч нерсе табылбаса
    bool nothingFound = filteredHobbies.isEmpty && searchText.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColorsFlowly.whiteColor,
        title: const Text(
          'My hobby profile',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<UserCubit, List<UserModel>>(
        builder: (context, users) {
          // Check if users are empty and handle gracefully
          if (users.isEmpty) {
            return const Center(child: Text("You don't have a user yet"));
          }

          final user = users.first;

          // Initialize hobby here if it's not yet initialized

          return SingleChildScrollView(
            child: Column(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                    color: AppColorsFlowly.blueColor,
                  ),
                  child: Column(
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                          color: AppColorsFlowly.whiteColor,
                        ),
                        child: Column(
                          children: [
                            Row(
                              spacing: 15,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => AddOrEditUserScreen(
                                              isEditing: true,
                                              user: user,
                                              index: 0,
                                            ),
                                      ),
                                    );
                                  },
                                  child: CircleAvatar(
                                    radius: 28,
                                    backgroundColor: AppColorsFlowly.blueColor,
                                    child: Image.asset(
                                      'assets/icons/Edit.png',
                                      height: 36,
                                      width: 36,
                                    ),
                                  ),
                                ),
                                user.userImage.isNotEmpty
                                    ? FutureBuilder(
                                      future: File(user.userImage).exists(),
                                      builder: (context, snapshot) {
                                        if (snapshot.data == true) {
                                          return ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              75,
                                            ),
                                            child: Image.file(
                                              File(user.userImage),
                                              height: 145,
                                              width: 145,
                                              fit: BoxFit.cover,
                                            ),
                                          );
                                        } else {
                                          return SizedBox(
                                            height: 145,
                                            width: 145,
                                            child: DecoratedBox(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(75),
                                                color:
                                                    AppColorsFlowly
                                                        .backroundColor,
                                              ),
                                              child: Image.asset(
                                                'assets/icons/Gallery.png',
                                                height: 40,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    )
                                    : SizedBox(
                                      height: 145,
                                      width: 145,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            75,
                                          ),
                                          color: AppColorsFlowly.backroundColor,
                                        ),
                                        child: Image.asset(
                                          'assets/icons/Gallery.png',
                                          height: 40,
                                        ),
                                      ),
                                    ),
                                CircleAvatar(
                                  radius: 28,
                                  backgroundColor: AppColorsFlowly.iconGrey,
                                  child: Image.asset(
                                    'assets/icons/Notification.png',
                                    height: 36,
                                    width: 36,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Имя пользователя
                            Text(
                              user.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${allHobbies.length} active hobbies',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColorsFlowly.black,
                              ),
                            ),
                            15.verticalSpace,
                          ],
                        ),
                      ),

                      // Цитата
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColorsFlowly.blueColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                        ),
                        child: const Text(
                          '"Success is moving from failure to \nfailure without losing enthusiasm." \n- Winston Churchill',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Переключатели "Recent actions" / "Progress"
                DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      // Сам TabBar с двумя вкладками
                      TabBar(
                        labelStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        labelColor: AppColorsFlowly.blueColor,
                        unselectedLabelColor: AppColorsFlowly.iconGrey,
                        indicatorColor: AppColorsFlowly.blueColor,
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: AppColorsFlowly.iconGrey,
                        automaticIndicatorColorAdjustment: true,
                        tabs: const [
                          Tab(text: "Recent actions"),
                          Tab(text: "Progress"),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // TabBarView для отображения контента каждой вкладки
                      Container(
                        color: AppColorsFlowly.backroundColor,
                        height: 500,
                        child: TabBarView(
                          children: [
                            // Контент для вкладки "Recent actions"
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child:
                                  allHobbies.isEmpty
                                      ? Center(
                                        child: Text(
                                          "You don't have a hobby yet",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: AppColorsFlowly.black,
                                            // кааласаңыз шрифттин салмагын, стилдерин да кошууга болот
                                          ),
                                        ),
                                      )
                                      : Column(
                                        children: [
                                          if (showSearch) ...[
                                            16.verticalSpace,

                                            TextFormField(
                                              controller: _searchController,
                                              onChanged:
                                                  (value) => setState(() {}),
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                      vertical: 10,
                                                    ),
                                                prefixIcon: Icon(Icons.search),
                                                fillColor: Colors.white,
                                                filled: true,
                                                hintText: 'Search',
                                                hintStyle: const TextStyle(
                                                  color: Colors.grey,
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  borderSide: BorderSide.none,
                                                ),
                                              ),
                                            ),
                                            16.verticalSpace,
                                          ],
                                          if (nothingFound)
                                            Expanded(
                                              child: Center(
                                                child: Text(
                                                  'No results found',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                              ),
                                            )
                                          // Иначе показываем список
                                          else
                                            ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount: filteredHobbies.length,
                                              itemBuilder: (context, index) {
                                                final hobby = allHobbies[index];
                                                final duration = hobby.dateTime
                                                    .difference(DateTime.now());
                                                String timeLeftText;
                                                if (duration.inDays >= 1) {
                                                  timeLeftText =
                                                      '${hobby.dateTime}';
                                                } else if (duration.inHours >=
                                                    1) {
                                                  timeLeftText =
                                                      '${duration.inHours} hours left';
                                                } else {
                                                  timeLeftText =
                                                      'Less than an hour left';
                                                }
                                                return Container(
                                                  margin: EdgeInsets.symmetric(
                                                    vertical: 10,
                                                  ),
                                                  padding: EdgeInsets.all(15),
                                                  width: 335,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                    color:
                                                        AppColorsFlowly
                                                            .whiteColor,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Image.asset(
                                                            hobby
                                                                .hobbyModel
                                                                .categoryModel
                                                                .imagePath,
                                                            height: 24,
                                                            width: 24,
                                                          ),
                                                          5.horizontalSpace,
                                                          Text(
                                                            'You started "${hobby.hobbyModel.name}"',
                                                            style: TextStyle(
                                                              color:
                                                                  AppColorsFlowly
                                                                      .black,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      15.verticalSpace,
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            timeLeftText,
                                                            style: TextStyle(
                                                              color:
                                                                  AppColorsFlowly
                                                                      .iconGrey,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                          Image.asset(
                                                            _getCategoryIcon(
                                                              hobby
                                                                  .hobbyModel
                                                                  .status
                                                                  .toString(),
                                                            ),
                                                            height: 24,
                                                            width: 24,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                        ],
                                      ),
                            ),
                            // Контент для вкладки "Progress"
                            // Контент для вкладки "Recent actions"
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child:
                                  allHobbies.isEmpty
                                      ? Center(
                                        child: Text(
                                          "You don't have a hobby yet",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: AppColorsFlowly.black,
                                            // кааласаңыз шрифттин салмагын, стилдерин да кошууга болот
                                          ),
                                        ),
                                      )
                                      : Column(
                                        children: [
                                          Expanded(
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount: allHobbies.length,
                                              itemBuilder: (context, index) {
                                                final hobby = allHobbies[index];
                                                final DateTime startDate =
                                                    DateTime.parse(
                                                      hobby.hobbyModel.startTime
                                                          .toString(),
                                                    );
                                                final DateTime endDate =
                                                    DateTime.parse(
                                                      hobby.hobbyModel.endTime
                                                          .toString(),
                                                    );
                                                final now = DateTime.now();
                                                final today = DateTime(
                                                  now.year,
                                                  now.month,
                                                  now.day,
                                                );
                                                final String? status =
                                                    hobby
                                                        .hobbyModel
                                                        .status; // "Done", "In Progress", "Frozen"

                                                // 2) Эсептөө
                                                double progress = 0.0;

                                                if (status == 'Frozen') {
                                                  progress = 0.0;
                                                } else if (status == 'Done') {
                                                  progress = 100.0;
                                                } else {
                                                  final totalDays =
                                                      endDate
                                                          .difference(startDate)
                                                          .inDays;
                                                  final loadedDays =
                                                      today
                                                          .difference(startDate)
                                                          .inDays;

                                                  final validTotalDays =
                                                      totalDays <= 0
                                                          ? 1
                                                          : totalDays;
                                                  double calculatedProgress =
                                                      (loadedDays /
                                                          validTotalDays) *
                                                      100;
                                                  if (calculatedProgress < 0) {
                                                    calculatedProgress = 0;
                                                  }
                                                  if (calculatedProgress >
                                                      100) {
                                                    calculatedProgress = 100;
                                                  }

                                                  progress = calculatedProgress;
                                                }

                                                return Container(
                                                  margin: EdgeInsets.symmetric(
                                                    vertical: 10,
                                                  ),
                                                  padding: EdgeInsets.all(15),
                                                  width: 335,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                    color:
                                                        AppColorsFlowly
                                                            .whiteColor,
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Image.asset(
                                                            hobby
                                                                .hobbyModel
                                                                .categoryModel
                                                                .imagePath,
                                                            height: 24,
                                                            width: 24,
                                                          ),
                                                          5.horizontalSpace,
                                                          Text(
                                                            hobby
                                                                .hobbyModel
                                                                .name,
                                                          ),
                                                        ],
                                                      ),
                                                      10.verticalSpace,
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: ProgressBar(
                                                              progress:
                                                                  progress,
                                                            ),
                                                          ),
                                                          5.horizontalSpace,
                                                          Text(
                                                            '${progress.toStringAsFixed(0)}%',
                                                            style: TextStyle(
                                                              color:
                                                                  AppColorsFlowly
                                                                      .black,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                          if (progress < 100)
                                                            30.horizontalSpace,
                                                          Image.asset(
                                                            _getCategoryIcon(
                                                              hobby
                                                                  .hobbyModel
                                                                  .status
                                                                  .toString(),
                                                            ),
                                                            height: 24,
                                                            width: 24,
                                                          ),
                                                        ],
                                                      ),
                                                      //  if (progress >= 100)
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          if (progress >= 100)
                                                            Text(
                                                              'Hobby time has come to an end',
                                                              style: TextStyle(
                                                                color:
                                                                    AppColorsFlowly
                                                                        .greenColor,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          if (progress >= 100)
                                                            Image.asset(
                                                              _getCategoryIcon(
                                                                hobby
                                                                    .hobbyModel
                                                                    .status
                                                                    .toString(),
                                                              ),
                                                              height: 24,
                                                              width: 24,
                                                            ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
