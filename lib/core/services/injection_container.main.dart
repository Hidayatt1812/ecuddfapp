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
  sl.registerFactory(
    () => HomeBloc(),
  );
}

Future<void> _initSettings() async {
  sl.registerFactory(
    () => SettingsBloc(),
  );
}
