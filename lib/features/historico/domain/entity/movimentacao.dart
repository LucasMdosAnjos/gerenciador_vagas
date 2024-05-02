// ignore_for_file: public_member_api_docs, sort_constructors_first
class Movimentacao {
  String placaVeiculo;
  TipoMovimentacao tipoMovimentacao;
  DateTime data;
  int vagaId;
  Movimentacao({
    required this.placaVeiculo,
    required this.tipoMovimentacao,
    required this.data,
    required this.vagaId,
  });
}

enum TipoMovimentacao {
  saida(value: 0),
  entrada(value: 1);

  final int value;

  const TipoMovimentacao({required this.value});
}
