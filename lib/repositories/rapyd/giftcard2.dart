import 'dart:convert';

class GiftCard2 {
  String brand_code;
  String name;
  String image_url;
  GiftCard2({
    required this.brand_code,
    required this.name,
    required this.image_url,
  });

  GiftCard2 copyWith({
    String? brand_code,
    String? name,
    String? image_url,
  }) {
    return GiftCard2(
      brand_code: brand_code ?? this.brand_code,
      name: name ?? this.name,
      image_url: image_url ?? this.image_url,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'brand_code': brand_code,
      'name': name,
      'image_url': image_url,
    };
  }

  factory GiftCard2.fromMap(Map<String, dynamic> map) {
    return GiftCard2(
      brand_code: map['brand_code'],
      name: map['name'],
      image_url: map['image_url'],
    );
  }

  String toJson() => json.encode(toMap());

  factory GiftCard2.fromJson(String source) =>
      GiftCard2.fromMap(json.decode(source));

  @override
  String toString() =>
      'GiftCard2(brand_code: $brand_code, name: $name, image_url: $image_url)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GiftCard2 &&
        other.brand_code == brand_code &&
        other.name == name &&
        other.image_url == image_url;
  }

  @override
  int get hashCode => brand_code.hashCode ^ name.hashCode ^ image_url.hashCode;
}
