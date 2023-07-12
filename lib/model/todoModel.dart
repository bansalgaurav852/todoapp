import 'package:hive/hive.dart';

part 'todoModel.g.dart';

@HiveType(typeId: 0)
class DataModel {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String description;
  @HiveField(2)
  final bool complete;
  @HiveField(3)
  final String priority;
  @HiveField(4)
  final DateTime createdate;
  @HiveField(5)
  final DateTime duedate;

  DataModel({
    required this.title,
    required this.description,
    required this.complete,
    required this.priority,
    required this.createdate,
    required this.duedate,
  });
}
