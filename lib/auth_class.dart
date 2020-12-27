import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AppUser {
  final String currentUserId;
  final String userName;
  final String profilePhoto;
  AppUser(
      {@required this.currentUserId,
      @required this.userName,
      @required this.profilePhoto});
}

abstract class AuthBase {
  AppUser currentUser();
  Future<AppUser> signInAnonymously();
  Future<AppUser> signInWithGoogle();
  Future<AppUser> signInWithFacebook();
  Future<void> signOut();
}

class Auth extends ChangeNotifier implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  AppUser _userFromFirebase(User firebaseUser) {
    if (firebaseUser == null) {
      return null;
    }
    print(firebaseUser);
    return AppUser(
        currentUserId: firebaseUser.uid,
        userName: firebaseUser.displayName,
        profilePhoto: firebaseUser.photoURL);
  }

  @override
  AppUser currentUser() {
    User user = _firebaseAuth.currentUser;
    return _userFromFirebase(user);
  }

  @override
  Future<AppUser> signInAnonymously() async {
    final authResult = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<AppUser> signInWithGoogle() async {
    print(' step 1--------------------------------------------');
    GoogleSignIn googleSignIn = GoogleSignIn();
    GoogleSignInAccount googleAccount = await googleSignIn.signIn();

    print(
        '${googleAccount.authentication}--------------------------------------------');
    if (googleAccount != null) {
      GoogleSignInAuthentication googleAuth =
          await googleAccount.authentication;
      print(' step 2--------------------------------------------');
      if (googleAuth.idToken != null && googleAuth.accessToken != null) {
        print(
            '${googleAuth.idToken}--------------------------------------------');
        final authResult = await _firebaseAuth.signInWithCredential(
          GoogleAuthProvider.credential(
            idToken: googleAuth.idToken,
            accessToken: googleAuth.accessToken,
          ),
        );
        return _userFromFirebase(authResult.user);
      } else {
        throw PlatformException(
          code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
          message: 'Missing Google Authentication Token',
        );
      }
    } else {
      throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign In aborted by user',
      );
    }
  }

  @override
  Future<AppUser> signInWithFacebook() async {
    final facebookLogin = FacebookLogin();
    final facebookAccount =
        await facebookLogin.logIn(['public_profile', 'email']);

    if (facebookAccount != null &&
        facebookAccount.status == FacebookLoginStatus.loggedIn) {
      final authResult = await _firebaseAuth.signInWithCredential(
        FacebookAuthProvider.credential(facebookAccount.accessToken.token),
      );
      return _userFromFirebase(authResult.user);
    } else {
      throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign In aborted by user',
      );
    }
  }

  @override
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    final facebookLogin = FacebookLogin();
    await facebookLogin.logOut();
    await googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}
