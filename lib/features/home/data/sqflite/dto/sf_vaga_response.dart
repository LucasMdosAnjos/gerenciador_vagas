// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:gerenciador_vagas/features/home/domain/entities/vaga.dart';

// ignore_for_file: non_constant_identifier_names

class SfVagaResponse {
  final int id;
  final int status;
  final String? placa_veiculo;

  SfVagaResponse(
      {required this.id, required this.status, required this.placa_veiculo});

  factory SfVagaResponse.fromMap(Map<String, dynamic> map) {
    return SfVagaResponse(
      id: map['id'] as int,
      status: map['status'] as int,
      placa_veiculo:
          map['placa_veiculo'] != null ? map['placa_veiculo'] as String : null,
    );
  }

  Vaga get vaga => Vaga(
      id: id,
      statusVaga:
          StatusVaga.values.firstWhere((element) => element.value == status),
      placaVeiculo: placa_veiculo);
}
