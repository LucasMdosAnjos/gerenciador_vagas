import 'package:gerenciador_vagas/features/home/domain/entities/vaga.dart';

abstract class GetVagasDatasource{
  Future<List<Vaga>> getVagas();
}