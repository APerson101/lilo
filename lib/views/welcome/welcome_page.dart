import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core_packages.dart';
import 'landing_page_Controller.dart';
import 'login_form.dart';
import 'welcome_info.dart';

class WelcomePage extends StatelessWidget {
  WelcomePage({Key? key}) : super(key: key);
  LandingController controller = Get.find<LandingController>();

  @override
  Widget build(BuildContext context) {
    bool twoColumnMode = true;
    double columnBreakPt = PageBreaks.TabletLandscape - 100;
    twoColumnMode = context.widthPx > columnBreakPt;
    double formWidth = max(500, context.widthPx * .382);
    double formHeight = max(500, context.heightPx * .382);

    return Scaffold(
        body: Stack(
      fit: StackFit.expand,
      children: [
        if (twoColumnMode) ...[
          WelcomeInfo().opacity(1.0).padding(right: formWidth),
          SizedBox(
            width: formWidth,
            height: formHeight,
            child: LoginForm(controller),
          ).positioned(
              top: 0, bottom: 0, right: 0, left: twoColumnMode ? null : 0)
        ] else ...[
          LoginForm(controller)
        ]
      ],
    ));
  }
}
