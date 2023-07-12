// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'todo_bloc.dart';

@immutable
abstract class TodoEvent {}

class Initilizedata extends TodoEvent {}

class SearchEvent extends TodoEvent {
  final String searchkeyword;
  SearchEvent({
    required this.searchkeyword,
  });
}

class PriorityEvent extends TodoEvent {
  final String priority;
  PriorityEvent({
    required this.priority,
  });
}

class DueDateEvent extends TodoEvent {
  final BuildContext context;
  DueDateEvent({
    required this.context,
  });
}

class DeleteTodoEvent extends TodoEvent {
  final int key;
  DeleteTodoEvent({
    required this.key,
  });
}

class AddTodoEvent extends TodoEvent {
  final DataModel data;
  AddTodoEvent({
    required this.data,
  });
}

class UpdateTodoEvent extends TodoEvent {
  final int key;
  final DataModel updateddata;
  UpdateTodoEvent({
    required this.key,
    required this.updateddata,
  });
}
