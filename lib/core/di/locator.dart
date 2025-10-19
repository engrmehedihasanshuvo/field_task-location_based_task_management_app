import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../data/datasources/task_local_ds.dart';
import '../../data/datasources/task_remote_ds.dart';
import '../../data/datasources/task_repository_impl.dart';
import '../../domain/repositories/task_repository.dart';
import '../location/location_service.dart';
import '../network/api_client.dart';
import '../network/connectivity_service.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {
  // Third-party
  sl.registerLazySingleton<Dio>(() => Dio(BaseOptions(
        baseUrl: 'https://api.example.com', // TODO: replace
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 20),
      )));

  // Core
  sl.registerLazySingleton<ApiClient>(() => ApiClient(sl<Dio>()));
  sl.registerLazySingleton<ConnectivityService>(() => ConnectivityService());
  sl.registerLazySingleton<LocationServiceCore>(() => LocationServiceCore());
  sl.registerLazySingleton<TaskRepository>(() => TaskRepositoryImpl(
        remote: sl<TaskRemoteDataSource>(),
        local: sl<TaskLocalDataSource>(),
        connectivity: sl<ConnectivityService>(),
      ));

  // Data sources
  final local = TaskLocalDataSource();
  await local.init();
  sl.registerLazySingleton<TaskLocalDataSource>(() => local);
  final mockRemote = TaskRemoteDataSource();
  mockRemote.fetch(); // pre-warm
  sl.registerLazySingleton<TaskRemoteDataSource>(() => mockRemote);
}
