import 'package:a230_flowly/presentations/bloc/homework_cubit.dart';
import 'package:a230_flowly/presentations/bloc/homework_state.dart';
import 'package:a230_flowly/presentations/pages/home_work/add_homework_page.dart';
import 'package:a230_flowly/presentations/widgets/homework_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeWorkPageA230 extends StatelessWidget {
  const HomeWorkPageA230({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Homework"),
        actions: [
          IconButton(
            icon: const Icon(Icons.emoji_events_outlined),
            onPressed: () {
              // TODO: Жетишкендиктер экранына өтүү
            },
          ),
        ],
      ),
      body: BlocBuilder<HomeworkCubit, HomeworkState>(
        builder: (context, state) {
          if (state.allHomeworks.isEmpty) {
            return const Center(child: Text("No homework yet."));
          }

          final showSearch = state.allHomeworks.length >= 5;

          return Column(
            children: [
              if (showSearch)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: "Search by title",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (query) {
                      context.read<HomeworkCubit>().searchHomeworks(query);
                    },
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: state.filteredHomeworks.length,
                  itemBuilder: (context, index) {
                    final homework = state.filteredHomeworks[index];
                    return HomeworkCard(homework: homework);
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const EditHomeworkPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
