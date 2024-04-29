import 'package:flutter/material.dart';
import 'package:hinvex/general/utils/enums/enums.dart';

class RoutingProvider with ChangeNotifier {
  UserRoutingEnum userRoutingEnum = UserRoutingEnum.userScreen;

  PropertiesRoutingEnum propertiesRoutingEnum =
      PropertiesRoutingEnum.propertiesScreen;

  UploadedByAdminRoutingEnum uploadedByAdminEnum =
      UploadedByAdminRoutingEnum.uploadedViewScreen;

  ReportsAndIssuesEnum reportsAndIssuesEnum =
      ReportsAndIssuesEnum.reportsAndIssuesScreen;

// USER ROUTING

  void userRouting(UserRoutingEnum value) {
    userRoutingEnum = value;
    notifyListeners();
  }

// PROPERTIES ROUTING

  void propertiesRouting(PropertiesRoutingEnum value) {
    propertiesRoutingEnum = value;
    notifyListeners();
  }

  // UPLOADED BY ADMIN

  void uploadedByAdminRouting(UploadedByAdminRoutingEnum value) {
    uploadedByAdminEnum = value;
    notifyListeners();
  }

  // REPORTS AND ISSUES

  void reportsAndIssuesRouting(ReportsAndIssuesEnum value) {
    reportsAndIssuesEnum = value;
    notifyListeners();
  }
}
