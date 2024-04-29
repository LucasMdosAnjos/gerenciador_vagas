import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gerenciador_vagas/features/home/domain/entities/vaga.dart';
import 'package:gerenciador_vagas/features/home/presentation/blocs/get_vagas/get_vagas_bloc.dart';
import 'package:gerenciador_vagas/features/home/presentation/blocs/get_vagas/get_vagas_event.dart';
import 'package:gerenciador_vagas/features/home/presentation/blocs/get_vagas/get_vagas_state.dart';
import 'package:gerenciador_vagas/features/home/presentation/home_screen.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

class MockGetVagasBloc extends MockBloc<GetVagasEvent, GetVagasState>
    implements GetVagasBloc {}

void main() {
  late MockGetVagasBloc bloc;

  setUpAll(() async {
    bloc = MockGetVagasBloc();

    getIt.registerSingleton<GetVagasBloc>(bloc);
  });

  group('Home Screen | ', () {
    testWidgets('Deve aparecer uma listagem de vagas no estado de sucesso',
        (tester) async {
      final listVagas = [
        Vaga(id: 1, statusVaga: StatusVaga.livre),
        Vaga(id: 2, statusVaga: StatusVaga.livre),
        Vaga(id: 3, statusVaga: StatusVaga.preeenchida)
      ];

      whenListen(
          bloc,
          Stream.fromIterable(
              [GetVagasLoadingState(), GetVagasSuccessState(vagas: listVagas)]),
          initialState: GetVagasInitialState());

      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      await tester.pump();
      await tester
          .pumpAndSettle(); // Isso aguardará todas as animações e construções de estado

      final getVagasSuccessWidgetFinder =
          find.byKey(const Key("getVagasSuccessWidget"));
      expect(getVagasSuccessWidgetFinder, findsOneWidget);
    });
  });
}
