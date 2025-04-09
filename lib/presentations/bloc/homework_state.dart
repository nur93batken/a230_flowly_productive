import 'package:equatable/equatable.dart';
import '../models/home_work_model_a230.dart';

class HomeworkState extends Equatable {
  final List<HomeworkModel> allHomeworks;
  final List<HomeworkModel> filteredHomeworks;
  final bool isSearchActive;
  final String searchQuery;

  const HomeworkState({
    required this.allHomeworks,
    required this.filteredHomeworks,
    this.isSearchActive = false,
    this.searchQuery = '',
  });

  HomeworkState copyWith({
    List<HomeworkModel>? allHomeworks,
    List<HomeworkModel>? filteredHomeworks,
    bool? isSearchActive,
    String? searchQuery,
  }) {
    return HomeworkState(
      allHomeworks: allHomeworks ?? this.allHomeworks,
      filteredHomeworks: filteredHomeworks ?? this.filteredHomeworks,
      isSearchActive: isSearchActive ?? this.isSearchActive,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object> get props => [
    allHomeworks,
    filteredHomeworks,
    isSearchActive,
    searchQuery, // ✅ Бул props'ко кошулду
  ];
}
