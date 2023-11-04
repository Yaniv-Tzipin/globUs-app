import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";

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

  Future PasswordReset() async{
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailcontroller.text.trim());
      // ignore: use_build_context_synchronously
      showDialog(context: context, builder: (context){
        return AlertDialog(content:
        Text("Password reset link sent! Check your Email",
        textAlign: TextAlign.center,
        )
        );
      }
      );
    } on FirebaseAuthException catch(e) {
      // ignore: use_build_context_synchronously
      showDialog(context: context, builder: (context){
        return AlertDialog(content:
        Text(e.message.toString(),
        textAlign: TextAlign.center,
        )
        );
      }
      );

    }

      }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Text("Enter your Email and we will send you a password reset link",
          textAlign: TextAlign.center),
        ),
        const SizedBox(height: 10,),
        Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  controller: _emailcontroller,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromARGB(225,220,232,220)),
                    ),
                    fillColor: Color.fromARGB(255, 245, 249, 244),
                    filled: true,
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Color.fromARGB(255, 176, 175, 171))
                  ),
                ),
              ),
              const SizedBox(height: 10),
              MaterialButton(onPressed: PasswordReset,
              child: Text('Reset Password'),
              color: Colors.amber,
              )
      ]
      ),

    );
  }
}