// ignore_for_file: directives_ordering
// ignore: depend_on_referenced_packages
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'injection.config.dart';

final GetIt sl = GetIt.I;

@InjectableInit(
  initializerName: 'init', // default init
  preferRelativeImports: true, // default true
  asExtension: false,
)
// ignore: unnecessary_await_in_return
Future<void> configureDependency() async => await init(
      sl,
      environment: Environment.prod,
    );
