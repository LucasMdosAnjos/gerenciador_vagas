import 'package:gerenciador_vagas/features/home/domain/entities/vaga.dart';
import 'package:gerenciador_vagas/features/home/domain/errors/errors.dart';
import 'package:gerenciador_vagas/features/home/domain/repositories/add_saida_repository.dart';
import 'package:gerenciador_vagas/features/home/infra/datasources/add_saida_datasource.dart';
import 'package:sqflite/sqflite.dart';

class SfAddSaida implements AddSaidaDatasource {
  final Database db;

  SfAddSaida(this.db);
  @override
  Future<int> addSaida(ParamsAddSaida params) async {
    try {
      // Atualizar a entidade vagas com o status preenchido/ocupado e com a placa do veículo em questão
      await db.update(
          'vagas', {'status': StatusVaga.livre.value, 'placa_veiculo': null},
          where: 'id = ?', whereArgs: [params.vagaId]);

      // Inserir na entidade movimentacoes o historico dessa saida
      await db.insert('movimentacoes', {
        'placa_veiculo': params.placaVeiculo,
        'tipo': 0, //0 para saída
        'timestamp': params.timestamp,
        'vaga_id': params.vagaId
      });

      return 200;
    } catch (e) {
      throw AddSaidaException(message: e.toString());
    }
  }
}
