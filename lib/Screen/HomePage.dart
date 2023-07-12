import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/bloc/todo_bloc.dart';
import 'package:todoapp/helper/utils.dart';
import 'package:todoapp/model/todoModel.dart';

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customappbar(),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SearchBar(
                controller: searchController,
                hintText: "Search",
                onChanged: (value) {
                  context
                      .read<TodoBloc>()
                      .add(SearchEvent(searchkeyword: value));
                },
              ),
              Expanded(
                child: items.isEmpty
                    ? const Text("Empty")
                    : ListView.separated(
                        separatorBuilder: (_, index) => const Divider(),
                        itemCount: items.length,
                        itemBuilder: (_, index) {
                          final int key = state.dataBox!.keyAt(index);
                          final DataModel data = items[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: data.complete ? Colors.green : Colors.white,
                            child: ListTile(
                              isThreeLine: true,
                              title: Text(
                                data.title,
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(data.description,
                                      style: const TextStyle(
                                          fontSize: 15, color: Colors.black38)),
                                  Text(
                                      "Due Date : ${Utils.dateformat(data.duedate)}",
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.black38)),
                                  Text("Priority Level : ${data.priority}",
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.black38)),
                                ],
                              ),
                              leading: Text(
                                "${index + 1}.",
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.black),
                              ),
                              trailing: PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value.compareTo("Edit") == 0) {
                                    titleController.text = data.title;
                                    descriptionController.text =
                                        data.description;
                                    formdialog(key: key);
                                  } else if (value.compareTo("Delete") == 0) {
                                    context
                                        .read<TodoBloc>()
                                        .add(DeleteTodoEvent(key: key));
                                  } else {
                                    DataModel updateddata = DataModel(
                                        title: data.title,
                                        description: data.description,
                                        complete: true,
                                        createdate: DateTime.now(),
                                        duedate: state.selecteddate ??
                                            DateTime.now(),
                                        priority: state.priority!);
                                    context.read<TodoBloc>().add(
                                        UpdateTodoEvent(
                                            key: key,
                                            updateddata: updateddata));
                                  }
                                },
                                itemBuilder: (BuildContext context) {
                                  return ["Edit", "Delete", "Completed"]
                                      .map((option) {
                                    return PopupMenuItem(
                                      value: option,
                                      child: Text(option),
                                    );
                                  }).toList();
                                },
                              ),
                            ),
                          );
                        },
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
            backgroundColor: Colors.blueGrey[100],
            child: Container(
                padding: const EdgeInsets.all(16),
                child: BlocBuilder<TodoBloc, TodoInitial>(
                  builder: (context, state) {
                    return Form(
                      key: _formKey,
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
                            decoration:
                                const InputDecoration(hintText: "Description"),
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
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.black))),
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
                            items: <String>['Low', 'High']
                                .map<DropdownMenuItem<String>>((String value) {
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
                                  context.read<TodoBloc>().add(UpdateTodoEvent(
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
                    );
                  },
                ))),
        context: context);
  }

  AppBar customappbar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black,
      title: const Text("TODO App"),
      actions: const <Widget>[],
    );
  }
}
