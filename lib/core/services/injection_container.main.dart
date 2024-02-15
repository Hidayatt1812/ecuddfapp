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
  final localstore = Localstore.instance;
  final sharedPreferences = await SharedPreferences.getInstance();
  sl
    ..registerFactory(
      () => HomeBloc(
        getTPSRPMLinesValue: sl(),
        getPorts: sl(),
        getTimingCell: sl(),
        getTimingFromControlUnit: sl(),
        loadRPMValue: sl(),
        loadTimingValue: sl(),
        loadTPSValue: sl(),
        postAllTiming: sl(),
        postDynamicTiming: sl(),
        saveValue: sl(),
        sendDataToECU: sl(),
        setRPMManually: sl(),
        setRPMParameter: sl(),
        setTimingManually: sl(),
        setTPSManually: sl(),
        setTPSParameter: sl(),
        switchPower: sl(),
      ),
    )
    ..registerLazySingleton(() => GetTPSRPMLinesValue(sl()))
    ..registerLazySingleton(() => GetPorts(sl()))
    ..registerLazySingleton(() => GetTimingCell(sl()))
    ..registerLazySingleton(() => GetTimingFromControlUnit(sl()))
    ..registerLazySingleton(() => LoadRPMValue(sl()))
    ..registerLazySingleton(() => LoadTimingValue(sl()))
    ..registerLazySingleton(() => LoadTPSValue(sl()))
    ..registerLazySingleton(() => PostAllTiming(sl()))
    ..registerLazySingleton(() => PostDynamicTiming(sl()))
    ..registerLazySingleton(() => SaveValue(sl()))
    ..registerLazySingleton(() => SendDataToECU(sl()))
    ..registerLazySingleton(() => SetRPMManually(sl()))
    ..registerLazySingleton(() => SetRPMParameter(sl()))
    ..registerLazySingleton(() => SetTimingManually(sl()))
    ..registerLazySingleton(() => SetTPSManually(sl()))
    ..registerLazySingleton(() => SetTPSParameter(sl()))
    ..registerLazySingleton(() => SwitchPower(sl()))
    ..registerLazySingleton<HomeRepository>(
        () => HomeRepositoryImpl(sl(), sl(), sl()))
    ..registerLazySingleton<HomeRemoteDataSource>(
      () => const HomeRemoteDataSourceImpl(),
    )
    ..registerLazySingleton<HomeLocalDataSource>(
      () => HomeLocalDataSourceImpl(
        localstore: sl(),
        sharedPreferences: sl(),
      ),
    )
    ..registerLazySingleton<HomePortDataSource>(
      () => const HomePortDataSourceImpl(),
    )
    ..registerLazySingleton(() => localstore)
    ..registerLazySingleton(() => sharedPreferences);
}

Future<void> _initSettings() async {
  sl.registerFactory(
    () => SettingsBloc(),
  );
}
