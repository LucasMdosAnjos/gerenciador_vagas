// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:gerenciador_vagas/features/historico/domain/entity/movimentacao.dart';

abstract class GetMovimentacoesState {}

class GetMovimentacoesInitialState implements GetMovimentacoesState {}

class GetMovimentacoesLoadingState implements GetMovimentacoesState {}

class GetMovimentacoesErrorState implements GetMovimentacoesState {
  String message;
  GetMovimentacoesErrorState({
    required this.message,
  });
}

class GetMovimentacoesSuccessState implements GetMovimentacoesState {
  final List<Movimentacao> movimentacoes;

  GetMovimentacoesSuccessState({required this.movimentacoes});
}
