import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseModel {
  String id;
  String userId;
  dynamic amount;
  DateTime date;

  ExpenseModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.date,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      amount: json['amount'] ?? 0.0,
      // description: json['description'] ?? '',
      date:
          json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
    );
  }


  

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }
}
