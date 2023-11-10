// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:myfirstapp/pages/auth_page.dart';
import 'package:myfirstapp/pages/choose_tags_page.dart';
import 'package:myfirstapp/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myfirstapp/providers/auth_status_provider.dart';
import 'package:myfirstapp/providers/my_provider.dart';
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
    return  MultiProvider(
      providers: [
      ChangeNotifierProvider<MyProvider>(create: (context) => MyProvider(),),
      ChangeNotifierProvider<AuthStateChanges>(create: (context)=>AuthStateChanges())
      ],
      child: const GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthPage()
      ),
    );
  }
}
 
  