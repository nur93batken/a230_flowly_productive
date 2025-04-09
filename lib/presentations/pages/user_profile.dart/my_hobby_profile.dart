import 'dart:io' show File;

import 'package:a230_flowly/core/app_colors_flowly.dart';
import 'package:a230_flowly/presentations/bloc/hobby_cubit.dart';
import 'package:a230_flowly/presentations/models/hobby_model.dart';
import 'package:a230_flowly/presentations/pages/user_profile.dart/add_user_screen.dart';
import 'package:a230_flowly/presentations/widgets/progress_bar_flowly.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:a230_flowly/presentations/bloc/user_cubit.dart';
import 'package:a230_flowly/presentations/models/user_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyHobbyProfile extends StatefulWidget {
  const MyHobbyProfile({super.key});

  @override
  State<MyHobbyProfile> createState() => _MyHobbyProfileState();
}

class _MyHobbyProfileState extends State<MyHobbyProfile> {
  //HobbyModel? hobby; // Use nullable instead of late

  @override
  void initState() {
    super.initState();
    // Load users initially, can later be updated based on your logic
    context.read<UserCubit>().loadUsers();
    context.read<HobbyCubit>().loadHobbies();
  }

  @override
  Widget build(BuildContext context) {
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

          return BlocBuilder<HobbyCubit, List<HobbyModel>>(
            builder: (context, hobbies) {
              if (hobbies.isEmpty) {
                return Center(child: Text("Хоббилер жок"));
              }

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
                                                (context) =>
                                                    AddOrEditUserScreen(
                                                      isEditing: true,
                                                      user: user,
                                                      index: 0,
                                                    ),
                                          ),
                                        );
                                      },
                                      child: CircleAvatar(
                                        radius: 28,
                                        backgroundColor:
                                            AppColorsFlowly.blueColor,
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
                                                borderRadius:
                                                    BorderRadius.circular(75),
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
                                                        BorderRadius.circular(
                                                          75,
                                                        ),
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

                                // Текст "0 active hobbies"
                                Text(
                                  "0 active hobbies",
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
                          SizedBox(
                            height: 500,
                            child: TabBarView(
                              children: [
                                // Контент для вкладки "Recent actions"
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: hobbies.length,
                                        itemBuilder: (context, index) {
                                          final hobby = hobbies[index];
                                          return Container(
                                            height: 100,
                                            width: 335,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color:
                                                  AppColorsFlowly
                                                      .backroundColor,
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Image.asset(
                                                      hobby
                                                          .progressImages
                                                          .first,
                                                    ),
                                                    Text('Zarlyk'),
                                                  ],
                                                ),
                                                // Row(
                                                //   children: [
                                                //     Text(
                                                //       DateFormat(
                                                //         'dd.MM.yy',
                                                //       ).format(hobby.startTime),
                                                //     ),
                                                //     Image.asset(hobby.status!),
                                                //   ],
                                                // ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                // Контент для вкладки "Progress"
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [ProgressBar(progress: 30)],
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
          );
        },
      ),
    );
  }
}
