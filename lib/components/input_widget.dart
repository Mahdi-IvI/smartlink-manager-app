import 'package:flutter/material.dart';

class InputWidget extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final TextInputType? textInputType;
  final bool? readOnly;
  final VoidCallback? onTap;
  const InputWidget({super.key, required this.labelText, required this.controller, this.textInputType, this.readOnly, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        keyboardType: textInputType,
        controller: controller,
        readOnly: readOnly!= null? readOnly! : false,
        onTap: onTap,
        decoration: InputDecoration(
            labelText: labelText,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18)
            )
        ),
      ),
    );
  }
}
