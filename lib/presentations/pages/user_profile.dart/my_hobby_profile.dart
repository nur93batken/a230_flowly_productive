import 'package:a230_flowly/core/app_colors_flowly.dart';
import 'package:a230_flowly/presentations/pages/user_profile.dart/add_user_screen.dart';
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
  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().loadUsers();
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

      // Основной контент
      body: BlocBuilder<UserCubit, List<UserModel>>(
        builder: (context, users) {
          // Если пользователей нет — показываем заглушку
          if (users.isEmpty) {
            return const Center(child: Text("You don't have a user yet"));
          }

          final user = users.first;

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
                                CircleAvatar(
                                  backgroundColor:
                                      AppColorsFlowly.backroundColor,
                                  radius: 65,
                                  backgroundImage: user.imageProvider,
                                  child:
                                      user.userImage.isEmpty
                                          ? Image.asset(
                                            'assets/icons/Gallery.png',
                                            height: 40,
                                          )
                                          : null,
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
                        // Высоту можно задать явно или обернуть в Expanded,
                        // если TabBarView находится внутри Column
                        height: 200,
                        child: TabBarView(
                          children: [
                            // Контент для вкладки "Recent actions"
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  const Text("You don't have a hobby yet"),

                                  // Пример дополнительного поля:
                                ],
                              ),
                            ),
                            // Контент для вкладки "Progress"
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  // Здесь можно разместить поля, виджеты и т.д.
                                  Center(
                                    child: const Text(
                                      "You don't have a hobby yet",
                                    ),
                                  ),

                                  // Пример дополнительного поля:
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
