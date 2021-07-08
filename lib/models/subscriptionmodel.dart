import 'dart:convert';

import 'payout.dart';

class SubscriptionModel {
  Payout payout_fields;
  String product_name;
  String? product_description;
  String interval;
  int interval_count;
  String group;
  SubscriptionModel({
    required this.payout_fields,
    required this.product_name,
    this.product_description,
    required this.interval,
    required this.interval_count,
    required this.group,
  });

  SubscriptionModel copyWith({
    Payout? payout_fields,
    String? product_name,
    String? product_description,
    String? interval,
    int? interval_count,
    String? group,
  }) {
    return SubscriptionModel(
      payout_fields: payout_fields ?? this.payout_fields,
      product_name: product_name ?? this.product_name,
      product_description: product_description ?? this.product_description,
      interval: interval ?? this.interval,
      interval_count: interval_count ?? this.interval_count,
      group: group ?? this.group,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'payout_fields': payout_fields.toMap(),
      'product_name': product_name,
      'product_description': product_description,
      'interval': interval,
      'interval_count': interval_count,
      'group': group,
    };
  }

  factory SubscriptionModel.fromMap(Map<String, dynamic> map) {
    return SubscriptionModel(
      payout_fields: Payout.fromMap(map['payout_fields']),
      product_name: map['product_name'],
      product_description: map['product_description'],
      interval: map['interval'],
      interval_count: map['interval_count'],
      group: map['group'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SubscriptionModel.fromJson(String source) =>
      SubscriptionModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SubscriptionModel(payout_fields: $payout_fields, product_name: $product_name, product_description: $product_description, interval: $interval, interval_count: $interval_count, group: $group)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SubscriptionModel &&
        other.payout_fields == payout_fields &&
        other.product_name == product_name &&
        other.product_description == product_description &&
        other.interval == interval &&
        other.interval_count == interval_count &&
        other.group == group;
  }

  @override
  int get hashCode {
    return payout_fields.hashCode ^
        product_name.hashCode ^
        product_description.hashCode ^
        interval.hashCode ^
        interval_count.hashCode ^
        group.hashCode;
  }
}
