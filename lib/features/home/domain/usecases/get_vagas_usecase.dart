import 'package:dartz/dartz.dart';
import 'package:gerenciador_vagas/features/home/domain/entities/vaga.dart';
import 'package:gerenciador_vagas/features/home/domain/errors/errors.dart';
import 'package:gerenciador_vagas/features/home/domain/repositories/get_vagas_repository.dart';

abstract class IGetVagasUsecase {
  Future<Either<GetVagasException, List<Vaga>>> call();
}

class GetVagasUsecase implements IGetVagasUsecase {
  final GetVagasRepository repository;

  GetVagasUsecase(this.repository);
  @override
  Future<Either<GetVagasException, List<Vaga>>> call() async {
    return await repository.getVagas();
  }
}
