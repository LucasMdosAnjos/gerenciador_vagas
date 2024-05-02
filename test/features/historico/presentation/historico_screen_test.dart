import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gerenciador_vagas/features/historico/domain/entity/movimentacao.dart';
import 'package:gerenciador_vagas/features/historico/presentation/blocs/get_movimentacoes_bloc.dart';
import 'package:gerenciador_vagas/features/historico/presentation/blocs/get_movimentacoes_event.dart';
import 'package:gerenciador_vagas/features/historico/presentation/blocs/get_movimentacoes_state.dart';
import 'package:gerenciador_vagas/features/historico/presentation/historico_screen.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

class MockGetMovimentacoesBloc
    extends MockBloc<GetMovimentacoesEvent, GetMovimentacoesState>
    implements GetMovimentacoesBloc {}

void main() {
  late MockGetMovimentacoesBloc bloc;

  setUpAll(() async {
    bloc = MockGetMovimentacoesBloc();

    getIt.registerSingleton<GetMovimentacoesBloc>(bloc);
  });

  group('Historico Screen | ', () {
    testWidgets(
        'Deve aparecer uma listagem de movimentações no estado de sucesso',
        (tester) async {
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

      whenListen(
          bloc,
          Stream.fromIterable([
            GetMovimentacoesLoadingState(),
            GetMovimentacoesSuccessState(movimentacoes: listMovimentacoes)
          ]),
          initialState: GetMovimentacoesInitialState());

      await tester.pumpWidget(const MaterialApp(home: HistoricoScreen()));
      await tester.pump();
      await tester
          .pumpAndSettle(); // Isso aguardará todas as animações e construções de estado

      final getMovimentacoesSuccessWidgetFinder =
          find.byKey(const Key("getMovimentacoesSuccessWidget"));
      expect(getMovimentacoesSuccessWidgetFinder, findsOneWidget);
    });

    testWidgets('Deve aparecer um aviso no estado de erro', (tester) async {
      String message = "Erro ao buscar as movimentações";

      whenListen(
          bloc,
          Stream.fromIterable([
            GetMovimentacoesLoadingState(),
            GetMovimentacoesErrorState(message: message)
          ]),
          initialState: GetMovimentacoesInitialState());

      await tester.pumpWidget(const MaterialApp(home: HistoricoScreen()));
      await tester.pump();
      await tester.pumpAndSettle();

      final getMovimentacoesErrorWidgetFinder =
          find.byKey(const Key("getMovimentacoesErrorWidget"));
      expect(getMovimentacoesErrorWidgetFinder, findsOneWidget);
      expect(find.text(message), findsOneWidget);
    });
  });
}
