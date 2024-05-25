import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hinvex/general/utils/app_assets/image_constants.dart';

import '../../../../general/utils/app_theme/colors.dart';
import 'widget/dashboard_container_card.dart';
import 'widget/graph_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: [
          SizedBox(
            width: 1100,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
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
                    const Divider(
                      thickness: 2,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Dashboard",
                        style: TextStyle(
                            color: titleTextColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          DashboardCard(
                            text: "Total User's",
                            icon: Icons.diversity_3,
                            num: '1000',
                            color: Color(0xFF8896AB),
                          ),
                          DashboardCard(
                            text: "Post",
                            icon: Icons.diversity_2,
                            num: '500',
                            color: Color(0xFF6F829D),
                          ),
                          DashboardCard(
                            text: "Reports",
                            icon: Icons.theaters,
                            num: '54',
                            color: Color(0xFF6F829D),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 388.75,
                            width: 430,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2FFFE),
                              borderRadius: BorderRadius.circular(12.69),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Weekly Users",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12.9),
                                      ),
                                    ],
                                  ),
                                ),
                                GraphWidget()
                              ],
                            ),
                          ),
                          const Gap(8),
                          Container(
                            height: 388.75,
                            width: 430,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2E9F1),
                              borderRadius: BorderRadius.circular(12.69),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "Weekly Post Count",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12.9),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 29.04,
                                        width: 99.58,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(8.3),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 16.6,
                                              width: 16.6,
                                              child: Image.asset(
                                                  ImageConstant.calendar),
                                            ),
                                            const Gap(12),
                                            const Text(
                                              "Calender",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 9.52),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const GraphWidgetnew(),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ]),
            ),
          ),
        ]),
      ),
    );
  }
}
