import 'package:flutter/material.dart';
import 'package:hinvex/features/home/presantation/provider/routing_provider.dart';
import 'package:hinvex/features/uploadedByAdmin/presentation/provider/uploadedByAdmin_provider.dart';
import 'package:hinvex/general/utils/app_assets/image_constants.dart';
import 'package:hinvex/general/utils/app_theme/colors.dart';
import 'package:hinvex/general/utils/enums/enums.dart';
import 'package:provider/provider.dart';

class UploadedDetailWidget extends StatefulWidget {
  const UploadedDetailWidget({super.key});

  @override
  State<UploadedDetailWidget> createState() => _UploadedDetailWidgetState();
}

class _UploadedDetailWidgetState extends State<UploadedDetailWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SingleChildScrollView(
      child: Consumer<UploadedByAdminProvider>(builder: (context, state, _) {
        return state.fetchUserLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(
                      width: 1100,
                      child: Center(
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      state.selectedPropertiesDetails!
                                          .propertyTitle!,
                                      style: const TextStyle(
                                        color: titleTextColor,
                                      ),
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
                                                    .uploadedViewScreen);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color: backButtonColor),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 16),
                                          child: Text(
                                            "Back",
                                            style: TextStyle(
                                                color: buttonTextColor,
                                                fontSize: 10),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Posted By",
                                  style: TextStyle(
                                      color: titleTextColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Container(
                                        padding: const EdgeInsets.all(20),
                                        color: Colors.white,
                                        height: 70,
                                        width: 70,
                                        child: Transform.scale(
                                          scale: 1.5,
                                          child: Image.asset(
                                            ImageConstant.hinvexWhite,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 4.0, vertical: 2),
                                          child: Text(
                                            "Admin",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 4.0, vertical: 2),
                                          child: Text(
                                            "Indivitual",
                                            style: TextStyle(fontSize: 11),
                                          ),
                                        ),
                                        // Padding(
                                        //   padding: const EdgeInsets.symmetric(
                                        //       horizontal: 4.0, vertical: 2),
                                        //   child: Text(
                                        //     "Location; ",
                                        //     style:
                                        //         const TextStyle(fontSize: 11),
                                        //   ),
                                        // ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4.0, vertical: 2),
                                          child: Text(
                                            "Phone Number; ${state.selectedPropertiesDetails!.phoneNumber}",
                                            style:
                                                const TextStyle(fontSize: 11),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4.0, vertical: 2),
                                          child: Text(
                                            "WhatsApp Number; ${state.selectedPropertiesDetails!.whatsAppNumber}",
                                            style:
                                                const TextStyle(fontSize: 11),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "About Property",
                                  style: TextStyle(
                                      color: titleTextColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        height: 110,
                                        width: 150,
                                        child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: state
                                                .selectedPropertiesDetails!
                                                .propertyImage!
                                                .length,
                                            // itemCount: state.selectedPropertiesDetails!
                                            //             .propertyImage!.length <=
                                            //         5
                                            //     ? state.selectedPropertiesDetails!
                                            //         .propertyImage!.length
                                            //     : 5,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4.0,
                                                        vertical: 4.0),
                                                child: SizedBox(
                                                  height: 110,
                                                  width: 150,
                                                  child: Image.network(
                                                    state
                                                        .selectedPropertiesDetails!
                                                        .propertyImage![index],
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              );
                                            }),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 4.0),
                                    child: Text(
                                      "\u{20B9}"
                                      "${state.selectedPropertiesDetails!.propertyPrice}",
                                      style: const TextStyle(
                                          fontSize: 13,
                                          color: Color.fromRGBO(1, 40, 95, 1),
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 2.0),
                                    child: Text(
                                      state.selectedPropertiesDetails!
                                          .propertyTitle!,
                                      style: const TextStyle(fontSize: 11),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 2.0),
                                    child: Text(
                                      state.selectedPropertiesDetails!
                                          .propertyDetils!,
                                      style: const TextStyle(fontSize: 11),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 2.0),
                                    child: Text(
                                      "${state.selectedPropertiesDetails!.propertyLocation!.localArea},${state.selectedPropertiesDetails!.propertyLocation!.district}",
                                      style: const TextStyle(fontSize: 11),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 2.0),
                                    child: Text(
                                      "Category: ${state.selectedPropertiesDetails!.getSelectedCategoryString}",
                                      style: const TextStyle(fontSize: 11),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          //
                                          const Text(
                                            "Type:",
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey),
                                          ),
                                          //
                                          if (state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'House' ||
                                              state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'Apartments')
                                            const Text(
                                              "Bedrooms:",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey),
                                            ),
                                          //
                                          if (state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'House' ||
                                              state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'Apartments')
                                            const Text(
                                              "Bathrooms:",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey),
                                            ),
                                          //
                                          if (state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'Commercial' ||
                                              state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'Co-Working Soace')
                                            const Text(
                                              "Washrooms:",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey),
                                            ),
                                          //
                                          if (state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'House' ||
                                              state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'Apartments' ||
                                              state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'Co-Working Soace' ||
                                              state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'Commercial' ||
                                              state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'PG & Guest House')
                                            const Text(
                                              "Furnishing:",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey),
                                            ),
                                          //
                                          if (state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'House' ||
                                              state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'Apartments' ||
                                              state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'Co-Working Soace' ||
                                              state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'Commercial')
                                            const Text(
                                              "Construction Status:",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey),
                                            ),
                                          //
                                          const Text(
                                            "Listed by:",
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey),
                                          ),
                                          //
                                          if (state.selectedPropertiesDetails!
                                                  .getSelectedCategoryString ==
                                              'Lands/Plots')
                                            const Text(
                                              "Length:",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey),
                                            ),
                                          //
                                          if (state.selectedPropertiesDetails!
                                                  .getSelectedCategoryString ==
                                              'Lands/Plots')
                                            const Text(
                                              "Breadth:",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey),
                                            ),
                                          //
                                          if (state.selectedPropertiesDetails!
                                                  .getSelectedCategoryString ==
                                              'Lands/Plots')
                                            const Text(
                                              "Plot Area:",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey),
                                            ),
                                          //

                                          if (state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'House' ||
                                              state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'Apartments' ||
                                              state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'Co-Working Soace' ||
                                              state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'Commercial')
                                            const Text(
                                              "Super Builtup area (ft²):",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey),
                                            ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          //
                                          Text(
                                            state.selectedPropertiesDetails!
                                                .getSelectedTypeString,
                                            style:
                                                const TextStyle(fontSize: 13),
                                          ),
                                          //
                                          if (state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'House' ||
                                              state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'Apartments')
                                            Text(
                                              state.selectedPropertiesDetails!
                                                  .bedRooms!
                                                  .toString(),
                                              style:
                                                  const TextStyle(fontSize: 13),
                                            ),
                                          //
                                          if (state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'House' ||
                                              state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'Apartments')
                                            Text(
                                              state.selectedPropertiesDetails!
                                                  .bathRooms!
                                                  .toString(),
                                              style:
                                                  const TextStyle(fontSize: 13),
                                            ),
                                          //
                                          if (state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'Commercial' ||
                                              state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'Co-Working Soace')
                                            Text(
                                              state.selectedPropertiesDetails!
                                                  .washRoom!
                                                  .toString(),
                                              style:
                                                  const TextStyle(fontSize: 13),
                                            ),
                                          //
                                          if (state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'House' ||
                                              state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'Apartments' ||
                                              state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'Co-Working Soace' ||
                                              state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'Commercial' ||
                                              state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'PG & Guest House')
                                            Text(
                                              state.selectedPropertiesDetails!
                                                  .getSelectedFurnisherString,
                                              style:
                                                  const TextStyle(fontSize: 13),
                                            ),
                                          //
                                          if (state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'House' ||
                                              state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'Apartments' ||
                                              state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'Co-Working Soace' ||
                                              state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'Commercial')
                                            Text(
                                              state.selectedPropertiesDetails!
                                                  .getConstructionStatusString,
                                              style:
                                                  const TextStyle(fontSize: 13),
                                            ),
                                          //
                                          Text(
                                            state.selectedPropertiesDetails!
                                                .getSelectedListedByString,
                                            style:
                                                const TextStyle(fontSize: 13),
                                          ),
                                          //
                                          if (state.selectedPropertiesDetails!
                                                  .getSelectedCategoryString ==
                                              'Lands/Plots')
                                            Text(
                                              state.selectedPropertiesDetails!
                                                  .plotLength
                                                  .toString(),
                                              style:
                                                  const TextStyle(fontSize: 13),
                                            ),
                                          //
                                          if (state.selectedPropertiesDetails!
                                                  .getSelectedCategoryString ==
                                              'Lands/Plots')
                                            Text(
                                              state.selectedPropertiesDetails!
                                                  .plotBreadth
                                                  .toString(),
                                              style:
                                                  const TextStyle(fontSize: 13),
                                            ),
                                          //
                                          if (state.selectedPropertiesDetails!
                                                  .getSelectedCategoryString ==
                                              'Lands/Plots')
                                            Text(
                                              state.selectedPropertiesDetails!
                                                  .plotArea
                                                  .toString(),
                                              style:
                                                  const TextStyle(fontSize: 13),
                                            ),
                                          //
                                          if (state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'House' ||
                                              state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'Apartments' ||
                                              state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'Co-Working Soace' ||
                                              state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'Commercial')
                                            Text(
                                              state.selectedPropertiesDetails!
                                                  .superBuiltupAreaft!
                                                  .toString(),
                                              style:
                                                  const TextStyle(fontSize: 13),
                                            ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                        width:
                                            30), // Adjust spacing between columns
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          //
                                          if (state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'House' ||
                                              state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'Apartments' ||
                                              state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'Co-Working Soace' ||
                                              state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'Commercial')
                                            const Text(
                                              "Carpet Area (ft²):",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey),
                                            ),
                                          //
                                          if (state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'House' ||
                                              state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'Apartments')
                                            const Text(
                                              "Price Per sq.ft:",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey),
                                            ),
                                          //
                                          if (state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'House' ||
                                              state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'Apartments')
                                            const Text(
                                              "Total Floors:",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey),
                                            ),
                                          //
                                          if (state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'House' ||
                                              state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'Apartments')
                                            const Text(
                                              "Floors No:",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey),
                                            ),
                                          //
                                          if (state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'House' ||
                                              state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'Apartments' ||
                                              state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'Co-Working Soace' ||
                                              state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'Commercial' ||
                                              state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'PG & Guest House')
                                            const Text(
                                              "Car Parking:",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey),
                                            ),
                                          //
                                          if (state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'House' ||
                                              state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'Apartments')
                                            const Text(
                                              "BHK:",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey),
                                            ),
                                          //
                                          if (state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'House' ||
                                              state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'Apartments' ||
                                              state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'Co-Working Soace' ||
                                              state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'Commercial' ||
                                              state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'Lands/Plots')
                                            const Text(
                                              "Project Name:",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey),
                                            ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          //
                                          if (state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'House' ||
                                              state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'Apartments' ||
                                              state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'Co-Working Soace' ||
                                              state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'Commercial')
                                            Text(
                                              state.selectedPropertiesDetails!
                                                  .carpetAreaft!
                                                  .toString(),
                                              style:
                                                  const TextStyle(fontSize: 13),
                                            ),
                                          //
                                          if (state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'House' ||
                                              state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'Apartments')
                                            Text(
                                              state.selectedPropertiesDetails!
                                                  .pricePerstft!
                                                  .toString(),
                                              style:
                                                  const TextStyle(fontSize: 13),
                                            ),
                                          //
                                          if (state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'House' ||
                                              state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'Apartments')
                                            Text(
                                              state.selectedPropertiesDetails!
                                                  .totalFloors!
                                                  .toString(),
                                              style:
                                                  const TextStyle(fontSize: 13),
                                            ),
                                          //
                                          if (state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'House' ||
                                              state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'Apartments')
                                            Text(
                                              state.selectedPropertiesDetails!
                                                  .floorNo!
                                                  .toString(),
                                              style:
                                                  const TextStyle(fontSize: 13),
                                            ),
                                          //
                                          if (state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'House' ||
                                              state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'Apartments' ||
                                              state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'Co-Working Soace' ||
                                              state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'Commercial' ||
                                              state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'PG & Guest House')
                                            Text(
                                              state.selectedPropertiesDetails!
                                                  .carParking!
                                                  .toString(),
                                              style:
                                                  const TextStyle(fontSize: 13),
                                            ),
                                          //
                                          if (state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'House' ||
                                              state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'Apartments')
                                            Text(
                                              state.selectedPropertiesDetails!
                                                  .getbhk,
                                              style:
                                                  const TextStyle(fontSize: 13),
                                            ),
                                          //
                                          if (state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'House' ||
                                              state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'Apartments' ||
                                              state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'Co-Working Soace' ||
                                              state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'Commercial' ||
                                              state.selectedPropertiesDetails!
                                                      .getSelectedCategoryString ==
                                                  'Lands/Plots')
                                            Text(
                                              state.selectedPropertiesDetails!
                                                  .projectName!,
                                              style:
                                                  const TextStyle(fontSize: 13),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Description",
                                  style: TextStyle(
                                      color: titleTextColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  state.selectedPropertiesDetails!.description!,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              )
                            ]),
                      ),
                    ),
                  ],
                ),
              );
      }),
    ));
  }
}
