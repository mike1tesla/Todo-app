import 'dart:convert';

import 'package:get/get.dart';
import 'package:todo/app/core/utils/keys.dart';
import 'package:todo/app/data/services/storage/services.dart';
import '../../models/task.dart';

// Vận chuyển cung cấp dữ liệu Task từ LocalStorage sang Repository
class TaskProvider {
  // cho phép quyền truy cập vào LocalStorage
  final _storage = Get.find<StorageService>();
  //tạo 2 phương thức đọc và ghi Task từ bộ nhớ
  List<Task> readTasks(){
    var tasks = <Task>[];
    jsonDecode(_storage.read(taskKey).toString())
        .forEach((e) => tasks.add(Task.fromJson(e)));
    return tasks;
  }
  void writeTasks(List<Task> tasks){
    _storage.write(taskKey, jsonEncode(tasks));
  }
}