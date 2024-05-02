import 'package:gerenciador_vagas/features/historico/domain/entity/movimentacao.dart';

abstract class GetMovimentacoesDatasource{
  Future<List<Movimentacao>> getMovimentacoes();
}