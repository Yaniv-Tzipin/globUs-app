// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:myfirstapp/components/choose_tags_button.dart';
import 'package:myfirstapp/components/my_country_picker.dart';
import 'package:myfirstapp/pages/auth_page.dart';
import 'package:myfirstapp/pages/choose_tags_page.dart';
import 'package:myfirstapp/pages/continue_register.dart';
import 'package:myfirstapp/pages/home_page.dart';
import 'package:myfirstapp/pages/login_or_register_page.dart';
import 'package:myfirstapp/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myfirstapp/pages/main_chat_page.dart';
import 'package:myfirstapp/providers/my_tags_provider.dart';
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
      ChangeNotifierProvider<MyTagsProvider>(create: (context) => MyTagsProvider(),),
      ],
      child:  const GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthPage()
      ),
    );
  }
}
 
  