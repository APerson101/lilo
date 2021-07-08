import 'dart:convert';

class Payout {
  Map<String, dynamic> beneficiary;

  String? beneficiaryCountry;
  String beneficiaryEntityType;
  String? description;
  String ewallet;
  double payoutAmount;
  String payoutCurrency;
  String payoutMethodType;
  bool confirmAutomatically = true;
  Map<String, dynamic> sender;
  String senderCountry;
  String senderCurrency;
  String senderEntityType;
  Payout({
    required this.beneficiary,
    this.beneficiaryCountry,
    required this.beneficiaryEntityType,
    this.description,
    required this.ewallet,
    required this.payoutAmount,
    required this.payoutCurrency,
    required this.payoutMethodType,
    required this.sender,
    required this.senderCountry,
    required this.senderCurrency,
    required this.senderEntityType,
  });

  factory Payout.fromJson(String str) => Payout.fromMap(json.decode(str));

  factory Payout.fromMap(Map<String, dynamic> json) => Payout(
        beneficiary: json["beneficiary"],
        beneficiaryCountry: json["beneficiary_country"],
        beneficiaryEntityType: json["beneficiary_entity_type"],
        description: json["description"],
        ewallet: json["ewallet"],
        payoutAmount: json["payout_amount"],
        payoutCurrency: json["payout_currency"],
        payoutMethodType: json["payout_method_type"],
        sender: json["sender"],
        senderCountry: json["sender_country"],
        senderCurrency: json["sender_currency"],
        senderEntityType: json["sender_entity_type"],
      );

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        "beneficiary": beneficiary,
        "beneficiary_country": beneficiaryCountry,
        "beneficiary_entity_type": beneficiaryEntityType,
        "description": description,
        "ewallet": ewallet,
        "payout_amount": payoutAmount,
        "payout_currency": payoutCurrency,
        "payout_method_type": payoutMethodType,
        "confirm_automatically": confirmAutomatically,
        "sender": sender,
        "sender_country": senderCountry,
        "sender_currency": senderCurrency,
        "sender_entity_type": senderEntityType,
      };

  @override
  String toString() {
    return 'Payout(beneficiary: $beneficiary, beneficiaryCountry: $beneficiaryCountry, beneficiaryEntityType: $beneficiaryEntityType, description: $description, ewallet: $ewallet, payoutAmount: $payoutAmount, payoutCurrency: $payoutCurrency, payoutMethodType: $payoutMethodType, confirmAutomatically: $confirmAutomatically, sender: $sender, senderCountry: $senderCountry, senderCurrency: $senderCurrency, senderEntityType: $senderEntityType)';
  }
}
