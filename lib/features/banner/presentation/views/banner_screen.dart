import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hinvex/features/banner/presentation/provider/banner_provider.dart';
import 'package:hinvex/features/banner/presentation/views/widget/add_mobile_banner_popup_widget.dart';
import 'package:hinvex/features/banner/presentation/views/widget/web_property_attaching%20_popup_widget.dart';
import 'package:hinvex/general/utils/app_theme/colors.dart';
import 'package:provider/provider.dart';
import 'widget/add_web_banner_popup_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import 'widget/deletePopup_widget.dart';
import 'widget/mobile_property_attaching _popup_widget.dart';

class BannerScreen extends StatefulWidget {
  const BannerScreen({super.key});

  @override
  State<BannerScreen> createState() => _BannerScreenState();
}

class _BannerScreenState extends State<BannerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BannerProvider>(context, listen: false)
        ..fetchWebBanners(status: "0")
        ..fetchMobileBanners(status: "1");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<BannerProvider>(builder: (context, state, _) {
        return state.fetchwebBannerloading || state.fetchMobileBannerloading
            ? const Center(child: CircularProgressIndicator())
            : Column(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Websites Banners (Recommendation 1220*420)",
                          style: TextStyle(
                            color: titleTextColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            showAddWebBannerPopUpWidget(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: buttonColor),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Add New Banner",
                                style: TextStyle(
                                    color: buttonTextColor, fontSize: 10),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: state.webBannerList.isEmpty
                          ? const Center(
                              child: Text(
                                "No Banner Available (Add New Banner)",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            )
                          : ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: state.webBannerList.length,
                              itemBuilder: (context, index) {
                                log("BANNER LENGTH ${state.webBannerList.length}");
                                return state.bannerIsLoading
                                    ? const CircularProgressIndicator()
                                    : Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Stack(
                                          children: [
                                            SizedBox(
                                              width: 220, // Increase the width
                                              height:
                                                  120, // Increase the height
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(7.5),
                                                child: CachedNetworkImage(
                                                  placeholder: (context, url) =>
                                                      SizedBox(
                                                    width: 220.0,
                                                    height: 120.0,
                                                    child: Shimmer.fromColors(
                                                      baseColor: Colors.red,
                                                      highlightColor:
                                                          Colors.blue,
                                                      child: const SizedBox(
                                                        height: 220,
                                                        width: 120,
                                                      ),
                                                    ),
                                                  ),
                                                  fit: BoxFit.cover,
                                                  imageUrl: state
                                                      .webBannerList[index]
                                                      .image
                                                      .toString(),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 4,
                                              right: 4,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            60),
                                                    color: Colors.white30),
                                                child: PopupMenuButton(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  splashRadius: 10,
                                                  itemBuilder: (context) {
                                                    return [
                                                      PopupMenuItem(
                                                        height: 20,
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                bottom: 10),
                                                        onTap: () {
                                                          showDialog(
                                                            context: context,
                                                            barrierDismissible:
                                                                false,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return WebPropertyAttachingPopupScreen(
                                                                  id: state
                                                                      .webBannerList[
                                                                          index]
                                                                      .postId);
                                                            },
                                                          );
                                                        },
                                                        child: const Row(
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          8.0),
                                                              child: Icon(
                                                                Icons.add,
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          4.0),
                                                              child: Text(
                                                                  "Add Propery"),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      PopupMenuItem(
                                                        height: 20,
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                bottom: 10),
                                                        onTap: () {
                                                          // state.deleteStorageImage(
                                                          //   url: state
                                                          //       .webBannerList[index]
                                                          //       .image,
                                                          //   id: state
                                                          //       .webBannerList[index]
                                                          //       .postId,
                                                          //   onSuccess: () {},
                                                          // );
                                                          // Somewhere in your code where you need to show the dialog

                                                          showDialog(
                                                            context: context,
                                                            barrierDismissible:
                                                                false,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return DeletePostConfirmationDialog(
                                                                postId: state
                                                                    .webBannerList[
                                                                        index]
                                                                    .postId,
                                                                imageUrl: state
                                                                    .webBannerList[
                                                                        index]
                                                                    .image,
                                                              );
                                                            },
                                                          );
                                                        },
                                                        child: const Row(
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          8.0),
                                                              child: Icon(
                                                                  Icons.delete),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          4.0),
                                                              child: Text(
                                                                  "Delete"),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ];
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                              },
                            ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Mobile App Banners(Recommendation 330*220)",
                          style: TextStyle(
                            color: titleTextColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            showAddMobileBannerPopUpWidget(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: buttonColor),
                            child: const Padding(
                              padding: EdgeInsets.all(6.0),
                              child: Text(
                                "Add New Banner",
                                style: TextStyle(
                                    color: buttonTextColor, fontSize: 10),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: state.mobileBannerList.isEmpty
                          ? const Center(
                              child: Text(
                                "No Banner Available (Add New Banner)",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            )
                          : ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: state.mobileBannerList.length,
                              itemBuilder: (context, index) {
                                return state.mobileIsLoading
                                    ? const CircularProgressIndicator()
                                    : Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Stack(
                                          children: [
                                            SizedBox(
                                              width: 220, // Increase the width
                                              height:
                                                  120, // Increase the height
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(7.5),
                                                child: CachedNetworkImage(
                                                  placeholder: (context, url) =>
                                                      SizedBox(
                                                    width: 220.0,
                                                    height: 120.0,
                                                    child: Shimmer.fromColors(
                                                      baseColor: Colors.red,
                                                      highlightColor:
                                                          Colors.blue,
                                                      child: const SizedBox(
                                                        height: 220,
                                                        width: 120,
                                                      ),
                                                    ),
                                                  ),
                                                  fit: BoxFit.cover,
                                                  imageUrl: state
                                                      .mobileBannerList[index]
                                                      .image
                                                      .toString(),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 4,
                                              right: 4,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            60),
                                                    color: Colors.white30),
                                                child: PopupMenuButton(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  splashRadius: 10,
                                                  itemBuilder: (context) {
                                                    return [
                                                      PopupMenuItem(
                                                        height: 20,
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                bottom: 10),
                                                        onTap: () {
                                                          showDialog(
                                                            context: context,
                                                            barrierDismissible:
                                                                false,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return MobilePropertyAttachingPopupScreen(
                                                                  id: state
                                                                      .mobileBannerList[
                                                                          index]
                                                                      .postId);
                                                            },
                                                          );
                                                        },
                                                        child: const Row(
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          8.0),
                                                              child: Icon(
                                                                Icons.add,
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          4.0),
                                                              child: Text(
                                                                  "Add Propery"),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      PopupMenuItem(
                                                        height: 20,
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                bottom: 10),
                                                        onTap: () {
                                                          // state.deleteStorageImage(
                                                          //   url: state
                                                          //       .mobileBannerList[
                                                          //           index]
                                                          //       .image,
                                                          //   id: state
                                                          //       .mobileBannerList[
                                                          //           index]
                                                          //       .postId,
                                                          //   onSuccess: () {},
                                                          //   onFailure: () {},
                                                          // );
                                                          showDialog(
                                                            context: context,
                                                            barrierDismissible:
                                                                false,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return DeletePostConfirmationDialog(
                                                                postId: state
                                                                    .mobileBannerList[
                                                                        index]
                                                                    .postId,
                                                                imageUrl: state
                                                                    .mobileBannerList[
                                                                        index]
                                                                    .image,
                                                              );
                                                            },
                                                          );
                                                        },
                                                        child: const Row(
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          8.0),
                                                              child: Icon(
                                                                  Icons.delete),
                                                            ),
                                                            Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            8.0),
                                                                child: Text(
                                                                    "Delete")),
                                                          ],
                                                        ),
                                                      )
                                                    ];
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                              },
                            ),
                    ),
                  ),
                ],
              );
      }),
    );
  }
}
