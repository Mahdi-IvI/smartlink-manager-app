import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart_link_manager/models/place_model.dart';
import 'package:smart_link_manager/my_home_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'components/loading.dart';
import 'components/my_text.dart';
import 'config/config.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _phoneNumberTextEditingController =
      TextEditingController();
  final TextEditingController _usernameTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  final TextEditingController _smsCodeTextEditingController =
      TextEditingController();
  bool codeSent = false;
  String? _verificationId;
  String? placeId;
  String? managerId;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: H3Text(
          text: AppLocalizations.of(context)!.signInPageTitle,
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Image(
                width: size.height / 2,
                image: const AssetImage(
                  Config.signInPageImageAssetAddress,
                )),
          ),
          SizedBox(
            width: size.width / 2.5,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 26, horizontal: 36),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            H2Text(text: AppLocalizations.of(context)!.signIn),
                            const SizedBox(
                              height: kToolbarHeight,
                            ),
                            if (codeSent)
                              TextFormField(
                                controller: _smsCodeTextEditingController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                    label: Text(AppLocalizations.of(context)!
                                        .enterCode),
                                    border: const OutlineInputBorder()),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppLocalizations.of(context)!
                                        .errorRequired;
                                  }
                                  return null;
                                },
                              ),
                            if (!codeSent)
                              TextFormField(
                                controller: _phoneNumberTextEditingController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                    label: Text(AppLocalizations.of(context)!
                                        .phoneNumber),
                                    border: const OutlineInputBorder()),
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.length < 9) {
                                    return AppLocalizations.of(context)!
                                        .errorRequired;
                                  }
                                  return null;
                                },
                              ),
                            if (!codeSent)
                              const SizedBox(
                                height: kToolbarHeight / 2,
                              ),
                            if (!codeSent)
                              TextFormField(
                                controller: _usernameTextEditingController,
                                decoration: InputDecoration(
                                    label: Text(
                                        AppLocalizations.of(context)!.username),
                                    border: const OutlineInputBorder()),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppLocalizations.of(context)!
                                        .errorRequired;
                                  }
                                  return null;
                                },
                              ),
                            if (!codeSent)
                              const SizedBox(
                                height: kToolbarHeight / 2,
                              ),
                            if (!codeSent)
                              TextFormField(
                                controller: _passwordTextEditingController,
                                obscureText: true,
                                decoration: InputDecoration(
                                    label: Text(
                                        AppLocalizations.of(context)!.password),
                                    border: const OutlineInputBorder()),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return AppLocalizations.of(context)!
                                        .errorRequired;
                                  }
                                  return null;
                                },
                              ),
                            const SizedBox(
                              height: kToolbarHeight,
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(12), // <-- Radius
                                  ),
                                ),
                                onPressed: () {
                                  if (!_loading &&
                                      _formKey.currentState!.validate()) {
                                    if (codeSent) {
                                      signInWithCode();
                                    } else {
                                      signIn();
                                    }
                                  }
                                },
                                child: SizedBox(
                                  height: kToolbarHeight,
                                  width: size.width / 2 / 2,
                                  child: _loading
                                      ? const WhiteLoading()
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            H4Text(
                                              text:
                                                  AppLocalizations.of(context)!
                                                      .signIn,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void signIn() async {
    var passToBytes = utf8.encode(_passwordTextEditingController.text.trim());
    var bytesToHash = sha256.convert(passToBytes);

    setState(() {
      _loading = true;
    });
    await Config.fireStore
        .collection(Config.managerCollection)
        .where(Config.username,
            isEqualTo: _usernameTextEditingController.text.trim())
        .where(Config.password, isEqualTo: bytesToHash.toString())
        .get()
        .then((QuerySnapshot snapshot) async {
      if (snapshot.size < 1) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                AppLocalizations.of(context)!.incorrectUsernameOrPassword)));
        setState(() {
          _loading = false;
        });
      } else {
        placeId = snapshot.docs[0][Config.placeId];
        managerId = snapshot.docs[0].id;
        Config.sharedPreferences.setString(Config.placeId, placeId ?? "");
        Config.sharedPreferences.setString(Config.managerId, managerId ?? "");
        await Config.auth.verifyPhoneNumber(
          phoneNumber: _phoneNumberTextEditingController.text.trim(),
          verificationCompleted: (PhoneAuthCredential credential) async {
            await Config.auth
                .signInWithCredential(credential)
                .then((value) async {
              await Config.fireStore
                  .collection(Config.managerCollection)
                  .doc(managerId)
                  .collection(Config.loginLogsCollection)
                  .add({
                Config.uid: Config.auth.currentUser!.uid,
                Config.loginDate: DateTime.now()
              }).whenComplete(() {
                setState(() {
                  _loading = false;
                });
                Config.fireStore
                    .collection(Config.placesCollection)
                    .doc(placeId)
                    .get()
                    .then((value) {
                  PlaceModel place = PlaceModel.fromDocument(value);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyHomePage(
                                place: place,
                              )),
                      (route) => false);
                });
              });
            });
          },
          verificationFailed: (FirebaseAuthException e) {
            setState(() {
              _loading = false;
            });
            if (kDebugMode) {
              print(e.code);
            }
            if (e.code == 'invalid-phone-number') {
              if (kDebugMode) {
                print(AppLocalizations.of(context)!.invalidPhoneNumber);
              }
            }
          },
          codeSent: (String verificationId, int? resendToken) {
            setState(() {
              codeSent = true;
              _loading = false;
              _verificationId = verificationId;
            });
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
        );
      }
    });
  }

  signInWithCode() async {
    // Create a PhoneAuthCredential with the code
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: _smsCodeTextEditingController.text.trim());

    // Sign the user in (or link) with the credential
    if (mounted) {
      await Config.auth.signInWithCredential(credential).then((value) async {
        if (kDebugMode) {
          print("result: $value");
        }
        await Config.fireStore
            .collection(Config.managerCollection)
            .doc(managerId)
            .collection(Config.loginLogsCollection)
            .add({
          Config.uid: Config.auth.currentUser!.uid,
          Config.loginDate: DateTime.now()
        }).whenComplete(() {
          Config.fireStore
              .collection(Config.placesCollection)
              .doc(placeId)
              .get()
              .then((value) {
            PlaceModel place = PlaceModel.fromDocument(value);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => MyHomePage(
                          place: place,
                        )),
                (route) => false);
          });
        });
      });
    }
  }
}
