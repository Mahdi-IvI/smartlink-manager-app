import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_link_manager/splash_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'config/my_colors.dart';
import 'config/config.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Config.auth = FirebaseAuth.instance;
  Config.fireStore = FirebaseFirestore.instance;
  Config.firebaseStorage = FirebaseStorage.instance;
  Config.sharedPreferences = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Config.appName,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF20063E)),
          useMaterial3: true,
          primaryColor: MyColors.primaryColor,
          appBarTheme:
              AppBarTheme(color: MyColors.primaryColor,
              foregroundColor: Colors.white,
              centerTitle: true,
              titleTextStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          drawerTheme: DrawerThemeData(
            backgroundColor: MyColors.primaryColor,
          )),
      home: const SplashScreen()
    );
  }
}
