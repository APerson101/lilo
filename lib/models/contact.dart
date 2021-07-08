import 'dart:convert';

import 'package:flutter/foundation.dart';

class Beneficiary {
  String? id;
  String last_name;
  String? ewallet;
  String phone_number;
  String first_name;
  String email;
  List<String>? eligible;
  String? middle_name;
  String? id_date_of_issue;
  String? id_issue_authority;
  String? id_issue_location;
  String? tax_id;
  String? date_of_birth;
  String? city;
  String? address;
  String? state;
  String? postcode;
  String? suburb;
  String? beneficiary_entity_type;
  String? phone_country_code;
  String? nationality;
  String? country;

  List<PayoutDetails>? payout_fields;
  Beneficiary(
      {required this.last_name,
      this.ewallet,
      required this.phone_number,
      required this.first_name,
      required this.email,
      this.middle_name,
      this.id_date_of_issue,
      this.id_issue_authority,
      this.id_issue_location,
      this.tax_id,
      this.date_of_birth,
      this.city,
      this.address,
      this.state,
      this.postcode,
      this.suburb,
      this.phone_country_code,
      this.payout_fields,
      this.nationality,
      this.id,
      this.beneficiary_entity_type,
      this.country,
      this.eligible});

  BeneficiaryBase(int payoutIndex) {
    Map<dynamic, dynamic> general = {
      'last_name': last_name,
      'ewallet': ewallet,
      'phone_number': phone_number,
      'mobile_number': phone_number,
      'first_name': first_name,
      'name': first_name + ' ' + last_name,
      'email': email,
      'middle_name': middle_name,
      'id_date_of_issue': id_date_of_issue,
      'id_issue_authority': id_issue_authority,
      'id_issue_location': id_issue_location,
      'tax_id': tax_id,
      'date_of_birth': date_of_birth,
      'city': city,
      'address': address,
      'state': state,
      'province': state,
      'postcode': postcode,
      'beneficiary_entity_type': beneficiary_entity_type,
      'suburb': suburb,
      'nationality': nationality,
      'phone_country_code': phone_country_code,
      'payout_fields': payout_fields?.map((x) => x.toMap()).toList(),
    };

    var specific = payout_fields![payoutIndex].required_fields;
    general.addAll(specific!);
    return general;
  }

  factory Beneficiary.createContact(Map<String, dynamic> map) {
    return Beneficiary(
      last_name: map['last_name'],
      ewallet: map['ewallet'],
      phone_number: map['phone_number'],
      first_name: map['first_name'],
      email: map['email'],
      middle_name: map['middle_name'],
      id_date_of_issue: map['id_date_of_issue'],
      id_issue_authority: map['id_issue_authority'],
      id_issue_location: map['id_issue_location'],
      tax_id: map['tax_id'],
      date_of_birth: map['date_of_birth'],
      city: map['city'],
      address: map['address'],
      state: map['state'],
      postcode: map['postcode'],
      suburb: map['suburb'],
      nationality: map['nationality'],
      id: map['id'],
      beneficiary_entity_type: map['beneficiary_entity_type'],
      country: map['country'],
      eligible: map['eligible'],
      phone_country_code: map['phone_country_code'],
    );
  }
  factory Beneficiary.loadFromDB(Map<String, dynamic> map) {
    return Beneficiary(
      last_name: map['last_name'],
      ewallet: map['ewallet'],
      phone_number: map['phone_number'],
      first_name: map['first_name'],
      email: map['email'],
      middle_name: map['middle_name'],
      id_date_of_issue: map['id_date_of_issue'],
      id_issue_authority: map['id_issue_authority'],
      id_issue_location: map['id_issue_location'],
      tax_id: map['tax_id'],
      date_of_birth: map['date_of_birth'],
      city: map['city'],
      address: map['address'],
      state: map['state'],
      postcode: map['postcode'],
      suburb: map['suburb'],
      nationality: map['nationality'],
      id: map['id'],
      beneficiary_entity_type: map['beneficiary_entity_type'],
      country: map['country'],
      eligible: map['eligible'],
      phone_country_code: map['phone_country_code'],
      payout_fields: map['payout_fields'] == null
          ? null
          : List<PayoutDetails>.from(
              map['payout_fields']?.map((x) => PayoutDetails.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Beneficiary.fromJson(String source) =>
      Beneficiary.loadFromDB(json.decode(source));

  @override
  String toString() {
    return 'Beneficiary(last_name: $last_name, ewallet: $ewallet, phone_number: $phone_number, first_name: $first_name, email: $email, middle_name: $middle_name, id_date_of_issue: $id_date_of_issue, id_issue_authority: $id_issue_authority, id_issue_location: $id_issue_location, tax_id: $tax_id, date_of_birth: $date_of_birth, city: $city, address: $address, state: $state, postcode: $postcode, suburb: $suburb, phone_country_code: $phone_country_code, payout_fields: $payout_fields)';
  }

//For form fields
  Map<String, dynamic> toMap() {
    return {
      'last_name': last_name,
      'ewallet': ewallet,
      'phone_number': phone_number,
      'first_name': first_name,
      'email': email,
      'middle_name': middle_name,
      'id_date_of_issue': id_date_of_issue,
      'id_issue_authority': id_issue_authority,
      'id_issue_location': id_issue_location,
      'tax_id': tax_id,
      'date_of_birth': date_of_birth,
      'city': city,
      'address': address,
      'state': state,
      'postcode': postcode,
      'beneficiary_entity_type': beneficiary_entity_type,
      'suburb': suburb,
      'country': country,
      'phone_country_code': phone_country_code,
      'nationality': nationality,
      'payout_fields': payout_fields?.map((x) => x.toMap()).toList(),
    };
  }
}

class PayoutDetails {
  String? id;
  String? name;
  String? currency;
  Map<String, dynamic>? required_fields;
  PayoutDetails({
    this.id,
    this.name,
    this.currency,
    this.required_fields,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'currency': currency,
      'required_fields': required_fields,
    };
  }

  factory PayoutDetails.fromMap(Map<String, dynamic> map) {
    return PayoutDetails(
      id: map['id'],
      name: map['name'],
      currency: map['currency'],
      required_fields: Map<String, dynamic>.from(map['required_fields']),
    );
  }

  String toJson() => json.encode(toMap());

  factory PayoutDetails.fromJson(String source) =>
      PayoutDetails.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PayoutDetails(id: $id, name: $name, currency: $currency, required_fields: $required_fields)';
  }

  PayoutDetails copyWith({
    String? id,
    String? name,
    String? currency,
    Map<String, dynamic>? required_fields,
  }) {
    return PayoutDetails(
      id: id ?? this.id,
      name: name ?? this.name,
      currency: currency ?? this.currency,
      required_fields: required_fields ?? this.required_fields,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PayoutDetails &&
        other.id == id &&
        other.name == name &&
        other.currency == currency &&
        mapEquals(other.required_fields, required_fields);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        currency.hashCode ^
        required_fields.hashCode;
  }
}
