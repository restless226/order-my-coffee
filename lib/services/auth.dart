import 'package:brew_crew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:brew_crew/models/user.dart';

class AuthService{
  
  // private variable
  final FirebaseAuth _auth=FirebaseAuth.instance;

  // create User object based on firebase user
  User _userFromFirebaseUser(FirebaseUser user){
    return user!=null? User(uId: user.uid) :null;
  }

  // auth change user stream
  Stream<User> get user{
    return _auth.onAuthStateChanged
        .map(_userFromFirebaseUser);
  }

  // sign in as anonymous
  Future signInAnon() async{
    try{
      AuthResult result=await _auth.signInAnonymously();
      FirebaseUser user=result.user;
      return _userFromFirebaseUser(user);
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }
  
  // sign in with email and password
  Future signInWithEmailandPassword(String email, String password) async{
    try{
      AuthResult result=await _auth.signInWithEmailAndPassword
        (email: email, password: password);
      FirebaseUser user=result.user;
      return _userFromFirebaseUser(user);
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }
  
  // register with email and password
  Future registerWithEmailandPassword(String email, String password) async{
    try{
      AuthResult result=await _auth.createUserWithEmailAndPassword
        (email: email, password: password);
      FirebaseUser user=result.user;

      // create a new document for the user with UId
      await DatabaseService(uId: user.uid).updateUserDatabase('0', 'new crew member', 100);

      return _userFromFirebaseUser(user);
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }
  
  // sign out
  Future signOut () async{
    try{
      return await _auth.signOut();
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }
}