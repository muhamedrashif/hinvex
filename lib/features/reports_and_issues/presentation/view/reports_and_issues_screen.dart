import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hinvex/features/home/presantation/provider/routing_provider.dart';
import 'package:hinvex/features/reports_and_issues/presentation/provider/report_and_issue_provider.dart';
import 'package:hinvex/features/reports_and_issues/presentation/view/widget/date_widget.dart';
import 'package:hinvex/features/reports_and_issues/presentation/view/widget/reports_reasons_popup_widget.dart';
import 'package:hinvex/general/utils/app_theme/colors.dart';
import 'package:hinvex/general/utils/enums/enums.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ReportsAndIssuesScreen extends StatefulWidget {
  const ReportsAndIssuesScreen({super.key});

  @override
  State<ReportsAndIssuesScreen> createState() => _ReportsAndIssuesScreenState();
}

class _ReportsAndIssuesScreenState extends State<ReportsAndIssuesScreen> {
  // final TextEditingController _searchController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  DateTime startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime endDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReportsAndIssuesProvider>(context, listen: false).clearData();

      Provider.of<ReportsAndIssuesProvider>(context, listen: false)
          .fetchReports(startDate: startDate, endDate: endDate);
      _scrollController.addListener(_scrollListener);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      Provider.of<ReportsAndIssuesProvider>(context, listen: false)
          .fetchNextReports(startDate: startDate, endDate: endDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer<ReportsAndIssuesProvider>(builder: (context, state, _) {
      return state.isLoading
          ? const Center(
              child: CupertinoActivityIndicator(
                color: primaryColor,
              ),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(
                    width: 1100,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 80,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Hello Admin"),
                                  // Padding(
                                  //   padding: const EdgeInsets.symmetric(
                                  //       horizontal: 8.0, vertical: 0),
                                  //   child: SizedBox(
                                  //     height: 40,
                                  //     width: 300,
                                  //     child: TextFormField(
                                  //       scrollPadding: const EdgeInsets.all(8),
                                  //       style: const TextStyle(fontSize: 10),
                                  //       controller: _searchController,
                                  //       onChanged: (query) {
                                  //         state.onSearchChanged(query);
                                  //       },
                                  //       decoration: const InputDecoration(
                                  //         hintText: "Search Here",
                                  //         hintStyle: TextStyle(fontSize: 10),
                                  //         suffixIcon: Icon(Icons.search),
                                  //         border: OutlineInputBorder(
                                  //             borderRadius: BorderRadius.all(
                                  //                 Radius.circular(15))),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                          const Divider(
                            thickness: 2,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Reports",
                                  style: TextStyle(
                                      color: titleTextColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return const DateRangeService();
                                      },
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: buttonColor),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 16),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsets.only(right: 8.0),
                                            child: Icon(
                                              Icons.calendar_month,
                                              color: Colors.white,
                                              size: 15,
                                            ),
                                          ),
                                          Text(
                                            "This Month",
                                            style: TextStyle(
                                                color: buttonTextColor,
                                                fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Flexible(
                            flex: 1,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, top: 8, right: 8.0),
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
                                            width: 150,
                                            child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text("Category",
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.grey)))),

                                        SizedBox(
                                            width: 150,
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
                                                child: Text("Reason",
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.grey)))),

                                        SizedBox(
                                            width: 300,
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
                                Flexible(
                                  flex: 1,
                                  child: state.filteredReportsList.isEmpty
                                      ? const Center(
                                          child: Text(
                                            "No Reports Available",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                        )
                                      : ListView.builder(
                                          physics:
                                              const BouncingScrollPhysics(),
                                          scrollDirection: Axis.vertical,
                                          itemCount:
                                              state.filteredReportsList.length,
                                          itemBuilder: (context, index) {
                                            log("REPORTS LENGTH:::::::::::::::${state.filteredReportsList.length}");
                                            DateTime postDate = state
                                                .filteredReportsList[index]
                                                .createDate!
                                                .toDate();
                                            String formattedDate =
                                                "${postDate.day}/${postDate.month}/${postDate.year}";
                                            return InkWell(
                                              onTap: () {
                                                state.fetchUser(
                                                    userId: state
                                                        .filteredReportsList[
                                                            index]
                                                        .userId
                                                        .toString());
                                                state.fetchUserReports(
                                                    userId: state
                                                        .filteredReportsList[
                                                            index]
                                                        .userId
                                                        .toString());
                                                Provider.of<RoutingProvider>(
                                                        context,
                                                        listen: false)
                                                    .reportsAndIssuesRouting(
                                                        ReportsAndIssuesEnum
                                                            .reportsUserDetailWidget);
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0, right: 8.0),
                                                child: Container(
                                                  height:
                                                      40, // Adjusted height for better visibility
                                                  decoration:
                                                      const BoxDecoration(
                                                    border: Border(
                                                      bottom: BorderSide(
                                                          width: 1.0,
                                                          color: Colors.grey),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 140,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                            formattedDate,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),

                                                      // Adjusted widths for better alignment
                                                      SizedBox(
                                                        width: 150,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                            state
                                                                .filteredReportsList[
                                                                    index]
                                                                .getSelectedCategoryString,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 150,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                            state
                                                                .filteredReportsList[
                                                                    index]
                                                                .getSelectedTypeString,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            150, // Adjusted width for better alignment
                                                        child: InkWell(
                                                          onTap: () {
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return ReportReasonsPopupScreen(
                                                                  reasonList: state
                                                                      .filteredReportsList[
                                                                          index]
                                                                      .reportReasons,
                                                                );
                                                              },
                                                            );
                                                          },
                                                          child: const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
                                                            child: Text(
                                                              "View More",
                                                              style: TextStyle(
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            350, // Adjusted width for better alignment
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: RichText(
                                                            text: TextSpan(
                                                              text: "View More",
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    Colors.blue,
                                                                decoration:
                                                                    TextDecoration
                                                                        .underline,
                                                              ),
                                                              recognizer:
                                                                  TapGestureRecognizer()
                                                                    ..onTap =
                                                                        () {
                                                                      // log("id-----------------${state.filteredReportsList[index].id}");

                                                                      launchUrlString(
                                                                          'https://hinvex.com/all-categories/${state.filteredReportsList[index].id}');
                                                                    },
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                ),
                              ],
                            ),
                          )
                        ]),
                  ),
                ],
              ),
            );
    }));
  }
}
