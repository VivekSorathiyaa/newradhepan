import 'expenses_model.dart';

class UserModel {
  String id;
  String name;
  String phone;
  String createdBy;
  String password;
  String businessName;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.createdBy,
    required this.password,
    required this.businessName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      createdBy: json['createdBy'] ?? '',
      password: json['password'] ?? '',
      businessName: json['businessName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'createdBy': createdBy,
      'password': password,
      'businessName': businessName,
    };
  }
}
