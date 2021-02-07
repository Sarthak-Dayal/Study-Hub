import 'package:firebase_auth/firebase_auth.dart';
import 'package:study_hub/data/user.dart';
import 'package:study_hub/pages/AfterLogin/schedule.dart';
class AuthService{
  //FirestoreService firestoreService = new FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String error;

  //create user object from firebase User

  _user(User user){
    UserFromFirebaserUser value = user!=null? UserFromFirebaserUser(uid: user.uid,email: user.email):null;
    return value;
  }
  //auth change user stream
  Stream<User> get user {
    return _auth.authStateChanges();
  }
  // sign in with email and password
  Future signin(String email, String password) async{
    final now = DateTime.now();
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      await firestoreService.getClasses(now.year.toString()+" - "+(now.year+1).toString());
      User user = result.user;
      return _user(user);
    }
    catch(e){
      print(e.toString());
      error = e.toString();
      return null;
    }
  }
  // register with email and password
  Future register(String email, String password) async{
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      return _user(user);
    }
    catch(e){
      print(e.toString());
      error = e.toString();
      return null;
    }
  }
  // sign out
  Future signOutFromApp() async{
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  // reset password
  Future resetPassword(String email) async{
    try{
      return await _auth.sendPasswordResetEmail(email: email);
    }catch(e){
      print(e.toString());
      error = e.toString();
      return "Did not work";
    }
  }
}