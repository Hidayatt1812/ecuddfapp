import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/typedef.dart';
import '../repository/home_repository.dart';

class GetPortsValue
    implements UsecaseWithParamsStream<dynamic, GetPortsValueParams> {
  const GetPortsValue(this._repository);

  final HomeRepository _repository;

  @override
  ResultStream<dynamic> call(GetPortsValueParams params) =>
      _repository.getPortsValue(
        port: params.port,
        controllerRepo: params.controllerRepo,
        controllerDataSource: params.controllerDataSource,
      );
}

class GetPortsValueParams extends Equatable {
  const GetPortsValueParams({
    required this.port,
    required this.controllerRepo,
    required this.controllerDataSource,
  });

  GetPortsValueParams.empty()
      : port = '',
        controllerRepo = StreamController<Either<Failure, List<double>>>(),
        controllerDataSource = StreamController<dynamic>();

  final String port;
  final StreamController<Either<Failure, List<double>>> controllerRepo;
  final StreamController<dynamic> controllerDataSource;

  @override
  List<Object?> get props => [
        port,
        controllerRepo,
        controllerDataSource,
      ];
}
