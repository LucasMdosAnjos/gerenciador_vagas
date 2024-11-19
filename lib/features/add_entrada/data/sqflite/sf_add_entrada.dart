import 'package:gerenciador_vagas/features/add_entrada/domain/errors/errors.dart';
import 'package:gerenciador_vagas/features/add_entrada/domain/repositories/add_entrada_repository.dart';
import 'package:gerenciador_vagas/features/add_entrada/infra/datasources/add_entrada_datasource.dart';
import 'package:gerenciador_vagas/features/home/domain/entities/vaga.dart';
import 'package:sqflite/sqflite.dart';

class SfAddEntrada implements AddEntradaDatasource {
  final Database db;

  SfAddEntrada(this.db);
  @override
  Future<int> addEntrada(ParamsAddEntrada params) async {
    try {
      // Atualizar a entidade vagas com o status preenchido/ocupado e com a placa do veículo em questão
      await db.update(
          'vagas',
          {
            'status': StatusVaga.preenchida.value,
            'placa_veiculo': params.placaVeiculo
          },
          where: 'id = ?',
          whereArgs: [params.vagaId]);

      // Inserir na entidade movimentacoes o historico dessa entrada
      await db.insert('movimentacoes', {
        'placa_veiculo': params.placaVeiculo,
        'tipo': 1, //1 para entrada
        'timestamp': params.timestamp,
        'vaga_id': params.vagaId
      });

      return 200;
    } catch (e) {
      throw AddEntradaException(message: e.toString());
    }
  }
}
