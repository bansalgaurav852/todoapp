import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/bloc/todo_bloc.dart';

List sortingchoice = [
  "Due Date:From Newsest",
  "Due Date:From Oldest",
  "Priority:Low",
  "Priority:High",
  "Creation Date:From Newsest",
  "Creation Date:From Oldest",
];
List<Map<String, dynamic>> list = List.generate(sortingchoice.length, (index) {
  return {"key": sortingchoice[index], "index": index};
});

class Customappbar extends StatelessWidget implements PreferredSizeWidget {
  const Customappbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Text("TODO App"),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              showDialog(
                  builder: (context) => AlertDialog(
                        contentPadding: EdgeInsets.zero,
                        title: const Text("Sort by"),
                        content: Container(
                          padding: const EdgeInsets.all(16),
                          child: BlocBuilder<TodoBloc, TodoState>(
                            builder: (context, state) {
                              if (kDebugMode) print(state.selectedSorting);
                              return SingleChildScrollView(
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: list
                                        .map((e) => RadioListTile(
                                              title: Text(e['key'].toString()),
                                              value: e['index'] as int,
                                              groupValue:
                                                  state.selectedSorting ?? 0,
                                              onChanged: (value) {
                                                context.read<TodoBloc>().add(
                                                      SetSelectedSortingEvent(
                                                        index:
                                                            e['index'] as int,
                                                      ),
                                                    );
                                              },
                                            ))
                                        .toList()),
                              );
                            },
                          ),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("CANCEL")),
                          TextButton(
                              onPressed: () {
                                context
                                    .read<TodoBloc>()
                                    .add(SortListBySectedType());
                                Navigator.of(context).pop();
                              },
                              child: const Text("SORT"))
                        ],
                      ),
                  context: context);
            },
            child: const Text(
              "SORT",
            ))
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
