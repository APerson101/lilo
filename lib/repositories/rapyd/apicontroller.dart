import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ApiController {
  ApiController() {
    // _firebaseFunctions.useFunctionsEmulator(origin: 'http://localhost:5001');
  }
  FirebaseFunctions _firebaseFunctions = FirebaseFunctions.instance;
  callFunction({dynamic body, dynamic params, required String function}) async {
    HttpsCallable caller = _firebaseFunctions.httpsCallable(function);

    var responseData = await caller.call({body: body, params: params});

    return responseData.data;
  }
}
