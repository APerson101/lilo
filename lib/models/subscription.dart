import 'dart:convert';

class Subscription {
  String? userID;
  String? id;
  String? created_at;
  String? group;
  String? amount;
  String? currency;
  String? interval;
  String? interval_count;
  String? product_name;
  String? product_description;
  String status = "Active";
  List? groups;
  Subscription({
    this.userID,
    this.id,
    this.created_at,
    this.group,
    this.amount,
    this.currency,
    this.interval,
    this.interval_count,
    this.product_name,
    this.product_description,
    required this.status,
    this.groups,
  });

  Subscription copyWith({
    String? userID,
    String? id,
    String? created_at,
    String? group,
    String? amount,
    String? currency,
    String? interval,
    String? interval_count,
    String? product_name,
    String? product_description,
    String? status,
    List? groups,
  }) {
    return Subscription(
      userID: userID ?? this.userID,
      id: id ?? this.id,
      created_at: created_at ?? this.created_at,
      group: group ?? this.group,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      interval: interval ?? this.interval,
      interval_count: interval_count ?? this.interval_count,
      product_name: product_name ?? this.product_name,
      product_description: product_description ?? this.product_description,
      status: status ?? this.status,
      groups: groups ?? this.groups,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'id': id,
      'created_at': created_at,
      'group': group,
      'amount': amount,
      'currency': currency,
      'interval': interval,
      'interval_count': interval_count,
      'product_name': product_name,
      'product_description': product_description,
      'status': status,
      'groups': groups?.map((e) => {e}),
    };
  }

  factory Subscription.fromMap(Map<String, dynamic> map) {
    return Subscription(
      userID: map['userID'],
      id: map['id'],
      created_at: map['created_at'],
      group: map['group'],
      amount: map['amount'],
      currency: map['currency'],
      interval: map['interval'],
      interval_count: map['interval_count'],
      product_name: map['product_name'],
      product_description: map['product_description'],
      status: map['status'],
      groups: map['groups'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Subscription.fromJson(String source) =>
      Subscription.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Subscription(userID: $userID, id: $id, created_at: $created_at, group: $group, amount: $amount, currency: $currency, interval: $interval, interval_count: $interval_count, product_name: $product_name, product_description: $product_description, status: $status, groups: $groups)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Subscription &&
        other.userID == userID &&
        other.id == id &&
        other.created_at == created_at &&
        other.group == group &&
        other.amount == amount &&
        other.currency == currency &&
        other.interval == interval &&
        other.interval_count == interval_count &&
        other.product_name == product_name &&
        other.product_description == product_description &&
        other.status == status &&
        other.groups == groups;
  }

  @override
  int get hashCode {
    return userID.hashCode ^
        id.hashCode ^
        created_at.hashCode ^
        group.hashCode ^
        amount.hashCode ^
        currency.hashCode ^
        interval.hashCode ^
        interval_count.hashCode ^
        product_name.hashCode ^
        product_description.hashCode ^
        status.hashCode ^
        groups.hashCode;
  }
}
