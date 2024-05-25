import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hinvex/features/home/presantation/provider/routing_provider.dart';
import 'package:hinvex/features/properties/presentation/provider/properties_provider.dart';
import 'package:hinvex/features/user/data/model/user_product_details_model.dart';
import 'package:hinvex/general/utils/app_theme/colors.dart';
import 'package:hinvex/general/utils/enums/enums.dart';
import 'package:hinvex/general/widgets/custom_network_image._widget.dart';
import 'package:provider/provider.dart';

class PropertiesScreen extends StatefulWidget {
  const PropertiesScreen({super.key});

  @override
  State<PropertiesScreen> createState() => _PropertiesScreenState();
}

class _PropertiesScreenState extends State<PropertiesScreen> {
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PropertiesProvider>().init();
    });
    super.initState();
  }

  String _selectedMenuItem = 'All';

  List<UserProductDetailsModel> _filterProperties() {
    if (_selectedMenuItem == 'All') {
      return Provider.of<PropertiesProvider>(context, listen: false)
          .fetchPropertiesList;
    } else {
      return Provider.of<PropertiesProvider>(context, listen: false)
          .fetchPropertiesList
          .where((property) =>
              property.getSelectedCategoryString.toLowerCase() ==
              _selectedMenuItem.toLowerCase())
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PropertiesProvider>(builder: (context, state, _) {
        return SingleChildScrollView(
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      state.clearDoc();
                                      state.fetchPropertiesList.clear();
                                      state.fetchProducts();
                                    }
                                    if (query.isNotEmpty) {
                                      state.onSearchChanged(query);
                                    }
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
                            "Properties",
                            style: TextStyle(
                                color: titleTextColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: PopupMenuButton<String>(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            splashRadius: 10,
                            initialValue: _selectedMenuItem,
                            onSelected: (value) {
                              setState(() {
                                _selectedMenuItem = value;
                              });
                            },
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<String>>[
                              const PopupMenuItem<String>(
                                value: 'All',
                                child:
                                    Text('All', style: TextStyle(fontSize: 10)),
                              ),
                              const PopupMenuItem<String>(
                                value: 'House',
                                child: Text('House',
                                    style: TextStyle(fontSize: 10)),
                              ),
                              const PopupMenuItem<String>(
                                value: 'Apartments',
                                child: Text('Apartments',
                                    style: TextStyle(fontSize: 10)),
                              ),
                              const PopupMenuItem<String>(
                                value: 'Lands/Plots',
                                child: Text('Lands/Plots',
                                    style: TextStyle(fontSize: 10)),
                              ),
                              const PopupMenuItem<String>(
                                value: 'Commercial',
                                child: Text('Commercial',
                                    style: TextStyle(fontSize: 10)),
                              ),
                              const PopupMenuItem<String>(
                                value: 'Co-Working Space',
                                child: Text('Co-Working Space',
                                    style: TextStyle(fontSize: 10)),
                              ),
                              const PopupMenuItem<String>(
                                value: 'PG & Guest House',
                                child: Text('PG & Guest House',
                                    style: TextStyle(fontSize: 10)),
                              ),
                            ],
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: buttonColor,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(right: 16.0),
                                      child: Icon(
                                        Icons.filter_alt,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 16.0),
                                      child: Text(
                                        _selectedMenuItem.isEmpty
                                            ? "All"
                                            : _selectedMenuItem,
                                        style: const TextStyle(
                                          color: buttonTextColor,
                                          fontSize: 10,
                                        ),
                                      ),
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
                      child: state.fetchPropertiesLoading &&
                              _filterProperties().isEmpty
                          ? const Center(
                              child: CupertinoActivityIndicator(
                                color: primaryColor,
                              ),
                            )
                          : _filterProperties().isEmpty
                              ? const Center(
                                  child: Text(
                                    "No Property Available",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                )
                              : ListView.builder(
                                  controller: state.scrollController,
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemCount: _filterProperties().length,
                                  itemBuilder: (context, index) {
                                    log("PROPERTIES LENGTH::::::::::::${_filterProperties().length.toString()}");

                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border:
                                                Border.all(color: Colors.grey)),
                                        child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: CustomNetworkImageWidget(
                                                      imageUrl:
                                                          _filterProperties()[
                                                                  index]
                                                              .propertyImage![0],
                                                      width: 150,
                                                      height: 150),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 8.0,
                                                                vertical: 4.0),
                                                        child: Text(
                                                          "\u{20B9}"
                                                          "${_filterProperties()[index].propertyPrice}",
                                                          style: const TextStyle(
                                                              fontSize: 20,
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
                                                                horizontal: 8.0,
                                                                vertical: 4.0),
                                                        child: Text(
                                                          _filterProperties()[
                                                                          index]
                                                                      .propertyTitle!
                                                                      .length >
                                                                  50
                                                              ? '${_filterProperties()[index].propertyTitle!.substring(0, 50)}...'
                                                              : _filterProperties()[
                                                                      index]
                                                                  .propertyTitle!,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 15),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 8.0,
                                                                vertical: 4.0),
                                                        child: Text(
                                                          _filterProperties()[
                                                                          index]
                                                                      .propertyDetils!
                                                                      .length >
                                                                  50
                                                              ? '${_filterProperties()[index].propertyDetils!.substring(0, 50)}...'
                                                              : _filterProperties()[
                                                                      index]
                                                                  .propertyDetils!,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 15),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 8.0,
                                                                vertical: 4.0),
                                                        child: Text(
                                                          _filterProperties()[
                                                                  index]
                                                              .propertyLocation!
                                                              .localArea
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 15),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 8.0,
                                                                vertical: 4.0),
                                                        child: Text(
                                                          "Category: ${_filterProperties()[index].getSelectedCategoryString}",
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 15),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 8.0,
                                                                vertical: 4.0),
                                                        child: Text(
                                                          "Type: ${_filterProperties()[index].getSelectedTypeString}",
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 15),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              18.0),
                                                      child: InkWell(
                                                        onTap: () {
                                                          state.propertyDetails(
                                                              userProductDetailsModel:
                                                                  _filterProperties()[
                                                                      index]);
                                                          state.fetchUser(
                                                              userId:
                                                                  _filterProperties()[
                                                                          index]
                                                                      .userId!
                                                              //         ==
                                                              //     "owner"
                                                              // ?
                                                              // :  _filterProperties()[
                                                              //         index]
                                                              //     .userId!
                                                              );
                                                          Provider.of<RoutingProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .propertiesRouting(
                                                                  PropertiesRoutingEnum
                                                                      .propertiesDetailWidget);
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
                                                          child: const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10.0),
                                                            child: Text(
                                                              "View Info",
                                                              style: TextStyle(
                                                                color:
                                                                    buttonTextColor,
                                                                fontSize: 10,
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
                                    );
                                  }),
                    ),
                    if (state.fetchPropertiesLoading &&
                        _filterProperties().isNotEmpty)
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                          child: CupertinoActivityIndicator(
                            color: primaryColor,
                          ),
                        ),
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
}
