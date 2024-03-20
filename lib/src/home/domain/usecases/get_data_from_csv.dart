import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../repository/home_repository.dart';

class GetDataFromCSV implements UsecaseWithoutParams<List<dynamic>> {
  const GetDataFromCSV(this._repository);

  final HomeRepository _repository;

  @override
  ResultFuture<List<dynamic>> call() => _repository.getDataFromCSV();
}
