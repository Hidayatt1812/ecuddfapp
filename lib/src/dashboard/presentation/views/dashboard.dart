import 'package:ddfapp/core/res/fonts.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/res/colours.dart';
import '../providers/dashboard_controller.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  static const routeName = '/';

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardController>().getScreens();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardController>(builder: (_, controller, __) {
      return
          // NavigationView(
          //   transitionBuilder: (_, animation) {
          //     return FadeTransition(
          //       opacity: animation,
          //       child: SlideTransition(
          //         position: Tween<Offset>(
          //           begin: const Offset(0, 0.1),
          //           end: Offset.zero,
          //         ).animate(animation),
          //         child: controller.screens[controller.currentIndex],
          //       ),
          //     );
          //   },
          //   // paneBodyBuilder: (paneItem, widget) {
          //   //   print(widget.toString());
          //   //   print(controller.currentIndex);
          //   //   return FocusTraversalGroup(
          //   //     child: controller.screens[controller.currentIndex],
          //   //   );
          //   // },
          //   pane: NavigationPane(
          //     selected: controller.currentIndex,
          //     size: const NavigationPaneSize(openMaxWidth: 50),
          //     onChanged: controller.changeIndex,
          //     displayMode: PaneDisplayMode.top,
          //     items: [
          //       PaneItem(
          //         icon: const Icon(FluentIcons.home),
          //         title: const Text("Home"),
          //         body: const SizedBox(child: Text("Home")),
          //       ),
          //       PaneItem(
          //         icon: const Icon(FluentIcons.settings),
          //         title: const Text("Settings"),
          //         body: const SizedBox(child: Text("Settings")),
          //       ),
          //     ],
          //   ),
          // );
          Scaffold(
        body: IndexedStack(
          index: controller.currentIndex,
          children: controller.screens,
        ),
        appBar: AppBar(
          backgroundColor: Colours.primaryColour,
          toolbarHeight: 40,
          elevation: 0,
          leadingWidth: 300,
          leading: Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  border: controller.currentIndex == 0
                      ? const Border(
                          bottom: BorderSide(
                            color: Colours.secondaryColour,
                            width: 4.0,
                          ),
                        )
                      : null,
                ),
                child: TextButton(
                  onPressed: () {
                    controller.changeIndex(0);
                  },
                  child: const Row(
                    children: [
                      Icon(
                        FluentIcons.home,
                        size: 16,
                        color: Colours.tertiaryColour,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Home",
                        style: TextStyle(
                          fontFamily: Fonts.segoe,
                          fontWeight: FontWeight.w500,
                          color: Colours.tertiaryColour,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  border: controller.currentIndex == 1
                      ? const Border(
                          bottom: BorderSide(
                            color: Colours.secondaryColour,
                            width: 4.0,
                          ),
                        )
                      : null,
                ),
                child: TextButton(
                    onPressed: () {
                      controller.changeIndex(1);
                    },
                    child: const Row(
                      children: [
                        Icon(
                          FluentIcons.settings,
                          size: 16,
                          color: Colours.tertiaryColour,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "Settings",
                          style: TextStyle(
                            fontFamily: Fonts.segoe,
                            fontWeight: FontWeight.w500,
                            color: Colours.tertiaryColour,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
        // bottomNavigationBar: Container(
        //   decoration: BoxDecoration(
        //     color: Colours.secondaryColour,
        //     boxShadow: [
        //       BoxShadow(
        //         color: Colors.grey.withOpacity(1),
        //         spreadRadius: 0,
        //         blurRadius: 10,
        //         offset: const Offset(0, 3), // changes position of shadow
        //       ),
        //     ],
        //   ),
        //   child: SafeArea(
        //     child: BottomNavigationBar(
        //       currentIndex: controller.currentIndex,
        //       showSelectedLabels: false,
        //       showUnselectedLabels: false,
        //       backgroundColor: Colors.transparent,
        //       elevation: 0,
        //       onTap: controller.changeIndex,
        //       items: [
        //         BottomNavigationBarItem(
        //           icon: Container(
        //             decoration: BoxDecoration(
        //               border: Border(
        //                 top: BorderSide(
        //                   color: controller.currentIndex == 0
        //                       ? Colours.primaryColour
        //                       : Colors.transparent,
        //                   width: 5.0,
        //                 ),
        //               ),
        //             ),
        //             padding:
        //                 const EdgeInsets.only(top: 10, left: 20, right: 20),
        //             child: Icon(
        //               controller.currentIndex == 0
        //                   ? Icons.home_filled
        //                   : Icons.home_outlined,
        //               size: 32,
        //             ),
        //           ),
        //           label: 'Home',
        //         ),
        //         BottomNavigationBarItem(
        //           icon: Container(
        //             decoration: BoxDecoration(
        //               border: Border(
        //                 top: BorderSide(
        //                   color: controller.currentIndex == 1
        //                       ? Colours.primaryColour
        //                       : Colors.transparent,
        //                   width: 5.0,
        //                 ),
        //               ),
        //             ),
        //             padding:
        //                 const EdgeInsets.only(top: 10, left: 20, right: 20),
        //             child: Icon(
        //               controller.currentIndex == 1
        //                   ? Icons.settings
        //                   : Icons.settings_outlined,
        //               size: 32,
        //             ),
        //           ),
        //           label: 'Settings',
        //           backgroundColor: Colors.white,
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      );
    });
  }
}
