import 'package:dartz/dartz.dart';
import 'package:gerenciador_vagas/helpers/utils.dart';

import '../errors/errors.dart';
import '../repositories/add_entrada_repository.dart';

abstract class IAddEntradaUsecase{
  Future<Either<AddEntradaException,int>> call(ParamsAddEntrada params);
}

class AddEntradaUsecase implements IAddEntradaUsecase{
  final AddEntradaRepository repository;

  AddEntradaUsecase(this.repository);
  @override
  Future<Either<AddEntradaException, int>> call(ParamsAddEntrada params) async{
    int vagaId = params.vagaId;
    if(vagaId <= 0){
      return Left(AddEntradaException(message: "Id da Vaga inválida"));
    }

    String placaVeiculo = params.placaVeiculo;
    if(!Utils.verificaPlaca(placaVeiculo)){
      return Left(AddEntradaException(message: "Placa do veículo é inválida"));
    }

    String timestamp = params.timestamp;

    if(!Utils.verificaTimestampISO8601(timestamp)) {
      return Left(AddEntradaException(message: "Data mal formatada"));
    }

    return await repository.addEntrada(params);
    }
}