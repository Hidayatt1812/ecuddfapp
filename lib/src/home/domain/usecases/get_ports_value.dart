import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../repository/home_repository.dart';

class GetPortsValue implements UsecaseWithParamsStream<List<double>, String> {
  const GetPortsValue(this._repository);

  final HomeRepository _repository;

  @override
  ResultStream<List<double>> call(String port) => _repository.getPortsValue(
        port: port,
      );
}
