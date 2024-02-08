import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../repository/home_repository.dart';

class GetPorts implements UsecaseWithoutParams<List<String>> {
  const GetPorts(this._repository);

  final HomeRepository _repository;

  @override
  ResultFuture<List<String>> call() => _repository.getPorts();
}
