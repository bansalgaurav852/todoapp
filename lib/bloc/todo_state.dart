part of 'todo_bloc.dart';

@immutable
abstract class TodoState {
  final List<DataModel> datalist;
  final Box<DataModel>? dataBox;
  final DateTime? selecteddate;
  final String? priority;
  final int? selectedSorting;
  const TodoState({
    required this.datalist,
    required this.dataBox,
    required this.selecteddate,
    required this.priority,
    required this.selectedSorting,
  });
}

class TodoInitial extends TodoState {
  TodoInitial({
    required this.datalist,
    this.dataBox,
    this.selecteddate,
    this.priority,
    this.selectedSorting,
  }) : super(
            datalist: [],
            dataBox: null,
            selecteddate: null,
            priority: null,
            selectedSorting: 0);
  @override
  final List<DataModel> datalist;

  @override
  final Box<DataModel>? dataBox;
  @override
  final DateTime? selecteddate;
  @override
  final String? priority;
  @override
  final int? selectedSorting;

  TodoInitial copyWith({
    List<DataModel>? datalist,
    Box<DataModel>? dataBox,
    DateTime? selecteddate,
    String? priority,
    int? selectedSorting,
  }) {
    return TodoInitial(
      datalist: datalist ?? this.datalist,
      dataBox: dataBox ?? this.dataBox,
      selecteddate: selecteddate ?? this.selecteddate,
      priority: priority ?? this.priority,
      selectedSorting: selectedSorting ?? this.selectedSorting,
    );
  }
}
