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
      final result = await db.update(
          'vagas',
          {
            'status': StatusVaga.preeenchida.value,
            'placa_veiculo': params.placaVeiculo
          },
          where: 'id = ?',
          whereArgs: [params.vagaId]);

      print(result);

      final result2 = await db.insert('movimentacoes', {
        'placa_veiculo': params.placaVeiculo,
        'tipo': 0,
        'timestamp': DateTime.now().toIso8601String(),
        'vaga_id': params.vagaId
      });

      print(result2);

      return 200;
    } catch (e) {
      throw AddEntradaException(message: e.toString());
    }
  }
}
