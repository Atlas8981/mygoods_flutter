import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  static final String userCollection = "users";
  static final String itemCollection = "items";
  static final String additionalCollection = "additionInfo";
  static final String saveItemCollection = "saveItems";

  Future<bool> login(String email, String password) async {
    try {
      final response = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (response.user!.uid.isNotEmpty) {
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return false;
    }

    // List<Item> response = [];
    // try {
    //   await firestore
    //       .collection("$itemCollection")
    //       .limit(10)
    //       .where("mainCategory", isEqualTo: mainCat)
    //       .where("subCategory", isEqualTo: subCat)
    //       .orderBy("date", descending: true)
    //       .get()
    //       .then((value) => {
    //     value.docs.forEach((element) {
    //       Item item = Item.fromJson(element.data());
    //       response.add(item);
    //     })
    //   });
    // } catch (e) {
    //   print(e.toString());
    // }
    // return response;
  }
}
