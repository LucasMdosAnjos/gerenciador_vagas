import 'package:dartz/dartz.dart';
import 'package:gerenciador_vagas/features/historico/domain/entity/movimentacao.dart';
import 'package:gerenciador_vagas/features/historico/domain/errors/errors.dart';

abstract class GetMovimentacoesRepository {
  Future<Either<GetMovimentacoesException, List<Movimentacao>>>
      getMovimentacoes();
}
