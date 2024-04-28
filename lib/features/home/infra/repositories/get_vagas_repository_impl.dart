import 'package:dartz/dartz.dart';
import 'package:gerenciador_vagas/features/home/domain/entities/vaga.dart';
import 'package:gerenciador_vagas/features/home/domain/errors/errors.dart';
import 'package:gerenciador_vagas/features/home/domain/repositories/get_vagas_repository.dart';
import 'package:gerenciador_vagas/features/home/infra/datasources/get_vagas_datasource.dart';

class GetVagasRepositoryImpl implements GetVagasRepository {
  final GetVagasDatasource datasource;

  GetVagasRepositoryImpl(this.datasource);
  @override
  Future<Either<GetVagasException, List<Vaga>>> getVagas() async {
    try {
      return Right(await datasource.getVagas());
    } on GetVagasException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(GetVagasException(message: e.toString()));
    }
  }
}
