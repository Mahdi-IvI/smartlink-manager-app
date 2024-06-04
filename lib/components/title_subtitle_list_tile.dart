import 'package:flutter/material.dart';

class TitleSubtitleListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  const TitleSubtitleListTile({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      titleTextStyle: const TextStyle(fontSize: 13, color: Colors.black),
      subtitleTextStyle: const TextStyle(fontSize: 16, color: Colors.black),
    );
  }
}
