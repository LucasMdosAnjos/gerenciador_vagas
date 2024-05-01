import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  Database? _db;

  String dbName = "Gerenciador.db";

  Future<Database> get database async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDB();
    return _db!;
  }

  Future<Database> initDB() async {
    Directory docsDirectory = await getApplicationDocumentsDirectory();
    String path = join(docsDirectory.path, dbName);
    return await openDatabase(path, version: 1, onCreate: _onCreateDB);
  }

  Future<void> _onCreateDB(Database db, int version) async {
    await db.transaction((txn) async {
      await txn.execute('''
        CREATE TABLE vagas(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            status INTEGER NOT NULL DEFAULT 0, -- 0 como padrão para livre e 1 como padrão para ocupada
            placa_veiculo TEXT -- Placa do veículo atualmente na vaga, NULL se livre
        );
    ''');

      await txn.execute('''
        CREATE TABLE movimentacoes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            placa_veiculo TEXT NOT NULL, -- Placa do veículo
            tipo INTEGER NOT NULL, -- 0 para saída, 1 para entrada
            timestamp TEXT NOT NULL, -- Data e hora da movimentação, formatada como ISO 8601 string
            vaga_id INTEGER, -- ID da vaga relacionada
            FOREIGN KEY(vaga_id) REFERENCES vagas(id) -- Chave estrangeira ligando à vaga usada
        );
    ''');
      for (int i = 0; i < 9; i++) {
        await txn.insert('vagas', {'placa_veiculo': null, 'status': 0});
      }
    });
  }
}
