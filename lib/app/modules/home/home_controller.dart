import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:todo/app/data/models/task.dart';
import 'package:todo/app/data/services/storage/repository.dart';
// quản lý sự thay đổi các Task cần truy cập taskRepository
class HomeController extends GetxController{
  TaskRepository taskRepository;
  HomeController({required this.taskRepository});
  // Sử dụng key này để truy cập các phương thức và thuộc tính của FormState, như validate(), save(), và reset().
  final formKey = GlobalKey<FormState>();
  // quan sát sự thay đổi của trường TextFormField
  final editCtrl = TextEditingController();
  // quan sát sự thay đổi của các Icon
  final chipIndex = 0.obs;
  // quan sát xem có xóa task hay không
  final deleting = false.obs;
  //quan sát tác vụ List Task trong Repository có thay đổi cập nhật lại UI
  final tasks = <Task>[].obs;
  //quan sát 1 task có được chọn hay không trong add_dialog chọn select Task
  final task = Rx<Task?>(null);

  // tạo luồng LocalStorage->assignAll->readTasks->gán List tasks->ever obs change-> write Tasks
  @override
  void onInit() {
    super.onInit();
    // khi init -> chỉ định đọc tất cả các Task...
    //...từ localStorage-> put vào final tasks ở trên để quan sát
    tasks.assignAll(taskRepository.readTasks());
    // bất cứ khi nào tác vụ thay đổi thì ghi vào tasks
    ever(tasks, (_) => taskRepository.writeTasks(tasks));
  }

  @override
  void onClose() {
    // TODO: implement onClose
    editCtrl.dispose();
    super.onClose();
  }

  void changeChipIndex(int value){
    chipIndex.value = value;
  }
  void changeDeleting(bool value){
    deleting.value = value;
  }
  // chọn 1 trong List task đang có trong bộ nhớ
  void changeTask(Task? select){
    task.value = select;
  }

  bool addTask(Task task){
    if(tasks.contains(task)){
      return false;
    }
    tasks.add(task);
    return true;
  }
  void deleteTask(Task task) {
    tasks.remove(task);
  }

  updateTask(Task task, String title) {
    var todos = task.todos ?? []; // gán list todos nếu không có gán bằng []
    // nếu bị trung title_todo (hàm ktra ở dưới) thì trả về false
    if(containeTodo(todos, title)){
      return false;
    }
    // tạo 1 mục tiêu cần làm khác
    var todo = {'title': title, 'done': false};
    todos.add(todo);  //thêm vào list_todo trong task.todos
    var newTask = task.copyWith(todos: todos); // 1 task mới đc tạo = cách copy task gốc và cập nhật danh sách todos
    int oldIdx = tasks.indexOf(task); // tìm chỉ mục của task cũ trong danh sách tasks.
    tasks[oldIdx] = newTask; //thay thế task cũ bằng task mới trong danh sách tasks.
    tasks.refresh(); //mới danh sách
    return true;
  }
  // kiểm tra xem có title task trong list todos task hay chưa nếu có trả về true
  bool containeTodo(List todos,String title) {
    return todos.any((element) => element['title'] == title);
  }
}
