import 'expenses_model.dart';

class UserModel {
  String id;
  String name;
  String phone;
  String imageUrl;
  String createdBy;
  String password;
  String businessName;
  String deviceToken;
  String accessToken;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.imageUrl,
    required this.createdBy,
    required this.password,
    required this.businessName,
    required this.deviceToken,
    required this.accessToken, 
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      createdBy: json['createdBy'] ?? '',
      password: json['password'] ?? '',
      businessName: json['businessName'] ?? '',
      deviceToken: json['deviceToken'] ?? '',
      accessToken: json['accessToken'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'imageUrl': imageUrl,
      'createdBy': createdBy,
      'password': password,
      'businessName': businessName,
      'deviceToken': deviceToken,
      'accessToken': accessToken,
    };
  }
}
