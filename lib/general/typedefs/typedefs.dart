import 'package:dartz/dartz.dart';
import 'package:hinvex/general/failures/failures.dart';

typedef FutureResult<T> = Future<Either<MainFailure, T>>;
