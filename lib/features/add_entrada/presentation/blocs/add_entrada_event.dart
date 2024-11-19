// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:gerenciador_vagas/features/add_entrada/domain/repositories/add_entrada_repository.dart';

abstract class AddEntradaEvent {}

class AddEntrada implements AddEntradaEvent {
  final ParamsAddEntrada params;

  AddEntrada(this.params);
}

class ResetEntrada implements AddEntradaEvent{
  
}