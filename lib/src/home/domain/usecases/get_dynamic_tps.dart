import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../entities/tps.dart';
import '../repository/home_repository.dart';

class GetDynamicTPS implements UsecaseWithoutParams<TPS> {
  const GetDynamicTPS(this._repository);

  final HomeRepository _repository;

  @override
  ResultFuture<TPS> call() => _repository.getDynamicTPS();
}
