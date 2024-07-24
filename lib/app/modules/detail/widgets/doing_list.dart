import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/app/core/utils/extensions.dart';
import 'package:todo/app/modules/home/home_controller.dart';

class DoingList extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  DoingList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => homeCtrl.doingTodos.isEmpty && homeCtrl.doneTodos.isEmpty
        ? Column(
        children: [
          Image.asset("assets/images/todolist_img.png",
            fit: BoxFit.cover,
            width: 60.0.wp,
          ),
          Text("Add Task", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0.sp))
        ],
      ) : const Text("Have doing todos")
    );
  }
}
