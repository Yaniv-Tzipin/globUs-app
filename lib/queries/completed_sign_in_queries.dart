
import 'package:cloud_firestore/cloud_firestore.dart';


Future <void> addCompletedUser(
String email) async {
await FirebaseFirestore.instance.collection('completed_sign_in').doc(email).set({
});
}
