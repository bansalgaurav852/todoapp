import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoapp/main.dart';
import 'package:todoapp/model/todoModel.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoInitial> {
  TodoBloc() : super(TodoInitial(dataBox: null, datalist: const [])) {
    on<TodoEvent>((event, emit) {
      Hive.box<DataModel>(boxName);
    });
    on<Initilizedata>((event, emit) {
      Box<DataModel> dataBox = Hive.box<DataModel>(boxName);
      emit(TodoInitial(
        dataBox: dataBox,
        datalist: dataBox.values.toList(),
      ));
    });
    on<AddTodoEvent>((event, emit) {
      Box<DataModel> dataBox = state.dataBox!;
      dataBox.add(event.data);
      emit(TodoInitial(
        dataBox: dataBox,
        datalist: dataBox.values.toList(),
      ));
    });
    on<DeleteTodoEvent>((event, emit) {
      Box<DataModel> dataBox = state.dataBox!;
      dataBox.delete(event.key);
      emit(TodoInitial(
        dataBox: dataBox,
        datalist: dataBox.values.toList(),
      ));
    });
    on<PriorityEvent>((event, emit) {
      emit(state.copyWith(priority: event.priority));
    });
    on<UpdateTodoEvent>((event, emit) {
      Box<DataModel> dataBox = state.dataBox!;
      dataBox.put(event.key, event.updateddata);
      emit(TodoInitial(
        dataBox: dataBox,
        datalist: dataBox.values.toList(),
      ));
    });
    on<SearchEvent>((event, emit) {
      Box<DataModel> dataBox = state.dataBox!;

      List<DataModel> datalist = [];

      for (var e in dataBox.values) {
        if (e.title.contains(event.searchkeyword)) {
          datalist.add(e);
        }
        continue;
      }
      emit(TodoInitial(
        dataBox: dataBox,
        datalist: datalist,
      ));
    });
    on<DueDateEvent>((event, emit) async {
      await showDatePicker(
              context: event.context,
              initialDate: DateTime.now(), //get today's date
              firstDate: DateTime(
                  2000), //DateTime.now() - not to allow to choose before today.
              lastDate: DateTime(2101))
          .then((value) {
        if (value != null) {
          emit(state.copyWith(selecteddate: value));
        } else {
          print("Date is not selected");
        }
      });
    });
  }
}
