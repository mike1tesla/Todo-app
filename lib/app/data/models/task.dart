import 'package:equatable/equatable.dart';

// Models: tương tác với API bên ngoài chuyển đổi dữ liệu JSON
class Task extends Equatable {
  final String title;
  final int icon;
  final String color;
  final List<dynamic>? todos;

  const Task({
    required this.title,
    required this.color,
    required this.icon,
    this.todos,
  });
  // tạo instance có thể thay đổi đc cho const Task ở trên
  Task copyWith({
    String? title,
    int? icon,
    String? color,
    List<dynamic>? todos,
  }) => 
      Task(
          title: title ?? this.title,
          color: color ?? this.color,
          icon: icon ?? this.icon,
          todos: todos ?? this.todos,
      );
  // tạo đối tượng Task từ 1 Json: Json->jsonDecode->Map->fromJson->Object
  factory Task.fromJson(Map<String, dynamic> json) => Task(
    title: json['title'],
    color: json['color'],
    icon: json['icon'],
    todos: json['todos']
  );
  // Chuyển 1 đổi tượng sang Json: Object->toJson->Map->jsonEncode->Json
  Map<String,dynamic> toJson() => {
    'title' : title,
    'icon' : icon,
    'color' : color,
    'todos' : todos,
  };

  // so sánh các đối tượng với nhau xem có bị trùng lặp trong bộ nhớ hay không
  // sử dụng Equatable
  @override
  List<Object?> get props => [title, icon, color];

}