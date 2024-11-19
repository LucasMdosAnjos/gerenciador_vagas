import 'package:dartz/dartz.dart';
import 'package:gerenciador_vagas/features/add_entrada/domain/errors/errors.dart';

abstract class AddEntradaRepository{
  Future<Either<AddEntradaException,int>> addEntrada(ParamsAddEntrada params);
}

class ParamsAddEntrada{
  final int vagaId;
  final String placaVeiculo;
  final String timestamp;

  ParamsAddEntrada({required this.vagaId, required this.placaVeiculo, required this.timestamp});
}
