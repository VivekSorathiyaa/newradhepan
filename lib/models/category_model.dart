class CategoryModel {
  String categoryId;
  String name;

  CategoryModel({
    required this.categoryId,
    required this.name,
  });

  // Factory method to create a CategoryModel instance from a map
  factory CategoryModel.fromMap(Map<String, dynamic> map, String categoryId) {
    return CategoryModel(
      categoryId: categoryId,
      name: map['name'] ?? '',
    );
  }

  // Convert CategoryModel instance to a map
  Map<String, dynamic> toMap() {
    return {
      'categoryId': categoryId,
      'name': name,
    };
  }
}
