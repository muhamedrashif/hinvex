// ignore_for_file: library_private_types_in_public_api

import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:hinvex/features/banner/presentation/views/banner_screen.dart';
import 'package:hinvex/features/home/presantation/provider/routing_provider.dart';
import 'package:hinvex/features/notification/presentation/view/notification_screen.dart';
import 'package:hinvex/features/popular_cities/presentation/view/popularCitiesScreen.dart';
import 'package:hinvex/features/properties/presentation/view/properties_screen.dart';
import 'package:hinvex/features/properties/presentation/view/widget/properties_details_widget.dart';
import 'package:hinvex/features/reports_and_issues/presentation/view/reports_and_issues_screen.dart';
import 'package:hinvex/features/reports_and_issues/presentation/view/widget/reports_user_details_widget.dart';
import 'package:hinvex/features/uploadedByAdmin/presentation/view/uploaded_view_screen.dart';
import 'package:hinvex/features/uploadedByAdmin/presentation/view/widget/edit_uploaded_details_widget_screen.dart';
import 'package:hinvex/features/uploadedByAdmin/presentation/view/widget/uploaded_details_view_screen.dart';
import 'package:hinvex/features/uploadedByAdmin/presentation/view/widget/uploading_widget_screen.dart';
import 'package:hinvex/features/user/presentation/view/user_screen.dart';
import 'package:hinvex/features/user/presentation/view/widget/user_details_widget.dart';
import 'package:hinvex/general/utils/app_assets/image_constants.dart';
import 'package:hinvex/general/utils/enums/enums.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController pageController = PageController();
  SideMenuController sideMenu = SideMenuController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      sideMenu.addListener((index) {
        pageController.jumpToPage(index);
      });
    });
    super.initState();
  }

// USER ROUTING

  Widget currentUserScreen(UserRoutingEnum value) {
    if (value == UserRoutingEnum.userScreen) {
      return const UserScreen();
    } else {
      return const UserDetailWidget();
    }
  }

  // PROPERTIES ROUTING

  Widget currentPropertiesScreen(PropertiesRoutingEnum value) {
    if (value == PropertiesRoutingEnum.propertiesScreen) {
      return const PropertiesScreen();
    } else {
      return const PropertiesDetailWidget();
    }
  }

// UPLOADED BY ADMIN ROUTING

  Widget currentUploadedByAdminScreen(UploadedByAdminRoutingEnum value) {
    if (value == UploadedByAdminRoutingEnum.uploadedViewScreen) {
      return const UploadedViewScreen();
    } else if (value == UploadedByAdminRoutingEnum.uploadedDetailsScreen) {
      return const UploadedDetailWidget();
    } else if (value == UploadedByAdminRoutingEnum.uploadingWidgetScreen) {
      return const UploadingWidgetScreen();
    } else {
      return const EditUploadedWidgetScreen();
    }
  }

// REPORTS AND ISSUES

  Widget currentReportsAndIssuesScreen(ReportsAndIssuesEnum value) {
    if (value == ReportsAndIssuesEnum.reportsAndIssuesScreen) {
      return const ReportsAndIssuesScreen();
    } else {
      return const ReportsUserDetailWidget();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<RoutingProvider>(builder: (context, state, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SideMenu(
              controller: sideMenu,
              style: SideMenuStyle(
                openSideMenuWidth: 250,
                itemOuterPadding: const EdgeInsets.only(right: 0, left: 10),
                displayMode: SideMenuDisplayMode.open,
                unselectedTitleTextStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w500),
                unselectedIconColor: Colors.white,
                selectedColor: Colors.white,
                selectedTitleTextStyle:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                itemHeight: 40,
                itemBorderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10)),
                backgroundColor: const Color.fromRGBO(1, 40, 95, 1),
              ),
              title: Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 45.0),
                      child: SizedBox(
                        height: 25,
                        width: 130,
                        child: Image.asset(
                          ImageConstant.hinvex,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              items: [
                SideMenuItem(
                  title: 'Dashboard',
                  // trailing: const Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 4.0),
                  //   child: Text(
                  //     "|",
                  //     style: TextStyle(
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: 15,
                  //       color: Color.fromRGBO(1, 40, 95, 1),
                  //     ),
                  //   ),
                  // ),
                  onTap: (index, _) {
                    sideMenu.changePage(index);
                  },
                ),
                SideMenuItem(
                  title: 'Users',
                  // trailing: const Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 4.0),
                  //   child: Text(
                  //     "|",
                  //     style: TextStyle(
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: 15,
                  //       color: Color.fromRGBO(1, 40, 95, 1),
                  //     ),
                  //   ),
                  // ),
                  onTap: (index, _) {
                    sideMenu.changePage(index);
                  },
                ),
                SideMenuItem(
                  title: 'Properties',
                  // trailing: const Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 4.0),
                  //   child: Text(
                  //     "|",
                  //     style: TextStyle(
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: 15,
                  //       color: Color.fromRGBO(1, 40, 95, 1),
                  //     ),
                  //   ),
                  // ),
                  onTap: (index, _) {
                    sideMenu.changePage(index);
                  },
                ),
                SideMenuItem(
                  title: 'Uploaded By Admin',
                  onTap: (index, _) {
                    sideMenu.changePage(index);
                  },
                ),
                SideMenuItem(
                  title: 'Reports And Issues',
                  // trailing: const Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 4.0),
                  //   child: Text(
                  //     "|",
                  //     style: TextStyle(
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: 15,
                  //       color: Color.fromRGBO(1, 40, 95, 1),
                  //     ),
                  //   ),
                  // ),
                  onTap: (index, _) {
                    sideMenu.changePage(index);
                  },
                ),
                SideMenuItem(
                  title: 'Banners',
                  // trailing: const Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 4.0),
                  //   child: Text(
                  //     "|",
                  //     style: TextStyle(
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: 15,
                  //       color: Color.fromRGBO(1, 40, 95, 1),
                  //     ),
                  //   ),
                  // ),
                  onTap: (index, _) {
                    sideMenu.changePage(index);
                  },
                ),
                SideMenuItem(
                  title: 'Notification',
                  // trailing: const Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 4.0),
                  //   child: Text(
                  //     "|",
                  //     style: TextStyle(
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: 15,
                  //       color: Color.fromRGBO(1, 40, 95, 1),
                  //     ),
                  //   ),
                  // ),
                  onTap: (index, _) {
                    sideMenu.changePage(index);
                  },
                ),
                SideMenuItem(
                  title: 'Popular Cites',
                  // trailing: const Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 4.0),
                  //   child: Text(
                  //     "|",
                  //     style: TextStyle(
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: 15,
                  //       color: Color.fromRGBO(1, 40, 95, 1),
                  //     ),
                  //   ),
                  // ),
                  onTap: (index, _) {
                    sideMenu.changePage(index);
                  },
                ),
              ],
            ),
            Expanded(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: pageController,
                children: [
                  Container(
                    color: Colors.white,
                    child: const Center(
                      child: Text(
                        'Dashboard',
                        style: TextStyle(fontSize: 35),
                      ),
                    ),
                  ),
                  currentUserScreen(state.userRoutingEnum),
                  currentPropertiesScreen(state.propertiesRoutingEnum),
                  currentUploadedByAdminScreen(state.uploadedByAdminEnum),
                  currentReportsAndIssuesScreen(state.reportsAndIssuesEnum),
                  const Center(child: BannerScreen()),
                  const Center(child: NotificationScreen()),
                  const Center(
                    child: PopularCiteisScreen(),
                  )
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
