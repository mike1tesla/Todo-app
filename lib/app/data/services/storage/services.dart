import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo/app/core/utils/keys.dart';

//GetxService tương tự GetxController nhưng không thể xóa 1 cách thông thường
class StorageService extends GetxService {
  // Khởi tạo local storage = StorageService =_box k thể xóa và dùng trong cả quá trình
  late GetStorage _box;

  // Kiểm tra xem có dữ liệu trong bộ nhớ chưa,
  // Nếu chưa trả khởi tạo bộ nhớ _box, có rồi lấy dữ liệu từ bộ nhớ
  Future<StorageService> init() async {
    // Tạo bộ nhớ _box
    _box = GetStorage();
    // check bộ nhớ, k có data sẽ ghi write vào với key-value rỗng
    // await _box.write(taskKey, []); // xóa các task khỏi bộ nhớ
    await _box.writeIfNull(taskKey, []);
    // trả về bộ nhớ khởi tạo
    return this;
  }

  // khởi tạo 2 phương thức đọc và ghi vào bộ nhớ _box
  T read<T>(String key){
    return _box.read(key);
  }
  void write(String key, dynamic value) async {
    await _box.write(key, value);
  }
}