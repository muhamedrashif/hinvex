import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hinvex/features/popular_cities/data/model/popularcities_model.dart';
import 'package:hinvex/features/popular_cities/presentation/provider/popularCities_provider.dart';
import 'package:hinvex/features/uploadedByAdmin/data/model/search_location_model/search_location_model.dart';
import 'package:hinvex/general/utils/app_theme/colors.dart';
import 'package:hinvex/general/utils/progress_indicator_widget/progress_indicator_widget.dart';
import 'package:hinvex/general/utils/snackbar/snackbar.dart';
import 'package:provider/provider.dart';

import 'widgets/delete_popular_cities_popup_widget.dart';

class PopularCiteisScreen extends StatefulWidget {
  const PopularCiteisScreen({super.key});

  @override
  State<PopularCiteisScreen> createState() => _PopularCiteisScreenState();
}

class _PopularCiteisScreenState extends State<PopularCiteisScreen> {
  final TextEditingController _searchLocationController =
      TextEditingController();
  PlaceCell? placeCell;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PopularCitiesProvider>(context, listen: false)
          .fetchPopularCities();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer<PopularCitiesProvider>(builder: (context, state, _) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
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
                        "Popular Cities",
                        style: TextStyle(
                            color: titleTextColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 220,
                            child: Row(
                              children: [
                                Text("Choose Location"),
                                Text(
                                  "*",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 463,
                            child: Column(
                              children: [
                                Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: TextFormField(
                                      controller: _searchLocationController,
                                      keyboardType: TextInputType.text,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[a-zA-Z]')),
                                      ],
                                      validator: (text) {
                                        if (text == null || text.isEmpty) {
                                          return 'Please Select Place';
                                        }
                                        return null;
                                      },
                                      onChanged: (query) {
                                        if (query.isNotEmpty) {
                                          state.getLocations(
                                              query.toLowerCase());
                                        }
                                      },
                                      decoration: const InputDecoration(
                                        suffixIcon:
                                            Icon(Icons.location_searching),
                                        suffixIconColor: Colors.blue,
                                        border: InputBorder.none,
                                        hintText: "Search Location",
                                        hintStyle: TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ),
                                state.suggestions.isNotEmpty
                                    ? SizedBox(
                                        height: 200,
                                        child: Dialog(
                                          child: ListView.builder(
                                            itemCount: state.suggestions.length,
                                            itemBuilder: (context, index) {
                                              final suggestion =
                                                  state.suggestions[index];
                                              return ListTile(
                                                title: Text(
                                                  "${suggestion.formattedAddress}",
                                                  style: const TextStyle(
                                                      fontSize: 13),
                                                ),
                                                onTap: () {
                                                  if (state.popularcitiesList
                                                          .length <
                                                      6) {
                                                    showProgress(context);

                                                    state.serchLocationByAddres(
                                                      latitude: suggestion
                                                          .geometry!
                                                          .location!
                                                          .lat
                                                          .toString(),
                                                      longitude: suggestion
                                                          .geometry!
                                                          .location!
                                                          .lng
                                                          .toString(),
                                                      onSuccess: (placecell) {
                                                        log("placeCell$placecell");
                                                        state
                                                            .uploadPopularCities(
                                                          popularCitiesModel:
                                                              PopularCitiesModel(
                                                                  placeCell:
                                                                      placecell),
                                                          onFailure: () {},
                                                          onSuccess: () {},
                                                        );
                                                        // setState(() {
                                                        //   placeCell = placecell;
                                                        // });
                                                        _searchLocationController
                                                            .clear();
                                                        state
                                                            .clearSuggestions();
                                                        state.popularcitiesList
                                                            .clear();
                                                        state
                                                            .fetchPopularCities();
                                                        Navigator.pop(context);
                                                      },
                                                      onFailure: () {
                                                        state
                                                            .clearSuggestions();
                                                        Navigator.pop(context);
                                                      },
                                                    );
                                                  } else {
                                                    _searchLocationController
                                                        .clear();
                                                    state.clearSuggestions();
                                                    showSnackBar(
                                                        "Maximum Places Added....",
                                                        context);
                                                  }
                                                },
                                              );
                                            },
                                          ),
                                        ))
                                    : Container(), // Empty container if no suggestions
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Chooses Locations",
                        style: TextStyle(
                            color: titleTextColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                    state.popularcitiesIsLoading
                        ? const Center(
                            child: SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator()))
                        : SizedBox(
                            height: 350,
                            width: 700,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: state.popularcitiesList.length >= 6
                                  ? 6
                                  : state.popularcitiesList.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 40,
                                    decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              width: 1.0, color: Colors.grey)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 170,
                                          child: Text(state
                                              .popularcitiesList[index]
                                              .placeCell!
                                              .localArea
                                              .toString()),
                                        ),
                                        SizedBox(
                                          width: 170,
                                          child: Text(
                                            state.popularcitiesList[index]
                                                .placeCell!.district,
                                          ),
                                        ),
                                        SizedBox(
                                            width: 150,
                                            child: Text(state
                                                .popularcitiesList[index]
                                                .placeCell!
                                                .state)),
                                        SizedBox(
                                            width: 150,
                                            child: Text(state
                                                .popularcitiesList[index]
                                                .placeCell!
                                                .country)),
                                        InkWell(
                                          onTap: () {
                                            // state.deletePopularCities(
                                            //     id: state
                                            //         .popularcitiesList[
                                            //             index]
                                            //         .id
                                            //         .toString(),
                                            //     onSuccess: () {
                                            //       state.popularcitiesList
                                            //           .clear();
                                            //       state
                                            //           .fetchPopularCities();
                                            //     },
                                            //     onFailure: () {});

                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (BuildContext context) {
                                                return DeletePopularCitiesConfirmationDialog(
                                                  id: state
                                                      .popularcitiesList[index]
                                                      .id
                                                      .toString(),
                                                );
                                              },
                                            );
                                          },
                                          child: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                            size: 17,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }));
  }
}
