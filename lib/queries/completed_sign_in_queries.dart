import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myfirstapp/services/auth_service.dart';


Future addCompletedUser(
    String email) async {
  await FirebaseFirestore.instance.collection('completed_sign_in').add({
    'email': email,
  });
}



Future<bool> emailCompletedSignIn() async {
    try {
    print(FirebaseAuth.instance.currentUser?.email ?? "");
// if the size of value is greater then 0 then that email exist.
    final bool completedSignIn = await FirebaseFirestore.instance
        .collection('completed_sign_in')
        .where('email',
            isEqualTo: await FirebaseAuth.instance.currentUser?.email ?? "")
        .get()
        .then((value) => value.size > 0 ? true : false);
        print(completedSignIn);
        print(FirebaseAuth.instance.currentUser?.email ?? "");
    return completedSignIn;
  } catch (e) {
    print(e.toString());
    return false;
  }
}
