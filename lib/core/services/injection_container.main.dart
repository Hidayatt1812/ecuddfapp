part of 'injection_container.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final filePicker = FilePicker.platform;

  await _initCore(
    filePicker: filePicker,
  );
  await _initHome();
  await _initSettings();
}

Future<void> _initCore({
  required FilePicker filePicker,
}) async {
  sl.registerLazySingleton(() => filePicker);
}

Future<void> _initHome() async {
  sl
    ..registerFactory(
      () => HomeBloc(
        getDynamicRPM: sl(),
        getDynamicTPS: sl(),
        getTimingCell: sl(),
        getTimingFromControlUnit: sl(),
        postAllTiming: sl(),
        postDynamicTiming: sl(),
        saveValue: sl(),
        setRPMManually: sl(),
        setRPMParameter: sl(),
        setTimingManually: sl(),
        setTPSManually: sl(),
        setTPSParameter: sl(),
        switchPower: sl(),
      ),
    )
    ..registerLazySingleton(() => GetDynamicRPM(sl()))
    ..registerLazySingleton(() => GetDynamicTPS(sl()))
    ..registerLazySingleton(() => GetTimingCell(sl()))
    ..registerLazySingleton(() => GetTimingFromControlUnit(sl()))
    ..registerLazySingleton(() => PostAllTiming(sl()))
    ..registerLazySingleton(() => PostDynamicTiming(sl()))
    ..registerLazySingleton(() => SaveValue(sl()))
    ..registerLazySingleton(() => SetRPMManually(sl()))
    ..registerLazySingleton(() => SetRPMParameter(sl()))
    ..registerLazySingleton(() => SetTimingManually(sl()))
    ..registerLazySingleton(() => SetTPSManually(sl()))
    ..registerLazySingleton(() => SetTPSParameter(sl()))
    ..registerLazySingleton(() => SwitchPower(sl()))
    ..registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(sl()))
    ..registerLazySingleton<HomeRemoteDataSource>(
      () => const HomeRemoteDataSourceImpl(),
    );
}

Future<void> _initSettings() async {
  sl.registerFactory(
    () => SettingsBloc(),
  );
}
