import 'dart:convert';
import 'dart:html';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pretty_json/pretty_json.dart';
import 'package:random_string/random_string.dart';
import 'dart:math' show Random;
import 'package:crypto/crypto.dart';
import 'package:convert/convert.dart';

class APIHandler {
  final String _postRequest = 'postRequest';
  final String _getRequest = 'getRequest';
  final String _putRequest = 'putRequest';
  final String _url = 'url';
  final String _header = 'headers';
  final String _body = 'body';
  final String _params = 'params';
  final String _postMethod = 'post';
  final String _putMethod = 'put';
  final String _getMethod = 'get';
  final String baseURL = 'https://sandboxapi.rapyd.net';
  APIHandler() {
    _firebaseFunctions.useFunctionsEmulator(origin: 'http://localhost:5001');
  }
  FirebaseFunctions _firebaseFunctions = FirebaseFunctions.instance;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  callFunction({dynamic body, dynamic params, required String function}) async {
    HttpsCallable caller = _firebaseFunctions.httpsCallable(function);

    var responseData = await caller.call({'body': body, 'params': params});
    print(responseData);

    return responseData.data;
  }

  String _accessKey = '2B146C10B4E9C286189C';
  String _secretKey =
      '85335e819ceafb00cac0e56bacc47df138010d247b74e00fe26d0718b078e3ae1c83ce2420773b90';

  postRequest({dynamic body, dynamic params, required String path}) async {
    //?..get headers..?//

    var headers = await _getHeaders(_postMethod, path, body: body);
    // print(headers);
    HttpsCallable caller = _firebaseFunctions.httpsCallable(_postRequest);

    var responseData = await caller.call(
        {_url: baseURL + path, _header: headers, _body: body, _params: params});

    return responseData.data;
  }

  putRequest({dynamic body, dynamic params, required String path}) async {
    var headers = await _getHeaders(_putMethod, path, body: body);
    HttpsCallable caller = _firebaseFunctions.httpsCallable(_putRequest);
    var responseData = await caller.call(
        {_url: baseURL + path, _header: headers, _body: body, _params: params});
  }

  saveWalletInfo(dynamic data) async {
    HttpsCallable caller = _firebaseFunctions.httpsCallable('savetoFirebase');

    var responseData = await caller
        .call({'userID': _firebaseAuth.currentUser!.uid, 'data': data});
    return responseData;
  }

  saveToken(String token) async {
    HttpsCallable caller =
        _firebaseFunctions.httpsCallable('saveTokentoFirebase');
    print("user id is " + _firebaseAuth.currentUser!.uid);
    var responseData = await caller
        .call({'userID': _firebaseAuth.currentUser!.uid, 'token': token});
    return responseData;
  }

  saveTransactiontoFirebase(Map<String, dynamic> data) async {
    HttpsCallable caller =
        _firebaseFunctions.httpsCallable('saveTransactiontoFirebase');

    var responseData = await caller.call(data);
    return responseData;
  }

  getPendingTranscations(String userID) async {
    HttpsCallable caller =
        _firebaseFunctions.httpsCallable('pendingTransactions');

    var responseData = await caller.call({"userID": userID});
    return responseData.data;
  }

  getRequest({required String path, dynamic params}) async {
    // print('we are here');
    var headers = await _getHeaders(_getMethod, path);
    // print(headers);
    HttpsCallable caller = _firebaseFunctions.httpsCallable(_getRequest);
    // print(baseURL + path);
    var responseData = await caller
        .call({_url: baseURL + path, _header: headers, _params: params});
    return responseData.data;
  }

  getWalletID(String userID) async {
    HttpsCallable caller = _firebaseFunctions.httpsCallable('getWalletID');
    var responseData = await caller.call(userID);
    return responseData.data;
  }

  Future<Map<String, String>> _getHeaders(String httpMethod, String urlPath,
      {dynamic body = ''}) async {
    String timeStamp =
        ((DateTime.now().millisecondsSinceEpoch) / 1000).round().toString();
    var salt = randomString(randomBetween(8, 16), from: 97, to: 122);

    var toSign = httpMethod.toLowerCase() +
        urlPath +
        salt +
        timeStamp +
        _accessKey +
        _secretKey;
    if (body.isNotEmpty) toSign += jsonEncode(body);
    var signature = _getSignature(toSign);

    return {
      'content-type': 'application/json',
      'access_key': _accessKey,
      'timestamp': timeStamp,
      'salt': salt,
      'signature': signature
    };
  }

  familyRequest({required dynamic body}) async {
    HttpsCallable caller = _firebaseFunctions.httpsCallable('FamilyRequest');
    var responseData = await caller.call(body);
    return responseData.data;
  }

  _getSignature(String toSign) {
    var _key = ascii.encode(_secretKey);
    var _toSign = ascii.encode(toSign);

    var hmacSha256 = Hmac(sha256, _key); // HMAC-SHA256

    var _hmacSha256 = hmacSha256.convert(_toSign);
    var ss = hex.encode(_hmacSha256.bytes);
    var tt = ss.codeUnits;
    var signature = base64.encode(tt);
    return signature;
  }
}
