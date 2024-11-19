import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gerenciador_vagas/features/add_entrada/domain/errors/errors.dart';
import 'package:gerenciador_vagas/features/add_entrada/domain/repositories/add_entrada_repository.dart';
import 'package:gerenciador_vagas/features/add_entrada/domain/usecases/add_entrada_usecase.dart';
import 'package:gerenciador_vagas/features/add_entrada/presentation/blocs/add_entrada_bloc.dart';
import 'package:gerenciador_vagas/features/add_entrada/presentation/blocs/add_entrada_event.dart';
import 'package:gerenciador_vagas/features/add_entrada/presentation/blocs/add_entrada_state.dart';
import 'package:mocktail/mocktail.dart';

class AddEntradaRepositoryMock extends Mock implements AddEntradaRepository {}

void main() {
  late AddEntradaRepositoryMock repository;
  late IAddEntradaUsecase usecase;
  late AddEntradaBloc bloc;

  setUp(() {
    repository = AddEntradaRepositoryMock();
    usecase = AddEntradaUsecase(repository);
    bloc = AddEntradaBloc(usecase);
  });
  group('Add Entrada Bloc | ', () {
    test('Deve retornar 200 simbolizando sucesso ao adicionar uma entrada',
        () async {
      // Parâmetros com padrão placa Mercosul
      ParamsAddEntrada params = ParamsAddEntrada(
          vagaId: 1, placaVeiculo: "ABC1D23", timestamp: "2024-05-01T12:45:00");

      when(() => repository.addEntrada(params))
          .thenAnswer((invocation) async => const Right(200));

      expect(
          bloc.stream,
          emitsInOrder(
              [isA<AddEntradaLoadingState>(), isA<AddEntradaSuccessState>()]));

      bloc.add(AddEntrada(params));

      // Parâmetros com padrão placa antiga
      params = ParamsAddEntrada(
          vagaId: 1,
          placaVeiculo: "ABC-1234",
          timestamp: "2024-05-01T12:45:00");

      when(() => repository.addEntrada(params))
          .thenAnswer((invocation) async => const Right(200));
      expect(
          bloc.stream,
          emitsInOrder(
              [isA<AddEntradaLoadingState>(), isA<AddEntradaSuccessState>()]));

      bloc.add(AddEntrada(params));
    });

    test('Deve retornar erro no usecase ao usar placa de veículo mal formatada',
        () async {
      ParamsAddEntrada params = ParamsAddEntrada(
          vagaId: 1, placaVeiculo: "ABC1DD3", timestamp: "2024-05-01T12:45:00");
      expect(
          bloc.stream,
          emitsInOrder(
              [isA<AddEntradaLoadingState>(), isA<AddEntradaErrorState>()]));

      bloc.add(AddEntrada(params));
    });

    test('Deve retornar erro no usecase ao usar id de vaga inválido', () async {
      ParamsAddEntrada params = ParamsAddEntrada(
          vagaId: 0, placaVeiculo: "ABC1D23", timestamp: "2024-05-01T12:45:00");

      expect(
          bloc.stream,
          emitsInOrder(
              [isA<AddEntradaLoadingState>(), isA<AddEntradaErrorState>()]));

      bloc.add(AddEntrada(params));
    });

    test('Deve retornar erro no usecase ao usar data inválida', () async {
      ParamsAddEntrada params = ParamsAddEntrada(
          vagaId: 1, placaVeiculo: "ABC1D23", timestamp: "15-03-2022T12:45:00");

      expect(
          bloc.stream,
          emitsInOrder(
              [isA<AddEntradaLoadingState>(), isA<AddEntradaErrorState>()]));

      bloc.add(AddEntrada(params));
    });
  });

  test('Deve retornar erro vindo do repository', () async {
    // Parâmetros com padrão placa Mercosul
    ParamsAddEntrada params = ParamsAddEntrada(
        vagaId: 1, placaVeiculo: "ABC1D23", timestamp: "2024-05-01T12:45:00");

    when(() => repository.addEntrada(params)).thenAnswer((invocation) async =>
        Left(AddEntradaException(message: "Erro externo")));
    expect(
        bloc.stream,
        emitsInOrder(
            [isA<AddEntradaLoadingState>(), isA<AddEntradaErrorState>()]));

    bloc.add(AddEntrada(params));
  });

  test('Deve resetar para o estado inicial ao mandar evento de Reset',
      () async {
    expect(bloc.stream, emits(isA<AddEntradaInitialState>()));

    bloc.add(ResetEntrada());
  });
}
