import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../entities/timing.dart';
import '../repository/home_repository.dart';

class PostAllTiming implements UsecaseWithParams<void, List<Timing>> {
  const PostAllTiming(this._repository);

  final HomeRepository _repository;

  @override
  ResultFuture<void> call(List<Timing> timings) =>
      _repository.postAllTiming(timings: timings);
}
