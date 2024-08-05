import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/app/modules/home/home_controller.dart';

class ReportPage extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Report page"),
      ),
    );
  }
}
