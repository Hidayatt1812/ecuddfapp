import 'package:ddfapp/core/common/widgets/main_text_input.dart';
import 'package:flutter/material.dart';

import '../../res/colours.dart';
import '../../res/fonts.dart';

class MainPopUp extends StatelessWidget {
  const MainPopUp({
    super.key,
    required this.title,
    required this.data,
    required this.controller,
    this.placholder,
    required this.value,
    required this.onPressed,
  });

  final String title;
  final dynamic data;
  final String value;
  final TextEditingController controller;
  final String? placholder;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colours.primaryColour,
      title: Text(
        "Edit $title",
        style: const TextStyle(
          fontFamily: Fonts.segoe,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Current value: $value",
            style: const TextStyle(
              fontFamily: Fonts.segoe,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.only(left: 20),
            child: MainTextInput(
              boxDecoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Color.fromARGB(255, 249, 249, 249)),
              disabled: false,
              placholder: placholder,
              controller: controller,
            ),
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            "Cancel",
            style: TextStyle(
              fontFamily: Fonts.segoe,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colours.secondaryColour,
            ),
          ),
        ),
        TextButton(
          onPressed: onPressed,
          child: const Text(
            "Save",
            style: TextStyle(
              fontFamily: Fonts.segoe,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colours.secondaryColour,
            ),
          ),
        ),
      ],
    );
  }
}
