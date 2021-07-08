import 'dart:convert';

class OtherTransfer {
  String id;
  double amount;
  double sender_amount;
  String sender_currency;
  String receiver_currency;
  int created_at;
  String receiver_name;
  String transferMethodName;
  String transaction_type;
  OtherTransfer({
    required this.id,
    required this.amount,
    required this.sender_amount,
    required this.sender_currency,
    required this.receiver_currency,
    required this.created_at,
    required this.receiver_name,
    required this.transferMethodName,
    required this.transaction_type,
  });

  OtherTransfer copyWith({
    String? id,
    double? amount,
    double? sender_amount,
    String? sender_currency,
    String? receiver_currency,
    int? created_at,
    String? receiver_name,
    String? transferMethodName,
    String? transaction_type,
  }) {
    return OtherTransfer(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      sender_amount: sender_amount ?? this.sender_amount,
      sender_currency: sender_currency ?? this.sender_currency,
      receiver_currency: receiver_currency ?? this.receiver_currency,
      created_at: created_at ?? this.created_at,
      receiver_name: receiver_name ?? this.receiver_name,
      transferMethodName: transferMethodName ?? this.transferMethodName,
      transaction_type: transaction_type ?? this.transaction_type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'sender_amount': sender_amount,
      'sender_currency': sender_currency,
      'receiver_currency': receiver_currency,
      'created_at': created_at,
      'receiver_name': receiver_name,
      'transferMethodName': transferMethodName,
      'transaction_type': transaction_type,
    };
  }

  factory OtherTransfer.fromMap(Map<String, dynamic> map) {
    return OtherTransfer(
      id: map['id'],
      amount: map['receiver_amount'],
      sender_amount: map['sender_amount'],
      sender_currency: map['sender_currency'],
      receiver_currency: map['receiver_currency'],
      created_at: map['timestamp'],
      receiver_name: map['receiver_name'],
      transferMethodName: map['transferMethodName'],
      transaction_type: map['transaction_type'],
    );
  }

  String toJson() => json.encode(toMap());

  factory OtherTransfer.fromJson(String source) =>
      OtherTransfer.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OtherTransfer(id: $id, amount: $amount, sender_amount: $sender_amount, sender_currency: $sender_currency, receiver_currency: $receiver_currency, created_at: $created_at, receiver_name: $receiver_name, transferMethodName: $transferMethodName, transaction_type: $transaction_type)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OtherTransfer &&
        other.id == id &&
        other.amount == amount &&
        other.sender_amount == sender_amount &&
        other.sender_currency == sender_currency &&
        other.receiver_currency == receiver_currency &&
        other.created_at == created_at &&
        other.receiver_name == receiver_name &&
        other.transferMethodName == transferMethodName &&
        other.transaction_type == transaction_type;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        amount.hashCode ^
        sender_amount.hashCode ^
        sender_currency.hashCode ^
        receiver_currency.hashCode ^
        created_at.hashCode ^
        receiver_name.hashCode ^
        transferMethodName.hashCode ^
        transaction_type.hashCode;
  }
}
