import 'package:a230_flowly/presentations/models/home_work_model_a230.dart';
import 'package:equatable/equatable.dart';

class HomeworkState extends Equatable {
  final List<HomeworkModel> allHomeworks;
  final List<HomeworkModel> filteredHomeworks;
  final bool isSearchActive;

  const HomeworkState({
    required this.allHomeworks,
    required this.filteredHomeworks,
    this.isSearchActive = false,
  });

  HomeworkState copyWith({
    List<HomeworkModel>? allHomeworks,
    List<HomeworkModel>? filteredHomeworks,
    bool? isSearchActive,
  }) {
    return HomeworkState(
      allHomeworks: allHomeworks ?? this.allHomeworks,
      filteredHomeworks: filteredHomeworks ?? this.filteredHomeworks,
      isSearchActive: isSearchActive ?? this.isSearchActive,
    );
  }

  @override
  List<Object?> get props => [allHomeworks, filteredHomeworks, isSearchActive];
}
