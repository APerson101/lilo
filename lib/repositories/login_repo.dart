import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lilo/models/signUp.dart';
import 'package:lilo/repositories/rapyd/walletRepository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginRepository {
  LoginRepository() {
    _init();
  }
  late FirebaseAuth auth;
  _init() async {
    if (Firebase.apps.length == 0) await Firebase.initializeApp();

    auth = FirebaseAuth.instance;
  }

  signUp(SignUp signUp) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: signUp.email, password: signUp.password);
      return '200';
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      print(e);
    }
  }

  signIn(String email, String password) async {
    try {
      UserCredential user = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      return '200';
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      print(e);
    }
  }

  signOut() {}
//SharedPreferences.setMockInitialValues (Map<String, dynamic> values); used for testing shared preferences

  fetchSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int theme = (prefs.getInt('theme') ?? 0);
    return theme;
  }
}
