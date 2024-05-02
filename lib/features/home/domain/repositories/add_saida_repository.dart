// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import 'package:gerenciador_vagas/features/home/domain/errors/errors.dart';

abstract class AddSaidaRepository {
  Future<Either<AddSaidaException, int>> addSaida(ParamsAddSaida params);
}

class ParamsAddSaida {
  final int vagaId;
  final String placaVeiculo;
  final String timestamp;
  ParamsAddSaida({
    required this.vagaId,
    required this.placaVeiculo,
    required this.timestamp,
  });
}
