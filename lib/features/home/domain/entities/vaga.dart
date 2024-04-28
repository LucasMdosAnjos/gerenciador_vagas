// ignore_for_file: public_member_api_docs, sort_constructors_first
class Vaga {
  int id;
  StatusVaga statusVaga;
  String? placaVeiculo;

  Vaga({
    required this.id,
    required this.statusVaga,
    this.placaVeiculo
  });
}

enum StatusVaga {
  livre(0),
  preeenchida(1);

  final int value;

  const StatusVaga(this.value);
}
