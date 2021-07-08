import 'dart:convert';

class UserModel2 {
  String last_name;
  String? user_type;
  String? ewallet;
  String phone_number;
  String first_name;
  String email;
  String? sender_entity_type = 'individual';
  String? familyID;
  String? id_date_of_issue;
  String? id_expiry;
  String? id_issue_authority;
  String? id_issue_location;
  String? occupation;
  String? source_of_income;
  String? tax_id;
  String? mothers_name;
  String? identification_type;
  String? identification_number;
  String date_of_birth;
  String country;
  String? gender;
  String city;
  String? house_type;
  String? marital_status;
  String nationality;
  String address;
  String line_1;
  String state;
  String zip;
  String? line_2;
  String? line_3;
  String? district;
  String? canton;
  String? suburb;
  String phone_country_code;
  Map<String, dynamic>? card_pin;
  UserModel2({
    required this.last_name,
    this.user_type,
    this.ewallet,
    required this.phone_number,
    required this.first_name,
    required this.email,
    this.sender_entity_type,
    this.familyID,
    this.id_date_of_issue,
    this.id_expiry,
    this.id_issue_authority,
    this.id_issue_location,
    this.occupation,
    this.source_of_income,
    this.tax_id,
    this.mothers_name,
    this.identification_type,
    this.identification_number,
    required this.date_of_birth,
    required this.country,
    this.gender,
    required this.city,
    this.house_type,
    this.marital_status,
    required this.nationality,
    required this.address,
    required this.line_1,
    required this.state,
    required this.zip,
    this.line_2,
    this.line_3,
    this.district,
    this.canton,
    this.suburb,
    this.card_pin,
    required this.phone_country_code,
  });

  Map<String, dynamic> toMap() {
    return {
      'last_name': last_name,
      'user_type': user_type,
      'eWalletID': ewallet,
      'phone_number': phone_number,
      'first_name': first_name,
      'name': first_name + last_name,
      'surname': last_name,
      'msisdn': '962519185055',
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
      'mothers_name': mothers_name,
      'identification_type': identification_type,
      'identification_number': identification_number,
      'date_of_birth': date_of_birth,
      'country': country,
      'gender': gender,
      'city': city,
      'house_type': house_type,
      'marital_status': marital_status,
      'nationality': nationality,
      'address': address,
      'line_1': line_1,
      'state': state,
      'zip': zip,
      'line_2': line_2,
      'line_3': line_3,
      'district': district,
      'canton': canton,
      'suburb': suburb,
      'card_pin': card_pin,
      'phone_country_code': phone_country_code,
    };
  }

  factory UserModel2.fromMap(Map<String, dynamic> map) {
    return UserModel2(
        last_name: map['last_name'],
        user_type: map['user_type'],
        ewallet: map['eWalletID'],
        phone_number: map['phone_number'],
        first_name: map['first_name'],
        email: map['email'],
        familyID: map['familyID'],
        id_date_of_issue: map['id_date_of_issue'],
        id_expiry: map['id_expiry'],
        id_issue_authority: map['id_issue_authority'],
        id_issue_location: map['id_issue_location'],
        occupation: map['occupation'],
        source_of_income: map['source_of_income'],
        tax_id: map['tax_id'],
        mothers_name: map['mothers_name'],
        identification_type: map['identification_type'],
        identification_number: map['identification_number'],
        date_of_birth: map['date_of_birth'],
        country: map['country'],
        gender: map['gender'],
        city: map['city'],
        house_type: map['house_type'],
        marital_status: map['marital_status'],
        nationality: map['nationality'],
        address: map['address'],
        line_1: map['line_1'],
        state: map['state'],
        zip: map['zip'],
        line_2: map['line_2'],
        line_3: map['line_3'],
        district: map['district'],
        canton: map['canton'],
        suburb: map['suburb'],
        phone_country_code: map['phone_country_code'],
        card_pin: map['card_pin']);
  }

  String toJson() => json.encode(toMap());

  factory UserModel2.fromJson(String source) =>
      UserModel2.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel2(last_name: $last_name, user_type: $user_type, ewallet: $ewallet, phone_number: $phone_number, first_name: $first_name, email: $email, sender_entity_type: $sender_entity_type, familyID: $familyID, id_date_of_issue: $id_date_of_issue, id_expiry: $id_expiry, id_issue_authority: $id_issue_authority, id_issue_location: $id_issue_location, occupation: $occupation, source_of_income: $source_of_income, tax_id: $tax_id, mothers_name: $mothers_name, identification_type: $identification_type, identification_number: $identification_number, date_of_birth: $date_of_birth, country: $country, gender: $gender, city: $city, house_type: $house_type, marital_status: $marital_status, nationality: $nationality, address: $address, line_1: $line_1, state: $state, zip: $zip, line_2: $line_2, line_3: $line_3, district: $district, canton: $canton, suburb: $suburb, phone_country_code: $phone_country_code)';
  }
}
