import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smart_link_manager/components/default_button.dart';
import 'package:smart_link_manager/components/input_widget.dart';
import 'package:smart_link_manager/config/config.dart';
import 'package:smart_link_manager/models/place_model.dart';
import 'package:smart_link_manager/models/user_model.dart';

import 'find_available_rooms_page.dart';

class AddGuestPage extends StatefulWidget {
  final PlaceModel place;
  const AddGuestPage({super.key, required this.place});

  @override
  State<AddGuestPage> createState() => _AddGuestPageState();
}

class _AddGuestPageState extends State<AddGuestPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController codeTextEditingController = TextEditingController();
  TextEditingController passportNumberTextEditingController =
      TextEditingController();
  TextEditingController firstnameTextEditingController =
      TextEditingController();
  TextEditingController lastnameTextEditingController = TextEditingController();
  TextEditingController phoneNumberTextEditingController =
      TextEditingController();
  TextEditingController dateTextEditingController = TextEditingController();

  bool loading = false;
  DateTimeRange? dateTimeRange;

  UserModel? user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addGuest),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 18.0),
                            child: InputWidget(
                                textInputType: TextInputType.number,
                                labelText: "Code",
                                controller: codeTextEditingController),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              findUser();
                            },
                            icon: const Icon(Icons.search))
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Form(
                        child: GridView.count(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          childAspectRatio: 4.3,
                          crossAxisSpacing: 8,
                          children: [
                            InputWidget(
                                labelText:
                                    AppLocalizations.of(context)!.passportNumber,
                                controller: passportNumberTextEditingController),
                            InputWidget(
                                labelText: AppLocalizations.of(context)!.firstname,
                                controller: firstnameTextEditingController),
                            InputWidget(
                                labelText: AppLocalizations.of(context)!.lastname,
                                controller: lastnameTextEditingController),
                            InputWidget(
                              textInputType: TextInputType.phone,
                                labelText: AppLocalizations.of(context)!.phoneNumber,
                                controller: phoneNumberTextEditingController),
                            InputWidget(
                                onTap: () async {
                                  dateTimeRange = await showDateRangePicker(
                                      context: context,
                                      firstDate: DateTime.now()
                                          .subtract(const Duration(days: 9999)),
                                      lastDate: DateTime.now()
                                          .add(const Duration(days: 9999)));
                                  if (dateTimeRange != null) {
                                    setState(() {
                                      dateTextEditingController.text =
                                          "${Config.dateFormatter.format(dateTimeRange!.start)} - "
                                          "${Config.dateFormatter.format(dateTimeRange!.end)}";
                                    });
                                  }
                                },
                                readOnly: true,
                                labelText: "date",
                                controller: dateTextEditingController),
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
          DefaultButton(
              loading: loading,
              onPress: () {
                updateUserInfo();
              },
              width: double.infinity,
              title: AppLocalizations.of(context)!.addGuest)
        ],
      ),
    );
  }

  Future findUser() async {
    String userCode = codeTextEditingController.text.trim();

    await Config.fireStore
        .collection(Config.userCollection)
        .where(Config.code,
            arrayContains: userCode)
        .get()
        .then((QuerySnapshot snapshot) {
      if (snapshot.size == 0) {
        return ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("can't find user")));
      }
      if (snapshot.size > 1) {
        codeTextEditingController.clear();
        return ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Something went Wrong. please try again")));
      }
      UserModel existUser = UserModel.fromDocument(snapshot.docs.first);
      DateTime expire = existUser.code[1].toDate();
      if (expire.isBefore(DateTime.now())) {

        return ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("code has been expired!")));
      } else {
        setState(() {
          user = existUser;
          passportNumberTextEditingController.text =
              user!.passportNumber ?? "";
          firstnameTextEditingController.text = user!.firstname ?? "";
          lastnameTextEditingController.text = user!.lastname ?? "";
          phoneNumberTextEditingController.text = user!.phoneNumber ?? "";
        });
      }
    });
  }

  Future updateUserInfo() async {
    if ( user != null &&
        dateTimeRange != null) {
      user!.passportNumber =
          passportNumberTextEditingController.text.trim();
      user!.firstname = firstnameTextEditingController.text.trim();
      user!.lastname = lastnameTextEditingController.text.trim();
      user!.phoneNumber = phoneNumberTextEditingController.text.trim();

      await Config.fireStore
          .collection(Config.userCollection)
          .doc(user!.uid)
          .update(user!.toJson())
          .then((value) {
         Navigator.push(context, MaterialPageRoute(builder: (context)=>FindAvailableRoomsPage(
           place: widget.place,
           dateTimeRange: dateTimeRange!,
           user: user!,
         )));
      });
    }
  }
}
