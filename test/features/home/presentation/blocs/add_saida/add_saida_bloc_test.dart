import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gerenciador_vagas/features/home/domain/errors/errors.dart';
import 'package:gerenciador_vagas/features/home/domain/repositories/add_saida_repository.dart';
import 'package:gerenciador_vagas/features/home/domain/usecases/add_saida_usecase.dart';
import 'package:gerenciador_vagas/features/home/presentation/blocs/add_saida/add_saida_bloc.dart';
import 'package:gerenciador_vagas/features/home/presentation/blocs/add_saida/add_saida_event.dart';
import 'package:gerenciador_vagas/features/home/presentation/blocs/add_saida/add_saida_state.dart';
import 'package:mocktail/mocktail.dart';

class AddSaidaRepositoryMock extends Mock implements AddSaidaRepository {}

void main() {
  late AddSaidaRepositoryMock repository;
  late IAddSaidaUsecase usecase;
  late AddSaidaBloc bloc;

  setUp(() {
    repository = AddSaidaRepositoryMock();
    usecase = AddSaidaUsecase(repository);
    bloc = AddSaidaBloc(usecase);
  });
  group('Add Entrada Bloc | ', () {
    test('Deve retornar 200 simbolizando sucesso ao adicionar uma saida',
        () async {
      // Parâmetros com padrão placa Mercosul
      ParamsAddSaida params = ParamsAddSaida(
          vagaId: 1, placaVeiculo: "ABC1D23", timestamp: "2024-05-01T12:45:00");

      when(() => repository.addSaida(params))
          .thenAnswer((invocation) async => const Right(200));

      expect(
          bloc.stream,
          emitsInOrder(
              [isA<AddSaidaLoadingState>(), isA<AddSaidaSuccessState>()]));

      bloc.add(AddSaida(params));

      // Parâmetros com padrão placa antiga
      params = ParamsAddSaida(
          vagaId: 1,
          placaVeiculo: "ABC-1234",
          timestamp: "2024-05-01T12:45:00");

      when(() => repository.addSaida(params))
          .thenAnswer((invocation) async => const Right(200));
      expect(
          bloc.stream,
          emitsInOrder(
              [isA<AddSaidaLoadingState>(), isA<AddSaidaSuccessState>()]));

      bloc.add(AddSaida(params));
    });

    test('Deve retornar erro no usecase ao usar placa de veículo mal formatada',
        () async {
      ParamsAddSaida params = ParamsAddSaida(
          vagaId: 1, placaVeiculo: "ABC1DD3", timestamp: "2024-05-01T12:45:00");
      expect(
          bloc.stream,
          emitsInOrder(
              [isA<AddSaidaLoadingState>(), isA<AddSaidaErrorState>()]));

      bloc.add(AddSaida(params));
    });

    test('Deve retornar erro no usecase ao usar id de vaga inválido', () async {
      ParamsAddSaida params = ParamsAddSaida(
          vagaId: 0, placaVeiculo: "ABC1D23", timestamp: "2024-05-01T12:45:00");

      expect(
          bloc.stream,
          emitsInOrder(
              [isA<AddSaidaLoadingState>(), isA<AddSaidaErrorState>()]));

      bloc.add(AddSaida(params));
    });

    test('Deve retornar erro no usecase ao usar data inválida', () async {
      ParamsAddSaida params = ParamsAddSaida(
          vagaId: 1, placaVeiculo: "ABC1D23", timestamp: "15-03-2022T12:45:00");

      expect(
          bloc.stream,
          emitsInOrder(
              [isA<AddSaidaLoadingState>(), isA<AddSaidaErrorState>()]));

      bloc.add(AddSaida(params));
    });
  });

  test('Deve retornar erro vindo do repository', () async {
    // Parâmetros com padrão placa Mercosul
    ParamsAddSaida params = ParamsAddSaida(
        vagaId: 1, placaVeiculo: "ABC1D23", timestamp: "2024-05-01T12:45:00");

    when(() => repository.addSaida(params)).thenAnswer((invocation) async =>
        Left(AddSaidaException(message: "Erro externo")));
    expect(
        bloc.stream,
        emitsInOrder(
            [isA<AddSaidaLoadingState>(), isA<AddSaidaErrorState>()]));

    bloc.add(AddSaida(params));
  });

  test('Deve resetar para o estado inicial ao mandar evento de Reset',
      () async {
    expect(bloc.stream, emits(isA<AddSaidaInitialState>()));

    bloc.add(ResetSaida());
  });
}
