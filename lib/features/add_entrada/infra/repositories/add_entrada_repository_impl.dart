import 'package:dartz/dartz.dart';
import 'package:gerenciador_vagas/features/add_entrada/domain/errors/errors.dart';
import 'package:gerenciador_vagas/features/add_entrada/domain/repositories/add_entrada_repository.dart';
import 'package:gerenciador_vagas/features/add_entrada/infra/datasources/add_entrada_datasource.dart';

class AddEntradaRepositoryImpl implements AddEntradaRepository {
  final AddEntradaDatasource datasource;

  AddEntradaRepositoryImpl(this.datasource);
  @override
  Future<Either<AddEntradaException, int>> addEntrada(
      ParamsAddEntrada params) async {
    try {
      return Right(await datasource.addEntrada(params));
    } on AddEntradaException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(AddEntradaException(message: e.toString()));
    }
  }
}
