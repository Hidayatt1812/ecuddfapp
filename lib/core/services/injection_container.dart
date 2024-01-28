import 'package:ddfapp/src/settings/presentation/bloc/settings_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get_it/get_it.dart';

import '../../src/home/data/datasources/home_remote_data_source.dart';
import '../../src/home/data/repositories/home_repository_impl.dart';
import '../../src/home/domain/repository/home_repository.dart';
import '../../src/home/domain/usecases/get_dynamic_rpm.dart';
import '../../src/home/domain/usecases/get_dynamic_tps.dart';
import '../../src/home/domain/usecases/get_timing_cell.dart';
import '../../src/home/domain/usecases/get_timing_from_control_unit.dart';
import '../../src/home/domain/usecases/post_all_timing.dart';
import '../../src/home/domain/usecases/post_dynamic_timing.dart';
import '../../src/home/domain/usecases/save_value.dart';
import '../../src/home/domain/usecases/set_rpm_manually.dart';
import '../../src/home/domain/usecases/set_rpm_parameter.dart';
import '../../src/home/domain/usecases/set_timing_manually.dart';
import '../../src/home/domain/usecases/set_tps_manually.dart';
import '../../src/home/domain/usecases/set_tps_paramater.dart';
import '../../src/home/domain/usecases/switch_power.dart';
import '../../src/home/presentation/bloc/home_bloc.dart';

part 'injection_container.main.dart';
