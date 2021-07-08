import 'dart:convert';

class Wallet {
  String? id;
  Contact contact;
  String first_name;
  String last_name;
  List accounts = [];
  String email;
  String phone_number;
  Wallet(
      {required this.contact,
      required this.first_name,
      required this.last_name,
      required this.email,
      required this.accounts,
      required this.phone_number,
      this.id});

  toMap() {
    return {
      'contact': contact.toMap(),
      'first_name': first_name,
      'last_name': last_name,
      'email': email,
      'phone_number': phone_number,
    };
  }

  factory Wallet.fromMap(Map<String, dynamic> map) {
    return Wallet(
        contact: Contact.fromMap(map['contacts']['data'][0]),
        first_name: map['first_name'],
        last_name: map['last_name'],
        email: map['email'],
        accounts: map['accounts'],
        phone_number: map['phone_number'],
        id: map["id"]);
  }

  String toJson() => json.encode(toMap());

  factory Wallet.fromJson(String source) => Wallet.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Wallet(eWalletID: $id, contact: $contact, first_name: $first_name, last_name: $last_name, accounts: $accounts, email: $email, phone_number: $phone_number)';
  }
}

class ContactAddress {
  String? name;
  String? line_1;
  String? city;
  String? state;
  String? country;
  String? zip;
  String? phone_number;
  String? line_2;
  String? line_3;
  String? district;
  String? canton;
  ContactAddress(
      {this.name,
      this.city,
      this.country,
      this.line_1,
      this.phone_number,
      this.state,
      this.zip,
      this.line_2,
      this.canton,
      this.district,
      this.line_3});

  toMap() {
    return {
      'name': name,
      'line_1': line_1,
      'city': city,
      'state': state,
      'country': country,
      'zip': zip,
      'phone_number': phone_number,
      'line_2': line_2,
      'line_3': line_3,
      'district': district,
      'canton': canton,
    };
  }

  factory ContactAddress.fromMap(Map<String, dynamic> map) {
    return ContactAddress(
      name: map['name'],
      line_1: map['line_1'],
      city: map['city'],
      state: map['state'],
      country: map['country'],
      zip: map['zip'],
      phone_number: map['phone_number'],
      line_2: map['line_2'],
      line_3: map['line_3'],
      district: map['district'],
      canton: map['canton'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ContactAddress.fromJson(String source) =>
      ContactAddress.fromMap(json.decode(source));
}

class Contact {
  String? id;
  String? email;
  String? first_name;
  String? last_name;
  String? mothers_name;
  String contact_type;
  String? identification_type;
  String? identification_number;
  String? date_of_birth;
  String? country;
  String? gender;
  String? city;
  String? house_type;
  String? marital_status;
  String? nationality;
  String? phone_number;
  ContactAddress? address;
  Contact(
      {this.address,
      this.city,
      this.contact_type = 'personal',
      this.country,
      this.date_of_birth,
      this.email,
      this.first_name,
      this.gender,
      this.house_type,
      this.identification_number,
      this.identification_type,
      this.last_name,
      this.marital_status,
      this.mothers_name,
      this.nationality,
      this.id,
      this.phone_number});

  toMap() {
    return {
      'email': email,
      'first_name': first_name,
      'last_name': last_name,
      'mothers_name': mothers_name,
      'contact_type': contact_type,
      'identification_type': identification_type,
      'identification_number': identification_number,
      'date_of_birth': date_of_birth,
      'country': country,
      'gender': gender,
      'city': city,
      'house_type': house_type,
      'marital_status': marital_status,
      'nationality': nationality,
      'phone_number': phone_number,
      'address': address?.toMap(),
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
        email: map['email'],
        first_name: map['first_name'],
        last_name: map['last_name'],
        mothers_name: map['mothers_name'],
        contact_type: map['contact_type'],
        identification_type: map['identification_type'],
        identification_number: map['identification_number'],
        date_of_birth: map['date_of_birth'],
        country: map['country'],
        gender: map['gender'],
        city: map['city'],
        house_type: map['house_type'],
        marital_status: map['marital_status'],
        nationality: map['nationality'],
        phone_number: map['phone_number'],
        address: map["address"] == null
            ? null
            : ContactAddress?.fromMap(map['address']),
        // address: null,
        id: map['id']);
  }

  String toJson() => json.encode(toMap());

  factory Contact.fromJson(String source) =>
      Contact.fromMap(json.decode(source));
}

class Account {
  String id;
  String currency;
  String alias;
  double balance;
  int received_balance;
  int on_hold_balance;
  int reserve_balance;
  List<dynamic>? limits;
  String? limit;
  Account({
    required this.id,
    required this.currency,
    required this.alias,
    required this.balance,
    required this.received_balance,
    required this.on_hold_balance,
    required this.reserve_balance,
    this.limits,
    this.limit,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'currency': currency,
      'alias': alias,
      'balance': balance.toString(),
      'received_balance': received_balance,
      'on_hold_balance': on_hold_balance,
      'reserve_balance': reserve_balance,
      'limits': limits,
      'limit': limit,
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id'],
      currency: map['currency'],
      alias: map['alias'],
      balance: map['balance'],
      received_balance: map['received_balance'],
      on_hold_balance: map['on_hold_balance'],
      reserve_balance: map['reserve_balance'],
      limits: map['limits'],
      limit: map['limit'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Account.fromJson(String source) =>
      Account.fromMap(json.decode(source));

  Account copyWith({
    String? id,
    String? currency,
    String? alias,
    double? balance,
    int? received_balance,
    int? on_hold_balance,
    int? reserve_balance,
    List<dynamic>? limits,
    String? limit,
  }) {
    return Account(
      id: id ?? this.id,
      currency: currency ?? this.currency,
      alias: alias ?? this.alias,
      balance: balance ?? this.balance,
      received_balance: received_balance ?? this.received_balance,
      on_hold_balance: on_hold_balance ?? this.on_hold_balance,
      reserve_balance: reserve_balance ?? this.reserve_balance,
      limits: limits ?? this.limits,
      limit: limit ?? this.limit,
    );
  }

  @override
  String toString() {
    return 'Account(id: $id, currency: $currency, alias: $alias, balance: $balance, received_balance: $received_balance, on_hold_balance: $on_hold_balance, reserve_balance: $reserve_balance, limits: $limits, limit: $limit)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Account &&
        other.id == id &&
        other.currency == currency &&
        other.alias == alias &&
        other.balance == balance &&
        other.received_balance == received_balance &&
        other.on_hold_balance == on_hold_balance &&
        other.reserve_balance == reserve_balance &&
        other.limits == limits &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        currency.hashCode ^
        alias.hashCode ^
        balance.hashCode ^
        received_balance.hashCode ^
        on_hold_balance.hashCode ^
        reserve_balance.hashCode ^
        limits.hashCode ^
        limit.hashCode;
  }
}

class Transaction {
  String id;
  double amount;
  String currency;
  String ewallet_id;
  String type;
  String balance_type;
  int created_at;
  String status;
  String reason;
  Transaction({
    required this.id,
    required this.amount,
    required this.currency,
    required this.ewallet_id,
    required this.type,
    required this.balance_type,
    required this.created_at,
    required this.status,
    required this.reason,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'currency': currency,
      'ewallet_id': ewallet_id,
      'type': type,
      'balance_type': balance_type,
      'created_at': created_at,
      'status': status,
      'reason': reason,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      amount: map['amount'],
      currency: map['currency'],
      ewallet_id: map['ewallet_id'],
      type: map['type'],
      balance_type: map['balance_type'],
      created_at: map['created_at'],
      status: map['status'],
      reason: map['reason'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Transaction.fromJson(String source) =>
      Transaction.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Transaction(id: $id, amount: $amount, currency: $currency, ewallet_id: $ewallet_id, type: $type, balance_type: $balance_type, created_at: $created_at, status: $status, reason: $reason)';
  }
}
