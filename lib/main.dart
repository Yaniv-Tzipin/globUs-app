// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:myfirstapp/pages/auth_page.dart';
import 'package:myfirstapp/pages/choose_tags_page.dart';
import 'package:myfirstapp/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myfirstapp/providers/provider.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return  ChangeNotifierProvider(
      create: (context) => MyProvider(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthPage()
      ),
    );
  }
}
 
  