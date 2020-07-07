import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_carros/data/api/api_result.dart';
import 'package:flutter_carros/data/model/user.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseService {
  static FirebaseService _instance = FirebaseService._internal();

  FirebaseService._internal();

  factory FirebaseService() {
    return _instance;
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<ApiResult> login(String email, String password) async {
    try {
      final AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final FirebaseUser firebaseUser = result.user;

      final User user = User(
        name: firebaseUser.displayName,
        email: firebaseUser.email,
        username: firebaseUser.email,
        imageURL: firebaseUser.photoUrl,
      );
      user.save();

      return ApiResult.success();
    } catch (e) {
      print(e);
      return ApiResult.failure(
          'Não foi possível realizar login com a conta da Google.');
    }
  }

  Future<ApiResult> loginGoogle() async {
    try {
      final googleAccount = await _googleSignIn.signIn();
      final googleAuth = await googleAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final AuthResult result =
          await _firebaseAuth.signInWithCredential(credential);
      final FirebaseUser firebaseUser = result.user;

      final User user = User(
        name: firebaseUser.displayName,
        email: firebaseUser.email,
        username: firebaseUser.email,
        imageURL: firebaseUser.photoUrl,
      );
      user.save();

      return ApiResult.success();
    } catch (e) {
      print(e);
      return ApiResult.failure(
          'Não foi possível realizar login com a conta da Google.');
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }

  Future<User> currentUser() async {
    final FirebaseUser firebaseUser = await _firebaseAuth.currentUser();
    if (firebaseUser != null) {
      return User(
        name: firebaseUser.displayName,
        email: firebaseUser.email,
        username: firebaseUser.email,
        imageURL: firebaseUser.photoUrl,
      );
    }
    return null;
  }

  Future<ApiResult> signUp({
    String name,
    String username,
    String password,
    String urlPhoto,
  }) async {
    try {
      final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: username,
        password: password,
      );
      final firebaseUser = authResult.user;

      final profile = UserUpdateInfo();
      profile.displayName = name;
      profile.photoUrl = urlPhoto;
      await firebaseUser.updateProfile(profile);

      return ApiResult.success();
    } on PlatformException catch(e) {
      print(e);
      return ApiResult.failure('Não foi possível criar o usuário.\n\n${e.message}');
    } catch(e) {
      print(e);
      return ApiResult.failure('Não foi possível criar o usuário.');
    }
  }
}
