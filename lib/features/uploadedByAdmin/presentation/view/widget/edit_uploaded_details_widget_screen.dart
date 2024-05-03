import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hinvex/features/home/presantation/provider/routing_provider.dart';
import 'package:hinvex/features/uploadedByAdmin/data/model/search_location_model/search_location_model.dart';
import 'package:hinvex/features/uploadedByAdmin/presentation/provider/uploadedByAdmin_provider.dart';
import 'package:hinvex/features/user/data/model/user_product_details_model.dart';
import 'package:hinvex/general/utils/app_assets/image_constants.dart';
import 'package:hinvex/general/utils/app_theme/colors.dart';
import 'package:hinvex/general/utils/enums/enums.dart';
import 'package:hinvex/general/utils/progress_indicator_widget/progress_indicator_widget.dart';
import 'package:hinvex/general/utils/snackbar/snackbar.dart';
import 'package:provider/provider.dart';

import 'uploading_widget_screen.dart';

class EditUploadedWidgetScreen extends StatefulWidget {
  const EditUploadedWidgetScreen({super.key});

  @override
  State<EditUploadedWidgetScreen> createState() =>
      _EditUploadedWidgetScreenState();
}

class _EditUploadedWidgetScreenState extends State<EditUploadedWidgetScreen> {
  // final TextEditingController _locationController = TextEditingController();
  final TextEditingController _superBuilupAreaController =
      TextEditingController();
  final TextEditingController _carpetAreaController = TextEditingController();
  final TextEditingController _totalFloorsController = TextEditingController();
  final TextEditingController _floorNoController = TextEditingController();
  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _adTitleController = TextEditingController();
  final TextEditingController _describeController = TextEditingController();
  final TextEditingController _askingPriceController = TextEditingController();
  final TextEditingController _searchLocationController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _whatsappNumberController =
      TextEditingController();
  final TextEditingController _washRoomController = TextEditingController();
  final TextEditingController _plotAreaController = TextEditingController();
  final TextEditingController _plotLenthController = TextEditingController();
  final TextEditingController _plotBreadthController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _pricePerSqftController = TextEditingController();

  String userId = "owner";
  OpentreetMapModel? opentreetMapModel;
  PlaceCell? placeCell;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _superBuilupAreaController.dispose();
    _carpetAreaController.dispose();
    _totalFloorsController.dispose();
    _floorNoController.dispose();
    _projectNameController.dispose();
    _adTitleController.dispose();
    _describeController.dispose();
    _askingPriceController.dispose();
    _searchLocationController.dispose();
    _phoneNumberController.dispose();
    _whatsappNumberController.dispose();
    _washRoomController.dispose();
    _plotAreaController.dispose();
    _plotLenthController.dispose();
    _plotBreadthController.dispose();
    _descriptionController.dispose();
    _pricePerSqftController.dispose();
    super.dispose();
  }

  // CATEGORY
  String? _selectedCategory; // State to hold selected category

  final List<String> _categories = [
    'House',
    'Apartments',
    'Lands/Plots',
    'Commercial',
    'Co-Working Soace',
    'PG & Guest House'
  ];
  // TYPE
  String? _selectedType;

  final List<String> _type = [
    'Sell',
    'Rent',
  ];
  // BEDROOM
  String? _selectedBedroom;
  final List<String> _bedroom = ['1', '2', '3', '4', '+4'];
  // BATHROOM
  String? _selectedBathroom;
  final List<String> _bathroom = ['1', '2', '3', '4', '+4'];
  // FURNISHER
  String? _selectedFurnisher;
  final List<String> _furnisher = [
    'Furnished',
    'Semi-Furnished',
    'Un-Furnished'
  ];
  // CONSTRUCTION STATUS
  String? _selectedConstructionStatus;
  final List<String> _constructionStatus = [
    'New Launch',
    'Ready To Move',
    'Uder-Construction'
  ];
  // LISTED BY
  String? _selectedListedBy;
  final List<String> _listedBy = ['Owner'];
  // CAR PARKING
  String? _selectedCarParking;
  final List<String> _carParking = ['1', '2', '3', '4', '+4'];
  // // FACING
  // String? _selectedFacing;
  // final List<String> _facing = [
  //   'East',
  //   'North',
  //   'West',
  //   'South',
  //   'North-East',
  //   'North-west',
  //   'South-East',
  //   'South-West',
  // ];
  // BHK
  String? _selectedBHK;
  int? _selctedBHKValue;
  final List<Bhk> _bhkList = [
    Bhk(name: '1+ BHK', value: 1),
    Bhk(name: '2+ BHK', value: 2),
    Bhk(name: '3+ BHK', value: 3),
    Bhk(name: '4+ BHK', value: 4),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<UploadedByAdminProvider>(builder: (context, state, _) {
      return Scaffold(
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
                    Expanded(
                        child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Edit Product",
                                    style: TextStyle(
                                      color: titleTextColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      state
                                        ..imageFile.clear()
                                        ..clearData()
                                        ..clearDoc()
                                        ..fetchProducts();
                                      Provider.of<RoutingProvider>(context,
                                              listen: false)
                                          .uploadedByAdminRouting(
                                              UploadedByAdminRoutingEnum
                                                  .uploadedViewScreen);
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
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    width: 200,
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
                                    width: 450,
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: TextFormField(
                                              controller:
                                                  _searchLocationController,
                                              keyboardType: TextInputType.text,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(r'[a-zA-Z]')),
                                              ],
                                              validator: (text) {
                                                if (text == null ||
                                                    text.isEmpty) {
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
                                              decoration: InputDecoration(
                                                suffixIcon: const Icon(
                                                    Icons.location_searching),
                                                suffixIconColor: Colors.blue,
                                                border: InputBorder.none,
                                                hintText: state.selectedPropertiesDetails !=
                                                            null &&
                                                        state.selectedPropertiesDetails!
                                                                .propertyLocation !=
                                                            null
                                                    ? '${state.selectedPropertiesDetails!.propertyLocation!.localArea},${state.selectedPropertiesDetails!.propertyLocation!.district}'
                                                    : "Search Location",
                                                hintStyle: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                          ),
                                        ),
                                        state.suggestions.isNotEmpty
                                            ? SizedBox(
                                                height: 200,
                                                child: Dialog(
                                                  child: ListView.builder(
                                                    itemCount: state
                                                        .suggestions.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      final suggestion = state
                                                          .suggestions[index];
                                                      return ListTile(
                                                        title: Text(
                                                          "${suggestion.formattedAddress}",
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 13),
                                                        ),
                                                        onTap: () {
                                                          showProgress(context);
                                                          _searchLocationController
                                                                  .text =
                                                              suggestion
                                                                  .formattedAddress
                                                                  .toString();
                                                          state
                                                              .serchLocationByAddres(
                                                            latitude: suggestion
                                                                .geometry!
                                                                .location!
                                                                .lat
                                                                .toString(),
                                                            longitude:
                                                                suggestion
                                                                    .geometry!
                                                                    .location!
                                                                    .lng
                                                                    .toString(),
                                                            onSuccess:
                                                                (placecell) {
                                                              setState(() {
                                                                placeCell =
                                                                    placecell;
                                                              });
                                                              state
                                                                  .clearSuggestions();
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            onFailure: () {
                                                              state
                                                                  .clearSuggestions();
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          );
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
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    width: 200,
                                    child: Row(
                                      children: [
                                        Text("Choose Category"),
                                        Text(
                                          "*",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 450,
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                      ),
                                      child: DropdownButtonFormField<String>(
                                        value: _selectedCategory,
                                        hint: Text(
                                          state
                                                  .selectedPropertiesDetails!
                                                  .getSelectedCategoryString
                                                  .isNotEmpty
                                              ? state.selectedPropertiesDetails!
                                                  .getSelectedCategoryString
                                              : "Select",
                                          style: const TextStyle(
                                              fontSize: 10, color: Colors.grey),
                                        ),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            _selectedCategory = newValue!;
                                          });
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please choose a category';
                                          }
                                          return null;
                                        },
                                        isExpanded: true,
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          border: InputBorder.none,
                                        ),
                                        itemHeight: 50,
                                        menuMaxHeight: 150,
                                        style: const TextStyle(fontSize: 13),
                                        items:
                                            _categories.map((String category) {
                                          return DropdownMenuItem<String>(
                                            value: category,
                                            child: Text(category),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // if (_selectedCategory != 'PG & Guest House')
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                      width: 200,
                                      child: Row(
                                        children: [
                                          Text("Type"),
                                          Text(
                                            "*",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ],
                                      )),
                                  SizedBox(
                                    width: 450,
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200]),
                                      child: DropdownButton<String>(
                                        value: _selectedType,
                                        hint: Text(
                                          state
                                                  .selectedPropertiesDetails!
                                                  .getSelectedTypeString
                                                  .isNotEmpty
                                              ? state.selectedPropertiesDetails!
                                                  .getSelectedTypeString
                                              : "Select",
                                          style: const TextStyle(
                                              fontSize: 10, color: Colors.grey),
                                        ),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            _selectedType = newValue!;
                                          });
                                        },
                                        isExpanded: true,
                                        underline: Container(
                                          height: 0,
                                          color: Colors.grey[200],
                                        ),
                                        itemHeight: 50,
                                        menuMaxHeight: 150,
                                        style: const TextStyle(fontSize: 13),
                                        padding: const EdgeInsets.all(8),
                                        items: _type.map((String type) {
                                          return DropdownMenuItem<String>(
                                            value: type,
                                            child: Text(type),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (_selectedCategory == 'House' ||
                                _selectedCategory == 'Apartments')
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                        width: 200,
                                        child: Row(
                                          children: [
                                            Text("Bedroom"),
                                            Text(
                                              "*",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ],
                                        )),
                                    SizedBox(
                                      width: 450,
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200]),
                                        child: DropdownButton<String>(
                                          value: _selectedBedroom,
                                          hint: Text(
                                            state.selectedPropertiesDetails!
                                                        .bedRooms !=
                                                    null
                                                ? '${state.selectedPropertiesDetails!.bedRooms}'
                                                : "Select",
                                            style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey),
                                          ),
                                          onChanged: (String? newValue) {
                                            if (newValue == null) return;
                                            setState(() {
                                              _selectedBedroom = newValue;
                                            });
                                          },
                                          isExpanded: true,
                                          underline: Container(
                                            height: 0,
                                            color: Colors.grey[200],
                                          ),
                                          itemHeight: 50,
                                          menuMaxHeight: 150,
                                          style: const TextStyle(fontSize: 13),
                                          padding: const EdgeInsets.all(8),
                                          items: _bedroom.map((String bedroom) {
                                            return DropdownMenuItem<String>(
                                              value: bedroom,
                                              child: Text(bedroom),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (_selectedCategory == 'House' ||
                                _selectedCategory == 'Apartments')
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                        width: 200,
                                        child: Row(
                                          children: [
                                            Text("Bathroom"),
                                            Text(
                                              "*",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ],
                                        )),
                                    SizedBox(
                                      width: 450,
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200]),
                                        child: DropdownButton<String>(
                                          value: _selectedBathroom,
                                          hint: Text(
                                            state.selectedPropertiesDetails!
                                                        .bathRooms !=
                                                    null
                                                ? '${state.selectedPropertiesDetails!.bathRooms}'
                                                : "Select",
                                            style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey),
                                          ),
                                          onChanged: (String? newValue) {
                                            if (newValue == null) return;
                                            setState(() {
                                              _selectedBathroom = newValue;
                                            });
                                          },
                                          isExpanded: true,
                                          underline: Container(
                                            height: 0,
                                            color: Colors.grey[200],
                                          ),
                                          itemHeight: 50,
                                          menuMaxHeight: 150,
                                          style: const TextStyle(fontSize: 13),
                                          padding: const EdgeInsets.all(8),
                                          items:
                                              _bathroom.map((String bathroom) {
                                            return DropdownMenuItem<String>(
                                              value: bathroom,
                                              child: Text(bathroom),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (_selectedCategory == 'House' ||
                                _selectedCategory == 'Apartments' ||
                                _selectedCategory == 'Commercial' ||
                                _selectedCategory == 'Co-Working Soace' ||
                                _selectedCategory == 'PG & Guest House')
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                        width: 200,
                                        child: Row(
                                          children: [
                                            Text("Furnishig"),
                                            Text(
                                              "*",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ],
                                        )),
                                    SizedBox(
                                      width: 450,
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200]),
                                        child: DropdownButton<String>(
                                          value: _selectedFurnisher,
                                          hint: Text(
                                            state
                                                    .selectedPropertiesDetails!
                                                    .getSelectedFurnisherString
                                                    .isNotEmpty
                                                ? state
                                                    .selectedPropertiesDetails!
                                                    .getSelectedFurnisherString
                                                : "Select",
                                            style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey),
                                          ),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              _selectedFurnisher = newValue!;
                                            });
                                          },
                                          isExpanded: true,
                                          underline: Container(
                                            height: 0,
                                            color: Colors.grey[200],
                                          ),
                                          itemHeight: 50,
                                          menuMaxHeight: 150,
                                          style: const TextStyle(fontSize: 13),
                                          padding: const EdgeInsets.all(8),
                                          items: _furnisher
                                              .map((String furnisher) {
                                            return DropdownMenuItem<String>(
                                              value: furnisher,
                                              child: Text(furnisher),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (_selectedCategory == 'House' ||
                                _selectedCategory == 'Apartments' ||
                                _selectedCategory == 'Co-Working Soace' ||
                                _selectedCategory == 'Commercial')
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                        width: 200,
                                        child: Row(
                                          children: [
                                            Text("Construction Status"),
                                            Text(
                                              "*",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ],
                                        )),
                                    SizedBox(
                                      width: 450,
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200]),
                                        child: DropdownButton<String>(
                                          value: _selectedConstructionStatus,
                                          hint: Text(
                                            state
                                                    .selectedPropertiesDetails!
                                                    .getConstructionStatusString
                                                    .isNotEmpty
                                                ? state
                                                    .selectedPropertiesDetails!
                                                    .getConstructionStatusString
                                                : "Select",
                                            style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey),
                                          ),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              _selectedConstructionStatus =
                                                  newValue!;
                                            });
                                          },
                                          isExpanded: true,
                                          underline: Container(
                                            height: 0,
                                            color: Colors.grey[200],
                                          ),
                                          itemHeight: 50,
                                          menuMaxHeight: 150,
                                          style: const TextStyle(fontSize: 13),
                                          padding: const EdgeInsets.all(8),
                                          items: _constructionStatus
                                              .map((String constructionStatus) {
                                            return DropdownMenuItem<String>(
                                              value: constructionStatus,
                                              child: Text(constructionStatus),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                      width: 200,
                                      child: Row(
                                        children: [
                                          Text("Listed By"),
                                          Text(
                                            "*",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ],
                                      )),
                                  SizedBox(
                                    width: 450,
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200]),
                                      child: DropdownButton<String>(
                                        value: _selectedListedBy,
                                        hint: Text(
                                          state
                                                  .selectedPropertiesDetails!
                                                  .getSelectedListedByString
                                                  .isNotEmpty
                                              ? state.selectedPropertiesDetails!
                                                  .getSelectedListedByString
                                              : "Select",
                                          style: const TextStyle(
                                              fontSize: 10, color: Colors.grey),
                                        ),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            _selectedListedBy = newValue!;
                                          });
                                        },
                                        isExpanded: true,
                                        underline: Container(
                                          height: 0,
                                          color: Colors.grey[200],
                                        ),
                                        itemHeight: 50,
                                        menuMaxHeight: 150,
                                        style: const TextStyle(fontSize: 13),
                                        padding: const EdgeInsets.all(8),
                                        items: _listedBy.map((String listed) {
                                          return DropdownMenuItem<String>(
                                            value: listed,
                                            child: Text(listed),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (_selectedCategory == 'House' ||
                                _selectedCategory == 'Apartments' ||
                                _selectedCategory == 'Co-Working Soace' ||
                                _selectedCategory == 'Commercial')
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                        width: 200,
                                        child: Row(
                                          children: [
                                            Text("Super Builup Area(ft2)"),
                                            Text(
                                              "*",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ],
                                        )),
                                    SizedBox(
                                      width: 450,
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200]),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: state
                                                          .selectedPropertiesDetails!
                                                          .superBuiltupAreaft !=
                                                      null
                                                  ? '${state.selectedPropertiesDetails!.superBuiltupAreaft}'
                                                  : "Enter Builtup Area",
                                              hintStyle: const TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey),
                                            ),
                                            keyboardType: TextInputType.number,
                                            controller:
                                                _superBuilupAreaController,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (_selectedCategory == 'House' ||
                                _selectedCategory == 'Apartments')
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                        width: 200,
                                        child: Row(
                                          children: [
                                            Text("Price Per sq.ft"),
                                            Text(
                                              "*",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ],
                                        )),
                                    SizedBox(
                                      width: 450,
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200]),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: state
                                                          .selectedPropertiesDetails!
                                                          .pricePerstft !=
                                                      null
                                                  ? '${state.selectedPropertiesDetails!.pricePerstft}'
                                                  : "Enter Price Per sq.ft",
                                              hintStyle: const TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey),
                                            ),
                                            keyboardType: TextInputType.number,
                                            controller: _pricePerSqftController,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (_selectedCategory == 'House' ||
                                _selectedCategory == 'Apartments' ||
                                _selectedCategory == 'Co-Working Soace' ||
                                _selectedCategory == 'Commercial')
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                        width: 200,
                                        child: Row(
                                          children: [
                                            Text("Carpet Area"),
                                            Text(
                                              "*",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ],
                                        )),
                                    SizedBox(
                                      width: 450,
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200]),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: state
                                                          .selectedPropertiesDetails!
                                                          .carpetAreaft !=
                                                      null
                                                  ? '${state.selectedPropertiesDetails!.carpetAreaft}'
                                                  : "Enter Builtup Area",
                                              hintStyle: const TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey),
                                            ),
                                            keyboardType: TextInputType.number,
                                            controller: _carpetAreaController,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (_selectedCategory == 'Commercial' ||
                                _selectedCategory == 'Co-Working Soace')
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                        width: 200,
                                        child: Row(
                                          children: [
                                            Text("Wash Room"),
                                            Text(
                                              "*",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ],
                                        )),
                                    SizedBox(
                                      width: 450,
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200]),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: state
                                                          .selectedPropertiesDetails!
                                                          .washRoom !=
                                                      null
                                                  ? '${state.selectedPropertiesDetails!.washRoom}'
                                                  : "Eg;3",
                                              hintStyle: const TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey),
                                            ),
                                            keyboardType: TextInputType.number,
                                            controller: _washRoomController,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (_selectedCategory == 'Lands/Plots')
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                        width: 200,
                                        child: Row(
                                          children: [
                                            Text("Plot Area"),
                                            Text(
                                              "*",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ],
                                        )),
                                    SizedBox(
                                      width: 450,
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200]),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: state
                                                          .selectedPropertiesDetails!
                                                          .plotArea !=
                                                      null
                                                  ? '${state.selectedPropertiesDetails!.plotArea}'
                                                  : "Enter Plot Area",
                                              hintStyle: const TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey),
                                            ),
                                            keyboardType: TextInputType.number,
                                            controller: _plotAreaController,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (_selectedCategory == 'Lands/Plots')
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                        width: 200,
                                        child: Row(
                                          children: [
                                            Text("Length"),
                                            Text(
                                              "*",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ],
                                        )),
                                    SizedBox(
                                      width: 450,
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200]),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: state
                                                          .selectedPropertiesDetails!
                                                          .plotLength !=
                                                      null
                                                  ? '${state.selectedPropertiesDetails!.plotLength}'
                                                  : "Enter Length",
                                              hintStyle: const TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey),
                                            ),
                                            keyboardType: TextInputType.number,
                                            controller: _plotLenthController,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (_selectedCategory == 'Lands/Plots')
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                        width: 200,
                                        child: Row(
                                          children: [
                                            Text("Breadth"),
                                            Text(
                                              "*",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ],
                                        )),
                                    SizedBox(
                                      width: 450,
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200]),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: state
                                                          .selectedPropertiesDetails!
                                                          .plotBreadth !=
                                                      null
                                                  ? '${state.selectedPropertiesDetails!.plotBreadth}'
                                                  : "Enter Breadth",
                                              hintStyle: const TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey),
                                            ),
                                            keyboardType: TextInputType.number,
                                            controller: _plotBreadthController,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (_selectedCategory == 'House' ||
                                _selectedCategory == 'Apartments')
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                        width: 200,
                                        child: Row(
                                          children: [
                                            Text("Total Floors"),
                                            Text(
                                              "*",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ],
                                        )),
                                    SizedBox(
                                      width: 450,
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200]),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: state
                                                          .selectedPropertiesDetails!
                                                          .totalFloors !=
                                                      null
                                                  ? '${state.selectedPropertiesDetails!.totalFloors}'
                                                  : "Eg;2",
                                              hintStyle: const TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey),
                                            ),
                                            keyboardType: TextInputType.number,
                                            controller: _totalFloorsController,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (_selectedCategory == 'House' ||
                                _selectedCategory == 'Apartments')
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                        width: 200,
                                        child: Row(
                                          children: [
                                            Text("Floor No"),
                                            Text(
                                              "*",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ],
                                        )),
                                    SizedBox(
                                      width: 450,
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200]),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: state
                                                          .selectedPropertiesDetails!
                                                          .floorNo !=
                                                      null
                                                  ? '${state.selectedPropertiesDetails!.floorNo}'
                                                  : "Eg;2",
                                              hintStyle: const TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey),
                                            ),
                                            keyboardType: TextInputType.number,
                                            controller: _floorNoController,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (_selectedCategory == 'House' ||
                                _selectedCategory == 'Apartments' ||
                                _selectedCategory == 'Commercial' ||
                                _selectedCategory == 'Co-Working Soace' ||
                                _selectedCategory == 'PG & Guest House')
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                        width: 200,
                                        child: Row(
                                          children: [
                                            Text("Car Parking"),
                                            Text(
                                              "*",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ],
                                        )),
                                    SizedBox(
                                      width: 450,
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200]),
                                        child: DropdownButton<String>(
                                          value: _selectedCarParking,
                                          hint: Text(
                                            state.selectedPropertiesDetails!
                                                        .carParking !=
                                                    null
                                                ? '${state.selectedPropertiesDetails!.carParking}'
                                                : "Select",
                                            style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey),
                                          ),
                                          onChanged: (String? newValue) {
                                            if (newValue == null) return;
                                            setState(() {
                                              _selectedCarParking = newValue;
                                            });
                                          },
                                          isExpanded: true,
                                          underline: Container(
                                            height: 0,
                                            color: Colors.grey[200],
                                          ),
                                          itemHeight: 50,
                                          menuMaxHeight: 150,
                                          style: const TextStyle(fontSize: 13),
                                          padding: const EdgeInsets.all(8),
                                          items: _carParking
                                              .map((String carParking) {
                                            return DropdownMenuItem<String>(
                                              value: carParking,
                                              child: Text(carParking),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (_selectedCategory == 'House' ||
                                _selectedCategory == 'Apartments')
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                        width: 200,
                                        child: Row(
                                          children: [
                                            Text("BHK"),
                                            Text(
                                              "*",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ],
                                        )),
                                    SizedBox(
                                      width: 450,
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200]),
                                        child: DropdownButton<Bhk>(
                                          value: _selectedBHK != null
                                              ? _bhkList.firstWhere((element) =>
                                                  element.name == _selectedBHK)
                                              : null,
                                          hint: const Text(
                                            "Select",
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey),
                                          ),
                                          onChanged: (Bhk? newValue) {
                                            if (newValue == null) return;
                                            setState(() {
                                              _selectedBHK = newValue.name;
                                              _selctedBHKValue = newValue.value;
                                            });
                                          },
                                          isExpanded: true,
                                          underline: Container(
                                            height: 0,
                                            color: Colors.grey[200],
                                          ),
                                          itemHeight: 50,
                                          menuMaxHeight: 150,
                                          style: const TextStyle(fontSize: 13),
                                          padding: const EdgeInsets.all(8),
                                          items: _bhkList.map((bhk) {
                                            return DropdownMenuItem<Bhk>(
                                              value: bhk,
                                              child: Text(bhk.name),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            // if (_selectedCategory == 'House' ||
                            //     _selectedCategory == 'Apartments' ||
                            //     _selectedCategory == 'Lands/Plots')
                            //   Padding(
                            //     padding: const EdgeInsets.all(10.0),
                            //     child: Row(
                            //       mainAxisAlignment: MainAxisAlignment.start,
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                            //       children: [
                            //         const SizedBox(
                            //             width: 200,
                            //             child: Row(
                            //               children: [
                            //                 Text("Facing"),
                            //                 Text(
                            //                   "*",
                            //                   style:
                            //                       TextStyle(color: Colors.red),
                            //                 ),
                            //               ],
                            //             )),
                            //         SizedBox(
                            //           width: 450,
                            //           child: Container(
                            //             height: 50,
                            //             decoration: BoxDecoration(
                            //                 color: Colors.grey[200]),
                            //             child: DropdownButton<String>(
                            //               value: _selectedFacing,
                            //               hint: Text(
                            //                 state
                            //                         .selectedPropertiesDetails!
                            //                         .getSelectedFacingString
                            //                         .isNotEmpty
                            //                     ? state
                            //                         .selectedPropertiesDetails!
                            //                         .getSelectedFacingString
                            //                     : "Select",
                            //                 style: const TextStyle(
                            //                     fontSize: 10,
                            //                     color: Colors.grey),
                            //               ),
                            //               onChanged: (String? newValue) {
                            //                 setState(() {
                            //                   _selectedFacing = newValue!;
                            //                 });
                            //               },
                            //               isExpanded: true,
                            //               underline: Container(
                            //                 height: 0,
                            //                 color: Colors.grey[200],
                            //               ),
                            //               itemHeight: 50,
                            //               menuMaxHeight: 150,
                            //               style: const TextStyle(fontSize: 13),
                            //               padding: const EdgeInsets.all(8),
                            //               items: _facing.map((String facing) {
                            //                 return DropdownMenuItem<String>(
                            //                   value: facing,
                            //                   child: Text(facing),
                            //                 );
                            //               }).toList(),
                            //             ),
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            if (_selectedCategory == 'House' ||
                                _selectedCategory == 'Apartments' ||
                                _selectedCategory == 'Commercial' ||
                                _selectedCategory == 'Co-Working Soace' ||
                                _selectedCategory == 'Lands/Plots')
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                        width: 200,
                                        child: Row(
                                          children: [
                                            Text("Project Name"),
                                            Text(
                                              "*",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ],
                                        )),
                                    SizedBox(
                                      width: 450,
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200]),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: state
                                                          .selectedPropertiesDetails!
                                                          .projectName !=
                                                      null
                                                  ? '${state.selectedPropertiesDetails!.projectName}'
                                                  : "Enter Project Name",
                                              hintStyle: const TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey),
                                            ),
                                            controller: _projectNameController,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                      width: 200,
                                      child: Row(
                                        children: [
                                          Text("Ad Title"),
                                          Text(
                                            "*",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ],
                                      )),
                                  SizedBox(
                                    width: 450,
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200]),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: state
                                                        .selectedPropertiesDetails!
                                                        .propertyTitle !=
                                                    null
                                                ? '${state.selectedPropertiesDetails!.propertyTitle}'
                                                : "Mention the key feature of your property",
                                            hintStyle: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey),
                                          ),
                                          controller: _adTitleController,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                      width: 200,
                                      child: Row(
                                        children: [
                                          Text("Describe"),
                                          Text(
                                            "*",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ],
                                      )),
                                  SizedBox(
                                    width: 450,
                                    child: Container(
                                      height: 70,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200]),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: state
                                                        .selectedPropertiesDetails!
                                                        .propertyDetils !=
                                                    null
                                                ? '${state.selectedPropertiesDetails!.propertyDetils}'
                                                : "Include Condition, Features and reasons for selling",
                                            hintStyle: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey),
                                          ),
                                          maxLength: 60,
                                          controller: _describeController,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                      width: 200,
                                      child: Row(
                                        children: [
                                          Text("Asking Price"),
                                          Text(
                                            "*",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ],
                                      )),
                                  SizedBox(
                                    width: 450,
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200]),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: state
                                                        .selectedPropertiesDetails!
                                                        .propertyPrice !=
                                                    null
                                                ? '${state.selectedPropertiesDetails!.propertyPrice}'
                                                : "Enter Your Asking Price",
                                            hintStyle: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey),
                                          ),
                                          controller: _askingPriceController,
                                          validator: (text) {
                                            if (text == null || text.isEmpty) {
                                              return 'Please Enter Your Asking Price';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                      width: 200,
                                      child: Row(
                                        children: [
                                          Text("Phone Number"),
                                          Text(
                                            "*",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ],
                                      )),
                                  SizedBox(
                                    width: 450,
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200]),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: state
                                                        .selectedPropertiesDetails!
                                                        .phoneNumber !=
                                                    null
                                                ? '${state.selectedPropertiesDetails!.phoneNumber}'
                                                : "Enter Phone Number",
                                            hintStyle: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey),
                                          ),
                                          controller: _phoneNumberController,
                                          validator: (text) {
                                            if (text == null || text.isEmpty) {
                                              return 'Please Enter WhatsApp Number';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                      width: 200,
                                      child: Row(
                                        children: [
                                          Text("WhatsApp Number"),
                                          Text(
                                            "*",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ],
                                      )),
                                  SizedBox(
                                    width: 450,
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200]),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: state
                                                        .selectedPropertiesDetails!
                                                        .whatsAppNumber !=
                                                    null
                                                ? '${state.selectedPropertiesDetails!.whatsAppNumber}'
                                                : "Enter WhatsApp Number",
                                            hintStyle: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey),
                                          ),
                                          controller: _whatsappNumberController,
                                          validator: (text) {
                                            if (text == null || text.isEmpty) {
                                              return 'Please Enter WhatsApp Number';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                      width: 200,
                                      child: Row(
                                        children: [
                                          Text("Description"),
                                          Text(
                                            "*",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ],
                                      )),
                                  SizedBox(
                                    width: 450,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200]),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: TextFormField(
                                          maxLines: 6,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: state
                                                        .selectedPropertiesDetails!
                                                        .description !=
                                                    null
                                                ? '${state.selectedPropertiesDetails!.description}'
                                                : "Decription",
                                            hintStyle: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey),
                                          ),
                                          controller: _descriptionController,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                      width: 200,
                                      child: Row(
                                        children: [
                                          Text("Images"),
                                          Text(
                                            "*",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ],
                                      )),
                                  Column(
                                    children: [
                                      DottedBorder(
                                        color: Colors.grey,
                                        strokeWidth: 1,
                                        dashPattern: const [5, 5],
                                        child: InkWell(
                                          onTap: () {
                                            if (state.imageFile.length > 7) {
                                              showSnackBar(
                                                  "Maximum Allowed Images 7",
                                                  context);
                                              return;
                                            }

                                            showProgress(context);

                                            state.getImage(onSuccess: () {
                                              Navigator.pop(context);
                                            }, onFailure: () {
                                              showSnackBar(
                                                  "Maximum Allowed Images 7",
                                                  context);
                                              Navigator.pop(context);
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 148.0,
                                                vertical: 20),
                                            child: Column(
                                              children: [
                                                Image.network(
                                                  ImageConstant.imageIcon,
                                                  fit: BoxFit.cover,
                                                ),
                                                const Text(
                                                  "Pick your image from here",
                                                  style:
                                                      TextStyle(fontSize: 13),
                                                ),
                                                const Text(
                                                  "Supports: PNG, JPG, JPEG, WEBP",
                                                  style: TextStyle(
                                                      fontSize: 8,
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      state.imageFile.isEmpty
                                          ? const SizedBox()
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SizedBox(
                                                  height: 200,
                                                  width: 400,
                                                  child: ListView.builder(
                                                    itemCount:
                                                        state.imageFile.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      if (state.imageFile
                                                          .isNotEmpty) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical:
                                                                      8.0),
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                            ),
                                                            height: 70,
                                                            width: 300,
                                                            child: Column(
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                  child: Row(
                                                                    children: [
                                                                      ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                        child:
                                                                            SizedBox(
                                                                          height:
                                                                              40,
                                                                          width:
                                                                              40,
                                                                          child:
                                                                              Image.network(state.imageFile[index]),
                                                                        ),
                                                                      ),
                                                                      const Padding(
                                                                        padding:
                                                                            EdgeInsets.symmetric(horizontal: 8.0),
                                                                        child: Text(
                                                                            "image"),
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Align(
                                                                          alignment:
                                                                              Alignment.topRight,
                                                                          child:
                                                                              GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              state.removeImageAtIndex(index);
                                                                            },
                                                                            child:
                                                                                const Icon(
                                                                              Icons.close,
                                                                              size: 13,
                                                                              color: Colors.red,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                      return null;
                                                    },
                                                  )),
                                            ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 367,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  // Padding(
                                  //   padding: const EdgeInsets.symmetric(
                                  //       vertical: 18.0, horizontal: 10),
                                  //   child: InkWell(
                                  //     onTap: () {},
                                  //     child: Container(
                                  //       decoration: BoxDecoration(
                                  //           borderRadius:
                                  //               BorderRadius.circular(4),
                                  //           border:
                                  //               Border.all(color: Colors.grey)),
                                  //       child: const Padding(
                                  //         padding: EdgeInsets.symmetric(
                                  //             horizontal: 15.0, vertical: 10),
                                  //         child: Text(
                                  //           "Preview",
                                  //           style: TextStyle(
                                  //             fontSize: 10,
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 18.0, horizontal: 10),
                                    child: GestureDetector(
                                      onTap: () {
                                        log(" propertyLocation: ${state.selectedPropertiesDetails?.propertyLocation.toString()}");

                                        // String text = _superBuilupAreaController
                                        //     .text
                                        //     .trim();
                                        // int _superBuilupArea = text.isEmpty
                                        //     ? 0
                                        //     : int.tryParse(text) ?? 0;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                        int? selectedBedroom;

                                        if (_selectedBedroom != null) {
                                          if (_selectedBedroom == '+4') {
                                            selectedBedroom = 5;
                                          } else {
                                            selectedBedroom =
                                                int.parse(_selectedBedroom!);
                                          }
                                        }

                                        int? selectedBathroom;

                                        if (_selectedBathroom != null) {
                                          if (_selectedBathroom == '+4') {
                                            selectedBathroom = 5;
                                          } else {
                                            selectedBathroom =
                                                int.parse(_selectedBathroom!);
                                          }
                                        }

                                        int? selectedCarParking;

                                        if (_selectedCarParking != null) {
                                          if (_selectedCarParking == '+4') {
                                            selectedCarParking = 5;
                                          } else {
                                            selectedCarParking =
                                                int.parse(_selectedCarParking!);
                                          }
                                        }
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                        showProgress(context);
                                        state.updateUploadedPosts(
                                            userProductDetailsModel: state
                                                .selectedPropertiesDetails!
                                                .copyWith(
                                                    userId: userId,
                                                    updateDate: Timestamp.now(),
                                                    propertyCategory: UserProductDetailsModel.getSelectedCategory(
                                                        _selectedCategory ??
                                                            ''),
                                                    propertyType: UserProductDetailsModel.getSelectedType(
                                                        _selectedType ?? ''),
                                                    propertyPrice: int.tryParse(
                                                        _askingPriceController
                                                            .text),
                                                    propertyImage:
                                                        state.imageFile,
                                                    propertyTitle: _adTitleController.text.isEmpty
                                                        ? state
                                                            .selectedPropertiesDetails!
                                                            .propertyTitle
                                                        : _adTitleController
                                                            .text,
                                                    propertyDetils: _describeController.text.isEmpty
                                                        ? state
                                                            .selectedPropertiesDetails!
                                                            .propertyDetils
                                                        : _describeController.text,
                                                    propertyLocation: placeCell ?? state.selectedPropertiesDetails!.propertyLocation,
                                                    bedRooms: selectedBedroom,
                                                    bathRooms: selectedBathroom,
                                                    furnishing: UserProductDetailsModel.getSelectedFurnisher(_selectedFurnisher ?? ''),
                                                    constructionStatus: UserProductDetailsModel.getConstructionStatus(_selectedConstructionStatus ?? ''),
                                                    listedBy: UserProductDetailsModel.getSelectedListedBy(_selectedListedBy ?? ''),
                                                    superBuiltupAreaft: int.tryParse(_superBuilupAreaController.text),
                                                    carpetAreaft: int.tryParse(_carpetAreaController.text),
                                                    totalFloors: int.tryParse(_totalFloorsController.text),
                                                    floorNo: int.tryParse(_floorNoController.text),
                                                    carParking: selectedCarParking,
                                                    // facing: UserProductDetailsModel.getSelectedFacing(_selectedFacing ?? ''),
                                                    projectName: _projectNameController.text.isEmpty ? state.selectedPropertiesDetails!.projectName : _projectNameController.text,
                                                    phoneNumber: _phoneNumberController.text.isEmpty ? state.selectedPropertiesDetails!.phoneNumber : _phoneNumberController.text,
                                                    whatsAppNumber: _whatsappNumberController.text.isEmpty ? state.selectedPropertiesDetails!.whatsAppNumber : _whatsappNumberController.text,
                                                    plotArea: int.tryParse(_plotAreaController.text),
                                                    plotLength: int.tryParse(_plotLenthController.text),
                                                    plotBreadth: int.tryParse(_plotBreadthController.text),
                                                    washRoom: int.tryParse(_washRoomController.text),
                                                    noOfReports: state.selectedPropertiesDetails!.noOfReports,
                                                    description: _descriptionController.text.isEmpty ? state.selectedPropertiesDetails!.description : _descriptionController.text,
                                                    pricePerstft: int.tryParse(_pricePerSqftController.text),
                                                    bhk: _selctedBHKValue,
                                                    id: state.selectedPropertiesDetails!.id),
                                            onSuccess: () {
                                              showSnackBar(
                                                  "Edit Property Successfully",
                                                  context);

                                              // showToast(
                                              //     "Edit Property Successfully");
                                              Navigator.pop(context);
                                              state
                                                ..imageFile.clear()
                                                ..clearData()
                                                ..clearDoc()
                                                ..fetchProducts();
                                              Provider.of<RoutingProvider>(
                                                      context,
                                                      listen: false)
                                                  .uploadedByAdminRouting(
                                                      UploadedByAdminRoutingEnum
                                                          .uploadedViewScreen);
                                              // Clear text controllers

                                              // Reset selected values to default or clear them
                                            },
                                            onFailure: () {
                                              showSnackBar(
                                                  "Edit Property Failed",
                                                  context);
                                              Navigator.pop(context);
                                            });

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                      },
                                      child: state.updateLoading
                                          ? const CircularProgressIndicator()
                                          : Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                color: titleTextColor,
                                              ),
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 15.0,
                                                    vertical: 10),
                                                child: Text(
                                                  "Submit",
                                                  style: TextStyle(
                                                    color: buttonTextColor,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ))
                  ]),
            ),
          ],
        ),
      ));
    });
  }
}
