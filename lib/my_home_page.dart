import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:smart_link_manager/components/my_text.dart';
import 'package:smart_link_manager/guests/guests_page.dart';
import 'package:smart_link_manager/models/place_model.dart';
import 'package:smart_link_manager/overview_page.dart';
import 'package:smart_link_manager/rooms/rooms_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smart_link_manager/splash_screen.dart';

import 'config/config.dart';
import 'info/info_page.dart';

class MyHomePage extends StatefulWidget {
  final PlaceModel place;

  const MyHomePage({super.key, required this.place});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  late final List _destinations = [
    OverviewPage(
      place: widget.place,
    ),
    RoomsPage(
      place: widget.place,
      showAppbar: false,
    ),
    GuestsPage(place: widget.place,),
    InfoPage(place: widget.place,)
  ];


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(Config.appName),
        actions: [
          IconButton(onPressed: () {
            Config.auth.signOut();
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) => const SplashScreen()), (
                    route) => false);
          }, icon: const Icon(Icons.logout))
        ],
      ),
      body: Stack(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                  width: size.width - 80, child: _destinations[_selectedIndex]),
            ],
          ),
          Row(
            children: [
              NavigationRail(
                backgroundColor: Colors.lightBlueAccent,
                labelType: NavigationRailLabelType.all,
                groupAlignment: -1,
                selectedIndex: _selectedIndex,
                extended: false,
                onDestinationSelected: (int index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                selectedLabelTextStyle: const TextStyle(fontSize: 16),
                destinations: <NavigationRailDestination>[
                  NavigationRailDestination(
                    icon: const Icon(Icons.home_outlined),
                    selectedIcon: const Icon(Icons.home),
                    label: BoldText(text: AppLocalizations.of(context)!.home),
                  ),
                  NavigationRailDestination(
                    icon: const Icon(Icons.meeting_room_outlined),
                    selectedIcon: const Icon(Icons.meeting_room),
                    label: BoldText(text: AppLocalizations.of(context)!.rooms),
                  ),
                  NavigationRailDestination(
                    icon: const Icon(Icons.groups_outlined),
                    selectedIcon: const Icon(Icons.groups),
                    label: BoldText(text: AppLocalizations.of(context)!.guests),
                  ),
                  NavigationRailDestination(
                    icon: const Icon(Icons.info_outline),
                    selectedIcon: const Icon(Icons.info),
                    label: BoldText(text: AppLocalizations.of(context)!.info),
                  ),
                ],
              ),
              const VerticalDivider(thickness: 1, width: 1),
            ],
          ),
        ],
      ),
    );
  }

}
