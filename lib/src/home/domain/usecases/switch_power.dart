import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../repository/home_repository.dart';

class SwitchPower implements UsecaseWithParams<bool, bool> {
  const SwitchPower(this._repository);

  final HomeRepository _repository;

  @override
  ResultFuture<bool> call(bool status) => _repository.switchPower(
        status: status,
      );
}
