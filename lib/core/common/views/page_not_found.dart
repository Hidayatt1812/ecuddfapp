import 'package:ddfapp/core/res/fonts.dart';
import 'package:flutter/material.dart';

import '../../res/media_res.dart';
import '../widgets/gradient_background.dart';

class PageNotFound extends StatelessWidget {
  const PageNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: GradientBackground(
        image: MediaRes.defaultBackground,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Page Not Found",
                style: TextStyle(
                  fontFamily: Fonts.segoe,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.error_outline_sharp,
                size: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
