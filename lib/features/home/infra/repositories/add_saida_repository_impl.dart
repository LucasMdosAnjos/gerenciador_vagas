import 'package:dartz/dartz.dart';
import 'package:gerenciador_vagas/features/home/domain/errors/errors.dart';
import 'package:gerenciador_vagas/features/home/domain/repositories/add_saida_repository.dart';
import 'package:gerenciador_vagas/features/home/infra/datasources/add_saida_datasource.dart';

class AddSaidaRepositoryImpl implements AddSaidaRepository {
  final AddSaidaDatasource datasource;

  AddSaidaRepositoryImpl(this.datasource);
  @override
  Future<Either<AddSaidaException, int>> addSaida(ParamsAddSaida params) async {
    try {
      return Right(await datasource.addSaida(params));
    } on AddSaidaException catch (e) {
      return Left(e);
    }catch(e){
      return Left(AddSaidaException(message: e.toString()));
    }
  }
}
