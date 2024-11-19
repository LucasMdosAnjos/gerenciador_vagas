import 'package:gerenciador_vagas/features/historico/domain/entity/movimentacao.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: non_constant_identifier_names

class SfMovimentacaoResponse {
  int id;
  String placa_veiculo;
  int tipo;
  String timestamp;
  int vaga_id;
  SfMovimentacaoResponse({
    required this.id,
    required this.placa_veiculo,
    required this.tipo,
    required this.timestamp,
    required this.vaga_id,
  });

  factory SfMovimentacaoResponse.fromMap(Map<String, dynamic> map) {
    return SfMovimentacaoResponse(
      id: map['id'] as int,
      placa_veiculo: map['placa_veiculo'] as String,
      tipo: map['tipo'] as int,
      timestamp: map['timestamp'] as String,
      vaga_id: map['vaga_id'] as int,
    );
  }

  Movimentacao get movimentacao => Movimentacao(
      placaVeiculo: placa_veiculo,
      tipoMovimentacao: TipoMovimentacao.values
          .firstWhere((element) => element.value == tipo),
      data: DateTime.parse(timestamp),
      vagaId: vaga_id);
}
