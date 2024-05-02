import 'package:gerenciador_vagas/features/historico/data/sqflite/dto/sf_movimentacao_response.dart';
import 'package:gerenciador_vagas/features/historico/domain/entity/movimentacao.dart';
import 'package:gerenciador_vagas/features/historico/domain/errors/errors.dart';
import 'package:gerenciador_vagas/features/historico/infra/datasources/get_movimentacoes_datasource.dart';
import 'package:sqflite/sqflite.dart';

class SfGetMovimentacoes implements GetMovimentacoesDatasource {
  final Database db;

  SfGetMovimentacoes(this.db);
  @override
  Future<List<Movimentacao>> getMovimentacoes() async {
    try {
  final result = await db.query('movimentacoes');
      final movimentacoesResponse = result.map(SfMovimentacaoResponse.fromMap).toList();
      return movimentacoesResponse.map((e) => e.movimentacao).toList();
    } catch (e) {
      throw GetMovimentacoesException(message: "Erro ao puxar as movimentações");
    }
  }
}
