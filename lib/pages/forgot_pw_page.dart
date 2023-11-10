import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:myfirstapp/components/my_alert_dialog.dart";
import 'package:myfirstapp/queries/completed_sign_in_queries.dart' as queries;

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailcontroller = TextEditingController();

  @override
  void dispose() {
    _emailcontroller.dispose();
    super.dispose();
  }

  Future PasswordReset() async {
    try {
      final completed =
          await queries.emailCompletedSignIn(_emailcontroller.text);
      // user did not complete signing up so he can't change a password because
      // he doesn't have an account
      print(completed);
      if (!completed) {
        showDialog(
            context: context,
            // ignore: prefer_const_constructors
            builder: (context) => MyAlertDialog(
                message: "There isn't an account with that email"));
      } else {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: _emailcontroller.text.trim());
        // ignore: use_build_context_synchronously
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                  content: Text(
                "Password reset link sent! Check your Email",
                textAlign: TextAlign.center,
              ));
            });
      }
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                content: Text(
              e.message.toString(),
              textAlign: TextAlign.center,
            ));
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(223, 240, 247, 232),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(225, 220, 232, 220),
        elevation: 0,
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Text(
            "Enter your Email and we will send you a password reset link",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 98, 130, 107)),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: TextField(
            controller: _emailcontroller,
            decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(225, 220, 232, 220)),
                ),
                fillColor: Color.fromARGB(255, 245, 249, 244),
                filled: true,
                hintText: 'Email',
                hintStyle:
                    TextStyle(color: Color.fromARGB(255, 176, 175, 171))),
          ),
        ),
        const SizedBox(height: 10),
        MaterialButton(
          onPressed: PasswordReset,
          child: Text('Reset Password'),
          color: Color.fromARGB(255, 98, 130, 107),
        )
      ]),
    );
  }
}
