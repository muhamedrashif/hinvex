import 'dart:developer';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hinvex/features/home/presantation/provider/routing_provider.dart';
import 'package:hinvex/features/reports_and_issues/presentation/provider/report_and_issue_provider.dart';
import 'package:hinvex/general/utils/app_theme/colors.dart';
import 'package:hinvex/general/utils/enums/enums.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ReportsUserDetailWidget extends StatefulWidget {
  const ReportsUserDetailWidget({super.key});

  @override
  State<ReportsUserDetailWidget> createState() =>
      _ReportsUserDetailWidgetState();
}

class _ReportsUserDetailWidgetState extends State<ReportsUserDetailWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ReportsAndIssuesProvider>(builder: (context, state, _) {
      log(state.fetchUsertList.toString());
      return state.fetchUsertLoading || state.fetchUserReportstLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Scaffold(
              body: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(
                      width: 1100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 80,
                              child: Text("Hello Admin"),
                            ),
                          ),
                          const Divider(thickness: 2),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Reports",
                                  style: TextStyle(
                                    color: titleTextColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Provider.of<RoutingProvider>(context,
                                            listen: false)
                                        .reportsAndIssuesRouting(
                                            ReportsAndIssuesEnum
                                                .reportsAndIssuesScreen);
                                    state.clearData();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: backButtonColor,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                      horizontal: 16,
                                    ),
                                    child: const Text(
                                      "Back",
                                      style: TextStyle(
                                        color: buttonTextColor,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        state.fetchUsertList.first.userImage),
                                    radius: 40,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 2),
                                    Text(
                                        "Name: ${state.fetchUsertList.first.userName}",
                                        style: const TextStyle(fontSize: 13)),
                                    Text(
                                        "Phone Number: ${state.fetchUsertList.first.userPhoneNumber}",
                                        style: const TextStyle(fontSize: 13)),
                                    Text(
                                        "Posts: ${state.fetchUsertList.first.totalPosts}",
                                        style: const TextStyle(fontSize: 13)),
                                    GestureDetector(
                                      onTap: () {
                                        state.toggleUserBlockStatus(
                                            state.fetchUsertList.first.userId);
                                      },
                                      child: Text(
                                        state.fetchUsertList.first.isBlocked
                                            ? "Unblock this account?"
                                            : "Block this account?",
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                          fontStyle: FontStyle.italic,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: sentButtonColor),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 40),
                                    child: Text(
                                      "Reports",
                                      style: TextStyle(
                                          fontSize: 10, color: buttonTextColor),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8.0, top: 8),
                                  child: Container(
                                    height:
                                        40, // Adjusted height for better visibility
                                    decoration: BoxDecoration(
                                      color: Colors.grey[350],
                                      border: const Border(
                                          bottom: BorderSide(
                                              width: 1.0, color: Colors.grey)),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                            width: 140,
                                            child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text("Date",
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold)))),

                                        // Adjusted widths for better alignment
                                        SizedBox(
                                            width: 210,
                                            child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text("Category",
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.grey)))),

                                        SizedBox(
                                            width: 140,
                                            child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text("Type",
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.grey)))),

                                        SizedBox(
                                            width: 150,
                                            child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text("Asking price",
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.grey)))),

                                        SizedBox(
                                            width: 290,
                                            child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text("Link",
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.grey)))),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    itemCount:
                                        state.fetchUserReportstList.length,
                                    itemBuilder: (context, index) {
                                      DateTime postDate = state
                                          .fetchUserReportstList[index]
                                          .createDate!
                                          .toDate();
                                      String formattedDate =
                                          "${postDate.day}/${postDate.month}/${postDate.year}";
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Stack(
                                          children: [
                                            Container(
                                              height:
                                                  40, // Adjusted height for better visibility
                                              decoration: const BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        width: 1.0,
                                                        color: Colors.grey)),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                      width: 140,
                                                      child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              formattedDate,
                                                              style: const TextStyle(
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)))),

                                                  // Adjusted widths for better alignment
                                                  SizedBox(
                                                      width: 210,
                                                      child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              state
                                                                  .fetchUserReportstList[
                                                                      index]
                                                                  .getSelectedCategoryString,
                                                              style: const TextStyle(
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)))),

                                                  SizedBox(
                                                      width: 140,
                                                      child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              state
                                                                  .fetchUserReportstList[
                                                                      index]
                                                                  .getSelectedTypeString,
                                                              style: const TextStyle(
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)))),

                                                  SizedBox(
                                                      width: 150,
                                                      child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              state
                                                                  .fetchUserReportstList[
                                                                      index]
                                                                  .propertyPrice
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)))),

                                                  SizedBox(
                                                      width: 290,
                                                      child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: RichText(
                                                            text: TextSpan(
                                                                text:
                                                                    "View More",
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .blue,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                ),
                                                                recognizer:
                                                                    TapGestureRecognizer()
                                                                      ..onTap =
                                                                          () {
                                                                        launchUrlString(
                                                                            'https://hinvex.com/all-categories/${state.filteredReportsList[index].id}');
                                                                      }),
                                                          ))),

                                                  Positioned(
                                                    top: 4,
                                                    right: 4,
                                                    child: PopupMenuButton(
                                                      splashRadius: 10,
                                                      icon: const Icon(
                                                        Icons.delete,
                                                        size: 15,
                                                        color: Colors.red,
                                                      ),
                                                      itemBuilder: (context) {
                                                        return [
                                                          PopupMenuItem(
                                                            height: 20,
                                                            onTap: () {
                                                              state
                                                                  .deleteReports(
                                                                id: state
                                                                    .fetchUserReportstList[
                                                                        index]
                                                                    .id
                                                                    .toString(),
                                                                onSuccess:
                                                                    () {},
                                                              );
                                                            },
                                                            child: const Text(
                                                                "Delete"),
                                                          )
                                                        ];
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
    });
  }
}
