class ToDoModel {
  String id;
  String title;
  bool isDone;

  ToDoModel({
    this.id = '',
    required this.title,
    this.isDone = false,
  });

  factory ToDoModel.fromJson(Map<String, dynamic> json) {
    return ToDoModel(
      id: json['id'],
      title: json['title'],
      isDone: json['isDone'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'isDone': isDone,
    };
  }
}
