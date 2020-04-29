import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';

import 'package:biplazma/util/helper.dart';

class AuthService {
  static FirebaseAuth _auth = FirebaseAuth.instance;
  static GoogleSignIn _googleSignIn = GoogleSignIn();
  final Firestore _db = Firestore.instance;

  FirebaseUser firebaseUser;

  Future<FirebaseUser> googleSignIn() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();

    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);

    FirebaseUser user = authResult.user;

    initUserData(user);

    Helper.setUserToken(googleAuth.idToken);

    return user;
  }

  Future<String> signInWithEmailAndPassword(String fullName, String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (result != null) {
        FirebaseUser user = await FirebaseAuth.instance.currentUser();
        updateLastSeen(user);
        return user.uid;
      }
    } catch (error) {
      if (error.code == "ERROR_USER_NOT_FOUND") {
        try {
          AuthResult authResult = await _auth.createUserWithEmailAndPassword(email: email, password: password);
          FirebaseUser user = authResult.user;
          initUserData(user);
          Helper.setUserToken(authResult.user.uid);
          return user.uid;
        } catch (e) {}
      }
    }
  }

  void initUserData(FirebaseUser user) async {
    DocumentReference ref = _db.collection('users').document(user.uid);

    return ref.setData({
      'uid': user.uid,
      'email': user.email,
      'photoURL': user.photoUrl,
      'fullName': user.displayName,
      'lastSeen': FieldValue.serverTimestamp(),
      'isPlasmaRequested': false
    }, merge: true);
  }

  void updateUserData(FirebaseUser user, String fullName, String age, String gender, String bloodGroup, String phoneNumber, String tcNumber,
      {bool donateAgreement = false}) async {
    DocumentReference ref = _db.collection('users').document(user.uid);

    return ref.setData({
      'firstName': fullName.split(" ")[0],
      'fullName': fullName,
      'age': age,
      'gender': gender,
      'bloodGroup': bloodGroup,
      'phoneNumber': phoneNumber,
      'donateAgreement': donateAgreement,
      'tcNumber': tcNumber
    }, merge: true);
  }

  void updateLastSeen(FirebaseUser user) async {
    DocumentReference ref = _db.collection('users').document(user.uid);

    return ref.setData({'lastSeen': FieldValue.serverTimestamp()}, merge: true);
  }

  void updateDonorCount(FirebaseUser user, String province, String county) async {
    DocumentReference userRef = _db.collection('users').document(user.uid);

    userRef.setData({'donateAgreement': true, 'province': province, 'county': county}, merge: true);

    Helper.setDonateAgreement(true);

    DocumentReference ref = _db.collection('statistics').document('biplazma');

    return ref.setData({'donorCount': FieldValue.increment(1)}, merge: true);
  }

  void updateRequestCount() async {
    DocumentReference ref = _db.collection('statistics').document('biplazma');
    return ref.setData({'requestCount': FieldValue.increment(1)}, merge: true);
  }

  void requestPlasm(FirebaseUser user, String province, String district, String hospitalName, bool agreement) async {
    var userData = await _db.collection("users").document(user.uid).get();

    DocumentReference ref = _db.collection('users').document(user.uid);

    ref.setData({'isPlasmaRequested': true}, merge: true);

    Helper.setPlasmaRequested(true);

    DocumentReference requestsRef = _db.collection('requests').document(user.uid);

    return requestsRef.setData({
      'name': userData.data['firstName'],
      'phoneNumber': userData.data['phoneNumber'],
      'bloodGroup': userData.data['bloodGroup'],
      'province': province,
      'district': district,
      'hospitalName': hospitalName,
      'ragreement': agreement,
      'photoUrl': user.photoUrl,
      'createdDate': FieldValue.serverTimestamp()
    }, merge: true);
  }

  void signOut() {
    _auth.signOut();
  }

  void resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}

final AuthService authService = AuthService();
