import 'package:dartz/dartz.dart';
import 'package:gerenciador_vagas/features/home/domain/errors/errors.dart';
import 'package:gerenciador_vagas/features/home/domain/repositories/add_saida_repository.dart';
import 'package:gerenciador_vagas/helpers/utils.dart';

abstract class IAddSaidaUsecase {
  Future<Either<AddSaidaException, int>> call(ParamsAddSaida params);
}

class AddSaidaUsecase implements IAddSaidaUsecase {
  final AddSaidaRepository repository;

  AddSaidaUsecase(this.repository);
  @override
  Future<Either<AddSaidaException, int>> call(ParamsAddSaida params) async {
    int vagaId = params.vagaId;
    if (vagaId <= 0) {
      return Left(AddSaidaException(message: "Id da Vaga inválida"));
    }

    String placaVeiculo = params.placaVeiculo;
    if (!Utils.verificaPlaca(placaVeiculo)) {
      return Left(AddSaidaException(message: "Placa do veículo é inválida"));
    }

    String timestamp = params.timestamp;

    if (!Utils.verificaTimestampISO8601(timestamp)) {
      return Left(AddSaidaException(message: "Data mal formatada"));
    }
    return await repository.addSaida(params);
  }
}
