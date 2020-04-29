import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:biplazma/model/user.dart';

class Database {
  static final Database instance = Database();

  final CollectionReference usersCollectionReference = Firestore.instance.collection('users');
  final CollectionReference statisticsCollectionReference = Firestore.instance.collection('statistics');

  Future<User> getUserData(String uid) async {
    var document = await usersCollectionReference.document(uid).get();
    var user = User.fromMap(document.data, uid);
    return user;
  }

}
