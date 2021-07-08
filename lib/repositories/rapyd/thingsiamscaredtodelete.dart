// var faker = Faker();
// String phone_number = '+234' + randomNumeric(10),
//     first_name = faker.person.firstName(),
//     last_name = faker.person.lastName(),
//     name = first_name + ' ' + last_name,
//     email = faker.internet.email();
// var city = faker.address.city();
// var state = faker.address.state();
// var country = faker.address.country();
// Wallet wallet = Wallet(
//     contact: Contact(
//       address: ContactAddress(
//           name: name,
//           line_1: faker.address.streetAddress(),
//           city: city,
//           state: state,
//           country: country,
//           zip: randomNumeric(4),
//           phone_number: phone_number),
//       city: city,
//       email: email,
//       phone_number: phone_number,
//       first_name: first_name,
//       last_name: last_name,
//       mothers_name: faker.person.name(),
//       date_of_birth: '01/01/1999',
//       country: faker.address.countryCode(),
//       gender: 'female',
//       house_type: 'live_with_family',
//       marital_status: 'single',
//       nationality: faker.address.countryCode(),
//     ),
//     first_name: first_name,
//     last_name: last_name,
//     email: email,
//     phone_number: phone_number);
    // var address = {
    //   "name": "Ayeola Olajide",
    //   "line_1": "123 Main Street",
    //   "city": "Epe",
    //   "state": "Lagos",
    //   "country": "NG",
    //   "zip": "98225",
    //   "phone_number": "+2347899543222"
    // };
    // var contact = {
    //   'email': 'Olajide@gmail.com',
    //   'first_name': 'Ayeola',
    //   'last_name': 'Olajide',
    //   'mothers_name': 'Raji',
    //   'contact_type': 'personal',
    //   'address': address,
    //   'identification_type': "PA",
    //   'identification_number': "DRV1234567",
    //   'date_of_birth': "10/10/1999",
    //   'country': "US",
    //   'gender': 'male',
    //   'house_type': 'live_with_family',
    //   'marital_status': 'single',
    //   'nationality': 'NG',
    //   'phone_number': '+2347899543222'
    // };
    // var body = {
    //   "contact": contact,
    //   "first_name": "Ayeola",
    //   "last_name": "Olajide",
    //   "email": "Olajide@gmail.com",
    //   "phone_number": "+2347899543222",
    //   "type": "person",
    // };




//     import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_messaging_web/firebase_messaging_web.dart';

// import 'package:flutter/material.dart';
// import 'package:lilo/repositories/user_repo.dart';
// import 'package:lilo/views/main_home/main_home.dart';

// class Appmodel {
//   // FirebaseMessagingWeb
//   FirebaseMessaging messaging;
//   UserRepository userRepository;
//   Appmodel({required this.messaging, required this.userRepository});

//   userLoggedIn() async {
//     NotificationSettings settings = await messaging.getNotificationSettings();
//     if (settings.authorizationStatus != AuthorizationStatus.authorized)
//       // NotificationSettings
//       settings = await messaging.requestPermission(
//         alert: true,
//         announcement: false,
//         badge: true,
//         carPlay: false,
//         criticalAlert: false,
//         provisional: false,
//         sound: true,
//       );
//     print('User granted permission: ${settings.authorizationStatus}');
//     String? userToken = await messaging.getToken(

//         // );
//         vapidKey:
//             "BEPvdhzVTfG0y_bqVBoMcmztkfJfmNuVtNid8P0hrEDMmyIwzdwk6KSKPU1PG9mmiDSzxryX_rhbmIYBDAn9cE0");
//     await saveTokenToDatabase(userToken!);
//     FirebaseMessaging.onBackgroundMessage((message) {
//       return printItOut(message);
//     });
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print('Got a message whilst in the foreground!');
//       print('Message data: ${message.data}');

//       if (message.notification != null) {
//         print('Message also contained a notification: ${message.notification}');
//       }
//     });
//   }

//   Future<void> saveTokenToDatabase(String token) async {
//     // Assume user is logged in for this example
//     await userRepository.saveToken(token);
//   }

//   Future<void> printItOut(RemoteMessage message) async {
//     // Assume user is logged in for this example
//     print(message.data);
//   }
// }
// import 'dart:convert';
// import 'package:random_string/random_string.dart';
// import 'package:crypto/crypto.dart';
// import 'package:convert/convert.dart';

// class APIHandler {
  
//   final String baseURL = 'https://sandboxapi.rapyd.net';
 

//   String _accessKey = 'put your access key';
//   String _secretKey =
//       'put your secret key';


//   Future<Map<String, String>> _getHeaders(String httpMethod, String urlPath,
//       {dynamic body = ''}) async {
//     String timeStamp =
//         ((DateTime.now().millisecondsSinceEpoch) / 1000).round().toString();
//     var salt = randomString(randomBetween(8, 16), from: 97, to: 122);

//     var toSign = httpMethod.toLowerCase() +
//         urlPath +
//         salt +
//         timeStamp +
//         _accessKey +
//         _secretKey;
//     if (body.isNotEmpty) toSign += jsonEncode(body);
//     var signature = _getSignature(toSign);

//     return {
//       'content-type': 'application/json',
//       'access_key': _accessKey,
//       'timestamp': timeStamp,
//       'salt': salt,
//       'signature': signature
//     };
//   }


//   _getSignature(String toSign) {
//     var _key = ascii.encode(_secretKey);
//     var _toSign = ascii.encode(toSign);

//     var hmacSha256 = Hmac(sha256, _key); // HMAC-SHA256

//     var _hmacSha256 = hmacSha256.convert(_toSign);
//     var ss = hex.encode(_hmacSha256.bytes);
//     var tt = ss.codeUnits;
//     var signature = base64.encode(tt);
//     return signature;
//   }
// }

