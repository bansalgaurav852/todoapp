import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/Screen/widget/appbar.dart';
import 'package:todoapp/bloc/todo_bloc.dart';
import 'package:todoapp/helper/utils.dart';
import 'package:todoapp/model/todoModel.dart';

import 'package:timezone/data/latest.dart' as tz;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    context.read<TodoBloc>().add(Initilizedata());
    tz.initializeTimeZones();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const Customappbar(),
        floatingActionButton: FloatingActionButton(
          onPressed: formdialog,
          child: const Icon(Icons.add),
        ),
        body: body());
  }

  Widget body() {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        var items = state.datalist;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: const BoxDecoration(color: Colors.black12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              SearchBar(
                elevation: MaterialStateProperty.all(2),
                controller: searchController,
                hintText: "Search",
                onChanged: (value) {
                  context
                      .read<TodoBloc>()
                      .add(SearchEvent(searchkeyword: value));
                },
              ),
              const SizedBox(height: 12),
              Expanded(
                child: items.isEmpty
                    ? const Center(child: Text("Empty"))
                    : GridView.builder(
                        itemCount: items.length,
                        itemBuilder: (_, index) {
                          final int key = state.dataBox!.keyAt(index);
                          final DataModel data = items[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            color: data.complete
                                ? const Color.fromARGB(255, 25, 69, 26)
                                : null,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${index + 1}.",
                                        style: const TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              data.title,
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      PopupMenuButton<String>(
                                        onSelected: (value) {
                                          if (value.compareTo("Edit") == 0) {
                                            titleController.text = data.title;
                                            descriptionController.text =
                                                data.description;
                                            formdialog(key: key);
                                          } else if (value
                                                  .compareTo("Delete") ==
                                              0) {
                                            context
                                                .read<TodoBloc>()
                                                .add(DeleteTodoEvent(key: key));
                                          } else if (value
                                                  .compareTo("Completed") ==
                                              0) {
                                            DataModel updateddata = DataModel(
                                                title: data.title,
                                                description: data.description,
                                                complete: true,
                                                createdate: data.createdate,
                                                duedate: data.duedate,
                                                priority: data.priority);
                                            context.read<TodoBloc>().add(
                                                UpdateTodoEvent(
                                                    key: key,
                                                    updateddata: updateddata));
                                          } else if (value
                                                  .compareTo('Set Reminder') ==
                                              0) {
                                            context.read<TodoBloc>().add(
                                                SetReminderEvent(
                                                    key: key,
                                                    data: data,
                                                    context: context));
                                          }
                                        },
                                        itemBuilder: (BuildContext context) {
                                          return [
                                            "Edit",
                                            "Delete",
                                            "Completed",
                                            "Set Reminder"
                                          ].map((option) {
                                            return PopupMenuItem(
                                              value: option,
                                              child: Text(option),
                                            );
                                          }).toList();
                                        },
                                      ),
                                    ],
                                  ),
                                  Text(data.description,
                                      style: const TextStyle(
                                        fontSize: 15,
                                      )),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "Date : ${Utils.dateformat(data.duedate)}",
                                          style: const TextStyle(
                                            fontSize: 14,
                                          )),
                                      Text("Priority  : ${data.priority}",
                                          style: const TextStyle(
                                            fontSize: 14,
                                          )),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  formdialog({int? key}) {
    showDialog(
        builder: (context) => Dialog(
            child: Container(
                padding: const EdgeInsets.all(16),
                child: BlocBuilder<TodoBloc, TodoInitial>(
                  builder: (context, state) {
                    return Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            TextFormField(
                              decoration:
                                  const InputDecoration(hintText: "Title"),
                              controller: titleController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Enter Title";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                  hintText: "Description"),
                              controller: descriptionController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Enter Description";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      context
                                          .read<TodoBloc>()
                                          .add(DueDateEvent(context: context));
                                    },
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          border: Border(bottom: BorderSide())),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      child: Text(state.selecteddate == null
                                          ? "Select Date"
                                          : Utils.dateformat(
                                              state.selecteddate!)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            DropdownButton<String>(
                              hint: const Text("Priority"),
                              isExpanded: true,
                              value: state.priority,
                              elevation: 16,
                              underline: DropdownButtonHideUnderline(
                                child: Container(),
                              ),
                              onChanged: (String? newValue) {},
                              items: <String>[
                                'Low',
                                'High'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  onTap: () {
                                    context
                                        .read<TodoBloc>()
                                        .add(PriorityEvent(priority: value));
                                  },
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              child: Text(
                                key == null ? "Add task" : "Update task",
                                style: const TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate() &&
                                    state.priority != null &&
                                    state.selecteddate != null) {
                                  final String title = titleController.text;

                                  final String description =
                                      descriptionController.text;
                                  titleController.clear();
                                  descriptionController.clear();
                                  DataModel data = DataModel(
                                      title: title,
                                      description: description,
                                      complete: false,
                                      createdate: DateTime.now(),
                                      duedate: state.selecteddate!,
                                      priority: state.priority!);
                                  if (key == null) {
                                    context
                                        .read<TodoBloc>()
                                        .add(AddTodoEvent(data: data));
                                  } else {
                                    context.read<TodoBloc>().add(
                                        UpdateTodoEvent(
                                            key: key, updateddata: data));
                                  }

                                  Navigator.pop(context);
                                } else if (state.selecteddate == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text("Select Date")));
                                } else if (state.priority == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text("Set priority")));
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ))),
        context: context);
  }
}
