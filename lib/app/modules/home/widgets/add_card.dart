import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:todo/app/core/utils/extensions.dart';
import 'package:todo/app/modules/home/home_controller.dart';
import 'package:todo/app/widgets/icons.dart';
import '../../../core/values/color.dart';
import '../../../data/models/task.dart';

class AddCard extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();

  AddCard({super.key});

  @override
  Widget build(BuildContext context) {
    final icons = getIcons();
    var squareWidth = Get.width - 12.0.wp;
    return Container(
      width: squareWidth / 2,
      height: squareWidth / 2,
      margin: EdgeInsets.all(3.0.wp),
      child: InkWell(
        onTap: () async {
          await Get.defaultDialog(
              titlePadding: EdgeInsets.symmetric(vertical: 5.0.wp),
              radius: 5,
              title: 'Task Type',
              // sử dụng formKey để quan sát trạng thái khi có thay đổi
              content: Form(
                  key: homeCtrl.formKey,
                  child: Column(
                    // xác thực validate thông tin nhập của người dùng,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3.0.wp),
                        child: TextFormField(
                          // Quan sát sự thay đổi UI cập nhật value
                          controller: homeCtrl.editCtrl,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(), labelText: 'Title'),
                          // Nếu giá trị nhập vào là null và rỗng thì return thông báo đỏ
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your task title';
                            }
                            return null;
                          },
                        ),
                      ),
                      // Wrap là một widget bố cục (layout) sắp xếp các widget con theo nhiều hàng hoặc nhiều cột
                      // khi không gian có sẵn không đủ để đặt chúng trong một hàng hoặc một cột duy nhất.
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.0.wp),
                        child: Wrap(
                          spacing: 2.0.wp,
                          // Xác định biến chipIndex = 0.obs trong homeCtrl
                          children: icons
                              .map((e) => Obx(() {
                                    // lấy ra stt index trong List icons
                                    final index = icons.indexOf(e);
                                    return ChoiceChip(
                                      selectedColor: Colors.grey[200],
                                      pressElevation: 0,
                                      // backgroundColor: Colors.white,
                                      label: e,
                                      // so sánh chipIndex có bằng index hay không nếu bằng thì highlight backgroundColor
                                      // chip hiện tại đang được chọn và thuộc tính selected sẽ được đặt là true, ngược lại sẽ là false.
                                      selected:
                                          homeCtrl.chipIndex.value == index,
                                      //Nếu (selected == true), homeCtrl.chipIndex.value sẽ được cập nhật với index của chip đó
                                      //Nếu (selected == false), homeCtrl.chipIndex.value sẽ được đặt về 0.
                                      onSelected: (bool selected) {
                                        homeCtrl.chipIndex.value =
                                            selected ? index : 0;
                                      },
                                    );
                                  }))
                              .toList(),
                        ),
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: blue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              minimumSize: const Size(150, 40)),
                          // Khi Confirm, phương thức validate() của FormState được gọi thông qua formKey.currentState!.validate().
                          // Nếu Form hợp lệ (validate() trả về true), các hành động tiếp theo sẽ được thực hiện.
                          onPressed: () {
                            if (homeCtrl.formKey.currentState!.validate()) {
                              int icon = icons[homeCtrl.chipIndex.value].icon!.codePoint;
                              String color = icons[homeCtrl.chipIndex.value].color!.toHex();
                              var task = Task(
                                  title: homeCtrl.editCtrl.text,
                                  icon: icon,
                                  color: color);
                              Get.back();
                              homeCtrl.addTask(task)
                                  ? EasyLoading.showSuccess("Create sucess")
                                  : EasyLoading.showError("Duplicated Task");
                            }
                          },
                          child: const Text('Confirm',
                              style: TextStyle(color: Colors.white)))
                    ],
                  )));
          homeCtrl.editCtrl.clear();
          homeCtrl.changeChipIndex(0);
        },
        child: DottedBorder(
          color: Colors.grey[400]!,
          dashPattern: const [8.4],
          child: Center(
            child: Icon(Icons.add, size: 10.0.wp, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
