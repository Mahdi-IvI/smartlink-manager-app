import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../components/loading.dart';
import '../components/my_text.dart';

class HotelInformationScreen extends StatefulWidget {
  const HotelInformationScreen({super.key});

  @override
  State<HotelInformationScreen> createState() => _HotelInformationScreenState();
}

class _HotelInformationScreenState extends State<HotelInformationScreen> {
  final bool _loading= false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const H3Text(text: "Add a new Place",color: Colors.white,),
        centerTitle: true,
      ),
      body: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Image(
                    width: size.width / 2 / 3 * 2,
                    image: const AssetImage(
                      "assets/setup/Empty street-rafiki.png",
                    )),
              ),
            ],
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const H2Text(text: "Sign In"),
                const SizedBox(
                  height: kToolbarHeight,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // <-- Radius
                      ),
                    ),
                    onPressed: () {

                    },
                    child: SizedBox(
                      height: kToolbarHeight,
                      width: size.width / 2 / 2,
                      child:  _loading
                          ? const WhiteLoading()
                          :Row(
                        children: [
                          const Expanded(
                              child: NText(
                                text: "Sign in with Google",
                                color: Colors.white,
                              )),
                          Icon(MdiIcons.google,
                            color: Colors.white,)
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
