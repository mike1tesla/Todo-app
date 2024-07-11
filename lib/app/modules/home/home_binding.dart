import 'package:get/get.dart';
import 'package:todo/app/data/providers/task/provider.dart';
import 'package:todo/app/data/services/storage/repository.dart';
import 'package:todo/app/modules/home/home_controller.dart';

//Quản lý các phụ thuộc mà khi khởi tạo HomeController cần đến:
// GetxController -> HomeController -> TaskRepository -> TaskProvider
class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => HomeController(
        taskRepository: TaskRepository(
          taskProvider: TaskProvider(),
        ),
      ),
    );
  }
}
