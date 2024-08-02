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
      ) : ListView(
        shrinkWrap: true, // xác định listview có nên cố gắng chỉ chiếm đủ không gian để hiển thị các con của nó hay k
        physics: const ClampingScrollPhysics(), //dừng lại ngay khi hết nội dung cuộn
        children: [
          ...homeCtrl.doingTodos.map((element) =>
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 9.0.wp,vertical: 3.0.wp),
            child: Row(
              children: [
                SizedBox(
                  width: 20, height: 20,
                  child: Checkbox(
                    fillColor: MaterialStateProperty.resolveWith((states) => Colors.white),
                    value: element['done'],
                    onChanged: (value){
                      homeCtrl.doneTodo(element['title']);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0.wp),
                  child: Text(element['title'], overflow: TextOverflow.ellipsis),
                ) // hien thi title cua Map<String,bool> todo<title,done>
              ],
            ),
          )
          ).toList(),
          if(homeCtrl.doingTodos.isNotEmpty)  Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.0.wp),
            child: const Divider(thickness: 2,),
          )
        ],
      )
    );
  }
}
