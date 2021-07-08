import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:lilo/models/debitTransaction.dart';

class Debit {
  List<DebitTransaction> allDebits;
  int number;
  double amount;
  Debit({
    required this.allDebits,
    required this.number,
    required this.amount,
  });

  Debit copyWith({
    List<DebitTransaction>? allDebits,
    int? number,
    double? amount,
  }) {
    return Debit(
      allDebits: allDebits ?? this.allDebits,
      number: number ?? this.number,
      amount: amount ?? this.amount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'allDebits': allDebits.map((x) => x.toMap()).toList(),
      'number': number,
      'amount': amount,
    };
  }

  factory Debit.fromMap(Map<String, dynamic> map) {
    return Debit(
      allDebits: List<DebitTransaction>.from(
          map['allDebits']?.map((x) => DebitTransaction.fromMap(x))),
      number: map['number'],
      amount: map['amount'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Debit.fromJson(String source) => Debit.fromMap(json.decode(source));

  @override
  String toString() =>
      'Debit(allDebits: $allDebits, number: $number, amount: $amount)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Debit &&
        listEquals(other.allDebits, allDebits) &&
        other.number == number &&
        other.amount == amount;
  }

  @override
  int get hashCode => allDebits.hashCode ^ number.hashCode ^ amount.hashCode;
}
