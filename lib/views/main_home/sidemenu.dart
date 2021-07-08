import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lilo/config/config.dart';
import 'package:get/get.dart';
import 'package:lilo/controllers/authentication.dart';

import 'main_home.dart';

class SideMenu extends StatefulWidget {
  final Function(PageType t) onPageSelected;

  const SideMenu({Key? key, required this.onPageSelected}) : super(key: key);

  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  void _handlePageSelected(PageType pageType) =>
      widget.onPageSelected.call(pageType);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
          child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/logo.png"),
          ),
          DrawerListTile(
            title: "Dashbord",
            svgSrc: "assets/icons/menu_dashbord.svg",
            press: () => _handlePageSelected(PageType.dashboard),
          ),
          DrawerListTile(
            title: "Transaction",
            svgSrc: "assets/icons/menu_tran.svg",
            press: () => _handlePageSelected(PageType.transactions),
          ),
          DrawerListTile(
            title: "Cards",
            svgSrc: "assets/icons/menu_task.svg",
            press: () => _handlePageSelected(PageType.cards),
          ),
          DrawerListTile(
            title: "Profile",
            svgSrc: "assets/icons/menu_profile.svg",
            press: () => _handlePageSelected(PageType.profile),
          ),
          DrawerListTile(
            title: "Family",
            svgSrc: "assets/icons/folder.svg",
            press: () => _handlePageSelected(PageType.family),
          ),
          DrawerListTile(
            title: "Settings",
            svgSrc: "assets/icons/menu_setting.svg",
            press: () => _handlePageSelected(PageType.settings),
          ),
          ElevatedButton(
              onPressed: () => Get.changeTheme(
                  Get.isDarkMode ? ThemeData.light() : ThemeData.dark()),
              child: Text('Theme')),

          /// logout
          SizedBox(height: 15),
          ElevatedButton(
              onPressed: () =>
                  Get.find<AuthenticationController>().demoSignOut(),
              child: Text('LogOut')),
        ],
      )),
    ).constrained(maxWidth: 280);
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        // color: Colors.white54,
        height: 16,
      ),
      title: Text(
        title,
        // style: TextStyle(color: Colors.white54),
      ),
    );
  }
}
