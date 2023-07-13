import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:todoapp/helper/LocalNotification.dart';
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
    on<SetReminderEvent>((event, emit) async {
      Box<DataModel> dataBox = state.dataBox!;
      DateTime? dateTime = await getselectedDateTime(context: event.context);
      if (dateTime != null) {
        NotificationService().showNotification(
            event.key, event.data.title, event.data.description, dateTime);

        emit(TodoInitial(
          dataBox: dataBox,
          datalist: dataBox.values.toList(),
        ));
      }
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
      emit(TodoInitial(dataBox: dataBox, datalist: datalist));
    });
    on<DueDateEvent>((event, emit) async {
      DateTime? dateTime = await getselectedDateTime(context: event.context);
      if (dateTime != null) {
        emit(state.copyWith(selecteddate: dateTime));
      }
    });
  }

  Future<DateTime?> getselectedDateTime({required BuildContext context}) async {
    DateTime? dateTime = await showOmniDateTimePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1600).subtract(const Duration(days: 3652)),
      lastDate: DateTime.now().add(
        const Duration(days: 3652),
      ),
      is24HourMode: false,
      isShowSeconds: false,
      minutesInterval: 1,
      secondsInterval: 1,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      constraints: const BoxConstraints(
        maxWidth: 350,
        maxHeight: 650,
      ),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1.drive(
            Tween(
              begin: 0,
              end: 1,
            ),
          ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
    );
    return dateTime;
  }
}
