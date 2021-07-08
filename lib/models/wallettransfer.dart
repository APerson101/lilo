import 'dart:convert';

import 'notificationtransfer.dart';

class WalletTransfer {
  String id;
  String sender_name;
  String receiver_name;
  String transaction_type;
  double amount;
  String timestamp;
  String currency;
  String source_ewallet_id;
  String destination_ewallet_id;
  WalletTransfer({
    required this.id,
    required this.sender_name,
    required this.receiver_name,
    required this.transaction_type,
    required this.amount,
    required this.timestamp,
    required this.currency,
    required this.source_ewallet_id,
    required this.destination_ewallet_id,
  });

  WalletTransfer copyWith({
    String? id,
    String? sender_name,
    String? receiver_name,
    String? transaction_type,
    double? amount,
    String? timestamp,
    String? currency,
    String? source_ewallet_id,
    String? destination_ewallet_id,
  }) {
    return WalletTransfer(
      id: id ?? this.id,
      sender_name: sender_name ?? this.sender_name,
      receiver_name: receiver_name ?? this.receiver_name,
      transaction_type: transaction_type ?? this.transaction_type,
      amount: amount ?? this.amount,
      timestamp: timestamp ?? this.timestamp,
      currency: currency ?? this.currency,
      source_ewallet_id: source_ewallet_id ?? this.source_ewallet_id,
      destination_ewallet_id:
          destination_ewallet_id ?? this.destination_ewallet_id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sender_name': sender_name,
      'receiver_name': receiver_name,
      'transaction_type': transaction_type,
      'amount': amount,
      'timestamp': timestamp,
      'currency': currency,
      'source_ewallet_id': source_ewallet_id,
      'destination_ewallet_id': destination_ewallet_id,
    };
  }

  factory WalletTransfer.fromMap(Map<String, dynamic> map) {
    return WalletTransfer(
      id: map['id'],
      sender_name: map['sender_name'],
      receiver_name: map['receiver_name'],
      transaction_type: map['transaction_type'],
      amount: map['amount'],
      timestamp: map['timestamp'],
      currency: map['currency'],
      source_ewallet_id: map['source_ewallet_id'],
      destination_ewallet_id: map['destination_ewallet_id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory WalletTransfer.fromJson(String source) =>
      WalletTransfer.fromMap(json.decode(source));

  @override
  String toString() {
    return 'WalletTransfer(id: $id, sender_name: $sender_name, receiver_name: $receiver_name, transaction_type: $transaction_type, amount: $amount, timestamp: $timestamp, currency: $currency, source_ewallet_id: $source_ewallet_id, destination_ewallet_id: $destination_ewallet_id)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WalletTransfer &&
        other.id == id &&
        other.sender_name == sender_name &&
        other.receiver_name == receiver_name &&
        other.transaction_type == transaction_type &&
        other.amount == amount &&
        other.timestamp == timestamp &&
        other.currency == currency &&
        other.source_ewallet_id == source_ewallet_id &&
        other.destination_ewallet_id == destination_ewallet_id;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        sender_name.hashCode ^
        receiver_name.hashCode ^
        transaction_type.hashCode ^
        amount.hashCode ^
        timestamp.hashCode ^
        currency.hashCode ^
        source_ewallet_id.hashCode ^
        destination_ewallet_id.hashCode;
  }
}
