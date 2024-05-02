import 'package:dartz/dartz.dart';
import 'package:gerenciador_vagas/features/historico/domain/entity/movimentacao.dart';
import 'package:gerenciador_vagas/features/historico/domain/errors/errors.dart';
import 'package:gerenciador_vagas/features/historico/domain/repositories/get_movimentacoes_repository.dart';

abstract class IGetMovimentacoesUsecase {
  Future<Either<GetMovimentacoesException, List<Movimentacao>>> call();
}

class GetMovimentacoesUsecase implements IGetMovimentacoesUsecase {
  final GetMovimentacoesRepository repository;

  GetMovimentacoesUsecase(this.repository);
  @override
  Future<Either<GetMovimentacoesException, List<Movimentacao>>> call() async {
    return await repository.getMovimentacoes();
  }
}
