import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../entities/tps.dart';
import '../repository/home_repository.dart';

class LoadTPSValue implements UsecaseWithoutParams<List<TPS>> {
  const LoadTPSValue(this._repository);

  final HomeRepository _repository;

  @override
  ResultFuture<List<TPS>> call() => _repository.loadTPSValue();
}
