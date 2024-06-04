import 'package:flutter/material.dart';
import 'package:smart_link_manager/my_home_page.dart';
import 'package:smart_link_manager/components/loading.dart';
import 'package:smart_link_manager/sign_in_page.dart';

import 'config/config.dart';
import 'models/place_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      if (Config.auth.currentUser == null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SignInPage()),
            (route) => false);
      } else {
        String? placeId = Config.sharedPreferences
            .getString(Config.placeId);
        if (placeId != null) {
          Config.fireStore.collection(Config.placesCollection).doc(placeId).get().then((value) {
            PlaceModel place = PlaceModel.fromDocument(value);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => MyHomePage(
                      place: place,
                    )),
                    (route) => false);
          });
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const SignInPage()),
              (route) => false);
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Loading(),
      ),
    );
  }
}
