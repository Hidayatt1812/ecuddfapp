import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../entities/rpm.dart';
import '../repository/home_repository.dart';

class GetDynamicRPM implements UsecaseWithoutParams<RPM> {
  const GetDynamicRPM(this._repository);

  final HomeRepository _repository;

  @override
  ResultFuture<RPM> call() => _repository.getDynamicRPM();
}
