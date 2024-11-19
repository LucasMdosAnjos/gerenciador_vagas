// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:gerenciador_vagas/features/home/domain/entities/vaga.dart';

abstract class GetVagasState {}

class GetVagasInitialState implements GetVagasState{}

class GetVagasLoadingState implements GetVagasState {}

class GetVagasErrorState implements GetVagasState {
  String message;
  GetVagasErrorState({
    required this.message,
  });
}

class GetVagasSuccessState implements GetVagasState {
  final List<Vaga> vagas;

  GetVagasSuccessState({required this.vagas});
}
