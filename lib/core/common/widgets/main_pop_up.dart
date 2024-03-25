import 'package:ddfapp/core/common/widgets/main_text_input.dart';
import 'package:flutter/material.dart';

import '../../res/colours.dart';
import '../../res/fonts.dart';

class MainPopUp extends StatelessWidget {
  const MainPopUp({
    super.key,
    required this.title,
    this.controller,
    this.placholder,
    this.value,
    required this.onPressedPositive,
    this.isLoading = false,
    this.onPressedNegative,
    this.positiveText,
  });

  final String title;
  final String? value;
  final TextEditingController? controller;
  final String? placholder;
  final String? positiveText;
  final bool isLoading;
  final Function() onPressedPositive;
  final Function()? onPressedNegative;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colours.primaryColour,
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: Fonts.segoe,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: isLoading
          ? const CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(Colours.secondaryColour),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (value != null) ...[
                  Text(
                    "Current value: $value",
                    style: const TextStyle(
                      fontFamily: Fonts.segoe,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                if (controller != null)
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
            onPressedNegative?.call();
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
          onPressed: onPressedPositive,
          child: Text(
            positiveText ?? "Save",
            style: const TextStyle(
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
