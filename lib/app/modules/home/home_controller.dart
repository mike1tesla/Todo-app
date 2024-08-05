import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
  // quan sát sự thay đổi của tab navigation bar
  final tabIndex = 0.obs;
  // quan sát sự thay đổi của các Icon
  final chipIndex = 0.obs;
  // quan sát xem có xóa task hay không
  final deleting = false.obs;
  //quan sát tác vụ List Task trong Repository có thay đổi cập nhật lại UI
  final tasks = <Task>[].obs;
  //quan sát 1 task có được chọn hay không trong add_dialog chọn select Task
  final task = Rx<Task?>(null);
  //list các todos đang làm và list các todos đã hoàn thành xong
  final doingTodos = <dynamic>[].obs;
  final doneTodos = <dynamic>[].obs;

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

  void changeTabIndex(int index){
    tabIndex.value = index;
  }

  void changeChipIndex(int value){
    chipIndex.value = value;
  }
  void changeDeleting(bool value){
    deleting.value = value;
  }
  // chọn 1 trong List task đang có trong bộ nhớ lưu vào task.value
  void changeTask(Task? select){
    task.value = select;
  }
  // thực hiện add các todos trong Task(là select) vào 2 loại done và doing
  void changeTodos(List<dynamic> select){
    doingTodos.clear();
    doneTodos.clear();
    for(int i = 0; i < select.length; i++){
      var todo = select[i];
      //cau truc bien todo = {'title' : title, 'done' : false}
      var status = todo["done"]; // mỗi đối tượng có thể truy cập thuộc tính = cách sd ki hiệu []
      if (status == true){
        doneTodos.add(todo);
      } else {
        doingTodos.add(todo);
      }
    }
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

  /// add todo into specific task
  /// ham nay tao ra 2 bien todo va doneTodo de so sanh trung lap voi list doingTodos va doneTodos
  bool addTodo(String title) {
    var todo = {'title' : title, 'done' : false};// tao map key title va done Map<String, Boolean>
    //so sánh voi doingTodos bất kì element có title giống nhau và status done => trả về false không thêm todo
    if(doingTodos.any((element) => mapEquals<String, dynamic>(todo, element))){
     return false;
    }
    //so sanh doneTodo voi doneTodos neu da hoan thanh thi khong them vao todo
    var doneTodo = {'title' : title, 'done' : true}; // tao bien Map<String, bool>
    if(doneTodos.any((element) => mapEquals<String, dynamic>(doneTodo, element))){
      return false;
    }
    // neu khong bi trung lap thi them vao phan doingTodos
    doingTodos.add(todo);
    return true;
  }

  // update task with new todoo list sẽ cập nhật việc cần làm nhấn khi ấn nút back
  void updateTodos(){
    var newTodos = <Map<String, dynamic>>[];
    newTodos.addAll(
      [...doingTodos,
      ...doneTodos]
    );
    // tạo newTask vẫn giữ nguyên các thuộc tính title, icon, color chỉ thay đổi thuộc tính todos
    var newTask = task.value!.copyWith(todos: newTodos);
    int oldIdx = tasks.indexOf(task.value);
    tasks[oldIdx] = newTask;
    tasks.refresh();
  }

  void doneTodo(String title) {
    var doingTodo = {'title': title, 'done': false};
    int index = doingTodos.indexWhere((element) => mapEquals<String, dynamic>(doingTodo, element));
    doingTodos.removeAt(index);
    var doneTodo = {'title': title, 'done': true};
    doneTodos.add(doneTodo);
    doingTodos.refresh();
    doneTodos.refresh();

  }

  void deleteDoneTodo(dynamic doneTodo) {
    int index = doneTodos.indexWhere((element) => mapEquals<String, dynamic>(doneTodo, element));
    doingTodos.removeAt(index);
    doneTodos.refresh();
  }

  int getTotalTask(){
    var res = 0;
    for(int i = 0; i < tasks.length; i++){
      if(tasks[i].todos != null){
        res += tasks[i].todos!.length;
      }
    }
    return res;
  }
  int getTotalDoneTask(){
    var res = 0;
    for(int i = 0; i < tasks.length; i++){
      if(tasks[i].todos != null){
        for(int j = 0; j < tasks[i].todos!.length; j++){
          if(tasks[i].todos![j]["done"] == true ){
            res += 1;
          }
        }
      }
    }
    return res;
  }
}
