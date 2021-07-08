import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:lilo/models/wallet.dart';

class UserModel {
  Contact contact;
  String lastName;
  String userType;
  String eWalletId;
  String phoneNumber;
  String firstName;
  String email;
  String entityType;
  String? familyID;
  String? id_date_of_issue;
  String? id_expiry;
  String? id_issue_authority;
  String? id_issue_location;
  String? occupation;
  String? source_of_income;
  String? tax_id;
  String? suburb;
  String phone_country_code;

  UserModel({
    required this.contact,
    required this.lastName,
    required this.userType,
    required this.eWalletId,
    required this.phoneNumber,
    required this.firstName,
    required this.email,
    required this.entityType,
    this.familyID,
    this.id_date_of_issue,
    this.id_expiry,
    this.id_issue_authority,
    this.id_issue_location,
    this.occupation,
    this.source_of_income,
    this.tax_id,
    this.suburb,
    required this.phone_country_code,
  });

  UserModel copyWith({
    Contact? contact,
    String? lastName,
    String? userType,
    String? eWalletId,
    String? phoneNumber,
    String? firstName,
    String? email,
    String? entityType,
    String? familyID,
    String? id_date_of_issue,
    String? id_expiry,
    String? id_issue_authority,
    String? id_issue_location,
    String? occupation,
    String? source_of_income,
    String? tax_id,
    String? suburb,
    String? phone_country_code,
  }) {
    return UserModel(
      contact: contact ?? this.contact,
      lastName: lastName ?? this.lastName,
      userType: userType ?? this.userType,
      eWalletId: eWalletId ?? this.eWalletId,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      firstName: firstName ?? this.firstName,
      email: email ?? this.email,
      entityType: entityType ?? this.entityType,
      familyID: familyID ?? this.familyID,
      id_date_of_issue: id_date_of_issue ?? this.id_date_of_issue,
      id_expiry: id_expiry ?? this.id_expiry,
      id_issue_authority: id_issue_authority ?? this.id_issue_authority,
      id_issue_location: id_issue_location ?? this.id_issue_location,
      occupation: occupation ?? this.occupation,
      source_of_income: source_of_income ?? this.source_of_income,
      tax_id: tax_id ?? this.tax_id,
      suburb: suburb ?? this.suburb,
      phone_country_code: phone_country_code ?? this.phone_country_code,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'contact': contact.toMap(),
      'lastName': lastName,
      'userType': userType,
      'eWalletId': eWalletId,
      'phoneNumber': phoneNumber,
      'firstName': firstName,
      'email': email,
      'entityType': entityType,
      'familyID': familyID,
      'id_date_of_issue': id_date_of_issue,
      'id_expiry': id_expiry,
      'id_issue_authority': id_issue_authority,
      'id_issue_location': id_issue_location,
      'occupation': occupation,
      'source_of_income': source_of_income,
      'tax_id': tax_id,
      'suburb': suburb,
      'phone_country_code': phone_country_code,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      contact: Contact.fromMap(map['contact']),
      lastName: map['lastName'],
      userType: map['userType'],
      eWalletId: map['eWalletId'],
      phoneNumber: map['phoneNumber'],
      firstName: map['firstName'],
      email: map['email'],
      entityType: map['entityType'],
      familyID: map['familyID'],
      id_date_of_issue: map['id_date_of_issue'],
      id_expiry: map['id_expiry'],
      id_issue_authority: map['id_issue_authority'],
      id_issue_location: map['id_issue_location'],
      occupation: map['occupation'],
      source_of_income: map['source_of_income'],
      tax_id: map['tax_id'],
      suburb: map['suburb'],
      phone_country_code: map['phone_country_code'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  SenderInfoBase() {
    // phone_country_code
    return {
      'last_name': lastName,
      'user_type': userType,
      'ewallet': eWalletId,
      'phone_number': phoneNumber,
      'first_name': firstName,
      'name': firstName + ' ' + lastName,
      'email': email,
      'sender_entity_type': 'individual',
      'familyID': familyID,
      'id_date_of_issue': id_date_of_issue,
      'id_expiry': id_expiry,
      'id_issue_authority': id_issue_authority,
      'id_issue_location': id_issue_location,
      'occupation': occupation,
      'source_of_income': source_of_income,
      'tax_id': tax_id,
      'mothers_name': contact.mothers_name,
      'identification_type': contact.identification_type,
      'identification_number': contact.identification_number,
      'date_of_birth': contact.date_of_birth,
      'country': contact.country,
      'gender': contact.gender,
      'city': contact.city,
      'house_type': contact.house_type,
      'marital_status': contact.marital_status,
      'nationality': contact.nationality,
      'address': contact.address?.name,
      'line_1': contact.address?.line_1,
      'state': contact.address?.state,
      'zip': contact.address?.zip,
      'postcode': contact.address?.zip,
      'line_2': contact.address?.line_2,
      'line_3': contact.address?.line_3,
      'district': contact.address?.district,
      'canton': contact.address?.canton,
      'mobile_number': phoneNumber,
      'province': contact.address?.state,
      'suburb': suburb,
      'phone_country_code': phone_country_code
    };
  }

  profileViewInfo() {
    // phone_country_code
    return {
      'last_name': lastName,
      'user_type': userType,
      'ewallet': eWalletId,
      'phone_number': phoneNumber,
      'first_name': firstName,
      'email': email,
      'familyID': familyID,
      'id_date_of_issue': id_date_of_issue,
      'id_expiry': id_expiry,
      'id_issue_authority': id_issue_authority,
      'id_issue_location': id_issue_location,
      'occupation': occupation,
      'source_of_income': source_of_income,
      'tax_id': tax_id,
      'mothers_name': contact.mothers_name,
      'identification_type': contact.identification_type,
      'identification_number': contact.identification_number,
      'date_of_birth': contact.date_of_birth,
      'country': contact.country,
      'gender': contact.gender,
      'city': contact.city,
      'house_type': contact.house_type,
      'marital_status': contact.marital_status,
      'nationality': contact.nationality,
      'address': contact.address?.name,
      'line_1': contact.address?.line_1,
      'state': contact.address?.state,
      'zip': contact.address?.zip,
      'line_2': contact.address?.line_2,
      'line_3': contact.address?.line_3,
      'district': contact.address?.district,
      'canton': contact.address?.canton,
      'suburb': suburb,
    };
  }

  @override
  String toString() {
    return 'UserModel(contact: $contact, lastName: $lastName, userType: $userType, eWalletId: $eWalletId, phoneNumber: $phoneNumber, firstName: $firstName, email: $email, entityType: $entityType, familyID: $familyID, id_date_of_issue: $id_date_of_issue, id_expiry: $id_expiry, id_issue_authority: $id_issue_authority, id_issue_location: $id_issue_location, occupation: $occupation, source_of_income: $source_of_income, tax_id: $tax_id, suburb: $suburb, phone_country_code: $phone_country_code)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.contact == contact &&
        other.lastName == lastName &&
        other.userType == userType &&
        other.eWalletId == eWalletId &&
        other.phoneNumber == phoneNumber &&
        other.firstName == firstName &&
        other.email == email &&
        other.entityType == entityType &&
        other.familyID == familyID &&
        other.id_date_of_issue == id_date_of_issue &&
        other.id_expiry == id_expiry &&
        other.id_issue_authority == id_issue_authority &&
        other.id_issue_location == id_issue_location &&
        other.occupation == occupation &&
        other.source_of_income == source_of_income &&
        other.tax_id == tax_id &&
        other.suburb == suburb &&
        other.phone_country_code == phone_country_code;
  }

  @override
  int get hashCode {
    return contact.hashCode ^
        lastName.hashCode ^
        userType.hashCode ^
        eWalletId.hashCode ^
        phoneNumber.hashCode ^
        firstName.hashCode ^
        email.hashCode ^
        entityType.hashCode ^
        familyID.hashCode ^
        id_date_of_issue.hashCode ^
        id_expiry.hashCode ^
        id_issue_authority.hashCode ^
        id_issue_location.hashCode ^
        occupation.hashCode ^
        source_of_income.hashCode ^
        tax_id.hashCode ^
        suburb.hashCode ^
        phone_country_code.hashCode;
  }
}
