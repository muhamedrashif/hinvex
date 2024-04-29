import 'package:flutter/material.dart';
import 'package:hinvex/features/banner/presentation/provider/banner_provider.dart';
import 'package:hinvex/features/home/presantation/provider/routing_provider.dart';
import 'package:hinvex/features/notification/data/i_notification_facade.dart';
import 'package:hinvex/features/notification/presentation/provider/notification_provider.dart';
import 'package:hinvex/features/popular_cities/presentation/provider/popularCities_provider.dart';
import 'package:hinvex/features/properties/data/i_properties_facade.dart';
import 'package:hinvex/features/properties/presentation/provider/properties_provider.dart';
import 'package:hinvex/features/reports_and_issues/data/i_reports_and_issues_facade.dart';
import 'package:hinvex/features/reports_and_issues/presentation/provider/report_and_issue_provider.dart';
import 'package:hinvex/features/uploadedByAdmin/data/i_uploadedByAdmin_facade.dart';
import 'package:hinvex/features/uploadedByAdmin/presentation/provider/uploadedByAdmin_provider.dart';
import 'package:hinvex/features/user/data/i_user_facade.dart';
import 'package:hinvex/features/user/presentation/provider/user_provider.dart';
import 'package:hinvex/general/utils/app_theme/colors.dart';
import 'package:provider/provider.dart';
import 'features/banner/data/i_banner_facade.dart';
import 'features/popular_cities/data/i_popularCities_facade.dart';
import 'general/di/injection.dart';
import 'features/home/presantation/view/home_screen.dart';

Future<void> main() async {
  await configureDependency();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => BannerProvider(iBannerFacade: sl<IBannerFacade>())),
        ChangeNotifierProvider(
            create: (_) => NotificationProvider(
                iNotificationFacade: sl<INotificationFacade>())),
        ChangeNotifierProvider(create: (_) => RoutingProvider()),
        ChangeNotifierProvider(
            create: (_) => UserProvider(iUserFacade: sl<IUserFacade>())),
        ChangeNotifierProvider(
            create: (_) =>
                PropertiesProvider(iPropertiesFacade: sl<IPropertiesFacade>())),
        ChangeNotifierProvider(
            create: (_) => UploadedByAdminProvider(
                iUploadedByAdminFacade: sl<IUploadedByAdminFacade>())),
        ChangeNotifierProvider(
            create: (_) => ReportsAndIssuesProvider(
                iReportsAndIssuesFacade: sl<IReportsAndIssuesFacade>())),
        ChangeNotifierProvider(
            create: (_) => PopularCitiesProvider(
                iPopularCitiesFacade: sl<IPopularCitiesFacade>())),
      ],
      child: MaterialApp(
        title: 'Hinvex',
        theme: ThemeData(primarySwatch: primaryColor, useMaterial3: false),
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
