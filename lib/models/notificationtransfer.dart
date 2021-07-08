import 'dart:convert';

class Notificationtransfer {
  String receiver_name;
  String timestamp;
  Notificationtransfer({
    required this.receiver_name,
    required this.timestamp,
  });

  Notificationtransfer copyWith({
    String? receiver_name,
    String? timestamp,
  }) {
    return Notificationtransfer(
      receiver_name: receiver_name ?? this.receiver_name,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'receiver_name': receiver_name,
      'timestamp': timestamp,
    };
  }

  factory Notificationtransfer.fromMap(Map<String, dynamic> map) {
    return Notificationtransfer(
      receiver_name: map['receiver_name'],
      timestamp: map['timestamp'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Notificationtransfer.fromJson(String source) =>
      Notificationtransfer.fromMap(json.decode(source));

  @override
  String toString() =>
      'Notificationtransfer(receiver_name: $receiver_name, timestamp: $timestamp)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Notificationtransfer &&
        other.receiver_name == receiver_name &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode => receiver_name.hashCode ^ timestamp.hashCode;
}
