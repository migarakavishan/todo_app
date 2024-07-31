class UserModel {
  String name;
  String email;
  String uid;

  UserModel({
    required this.email,
    required this.name,
    required this.uid,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      name: json['name'],
      uid: json['uid'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'uid': uid,
    };
  }
}
