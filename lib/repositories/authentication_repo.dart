import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:lilo/controllers/authentication.dart';
import 'package:lilo/models/signUp.dart';
import 'package:lilo/views/welcome/personalSignUp.dart';

class AuthenticationRepository {
  AuthenticationRepository(this.auth) {
    auth.useEmulator('http://localhost:9099');
  }

  // AuthenticationRepository();
  FirebaseAuth auth;
  // _init() async {
  //   // print('trying from here');
  //   if (Firebase.apps.length == 0) await Firebase.initializeApp();

  // }

  authenticate() {
    return auth.authStateChanges();
  }

  signUp(SignUp signUp) async {
    // try {
    //   await auth.createUserWithEmailAndPassword(
    //       email: signUp.email, password: signUp.password);
    //   return '200';
    // } on FirebaseAuthException catch (e) {
    //   return e.code;
    // } catch (e) {
    //   print(e);
    // }
  }

  newSignUp(String email, String password) async {
    // try {
    //   await auth.createUserWithEmailAndPassword(
    //       email: email, password: password);
    //   return '200';
    // } on FirebaseAuthException catch (e) {
    //   return e.code;
    // } catch (e) {
    //   print(e);
    // }
  }

  signIn({required String email, required String password}) async {
    auth.useEmulator('http://localhost:9099');

    try {
      print({'trying to sign in with : ', email, password});
      UserCredential user = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      Get.find<AuthenticationController>().userID.value = user.user!.uid;
      return '200';
    } on FirebaseAuthException catch (e) {
      print(e);
      return e.code;
    } catch (e) {
      print(e);
    }
  }

  unaunthenticate() async {
    //   try {
    //     auth.signOut();
    //     return true;
    //   } catch (e) {
    //     return false;
    //   }
  }
}
