import 'dart:convert';

import 'package:lilo/models/wallet.dart';

class WalletCard {
  //
  String id;
  Contact ewallet_contact;
  String status;
  String card_id;
  int assigned_at;
  int activated_at;
  String country_iso_alpha_2;
  int created_at;
  String blocked_reason;
  String? card_tracking_id;
  String? card_program;
  String card_number;
  String cvv;
  String expiration_month;
  String expiration_year;
  String bin;
  String sub_bin;
  WalletCard({
    required this.id,
    required this.ewallet_contact,
    required this.status,
    required this.card_id,
    required this.assigned_at,
    required this.activated_at,
    required this.country_iso_alpha_2,
    required this.created_at,
    required this.blocked_reason,
    this.card_tracking_id,
    this.card_program,
    required this.card_number,
    required this.cvv,
    required this.expiration_month,
    required this.expiration_year,
    required this.bin,
    required this.sub_bin,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ewallet_contact': ewallet_contact.toMap(),
      'status': status,
      'card_id': card_id,
      'assigned_at': assigned_at,
      'activated_at': activated_at,
      'country_iso_alpha_2': country_iso_alpha_2,
      'created_at': created_at,
      'blocked_reason': blocked_reason,
      'card_tracking_id': card_tracking_id,
      'card_program': card_program,
      'card_number': card_number,
      'cvv': cvv,
      'expiration_month': expiration_month,
      'expiration_year': expiration_year,
      'bin': bin,
      'sub_bin': sub_bin,
    };
  }

  factory WalletCard.fromMap(Map<String, dynamic> map) {
    return WalletCard(
      id: map['id'],
      ewallet_contact: Contact.fromMap(map['ewallet_contact']),
      status: map['status'],
      card_id: map['card_id'],
      assigned_at: map['assigned_at'],
      activated_at: map['activated_at'],
      country_iso_alpha_2: map['country_iso_alpha_2'],
      created_at: map['created_at'],
      blocked_reason: map['blocked_reason'],
      card_tracking_id: map['card_tracking_id'],
      card_program: map['card_program'],
      card_number: map['card_number'],
      cvv: map['cvv'],
      expiration_month: map['expiration_month'],
      expiration_year: map['expiration_year'],
      bin: map['bin'],
      sub_bin: map['sub_bin'],
    );
  }

  String toJson() => json.encode(toMap());

  factory WalletCard.fromJson(String source) =>
      WalletCard.fromMap(json.decode(source));

  WalletCard copyWith({
    String? id,
    Contact? ewallet_contact,
    String? status,
    String? card_id,
    int? assigned_at,
    int? activated_at,
    String? country_iso_alpha_2,
    int? created_at,
    String? blocked_reason,
    String? card_tracking_id,
    String? card_program,
    String? card_number,
    String? cvv,
    String? expiration_month,
    String? expiration_year,
    String? bin,
    String? sub_bin,
  }) {
    return WalletCard(
      id: id ?? this.id,
      ewallet_contact: ewallet_contact ?? this.ewallet_contact,
      status: status ?? this.status,
      card_id: card_id ?? this.card_id,
      assigned_at: assigned_at ?? this.assigned_at,
      activated_at: activated_at ?? this.activated_at,
      country_iso_alpha_2: country_iso_alpha_2 ?? this.country_iso_alpha_2,
      created_at: created_at ?? this.created_at,
      blocked_reason: blocked_reason ?? this.blocked_reason,
      card_tracking_id: card_tracking_id ?? this.card_tracking_id,
      card_program: card_program ?? this.card_program,
      card_number: card_number ?? this.card_number,
      cvv: cvv ?? this.cvv,
      expiration_month: expiration_month ?? this.expiration_month,
      expiration_year: expiration_year ?? this.expiration_year,
      bin: bin ?? this.bin,
      sub_bin: sub_bin ?? this.sub_bin,
    );
  }

  @override
  String toString() {
    return 'Card(id: $id, ewallet_contact: $ewallet_contact, status: $status, card_id: $card_id, assigned_at: $assigned_at, activated_at: $activated_at, country_iso_alpha_2: $country_iso_alpha_2, created_at: $created_at, blocked_reason: $blocked_reason, card_tracking_id: $card_tracking_id, card_program: $card_program, card_number: $card_number, cvv: $cvv, expiration_month: $expiration_month, expiration_year: $expiration_year, bin: $bin, sub_bin: $sub_bin)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WalletCard &&
        other.id == id &&
        other.ewallet_contact == ewallet_contact &&
        other.status == status &&
        other.card_id == card_id &&
        other.assigned_at == assigned_at &&
        other.activated_at == activated_at &&
        other.country_iso_alpha_2 == country_iso_alpha_2 &&
        other.created_at == created_at &&
        other.blocked_reason == blocked_reason &&
        other.card_tracking_id == card_tracking_id &&
        other.card_program == card_program &&
        other.card_number == card_number &&
        other.cvv == cvv &&
        other.expiration_month == expiration_month &&
        other.expiration_year == expiration_year &&
        other.bin == bin &&
        other.sub_bin == sub_bin;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        ewallet_contact.hashCode ^
        status.hashCode ^
        card_id.hashCode ^
        assigned_at.hashCode ^
        activated_at.hashCode ^
        country_iso_alpha_2.hashCode ^
        created_at.hashCode ^
        blocked_reason.hashCode ^
        card_tracking_id.hashCode ^
        card_program.hashCode ^
        card_number.hashCode ^
        cvv.hashCode ^
        expiration_month.hashCode ^
        expiration_year.hashCode ^
        bin.hashCode ^
        sub_bin.hashCode;
  }
}
