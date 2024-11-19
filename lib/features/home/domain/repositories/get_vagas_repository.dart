import 'package:dartz/dartz.dart';
import 'package:gerenciador_vagas/features/home/domain/entities/vaga.dart';
import 'package:gerenciador_vagas/features/home/domain/errors/errors.dart';

abstract class GetVagasRepository {
  Future<Either<GetVagasException, List<Vaga>>> getVagas();
}
