import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gerenciador_vagas/features/add_entrada/domain/errors/errors.dart';
import 'package:gerenciador_vagas/features/add_entrada/domain/repositories/add_entrada_repository.dart';
import 'package:gerenciador_vagas/features/add_entrada/domain/usecases/add_entrada_usecase.dart';
import 'package:mocktail/mocktail.dart';

class AddEntradaRepositoryMock extends Mock implements AddEntradaRepository {}

void main() {
  late AddEntradaRepositoryMock repository;
  late AddEntradaUsecase usecase;

  setUp(() {
    repository = AddEntradaRepositoryMock();
    usecase = AddEntradaUsecase(repository);
  });

  group('Add Entrada Usecase | ', () {
    test('Deve retornar 200 simbolizando sucesso ao adicionar uma entrada',
        () async {
      // Parâmetros com padrão placa Mercosul
      ParamsAddEntrada params = ParamsAddEntrada(
          vagaId: 1, placaVeiculo: "ABC1D23", timestamp: "2024-05-01T12:45:00");

      when(() => repository.addEntrada(params))
          .thenAnswer((invocation) async => const Right(200));

      final result = await usecase(params);

      expect(result.isRight(), true);
      expect(result.fold(id, id), isA<int>());
      expect(result.fold(id, id), 200);

      // Parâmetros com padrão placa antiga
      params = ParamsAddEntrada(
          vagaId: 1,
          placaVeiculo: "ABC-1234",
          timestamp: "2024-05-01T12:45:00");

      when(() => repository.addEntrada(params))
          .thenAnswer((invocation) async => const Right(200));

      final result2 = await usecase(params);

      expect(result2.isRight(), true);
      expect(result2.fold(id, id), isA<int>());
      expect(result2.fold(id, id), 200);
    });

    test('Deve retornar erro no usecase ao usar placa de veículo mal formatada',
        () async {
      ParamsAddEntrada params = ParamsAddEntrada(
          vagaId: 1, placaVeiculo: "ABC1DD3", timestamp: "2024-05-01T12:45:00");

      final result = await usecase(params);

      expect(result.isLeft(), true);
      expect(result.fold(id, id), isA<AddEntradaException>());
    });

    test('Deve retornar erro no usecase ao usar id de vaga inválido', () async {
      ParamsAddEntrada params = ParamsAddEntrada(
          vagaId: 0, placaVeiculo: "ABC1D23", timestamp: "2024-05-01T12:45:00");

      final result = await usecase(params);

      expect(result.isLeft(), true);
      expect(result.fold(id, id), isA<AddEntradaException>());
    });

    test('Deve retornar erro no usecase ao usar data inválida', () async {
      ParamsAddEntrada params = ParamsAddEntrada(
          vagaId: 1, placaVeiculo: "ABC1D23", timestamp: "15-03-2022T12:45:00");

      final result = await usecase(params);

      expect(result.isLeft(), true);
      expect(result.fold(id, id), isA<AddEntradaException>());
    });
  });

  test('Deve retornar erro vindo do repository', () async {
    // Parâmetros com padrão placa Mercosul
    ParamsAddEntrada params = ParamsAddEntrada(
        vagaId: 1, placaVeiculo: "ABC1D23", timestamp: "2024-05-01T12:45:00");

    when(() => repository.addEntrada(params)).thenAnswer((invocation) async =>
         Left(AddEntradaException(message: "Erro externo")));

    final result = await usecase(params);

    expect(result.isLeft(), true);
    expect(result.fold(id, id), isA<AddEntradaException>());
  });
}
