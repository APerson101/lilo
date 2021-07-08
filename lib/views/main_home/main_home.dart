import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lilo/components/fading_index_stack.dart';
import 'package:lilo/components/styled_container.dart';
import 'package:lilo/config/config.dart';
import 'package:lilo/controllers/mainController.dart';
import 'package:lilo/repositories/rapyd/walletRepository.dart';
import 'package:lilo/responsive.dart';
import 'package:lilo/styles.dart';
import 'package:lilo/views/cards/cardsView.dart';
import 'package:lilo/views/dashboard/DashboardView.dart';
import 'package:lilo/views/family/family.dart';
import 'package:lilo/views/profile/profileView.dart';
import 'package:lilo/views/settings/settingsView.dart';
import 'package:lilo/views/transactions/transactions.dart';
import 'package:lilo/components/components.dart';

import 'sidemenu.dart';

enum PageType { dashboard, transactions, cards, profile, family, settings }

class MainHome extends StatelessWidget {
  // MainController _mainController = Get.find<MainController>();
  MainController _mainController = Get.put(MainController());

  Future<void> trySetCurrentPage(PageType newPage) async {
    // Get.toNamed('/${describeEnum(newPage)}');
    _mainController.changePage(newPage);
  }

  List<PageType> desktopPages = [
    PageType.dashboard,
    PageType.transactions,
    PageType.cards,
    PageType.profile,
    PageType.family,
    PageType.settings
  ];
  List<PageType> mobilePages = [
    PageType.dashboard,
    PageType.transactions,
    PageType.cards,
    PageType.family
  ];
  // void openMenu() => MainHome.scaffoldKey.currentState!.openDrawer();
  @override
  Widget build(BuildContext context) {
    bool showDrawerMenu = Responsive.isTablet(context);

    double leftMenuWidth = !showDrawerMenu ? 0 : Sizes.sideBarSm;
    if (context.widthPx >= Responsive.desktopSize) {
      leftMenuWidth = Sizes.sideBarLg;
    } else if (context.widthPx >= 850 && context.widthPx < 1100) {
      leftMenuWidth = Sizes.sideBarMed;
    }
    double leftContentOffset = !showDrawerMenu ? leftMenuWidth : Insets.mGutter;

    Widget sideMenu = SideMenu(
      onPageSelected: trySetCurrentPage,
    )
        .animatedPanelX(
          closeX: -leftMenuWidth,
          // Rely on the animatedPanel to toggle visibility of this when it's hidden. It renders an empty Container() when closed
          isClosed: showDrawerMenu,
        ) // Styling, pin to left, fixed width
        .positioned(
            left: 0, top: 0, width: leftMenuWidth, bottom: 0, animate: false);
    print("side menu width $leftMenuWidth");
    return Scaffold(
        drawer:
            showDrawerMenu ? SideMenu(onPageSelected: trySetCurrentPage) : null,
        body: ObxValue(
                (Rx<PageType> page) =>
                    getContent(sideMenu, page, leftContentOffset),
                _mainController.currentPage)
            .paddingAll(12),
        bottomNavigationBar:
            Responsive.isMobile(context) ? bottomNavBar() : null);
  }

  Widget bottomNavBar() {
    return ObxValue(
        (Rx<PageType> data) => BottomNavigationBar(
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.transform_rounded), label: 'Transactions'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.card_travel), label: 'Cards'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: 'Profile'),
              ],
              currentIndex: mobilePages.indexOf(data.value),
              selectedItemColor: Colors.amber,
              onTap: (index) => trySetCurrentPage(mobilePages[index]),
            ),
        _mainController.currentPage);
  }

  Widget getContent(Widget sideMenu, Object? page, double leftContentOffset) {
    return Stack(children: [
      Stack(children: [sideMenu]),
      getCurrentView(page, leftContentOffset)
    ]);
  }

  getCurrentView(page, double leftContentOffset) {
    Widget view;
    switch (page.value) {
      case PageType.dashboard:
        // Get.toNamed("/dashboard");
        view = DashboardView();
        break;
      case PageType.cards:
        view = CardsView();
        break;
      case PageType.profile:
        // view = Container();
        view = ProfileView();
        break;
      case PageType.transactions:
        // view = Container();

        view = TransactionsView();
        break;
      case PageType.family:
        view = FamilyView();
        break;
      default:
        view = CircularProgressIndicator();
    }
    // print('amount of space used up: $leftContentOffset');

    return view.positioned(
        left: leftContentOffset, right: 0, bottom: 0, top: 0, animate: false);
  }
}
