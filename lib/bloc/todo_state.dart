part of 'todo_bloc.dart';

@immutable
abstract class TodoState {
  final List<DataModel> datalist;
  final Box<DataModel>? dataBox;
  final DateTime? selecteddate;
  final String? priority;
  const TodoState({
    required this.datalist,
    required this.dataBox,
    required this.selecteddate,
    required this.priority,
  });
}

class TodoInitial extends TodoState {
  TodoInitial({
    required this.datalist,
    this.dataBox,
    this.selecteddate,
    this.priority,
  }) : super(
          datalist: [],
          dataBox: null,
          selecteddate: null,
          priority: null,
        );
  @override
  final List<DataModel> datalist;

  @override
  final Box<DataModel>? dataBox;
  @override
  final DateTime? selecteddate;
  @override
  final String? priority;

  TodoInitial copyWith({
    List<DataModel>? datalist,
    Box<DataModel>? dataBox,
    DateTime? selecteddate,
    String? priority,
  }) {
    return TodoInitial(
      datalist: datalist ?? this.datalist,
      dataBox: dataBox ?? this.dataBox,
      selecteddate: selecteddate ?? this.selecteddate,
      priority: priority ?? this.priority,
    );
  }
}
