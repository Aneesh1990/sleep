import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:sleep_giant/data/song_data.dart';
import 'package:sleep_giant/repositories/firestore_provider.dart';
import 'package:sleep_giant/utils/error_codes.dart';

class UserRepository {
  FirebaseAuth firebaseAuth;
  final _firestoreProvider = FirestoreProvider();

  UserRepository() {
    this.firebaseAuth = FirebaseAuth.instance;
  }

  // sign up with email
  Future<FirebaseUser> signUpUserWithEmailPass(
      String email, String pass, String name) async {
    try {
      var authResult = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );
      print("REPO : ${authResult.user.email}");
      _firestoreProvider.registerUserDetails(
          authResult.user.uid, name, authResult.user.email);
      return authResult.user;
    } on PlatformException catch (e) {
      String authError = "";
      switch (e.code) {
        case ErrorCodes.ERROR_C0DE_NETWORK_ERROR:
          authError = ErrorMessages.ERROR_C0DE_NETWORK_ERROR;
          break;
        case ErrorCodes.ERROR_USER_NOT_FOUND:
          authError = ErrorMessages.ERROR_USER_NOT_FOUND;
          break;
        case ErrorCodes.ERROR_TOO_MANY_REQUESTS:
          authError = ErrorMessages.ERROR_TOO_MANY_REQUESTS;
          break;
        case ErrorCodes.ERROR_INVALID_EMAIL:
          authError = ErrorMessages.ERROR_INVALID_EMAIL;
          break;
        case ErrorCodes.ERROR_CODE_USER_DISABLED:
          authError = ErrorMessages.ERROR_CODE_USER_DISABLED;
          break;
        case ErrorCodes.ERROR_CODE_WRONG_PASSWORD:
          authError = ErrorMessages.ERROR_CODE_WRONG_PASSWORD;
          break;
        case ErrorCodes.ERROR_CODE_EMAIL_ALREADY_IN_USE:
          authError = ErrorMessages.ERROR_CODE_EMAIL_ALREADY_IN_USE;
          break;
        case ErrorCodes.ERROR_OPERATION_NOT_ALLOWED:
          authError = ErrorMessages.ERROR_OPERATION_NOT_ALLOWED;
          break;
        case ErrorCodes.ERROR_CODE_WEAK_PASSWORD:
          authError = ErrorMessages.ERROR_CODE_WEAK_PASSWORD;
          break;
        default:
          authError = ErrorMessages.DEFAULT;
          break;
      }
      throw Exception(authError);
    }
  }

  // sign in with email and password
  Future<FirebaseUser> signInEmailAndPassword(
      String email, String password) async {
    try {
      var authresult = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return authresult.user;
    } on PlatformException catch (e) {
      String authError = "";
      switch (e.code) {
        case ErrorCodes.ERROR_C0DE_NETWORK_ERROR:
          authError = ErrorMessages.ERROR_C0DE_NETWORK_ERROR;
          break;
        case ErrorCodes.ERROR_USER_NOT_FOUND:
          authError = ErrorMessages.ERROR_USER_NOT_FOUND;
          break;
        case ErrorCodes.ERROR_TOO_MANY_REQUESTS:
          authError = ErrorMessages.ERROR_TOO_MANY_REQUESTS;
          break;
        case ErrorCodes.ERROR_INVALID_EMAIL:
          authError = ErrorMessages.ERROR_INVALID_EMAIL;
          break;
        case ErrorCodes.ERROR_CODE_USER_DISABLED:
          authError = ErrorMessages.ERROR_CODE_USER_DISABLED;
          break;
        case ErrorCodes.ERROR_CODE_WRONG_PASSWORD:
          authError = ErrorMessages.ERROR_CODE_WRONG_PASSWORD;
          break;
        case ErrorCodes.ERROR_CODE_EMAIL_ALREADY_IN_USE:
          authError = ErrorMessages.ERROR_CODE_EMAIL_ALREADY_IN_USE;
          break;
        case ErrorCodes.ERROR_OPERATION_NOT_ALLOWED:
          authError = ErrorMessages.ERROR_OPERATION_NOT_ALLOWED;
          break;
        case ErrorCodes.ERROR_CODE_WEAK_PASSWORD:
          authError = ErrorMessages.ERROR_CODE_WEAK_PASSWORD;
          break;
        default:
          authError = ErrorMessages.DEFAULT;
          break;
      }
      throw Exception(authError);
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      // return authResult.user;
    } on PlatformException catch (e) {
      String authError = "";
      switch (e.code) {
        case ErrorCodes.ERROR_INVALID_EMAIL:
          authError = ErrorMessages.ERROR_INVALID_EMAIL;
          break;
        case ErrorCodes.ERROR_USER_NOT_FOUND:
          authError = ErrorMessages.ERROR_USER_NOT_FOUND;
          break;
        case ErrorCodes.ERROR_TOO_MANY_REQUESTS:
          authError = ErrorMessages.ERROR_TOO_MANY_REQUESTS;
          break;
        case ErrorCodes.ERROR_INVALID_EMAIL:
          authError = ErrorMessages.ERROR_INVALID_EMAIL;
          break;
        case ErrorCodes.ERROR_CODE_USER_DISABLED:
          authError = ErrorMessages.ERROR_CODE_USER_DISABLED;
          break;
        case ErrorCodes.ERROR_CODE_WRONG_PASSWORD:
          authError = ErrorMessages.ERROR_CODE_WRONG_PASSWORD;
          break;
        case ErrorCodes.ERROR_CODE_EMAIL_ALREADY_IN_USE:
          authError = ErrorMessages.ERROR_CODE_EMAIL_ALREADY_IN_USE;
          break;
        case ErrorCodes.ERROR_OPERATION_NOT_ALLOWED:
          authError = ErrorMessages.ERROR_OPERATION_NOT_ALLOWED;
          break;
        case ErrorCodes.ERROR_CODE_WEAK_PASSWORD:
          authError = ErrorMessages.ERROR_CODE_WEAK_PASSWORD;
          break;
        default:
          authError = ErrorMessages.DEFAULT;
          break;
      }
      throw Exception(authError);
    }
  }

  Future<QuerySnapshot> getMusicData() => _firestoreProvider.getData();
  // sign out
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  // check signIn
  Future<bool> isSignedIn() async {
    var currentUser = await firebaseAuth.currentUser();
    return currentUser != null;
  }

  // get current user
  Future<FirebaseUser> getCurrentUser() async {
    return await FirebaseAuth.instance.currentUser();
  }

//Sleep Deck Page
  Future<SleepDeckData> getData(String userId) async {
    var postItemdz =
        await Firestore.instance.collection('users').document(userId).get();

    return SleepDeckData.fromSnapshot(postItemdz);
  }

  // </editor-fold>

  Future<void> saveData(DeckData data, String userId) async {
    DocumentSnapshot doc =
        await Firestore.instance.collection("users").document(userId).get();

    SleepDeckData goals = SleepDeckData.fromSnapshot(doc);

    goals.decks.add(data);

    List<Map> list = new List();
    if (data != null && goals.decks.isNotEmpty) {
      goals.decks.forEach((grp) {
        list.add(grp.toJson());
      });
    }

    return Firestore.instance.collection("users").document(userId).updateData(
        {'sleep_deck': FieldValue.arrayUnion(list), 'sleep_deck_added': true});
  }

  Future<void> deleteData(DeckData data, String userId) async {
    DocumentSnapshot doc =
        await Firestore.instance.collection("users").document(userId).get();

    SleepDeckData goals = SleepDeckData.fromSnapshot(doc);

    List<Map> list = new List();
    if (goals.decks.isNotEmpty) {
      goals.decks.forEach((grp) {
        grp.id != data.id ? null : list.add(grp.toJson());
      });
    }
    if (list.isNotEmpty) {
      return Firestore.instance
          .collection("users")
          .document(userId)
          .updateData({
        'sleep_deck': FieldValue.arrayRemove(list),
      });
    } else {
      return Firestore.instance
          .collection("users")
          .document(userId)
          .updateData({'sleep_deck': [], 'sleep_deck_added': false});
    }
  }
}
