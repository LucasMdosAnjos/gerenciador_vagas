import 'package:dartz/dartz.dart';
import 'package:gerenciador_vagas/features/historico/domain/entity/movimentacao.dart';
import 'package:gerenciador_vagas/features/historico/domain/errors/errors.dart';
import 'package:gerenciador_vagas/features/historico/domain/repositories/get_movimentacoes_repository.dart';
import 'package:gerenciador_vagas/features/historico/infra/datasources/get_movimentacoes_datasource.dart';

class GetMovimentacoesRepositoryImpl implements GetMovimentacoesRepository {
  final GetMovimentacoesDatasource datasource;

  GetMovimentacoesRepositoryImpl(this.datasource);
  @override
  Future<Either<GetMovimentacoesException, List<Movimentacao>>>
      getMovimentacoes() async {
    try {
      return Right(await datasource.getMovimentacoes());
    } on GetMovimentacoesException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(GetMovimentacoesException(message: e.toString()));
    }
  }
}
