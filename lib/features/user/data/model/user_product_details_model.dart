// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:hinvex/features/uploadedByAdmin/data/model/search_location_model/search_location_model.dart';
import 'package:hinvex/general/utils/enums/enums.dart';

class UserProductDetailsModel {
  final String? id;
  final String? userId;
  final Timestamp? createDate;
  final Timestamp? updateDate;
  final SelectedCategory? propertyCategory;
  final SelectedType? propertyType;
  final int? propertyPrice;
  // final String? propertyLink;
  List? propertyImage;
  final String? propertyTitle;
  final String? propertyDetils;
  final PlaceCell? propertyLocation;
  final int? bedRooms;
  final int? bathRooms;
  final SelectedFurnisher? furnishing;
  final ConstructionStatus? constructionStatus;
  final SelectedListedBy? listedBy;
  final int? superBuiltupAreaft;
  final int? carpetAreaft;
  final int? totalFloors;
  final int? floorNo;
  final int? carParking;
  final SelectedFacing? facing;
  final String? projectName;
  final String? description;
  final int? noOfReports;
  final String? phoneNumber;
  final String? whatsAppNumber;
  final int? plotArea;
  final int? plotLength;
  final int? plotBreadth;
  final int? washRoom;
  final int? pricePerstft;
  final int? bhk;
  final List? keywords;
  final String? bannerId;
  UserProductDetailsModel({
    this.id,
    this.userId,
    this.createDate,
    this.updateDate,
    this.propertyCategory,
    this.propertyType,
    this.propertyPrice,
    // this.propertyLink,
    this.propertyImage,
    this.propertyTitle,
    this.propertyDetils,
    this.propertyLocation,
    this.bedRooms,
    this.bathRooms,
    this.furnishing,
    this.constructionStatus,
    this.listedBy,
    this.superBuiltupAreaft,
    this.carpetAreaft,
    this.totalFloors,
    this.floorNo,
    this.carParking,
    this.facing,
    this.projectName,
    this.description,
    this.noOfReports,
    this.phoneNumber,
    this.whatsAppNumber,
    this.plotArea,
    this.plotLength,
    this.plotBreadth,
    this.washRoom,
    this.pricePerstft,
    this.bhk,
    this.keywords,
    this.bannerId,
  });
  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "createDate": createDate,
        "updateDate": updateDate,
        "propertyCategory": propertyCategory?.name,
        "propertyType": propertyType?.name,
        "propertyPrice": propertyPrice,
        // "propertyLink": propertyLink,
        "propertyImage": propertyImage,
        "propertyTitle": propertyTitle,
        "propertyDetils": propertyDetils,
        "propertyLocation": propertyLocation?.toMap(),
        "bedRooms": bedRooms,
        "bathRooms": bathRooms,
        "furnishing": furnishing?.name,
        "constructionStatus": constructionStatus?.name,
        "listedBy": listedBy?.name,
        "superBuiltupAreaft": superBuiltupAreaft,
        "carpetAreaft": carpetAreaft,
        "totalFloors": totalFloors,
        "floorNo": floorNo,
        "carParking": carParking,
        "facing": facing?.name,
        "projectName": projectName,
        "description": description,
        "noOfReports": noOfReports,
        "phoneNumber": phoneNumber,
        "whatsAppNumber": whatsAppNumber,
        "plotArea": plotArea,
        "plotLength": plotLength,
        "plotBreadth": plotBreadth,
        "washRoom": washRoom,
        "pricePerstft": pricePerstft,
        "bhk": bhk,
        "keywords": keywords,
        "bannerId": bannerId,
      };

  static UserProductDetailsModel fromSnap(
      DocumentSnapshot<Map<String, dynamic>> snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    // log("etSelectedCategory(snapshot['propertyCategory']) ${getSelectedCategoryEnum(snapshot['propertyCategory'])}");
    return UserProductDetailsModel(
      id: snap.id,
      userId: snapshot['userId'],
      createDate: snapshot['createDate'],
      updateDate: snapshot['updateDate'],
      propertyCategory: getSelectedCategoryEnum(snapshot['propertyCategory']),
      propertyType: getSelectedTypeEnum(snapshot['propertyType']),
      propertyPrice: snapshot['propertyPrice'],
      // propertyLink: snapshot['propertyLink'] ?? '',
      propertyImage: snapshot['propertyImage'],
      propertyTitle: snapshot['propertyTitle'] ?? '',
      propertyDetils: snapshot['propertyDetils'] ?? '',
      propertyLocation: PlaceCell.fromMap(snapshot['propertyLocation']),
      bedRooms: snapshot['bedRooms'],
      bathRooms: snapshot['bathRooms'],
      furnishing: getSelectedFurnisherEnum(snapshot['furnishing']),
      constructionStatus:
          getConstructionStatusEnum(snapshot['constructionStatus']),
      listedBy: getSelectedListedByEnum(snapshot['listedBy']),
      superBuiltupAreaft: snapshot['superBuiltupAreaft'],
      carpetAreaft: snapshot['carpetAreaft'],
      totalFloors: snapshot['totalFloors'],
      floorNo: snapshot['floorNo'],
      carParking: snapshot['carParking'],
      facing: getSelectedFacingEnum(snapshot['facing']),
      projectName: snapshot['projectName'] ?? '',
      description: snapshot['description'] ?? '',
      noOfReports: snapshot['noOfReports'] ?? 0,
      phoneNumber: snapshot['phoneNumber'] ?? '',
      whatsAppNumber: snapshot['whatsAppNumber'] ?? '',
      plotArea: snapshot['plotArea'],
      plotLength: snapshot['plotLength'],
      plotBreadth: snapshot['plotBreadth'],
      washRoom: snapshot['washRoom'],
      pricePerstft: snapshot['pricePerstft'] ?? 0,
      bhk: snapshot['bhk'],
      keywords: snapshot['keywords'],
      bannerId: snapshot['bannerId'],
    );
  }

  String get getbhk {
    switch (bhk) {
      case 1:
        return '1+ BHK';
      case 2:
        return '2+ BHK';
      case 3:
        return '3+ BHK';
      case 4:
        return '4+ BHK';
    }
    return '';
  }

  static ConstructionStatus? getConstructionStatus(String? value) {
    switch (value) {
      case 'New Launch':
        return ConstructionStatus.newLaunch;
      case 'Ready To Move':
        return ConstructionStatus.readyToMove;
      case 'Uder-Construction':
        return ConstructionStatus.uderConstruction;
    }

    return null;
  }

  static ConstructionStatus? getConstructionStatusEnum(String? value) {
    switch (value) {
      case 'newLaunch':
        return ConstructionStatus.newLaunch;
      case 'readyToMove':
        return ConstructionStatus.readyToMove;
      case 'uderConstruction':
        return ConstructionStatus.uderConstruction;
    }

    return null;
  }

  String get getConstructionStatusString {
    switch (constructionStatus?.name) {
      case 'newLaunch':
        return 'New Launch';
      case 'readyToMove':
        return 'Ready To Move';
      case 'uderConstruction':
        return 'Uder-Construction';
    }
    return '';
  }

  static SelectedCategory? getSelectedCategory(String? value) {
    switch (value) {
      case 'House':
        return SelectedCategory.house;
      case 'Apartments':
        return SelectedCategory.apartments;
      case 'Lands/Plots':
        return SelectedCategory.landsPlots;
      case 'Commercial':
        return SelectedCategory.commercial;
      case 'Co-Working Soace':
        return SelectedCategory.coWorkingSoace;
      case 'PG & Guest House':
        return SelectedCategory.pGGuestHouse;
    }

    return null;
  }

  static SelectedCategory? getSelectedCategoryEnum(String? vale) {
    switch (vale) {
      case 'house':
        return SelectedCategory.house;
      case 'apartments':
        return SelectedCategory.apartments;
      case 'landsPlots':
        return SelectedCategory.landsPlots;
      case 'commercial':
        return SelectedCategory.commercial;
      case 'coWorkingSoace':
        return SelectedCategory.coWorkingSoace;
      case 'pGGuestHouse':
        return SelectedCategory.pGGuestHouse;
    }
    return null;
  }

  String get getSelectedCategoryString {
    switch (propertyCategory?.name) {
      case 'house':
        return 'House';
      case 'apartments':
        return 'Apartments';
      case 'landsPlots':
        return 'Lands/Plots';
      case 'commercial':
        return 'Commercial';
      case 'coWorkingSoace':
        return 'Co-Working Soace';
      case 'pGGuestHouse':
        return 'PG & Guest House';
    }
    return '';
  }

  static SelectedType? getSelectedType(String? value) {
    switch (value) {
      case 'Sell':
        return SelectedType.sell;
      case 'Rent':
        return SelectedType.rent;
    }

    return null;
  }

  static SelectedType? getSelectedTypeEnum(String? value) {
    switch (value) {
      case 'sell':
        return SelectedType.sell;
      case 'rent':
        return SelectedType.rent;
    }

    return null;
  }

  String get getSelectedTypeString {
    switch (propertyType?.name) {
      case 'sell':
        return 'Sell';

      case 'rent':
        return 'Rent';
    }
    return '';
  }

  static SelectedFurnisher? getSelectedFurnisher(String? value) {
    switch (value) {
      case 'Furnished':
        return SelectedFurnisher.furnished;
      case 'Semi-Furnished':
        return SelectedFurnisher.semiFurnished;
      case 'Un-Furnished':
        return SelectedFurnisher.unFurnished;
    }

    return null;
  }

  static SelectedFurnisher? getSelectedFurnisherEnum(String? value) {
    switch (value) {
      case 'furnished':
        return SelectedFurnisher.furnished;
      case 'semiFurnished':
        return SelectedFurnisher.semiFurnished;
      case 'unFurnished':
        return SelectedFurnisher.unFurnished;
    }

    return null;
  }

  String get getSelectedFurnisherString {
    switch (furnishing?.name) {
      case 'furnished':
        return 'Furnished';
      case 'semiFurnished':
        return 'Semi-Furnished';
      case 'unFurnished':
        return 'Un-Furnished';
    }
    return '';
  }

  static SelectedListedBy? getSelectedListedBy(String? value) {
    switch (value) {
      case 'Builder':
        return SelectedListedBy.builder;
      case 'Dealer':
        return SelectedListedBy.dealer;
      case 'Owner':
        return SelectedListedBy.owner;
    }

    return null;
  }

  static SelectedListedBy? getSelectedListedByEnum(String? value) {
    switch (value) {
      case 'builder':
        return SelectedListedBy.builder;
      case 'dealer':
        return SelectedListedBy.dealer;
      case 'owner':
        return SelectedListedBy.owner;
    }

    return null;
  }

  String get getSelectedListedByString {
    switch (listedBy?.name) {
      case 'builder':
        return 'Builder';
      case 'dealer':
        return 'Dealer';
      case 'owner':
        return 'Owner';
    }
    return '';
  }

  static SelectedFacing? getSelectedFacing(String? value) {
    switch (value) {
      case 'East':
        return SelectedFacing.east;
      case 'North':
        return SelectedFacing.north;
      case 'West':
        return SelectedFacing.west;
      case 'South':
        return SelectedFacing.south;
      case 'North-East':
        return SelectedFacing.northEast;
      case 'North-west':
        return SelectedFacing.northwest;
      case 'South-East':
        return SelectedFacing.southEast;
      case 'South-West':
        return SelectedFacing.southWest;
    }

    return null;
  }

  static SelectedFacing? getSelectedFacingEnum(String? value) {
    switch (value) {
      case 'east':
        return SelectedFacing.east;
      case 'north':
        return SelectedFacing.north;
      case 'west':
        return SelectedFacing.west;
      case 'south':
        return SelectedFacing.south;
      case 'northEast':
        return SelectedFacing.northEast;
      case 'northwest':
        return SelectedFacing.northwest;
      case 'southEast':
        return SelectedFacing.southEast;
      case 'southWest':
        return SelectedFacing.southWest;
    }

    return null;
  }

  String get getSelectedFacingString {
    switch (facing?.name) {
      case 'east':
        return 'East';
      case 'north':
        return 'North';
      case 'west':
        return 'West';
      case 'south':
        return 'South';
      case 'northEast':
        return 'North-East';
      case 'northwest':
        return 'North-west';
      case 'southEast':
        return 'South-East';
      case 'southWest':
        return 'South-West';
    }
    return '';
  }

  UserProductDetailsModel copyWith({
    String? id,
    String? userId,
    Timestamp? createDate,
    Timestamp? updateDate,
    SelectedCategory? propertyCategory,
    SelectedType? propertyType,
    int? propertyPrice,
    // String? propertyLink,
    List? propertyImage,
    String? propertyTitle,
    String? propertyDetils,
    PlaceCell? propertyLocation,
    int? bedRooms,
    int? bathRooms,
    SelectedFurnisher? furnishing,
    ConstructionStatus? constructionStatus,
    SelectedListedBy? listedBy,
    int? superBuiltupAreaft,
    int? carpetAreaft,
    int? totalFloors,
    int? floorNo,
    int? carParking,
    SelectedFacing? facing,
    String? projectName,
    String? description,
    int? noOfReports,
    String? phoneNumber,
    String? whatsAppNumber,
    int? plotArea,
    int? plotLength,
    int? plotBreadth,
    int? washRoom,
    int? pricePerstft,
    int? bhk,
    List? keywords,
    String? bannerId,
  }) {
    return UserProductDetailsModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      propertyCategory: propertyCategory ?? this.propertyCategory,
      propertyType: propertyType ?? this.propertyType,
      propertyPrice: propertyPrice ?? this.propertyPrice,
      // propertyLink: propertyLink ?? this.propertyLink,
      propertyImage: propertyImage ?? this.propertyImage,
      propertyTitle: propertyTitle ?? this.propertyTitle,
      propertyDetils: propertyDetils ?? this.propertyDetils,
      propertyLocation: propertyLocation ?? this.propertyLocation,
      bedRooms: bedRooms ?? this.bedRooms,
      bathRooms: bathRooms ?? this.bathRooms,
      furnishing: furnishing ?? this.furnishing,
      constructionStatus: constructionStatus ?? this.constructionStatus,
      listedBy: listedBy ?? this.listedBy,
      superBuiltupAreaft: superBuiltupAreaft ?? this.superBuiltupAreaft,
      carpetAreaft: carpetAreaft ?? this.carpetAreaft,
      totalFloors: totalFloors ?? this.totalFloors,
      floorNo: floorNo ?? this.floorNo,
      carParking: carParking ?? this.carParking,
      facing: facing ?? this.facing,
      projectName: projectName ?? this.projectName,
      description: description ?? this.description,
      noOfReports: noOfReports ?? this.noOfReports,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      whatsAppNumber: whatsAppNumber ?? this.whatsAppNumber,
      plotArea: plotArea ?? this.plotArea,
      plotLength: plotLength ?? this.plotLength,
      plotBreadth: plotBreadth ?? this.plotBreadth,
      washRoom: washRoom ?? this.washRoom,
      pricePerstft: pricePerstft ?? this.pricePerstft,
      bhk: bhk ?? this.bhk,
      keywords: keywords ?? this.keywords,
      bannerId: bannerId ?? this.bannerId,
    );
  }
}
