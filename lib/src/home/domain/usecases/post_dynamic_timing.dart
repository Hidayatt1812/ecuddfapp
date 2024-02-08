import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../repository/home_repository.dart';

class PostDynamicTiming implements UsecaseWithParams<void, double> {
  const PostDynamicTiming(this._repository);

  final HomeRepository _repository;

  @override
  ResultFuture<void> call(double value) =>
      _repository.postDynamicTiming(value: value);
}
