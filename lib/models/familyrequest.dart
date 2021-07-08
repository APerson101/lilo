import 'dart:convert';

class FamRequest {
  String requesterWalletId;
  String requesterUserId;
  String familyID;
  String amount;
  String name;
  String type;
  String currency;
  String id;
  FamRequest({
    required this.requesterWalletId,
    required this.requesterUserId,
    required this.familyID,
    required this.amount,
    required this.name,
    required this.type,
    required this.currency,
    required this.id,
  });

  FamRequest copyWith({
    String? requesterWalletId,
    String? requesterUserId,
    String? familyID,
    String? amount,
    String? name,
    String? type,
    String? currency,
    String? id,
  }) {
    return FamRequest(
      requesterWalletId: requesterWalletId ?? this.requesterWalletId,
      requesterUserId: requesterUserId ?? this.requesterUserId,
      familyID: familyID ?? this.familyID,
      amount: amount ?? this.amount,
      name: name ?? this.name,
      type: type ?? this.type,
      currency: currency ?? this.currency,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'requesterWalletId': requesterWalletId,
      'requesterUserId': requesterUserId,
      'familyID': familyID,
      'amount': amount,
      'name': name,
      'type': type,
      'currency': currency,
      'id': id,
    };
  }

  factory FamRequest.fromMap(Map<String, dynamic> map) {
    return FamRequest(
      requesterWalletId: map['requesterWalletId'],
      requesterUserId: map['requesterUserId'],
      familyID: map['familyID'],
      amount: map['amount'],
      name: map['name'],
      type: map['type'],
      currency: map['currency'],
      id: map['id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory FamRequest.fromJson(String source) =>
      FamRequest.fromMap(json.decode(source));

  @override
  String toString() {
    return 'FamRequest(requesterWalletId: $requesterWalletId, requesterUserId: $requesterUserId, familyID: $familyID, amount: $amount, name: $name, type: $type, currency: $currency, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FamRequest &&
        other.requesterWalletId == requesterWalletId &&
        other.requesterUserId == requesterUserId &&
        other.familyID == familyID &&
        other.amount == amount &&
        other.name == name &&
        other.type == type &&
        other.currency == currency &&
        other.id == id;
  }

  @override
  int get hashCode {
    return requesterWalletId.hashCode ^
        requesterUserId.hashCode ^
        familyID.hashCode ^
        amount.hashCode ^
        name.hashCode ^
        type.hashCode ^
        currency.hashCode ^
        id.hashCode;
  }
}
