import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gerenciador_vagas/features/historico/domain/entity/movimentacao.dart';
import 'package:gerenciador_vagas/features/historico/domain/errors/errors.dart';
import 'package:gerenciador_vagas/features/historico/domain/repositories/get_movimentacoes_repository.dart';
import 'package:gerenciador_vagas/features/historico/domain/usecases/get_movimentacoes_usecase.dart';
import 'package:gerenciador_vagas/features/historico/presentation/blocs/get_movimentacoes_bloc.dart';
import 'package:gerenciador_vagas/features/historico/presentation/blocs/get_movimentacoes_event.dart';
import 'package:gerenciador_vagas/features/historico/presentation/blocs/get_movimentacoes_state.dart';
import 'package:mocktail/mocktail.dart';

class GetMovimentacoesRepositoryMock extends Mock
    implements GetMovimentacoesRepository {}

void main() {
  late GetMovimentacoesRepositoryMock repository;
  late GetMovimentacoesUsecase usecase;
  late GetMovimentacoesBloc bloc;

  setUp(() {
    repository = GetMovimentacoesRepositoryMock();
    usecase = GetMovimentacoesUsecase(repository);
    bloc = GetMovimentacoesBloc(usecase);
  });

  group('Get Movimentacoes Bloc | ', () {
    test('Deve puxar a lista de movimentações com sucesso', () async {
      final listMovimentacoes = [
        Movimentacao(
            placaVeiculo: "ABC1D34",
            tipoMovimentacao: TipoMovimentacao.entrada,
            data: DateTime(2024),
            vagaId: 1),
        Movimentacao(
            placaVeiculo: "ABC1D35",
            tipoMovimentacao: TipoMovimentacao.entrada,
            data: DateTime(2024),
            vagaId: 2),
        Movimentacao(
            placaVeiculo: "ABC1D36",
            tipoMovimentacao: TipoMovimentacao.entrada,
            data: DateTime(2024),
            vagaId: 3),
      ];
      when(() => repository.getMovimentacoes())
          .thenAnswer((invocation) async => Right(listMovimentacoes));

      expect(
          bloc.stream,
          emitsInOrder([
            isA<GetMovimentacoesLoadingState>(),
            isA<GetMovimentacoesSuccessState>()
          ]));

      bloc.add(BuscarHistorico());
    });

    test('Deve puxar a lista de movimentações com erro', () async {
      when(() => repository.getMovimentacoes()).thenAnswer((invocation) async =>
          Left(GetMovimentacoesException(
              message: "Erro ao puxar movimentações")));

      expect(
          bloc.stream,
          emitsInOrder([
            isA<GetMovimentacoesLoadingState>(),
            isA<GetMovimentacoesErrorState>()
          ]));

      bloc.add(BuscarHistorico());
    });
  });
}
