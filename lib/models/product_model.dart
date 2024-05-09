import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String id;
  String title;
  String description;
  String price;
  String imageUrl;
  String categoryId;
  String subTitle;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.categoryId,
    required this.subTitle,
  });

  // Create ProductModel from a map (used when retrieving data from Firestore)
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      price: map['price'],
      imageUrl: map['imageUrl'],
      categoryId: map['categoryId'],
      subTitle: map['subTitle'],
    );
  }

  // Convert ProductModel to a map (used when adding or updating data in Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'categoryId': categoryId,
      'subTitle': subTitle,
    };
  }

  // Convert ProductModel to JSON format
  Map<String, dynamic> toJson() => toMap();
}
