import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo/app/data/services/storage/services.dart';
import 'package:todo/app/modules/home/home_binding.dart';
import 'app/modules/home/home_view.dart';

void main() async {
  // khởi tạo bộ nhớ lưu trữ với GetStorage
  await GetStorage.init();
  // gọi đến khởi tạo _box, trả về bộ nhớ box
  await Get.putAsync(() => StorageService().init());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Todo List',
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      initialBinding: HomeBinding(),
      builder: EasyLoading.init(),
    );
  }
}
