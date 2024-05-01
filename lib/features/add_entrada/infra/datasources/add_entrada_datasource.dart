import 'package:gerenciador_vagas/features/add_entrada/domain/repositories/add_entrada_repository.dart';

abstract class AddEntradaDatasource {
  Future<int> addEntrada(ParamsAddEntrada params);
}
