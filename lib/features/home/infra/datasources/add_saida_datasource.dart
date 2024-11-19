import 'package:gerenciador_vagas/features/home/domain/repositories/add_saida_repository.dart';

abstract class AddSaidaDatasource{
  Future<int> addSaida(ParamsAddSaida params);
}