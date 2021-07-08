import 'dart:convert';

import 'package:flutter/foundation.dart';

class GiftCard {
  String id;
  String name;
  List<String> currency_codes;
  List<dynamic> skus;
  List<Map<String, dynamic>> countries;
  String category;
  String disclosure;
  String description;
  List<Map<String, dynamic>> images;
  GiftCard({
    required this.id,
    required this.name,
    required this.currency_codes,
    required this.skus,
    required this.countries,
    required this.category,
    required this.disclosure,
    required this.description,
    required this.images,
  });

  GiftCard copyWith({
    String? id,
    String? name,
    List<String>? currency_codes,
    List<dynamic>? skus,
    List<Map<String, dynamic>>? countries,
    String? category,
    String? disclosure,
    String? description,
    List<Map<String, dynamic>>? images,
  }) {
    return GiftCard(
      id: id ?? this.id,
      name: name ?? this.name,
      currency_codes: currency_codes ?? this.currency_codes,
      skus: skus ?? this.skus,
      countries: countries ?? this.countries,
      category: category ?? this.category,
      disclosure: disclosure ?? this.disclosure,
      description: description ?? this.description,
      images: images ?? this.images,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'currency_codes': currency_codes,
      'skus': skus,
      'countries': countries,
      'category': category,
      'disclosure': disclosure,
      'description': description,
      'images': images,
    };
  }

  factory GiftCard.fromMap(Map<String, dynamic> map) {
    return GiftCard(
      id: map['id'],
      name: map['name'],
      currency_codes: List<String>.from(map['currency_codes']),
      skus: List<dynamic>.from(map['skus']),
      countries: List<Map<String, dynamic>>.from(map['countries']),
      category: map['category'],
      disclosure: map['disclosure'],
      description: map['description'],
      images: List<Map<String, dynamic>>.from(map['images']),
    );
  }

  String toJson() => json.encode(toMap());

  factory GiftCard.fromJson(String source) =>
      GiftCard.fromMap(json.decode(source));

  @override
  String toString() {
    return 'GiftCard(id: $id, name: $name, currency_codes: $currency_codes, skus: $skus, countries: $countries, category: $category, disclosure: $disclosure, description: $description, images: $images)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GiftCard &&
        other.id == id &&
        other.name == name &&
        listEquals(other.currency_codes, currency_codes) &&
        listEquals(other.skus, skus) &&
        listEquals(other.countries, countries) &&
        other.category == category &&
        other.disclosure == disclosure &&
        other.description == description &&
        listEquals(other.images, images);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        currency_codes.hashCode ^
        skus.hashCode ^
        countries.hashCode ^
        category.hashCode ^
        disclosure.hashCode ^
        description.hashCode ^
        images.hashCode;
  }
}
