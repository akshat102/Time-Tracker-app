import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class User {
  User({@required this.photoUrl, @required this.displayName, @required this.uid});
  final String uid;
  final String photoUrl;
  final String displayName;
}

abstract class AuthBase {
  Future<User> currrentUser();
  Future<User> signInAnonymously();
  Future<User> signInWithGoogle();
  Future<User> signInWithFacebook();
  Future<User> signInWithEmailAndPassword(String email, String password);
  Future<User> createUserWithEmailAndPassword(String email, String password);
  Future<void> signOut();
  Stream<User> get onAuthStateChanged;
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;
  User _userFromFirebase(FirebaseUser user) {
    if (user == null)
      return null;
    return User(uid: user.uid,
    displayName: user.displayName,
    photoUrl: user.photoUrl);
  }

  @override
  Stream<User> get onAuthStateChanged {
    return _firebaseAuth.onAuthStateChanged.map(_userFromFirebase);
  }

  @override
  Future<User> currrentUser() async {
    final user = await _firebaseAuth.currentUser();
    return _userFromFirebase(user);
  }

  @override
  Future<User> signInAnonymously() async {
    final authResult = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<User> signInWithGoogle() async{
    GoogleSignIn googleSignIn = GoogleSignIn();
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  if(googleSignInAccount != null){
    GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
    if(googleSignInAuthentication.accessToken != null && googleSignInAuthentication.idToken != null) {
      final authResult = await _firebaseAuth.signInWithCredential(
          GoogleAuthProvider.getCredential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken,)
      );
      return _userFromFirebase(authResult.user);
    }else{
      throw PlatformException(code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
          message: 'Missing google Auth Token');
    }
  }else{
    throw PlatformException(code: 'ERROR_ABORTED_BY_USER',
    message: 'Sign in aborted by User');
  }
  }

  Future<User> signInWithFacebook() async{
    final facebookLogIn = FacebookLogin();
    final result = await facebookLogIn.logInWithReadPermissions(['public_profile'],);
    if(result.accessToken != null){
      final authResult = await _firebaseAuth.signInWithCredential(FacebookAuthProvider.getCredential(
        accessToken: result.accessToken.token,
      ),
      );
      return _userFromFirebase(authResult.user);
    }else{
      throw PlatformException(code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by User',details: ' ptani kya kya aa rha h isme......');
    }
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async{
final authResult =  await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
return _userFromFirebase(authResult.user);
  }
  @override
  Future<User> createUserWithEmailAndPassword(String email, String password) async{
    final authResult =  await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    final facebookLogIn = FacebookLogin();
    await facebookLogIn.logOut();
    await googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}
