import 'package:gerenciador_vagas/features/home/data/sqflite/dto/sf_vaga_response.dart';
import 'package:gerenciador_vagas/features/home/domain/entities/vaga.dart';
import 'package:gerenciador_vagas/features/home/domain/errors/errors.dart';
import 'package:gerenciador_vagas/features/home/infra/datasources/get_vagas_datasource.dart';
import 'package:sqflite/sqflite.dart';

class SfGetVagas implements GetVagasDatasource {
  final Database db;

  SfGetVagas(this.db);
  @override
  Future<List<Vaga>> getVagas() async {
    try {
      final result = await db.query('vagas');
      final vagasResponse = result.map(SfVagaResponse.fromMap).toList();
      return vagasResponse.map((e) => e.vaga).toList();
    } catch (e) {
      throw GetVagasException(message: "Erro ao puxar vagas");
    }
  }
}
