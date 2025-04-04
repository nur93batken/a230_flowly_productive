import 'package:a230_flowly/presentations/models/category_model.dart';
import 'package:a230_flowly/presentations/models/hobby_model.dart';
import 'package:flutter/material.dart';
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
      appBar: AppBar(title: const Text("Hobbies")),
      body: Column(
        children: [
          // Category Chips
          if (allHobbies.isNotEmpty)
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (_, index) {
                  final cat = categories[index];
                  final isSelected = selectedCategory?.title == cat.title;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ChoiceChip(
                      label: Text(cat.title),
                      selected: isSelected,
                      onSelected: (_) => _onCategorySelected(cat),
                      avatar: Image.asset(cat.imagePath, width: 24),
                    ),
                  );
                },
              ),
            ),

          // Search Field
          if (allHobbies.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                onChanged: _onSearchChanged,
                decoration: const InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),

          // Hobby List
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
                    return GestureDetector(
                      onTap: () => Navigator.pop(context, hobby),
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                hobby.image,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                hobby.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(hobby.description),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Chip(
                                    label: Text(hobby.categoryModel.title),
                                    avatar: Image.asset(
                                      hobby.categoryModel.imagePath,
                                      width: 20,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    "${hobby.startTime.toLocal().toString().split(' ')[0]} → ${hobby.endTime.toLocal().toString().split(' ')[0]}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
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
