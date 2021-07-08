import 'dart:convert';

class DebitTransaction {
  int id;
  String type;
  String category;
  String? subCategory;
  double amount;
  String name;
  DebitTransaction({
    required this.id,
    required this.type,
    required this.category,
    this.subCategory,
    required this.amount,
    required this.name,
  });

  DebitTransaction copyWith({
    int? id,
    String? type,
    String? category,
    String? subCategory,
    double? amount,
    String? name,
  }) {
    return DebitTransaction(
      id: id ?? this.id,
      type: type ?? this.type,
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      amount: amount ?? this.amount,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'category': category,
      'subCategory': subCategory,
      'amount': amount,
      'name': name,
    };
  }

  factory DebitTransaction.fromMap(Map<String, dynamic> map) {
    return DebitTransaction(
      id: map['id'],
      type: map['type'],
      category: map['category'],
      subCategory: map['subCategory'],
      amount: map['amount'],
      name: map['name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory DebitTransaction.fromJson(String source) =>
      DebitTransaction.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DebitTransaction(id: $id, type: $type, category: $category, subCategory: $subCategory, amount: $amount, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DebitTransaction &&
        other.id == id &&
        other.type == type &&
        other.category == category &&
        other.subCategory == subCategory &&
        other.amount == amount &&
        other.name == name;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        type.hashCode ^
        category.hashCode ^
        subCategory.hashCode ^
        amount.hashCode ^
        name.hashCode;
  }
}
