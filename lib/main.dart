

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:myfirstapp/components/my_match_card.dart';
import 'package:myfirstapp/pages/auth_page.dart';
import 'package:myfirstapp/pages/its_a_match_page.dart';
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
 
  