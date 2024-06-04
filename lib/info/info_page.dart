import 'package:flutter/material.dart';
import 'package:smart_link_manager/components/title_subtitle_list_tile.dart';
import 'package:smart_link_manager/info/edit_info_page.dart';

import '../config/my_colors.dart';
import '../models/place_model.dart';
import '../news/photo_gallery.dart';

class InfoPage extends StatefulWidget {
  final PlaceModel place;

  const InfoPage({super.key, required this.place});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double sSize = size.width / 6;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Wrap(
                alignment: WrapAlignment.start,
                children: [
                  for (int i = 0; i < widget.place.images.length; i++)
                    Container(
                      margin: const EdgeInsets.all(4),
                      width: sSize,
                      height: sSize,
                      child: Stack(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PhotoGallery(
                                            imagesUrl: [widget.place.images[i]],
                                            url: true,
                                            index: 0,
                                          )));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      width: 2, color: MyColors.border),
                                  image: DecorationImage(
                                      image:
                                          NetworkImage(widget.place.images[i]),
                                      fit: BoxFit.cover)),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(child: TitleSubtitleListTile(title: "name", subtitle: widget.place.name)),
                Expanded(
              child: TitleSubtitleListTile(
                  title: "Phone Number",
                  subtitle: widget.place.phoneNumbers.join(", ")),
            ),

              ],
            ),

            Row(
              children: [
                Expanded(child: TitleSubtitleListTile(title: "email", subtitle: widget.place.email)),
            Expanded(
              child: TitleSubtitleListTile(
                  title: "stars", subtitle: widget.place.stars.toString()),
            ),
              ],
            ),
            Row(
              children: [
                Expanded(
              child: TitleSubtitleListTile(
                  title: "website", subtitle: widget.place.website),
            ),
                Expanded(
                  child: TitleSubtitleListTile(
                      title: "Address",
                      subtitle:
                          "${widget.place.address} ${widget.place.postCode} ${widget.place.city} ${widget.place.country}"),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TitleSubtitleListTile(
                      title: "instagram", subtitle: widget.place.instagram),
                ),
                Expanded(
                  child: TitleSubtitleListTile(
                      title: "facebook", subtitle: widget.place.facebook),
                ),
              ],
            ),
            TitleSubtitleListTile(
                title: "English description",
                subtitle: widget.place.description),
            TitleSubtitleListTile(
                title: "Deutsch description",
                subtitle: widget.place.descriptionDe),
            const SizedBox(height: kToolbarHeight*3,)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditInfoPage(place: widget.place)))
              .then((value) {
            setState(() {});
          });
        },
        child: const Icon(Icons.edit_outlined),
      ),
    );
  }
}
