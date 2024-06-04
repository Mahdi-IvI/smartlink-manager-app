import 'package:flutter/material.dart';

import 'loading.dart';
import 'my_text.dart';

class DefaultButton extends StatelessWidget {
  final bool loading;
  final VoidCallback onPress;
  final double width;
  final String title;
  const DefaultButton({super.key, required this.loading, required this.onPress, required this.width, required this.title});

  @override
  Widget build(BuildContext context) {
    return   ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
          Theme.of(context).primaryColor,
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(12),
          ),
        ),
        onPressed: onPress,
        child: SizedBox(
          height: kToolbarHeight,
          width: width,
          child: loading
              ? const WhiteLoading()
              : Row(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              H4Text(
                text:
                title,
                color: Colors.white,
              ),
            ],
          ),
        ));
  }
}
