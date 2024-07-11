import 'package:todo/app/data/providers/task/provider.dart';

import '../../models/task.dart';
// Kho chứa repository các Task được lấy từ Provider
class TaskRepository {
  TaskProvider taskProvider;
  TaskRepository({required this.taskProvider});

  List<Task> readTasks() => taskProvider.readTasks();
  void writeTasks(List<Task> tasks) =>taskProvider.writeTasks(tasks);
}