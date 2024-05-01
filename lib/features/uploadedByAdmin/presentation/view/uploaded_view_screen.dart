import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hinvex/features/home/presantation/provider/routing_provider.dart';
import 'package:hinvex/features/uploadedByAdmin/presentation/provider/uploadedByAdmin_provider.dart';
import 'package:hinvex/general/utils/app_theme/colors.dart';
import 'package:hinvex/general/utils/enums/enums.dart';
import 'package:provider/provider.dart';

class UploadedViewScreen extends StatefulWidget {
  const UploadedViewScreen({super.key});

  @override
  State<UploadedViewScreen> createState() => _UploadedViewScreenState();
}

class _UploadedViewScreenState extends State<UploadedViewScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UploadedByAdminProvider>(context, listen: false)
          .fetchProducts();

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
      Provider.of<UploadedByAdminProvider>(context, listen: false)
          .fetchProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UploadedByAdminProvider>(builder: (context, state, _) {
        return state.isLoading && state.filteredUploadedPropertiesList.isEmpty
            ? const Center(child: CircularProgressIndicator())
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 80,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Hello Admin"),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 0),
                                    child: SizedBox(
                                      height: 40,
                                      width: 300,
                                      child: TextFormField(
                                        scrollPadding: const EdgeInsets.all(8),
                                        style: const TextStyle(fontSize: 10),
                                        controller: _searchController,
                                        onChanged: (query) {
                                          if (query.isEmpty) {
                                            state
                                              ..clearData()
                                              ..clearDoc()
                                              ..fetchProducts();
                                            return;
                                          }
                                          state
                                            ..clearData()
                                            ..clearDoc()
                                            ..searchProperty(query);
                                          // state.search(query);
                                        },
                                        decoration: const InputDecoration(
                                          hintText: "Search Here",
                                          hintStyle: TextStyle(fontSize: 10),
                                          suffixIcon: Icon(Icons.search),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15))),
                                        ),
                                      ),
                                    ),
                                  ),
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
                                  "Uploaded By Admin",
                                  style: TextStyle(
                                      color: titleTextColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    Provider.of<RoutingProvider>(context,
                                            listen: false)
                                        .uploadedByAdminRouting(
                                            UploadedByAdminRoutingEnum
                                                .uploadingWidgetScreen);
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
                                              Icons.add,
                                              color: Colors.white,
                                              size: 15,
                                            ),
                                          ),
                                          Text(
                                            "Add A New Property",
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
                          Expanded(
                            child: state.filteredUploadedPropertiesList.isEmpty
                                ? const Center(
                                    child: Text("No Property found"),
                                  )
                                : ListView.builder(
                                    controller: _scrollController,
                                    physics: const BouncingScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    itemCount: state
                                        .filteredUploadedPropertiesList.length,
                                    itemBuilder: (context, index) {
                                      log("UPLOADED PROPERTIERS LENGTH:::::::::::::::::${state.filteredUploadedPropertiesList.length}");
                                      return Stack(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                      color: Colors.grey)),
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4.0),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          child: SizedBox(
                                                            height: 150,
                                                            width: 150,
                                                            child:
                                                                Image.network(
                                                              state
                                                                      .filteredUploadedPropertiesList[
                                                                          index]
                                                                      .propertyImage!
                                                                      .isNotEmpty
                                                                  ? state
                                                                      .filteredUploadedPropertiesList[
                                                                          index]
                                                                      .propertyImage![0]
                                                                  : "https://media.istockphoto.com/id/1490047352/photo/3d-folder-with-paper-documents-question-mark-and-magnifier-search-information-in-storage-faq.jpg?s=612x612&w=0&k=20&c=g_IqmKq9zvqw0cTnAlNYb_a8oNy6zTl7ky9t9d_aa2E=",
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          8.0,
                                                                      vertical:
                                                                          4.0),
                                                              child: Text(
                                                                "\u{20B9}"
                                                                "${state.filteredUploadedPropertiesList[index].propertyPrice}",
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            1,
                                                                            40,
                                                                            95,
                                                                            1),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          8.0,
                                                                      vertical:
                                                                          4.0),
                                                              child: Text(
                                                                state
                                                                            .filteredUploadedPropertiesList[
                                                                                index]
                                                                            .propertyTitle!
                                                                            .length >
                                                                        50
                                                                    ? '${state.filteredUploadedPropertiesList[index].propertyTitle!.substring(0, 50)}...'
                                                                    : state
                                                                        .filteredUploadedPropertiesList[
                                                                            index]
                                                                        .propertyTitle!,
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            15),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          8.0,
                                                                      vertical:
                                                                          4.0),
                                                              child: Text(
                                                                state
                                                                            .filteredUploadedPropertiesList[
                                                                                index]
                                                                            .propertyDetils!
                                                                            .length >
                                                                        50
                                                                    ? '${state.filteredUploadedPropertiesList[index].propertyDetils!.substring(0, 50)}...'
                                                                    : state
                                                                        .filteredUploadedPropertiesList[
                                                                            index]
                                                                        .propertyDetils!,
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            15),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          8.0,
                                                                      vertical:
                                                                          4.0),
                                                              child: Text(
                                                                "${state.filteredUploadedPropertiesList[index].propertyLocation!.localArea},${state.filteredUploadedPropertiesList[index].propertyLocation!.district}",
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            15),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          8.0,
                                                                      vertical:
                                                                          4.0),
                                                              child: Text(
                                                                "Category: ${state.filteredUploadedPropertiesList[index].getSelectedCategoryString}",
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            15),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          8.0,
                                                                      vertical:
                                                                          4.0),
                                                              child: Text(
                                                                "Type: ${state.filteredUploadedPropertiesList[index].getSelectedTypeString}",
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            15),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(18.0),
                                                            child: InkWell(
                                                              onTap: () {
                                                                state.propertyDetails(
                                                                    userProductDetailsModel:
                                                                        state.filteredUploadedPropertiesList[
                                                                            index]);

                                                                Provider.of<RoutingProvider>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .uploadedByAdminRouting(
                                                                        UploadedByAdminRoutingEnum
                                                                            .uploadedDetailsScreen);
                                                              },
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              4),
                                                                  color:
                                                                      titleTextColor,
                                                                ),
                                                                child:
                                                                    const Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              10.0),
                                                                  child: Text(
                                                                    "View Info",
                                                                    style:
                                                                        TextStyle(
                                                                      color:
                                                                          buttonTextColor,
                                                                      fontSize:
                                                                          10,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  )),
                                            ),
                                          ),
                                          Positioned(
                                              top: 0,
                                              right: 0,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: PopupMenuButton(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  splashRadius: 20,
                                                  itemBuilder: (context) {
                                                    return [
                                                      PopupMenuItem(
                                                        height: 30,
                                                        onTap: () {
                                                          state.propertyDetails(
                                                              userProductDetailsModel:
                                                                  state.filteredUploadedPropertiesList[
                                                                      index]);

                                                          Provider.of<RoutingProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .uploadedByAdminRouting(
                                                                  UploadedByAdminRoutingEnum
                                                                      .editUploadedWidgetScreen);
                                                        },
                                                        child:
                                                            const Text("Edit"),
                                                      ),
                                                      PopupMenuItem(
                                                        height: 30,
                                                        onTap: () {
                                                          showDeletePopup(state
                                                              .filteredUploadedPropertiesList[
                                                                  index]
                                                              .id
                                                              .toString());
                                                        },
                                                        child: const Text(
                                                            "Delete"),
                                                      ),
                                                    ];
                                                  },
                                                ),
                                              ))
                                        ],
                                      );
                                    }),
                          ),
                          if (state.isLoading)
                            const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(child: CircularProgressIndicator()),
                            )
                        ],
                      ),
                    ),
                  ],
                ),
              );
      }),
    );
  }

  Future<bool> showDeletePopup(String id) async {
    return await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text(
              'Delete Post',
              style: TextStyle(color: buttonTextColor),
            ),
            content: const Text(
              'Do you want to detele post',
              style: TextStyle(color: buttonTextColor),
            ),
            backgroundColor: titleTextColor,
            actions: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                      height: 30,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: buttonTextColor,
                      ),
                      child: const Center(
                          child: Text(
                        'No',
                        style: TextStyle(color: titleTextColor),
                      ))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: InkWell(
                  onTap: () {
                    Provider.of<UploadedByAdminProvider>(context, listen: false)
                        .deleteUploadedPosts(
                      id: id,
                      onSuccess: () {
                        Provider.of<UploadedByAdminProvider>(context,
                            listen: false)
                          ..fetchProducts()
                          ..deleteUploadedPost(id);
                        Navigator.pop(context);
                      },
                    );
                  },
                  child: Container(
                      height: 30,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: buttonTextColor,
                      ),
                      child: const Center(
                          child: Text(
                        'Yes',
                        style: TextStyle(color: titleTextColor),
                      ))),
                ),
              ),
            ],
          ),
        ) ??
        false; //if showDialouge had returned null, then return false
  }
}
