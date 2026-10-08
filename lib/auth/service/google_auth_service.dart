//Classes that handle google sign-in and sign-out
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:local_fork/features/home/home_page.dart';

class FirebaseServices {
  final auth = FirebaseAuth.instance;

  //googleSignIn instance (google_sign_in v7 uses a singleton)
  final googleSignIn = GoogleSignIn.instance;

  //initialize() must only be called once per app run
  static bool _initialized = false;

  //Method for Sign-in with using google
  Future<bool> signInWithGoogle() async {
    try {
      if (!_initialized) {
        await googleSignIn.initialize();
        _initialized = true;
      }

      //Throws GoogleSignInException if the user cancels sign in
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.authenticate();

      final GoogleSignInAuthentication googleSignInAuthentication =
          googleSignInAccount.authentication;

      //Create a firebase credential using the tokens from google
      final AuthCredential authCredential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
      );

      //Sign In to firebase using the google credentials
      await auth.signInWithCredential(authCredential);
      return true;
    } on GoogleSignInException catch (e) {
      print(e.toString());
      return false; //User cancelled or google sign in failed
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      return false; //Error Occured
      //throw e
    }
  }

  //Method to signout from both firebase and google
  Future<void> googleSignOut() async {
    //Signout from firebase
    await auth.signOut();
    //Signout from google
    await googleSignIn.signOut();
  }
}

//Call signInWithGoogle, then move to the home screen if it succeeded.
//Shared by login and signup so the flow only lives in one place.
Future<void> handleGoogleSignIn(BuildContext context) async {
  final success = await FirebaseServices().signInWithGoogle();
  if (!context.mounted) return; //Context.mounted = in case user backs out mid log in

  if (success) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeScreen()), //TODO Replace "HomeScreen() -> RecipePage()"
      (_) => false,
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Google Sign-In cancelled or failed')),
    );
  }
}