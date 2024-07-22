import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:todo/app/core/utils/extensions.dart';
import 'package:todo/app/modules/home/home_controller.dart';

class DetailPage extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();

  DetailPage({super.key});
  @override
  Widget build(BuildContext context) {
    var task = homeCtrl.task
        .value!; // select biến task lưu trữ trong task.value khi ấn
    var color = HexColor.fromHex(task.color);
    return Scaffold(
      body: Form(
        key: homeCtrl.formKey,
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(3.0.wp),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Get.back();
                      homeCtrl.changeTask(null); // khi back lại task.value = null
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                ],
              ),
            ),

            /// Hiển thị task đang chọn
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0.wp),
              child: Row(
                children: [
                  Icon(IconData(task.icon, fontFamily: 'MaterialIcons'), color: color),
                  SizedBox(width: 3.0.wp),
                  Text(task.title, style: TextStyle(fontSize: 12.0.sp, fontWeight: FontWeight.bold))
                ],
              ),
            ),
            /// hien thi tien trinh lam viec
            Obx( ()
              {
                var totalTodos = homeCtrl.doneTodos.length + homeCtrl.doingTodos.length;
                return Padding(
                  padding: EdgeInsets.only(left: 16.0.wp, top: 3.0.wp, right: 16.0.wp),
                  child: Row(
                    children: [
                      Text(
                        "$totalTodos tasks",
                        style: TextStyle(fontSize: 12.0.sp, color: Colors.grey),
                      ),
                      SizedBox(width: 3.0.wp),
                      Expanded(
                        child: StepProgressIndicator(
                          totalSteps: totalTodos == 0 ? 1 : totalTodos,
                          currentStep: homeCtrl.doneTodos.length,
                          size: 6,
                          padding: 0,
                          selectedGradientColor: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [color.withOpacity(0.5), color],
                          ),
                          unselectedGradientColor: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.grey[300]!, Colors.grey[300]!],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0.wp, vertical: 3.0.wp),
              child: TextFormField(
                controller: homeCtrl.editCtrl,
                autofocus: true,
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[400]!),
                  ),
                  prefixIcon: Icon(Icons.check_box_outline_blank, color: Colors.grey[400]!),
                  suffixIcon: IconButton(
                    onPressed: (){
                      if(homeCtrl.formKey.currentState!.validate()){
                        var success = homeCtrl.addTodo(homeCtrl.editCtrl.text);
                        if(success){
                          EasyLoading.showSuccess("Todo item add success");
                        } else {
                          EasyLoading.showError("Todo item already exist");
                        }
                        homeCtrl.editCtrl.clear();
                      }
                    },
                    icon: const Icon(Icons.done),
                  ),
                ),
                validator: (value){
                  if(value == null || value.trim().isEmpty) {
                    return "Please enter your todo item";
                  }
                  return null;
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
