import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gerenciador_vagas/features/home/domain/entities/vaga.dart';
import 'package:gerenciador_vagas/features/home/domain/errors/errors.dart';
import 'package:gerenciador_vagas/features/home/domain/repositories/get_vagas_repository.dart';
import 'package:gerenciador_vagas/features/home/domain/usecases/get_vagas_usecase.dart';
import 'package:mocktail/mocktail.dart';

class GetVagasRepositoryMock extends Mock implements GetVagasRepository {}

void main() {
  late GetVagasRepositoryMock repository;
  late IGetVagasUsecase usecase;

  setUp(() {
    repository = GetVagasRepositoryMock();
    usecase = GetVagasUsecase(repository);
  });

  group('Get Vagas Usecase | ', () {
    test('Deve retornar uma lista de vagas vindo do repository', () async {
      final listVagas = [
        Vaga(id: 1, statusVaga: StatusVaga.livre),
        Vaga(id: 2, statusVaga: StatusVaga.livre),
        Vaga(id: 3, statusVaga: StatusVaga.preenchida)
      ];
      when(
        () => repository.getVagas(),
      ).thenAnswer((invocation) async => Right(listVagas));

      final result = await usecase();

      expect(result.isRight(), true);

      expect(result.fold(id, id), isA<List<Vaga>>());

      expect(result.fold(id, id), hasLength(3));
    });

    test('Deve retornar um erro vindo do repository', () async {
      when(
        () => repository.getVagas(),
      ).thenAnswer((invocation) async =>
          Left(GetVagasException(message: "Erro ao acessar lista de vagas")));

      final result = await usecase();

      expect(result.isLeft(), true);

      expect(result.fold(id, id), isA<GetVagasException>());
    });
  });
}
