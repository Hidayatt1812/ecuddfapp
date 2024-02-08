import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../entities/rpm.dart';
import '../repository/home_repository.dart';

class LoadRPMValue implements UsecaseWithoutParams<List<RPM>> {
  const LoadRPMValue(this._repository);

  final HomeRepository _repository;

  @override
  ResultFuture<List<RPM>> call() => _repository.loadRPMValue();
}
