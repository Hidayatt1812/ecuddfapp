import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../entities/timing.dart';
import '../repository/home_repository.dart';

class GetTimingFromControlUnit implements UsecaseWithoutParams<List<Timing>> {
  const GetTimingFromControlUnit(this._repository);

  final HomeRepository _repository;

  @override
  ResultFuture<List<Timing>> call() => _repository.getTimingFromControlUnit();
}
