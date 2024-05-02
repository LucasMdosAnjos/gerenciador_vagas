import 'package:gerenciador_vagas/features/home/domain/repositories/add_saida_repository.dart';

abstract class AddSaidaEvent {}

class AddSaida implements AddSaidaEvent {
  final ParamsAddSaida params;

  AddSaida(this.params);
}

class ResetSaida implements AddSaidaEvent {}
