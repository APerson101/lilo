import 'dart:convert';

enum ResponseStatus { Error, Success, Failed }

class ResponseCode {
  Errors? error;
  ResponseStatus responseCode;
  dynamic successData;
  ResponseCode({this.error, required this.responseCode, this.successData});
}

class Errors {
  String error_code;
  String status;
  String message;
  Errors({
    required this.error_code,
    required this.status,
    required this.message,
  });

  Map<String, dynamic> toMap() {
    return {
      'error_code': error_code,
      'status': status,
      'message': message,
    };
  }

  factory Errors.fromMap(Map<String, dynamic> map) {
    return Errors(
      error_code: map['error_code'],
      status: map['status'],
      message: map['message'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Errors.fromJson(String source) => Errors.fromMap(json.decode(source));
}
