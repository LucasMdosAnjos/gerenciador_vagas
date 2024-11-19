import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gerenciador_vagas/features/home/domain/entities/vaga.dart';
import 'package:gerenciador_vagas/features/home/domain/errors/errors.dart';
import 'package:gerenciador_vagas/features/home/infra/datasources/get_vagas_datasource.dart';
import 'package:gerenciador_vagas/features/home/infra/repositories/get_vagas_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class GetVagasDatasourceMock extends Mock implements GetVagasDatasource {}

void main() {
  late GetVagasDatasourceMock datasource;
  late GetVagasRepositoryImpl repository;

  setUp(() {
    datasource = GetVagasDatasourceMock();
    repository = GetVagasRepositoryImpl(datasource);
  });

  group('Get Vagas Repository Impl | ', () {
    test('Deve retornar uma lista de vagas vindo do datasource', () async {
      final listVagas = [
        Vaga(id: 1, statusVaga: StatusVaga.livre),
        Vaga(id: 2, statusVaga: StatusVaga.livre),
        Vaga(id: 3, statusVaga: StatusVaga.preenchida)
      ];
      when(
            () => datasource.getVagas(),
      ).thenAnswer((invocation) async => listVagas);

      final result = await repository.getVagas();

      expect(result.isRight(), true);

      expect(result.fold(id, id), isA<List<Vaga>>());

      expect(result.fold(id, id), hasLength(3));
    });

    test('Deve retornar um erro vindo do datasource', () async {
      when(
            () => repository.getVagas(),
      ).thenThrow(GetVagasException(message: "Erro externo"));

      final result = await repository.getVagas();

      expect(result.isLeft(), true);

      expect(result.fold(id, id), isA<GetVagasException>());
    });
  });
}
