import 'package:flutter_libserialport/flutter_libserialport.dart';

import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../repository/home_repository.dart';

class GetTPSRPMLinesValue
    implements UsecaseWithParamsStream<List<double>, SerialPortReader> {
  const GetTPSRPMLinesValue(this._repository);

  final HomeRepository _repository;

  @override
  ResultStream<List<double>> call(SerialPortReader serialPortReader) =>
      _repository.getTPSRPMLinesValue(
        serialPortReader: serialPortReader,
      );
}
