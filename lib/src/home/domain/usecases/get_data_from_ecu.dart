import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../repository/home_repository.dart';

class GetDataFromECU implements UsecaseWithParams<List<dynamic>, dynamic> {
  const GetDataFromECU(this._repository);

  final HomeRepository _repository;

  @override
  ResultFuture<List<dynamic>> call(dynamic serialPort) =>
      _repository.getDataFromECU(
        serialPort: serialPort,
      );
}
