import 'package:brew_crew/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brew_crew/models/brew.dart';

class DatabaseService {
  final String uId;

  DatabaseService({this.uId});

  // collection reference
  final CollectionReference brewCollection =
      Firestore.instance.collection('brews');

  // firebase will automatically create this collection
  // different operations can be done on this collection

  Future updateUserDatabase(String sugars, String name, int strength) async {
    return await brewCollection.document(uId).setData({
      'sugars': sugars,
      'name': name,
      'strength': strength,
    }); //firebase automatically creates uId
  }

  // creating brew list from snapshot
  List<Brew> _BrewListFromShapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Brew(
        name: doc.data['name'] ?? '',
        strength: doc.data['strength'] ?? 0,
        sugars: doc.data['sugars'] ?? '',
      );
    }).toList();
  }

  // User data from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uId: uId,
      name: snapshot.data['name'],
      sugars: snapshot.data['sugars'] ?? '',
      strength: snapshot.data['strength'] ?? 0,
    );
  }

  // get brew's stream
  Stream<List<Brew>> get brews {
    return brewCollection.snapshots().map(_BrewListFromShapshot);
  }

  // get user doc stream
  Stream<UserData> get userData {
    return brewCollection.document(uId).snapshots().map(_userDataFromSnapshot);
  }
}
