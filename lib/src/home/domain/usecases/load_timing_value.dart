import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../entities/timing.dart';
import '../repository/home_repository.dart';

class LoadTimingValue implements UsecaseWithoutParams<List<Timing>> {
  const LoadTimingValue(this._repository);

  final HomeRepository _repository;

  @override
  ResultFuture<List<Timing>> call() => _repository.loadTimingValue();
}
