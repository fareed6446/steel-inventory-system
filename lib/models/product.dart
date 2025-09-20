class Product {
  final String id;
  final String name;
  final String description;
  final String
  category; // Steel types: Carbon Steel, Stainless Steel, Alloy Steel, etc.
  final String unit; // kg, tons, pieces, etc.
  final double? weight; // Weight per unit
  final double? length; // Length per unit
  final double? width; // Width per unit
  final double? thickness; // Thickness per unit
  final String grade; // Steel grade
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.unit,
    this.weight,
    this.length,
    this.width,
    this.thickness,
    required this.grade,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      unit: map['unit'] ?? '',
      weight: map['weight']?.toDouble(),
      length: map['length']?.toDouble(),
      width: map['width']?.toDouble(),
      thickness: map['thickness']?.toDouble(),
      grade: map['grade'] ?? '',
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'unit': unit,
      'weight': weight,
      'length': length,
      'width': width,
      'thickness': thickness,
      'grade': grade,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Product copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    String? unit,
    double? weight,
    double? length,
    double? width,
    double? thickness,
    String? grade,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      unit: unit ?? this.unit,
      weight: weight ?? this.weight,
      length: length ?? this.length,
      width: width ?? this.width,
      thickness: thickness ?? this.thickness,
      grade: grade ?? this.grade,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
