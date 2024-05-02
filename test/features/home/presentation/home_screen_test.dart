import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gerenciador_vagas/cubits/theme_cubit.dart';
import 'package:gerenciador_vagas/features/home/domain/entities/vaga.dart';
import 'package:gerenciador_vagas/features/home/presentation/blocs/add_saida/add_saida_bloc.dart';
import 'package:gerenciador_vagas/features/home/presentation/blocs/add_saida/add_saida_event.dart';
import 'package:gerenciador_vagas/features/home/presentation/blocs/add_saida/add_saida_state.dart';
import 'package:gerenciador_vagas/features/home/presentation/blocs/get_vagas/get_vagas_bloc.dart';
import 'package:gerenciador_vagas/features/home/presentation/blocs/get_vagas/get_vagas_event.dart';
import 'package:gerenciador_vagas/features/home/presentation/blocs/get_vagas/get_vagas_state.dart';
import 'package:gerenciador_vagas/features/home/presentation/home_screen.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

class MockGetVagasBloc extends MockBloc<GetVagasEvent, GetVagasState>
    implements GetVagasBloc {}

class MockAddSaidaBloc extends MockBloc<AddSaidaEvent, AddSaidaState>
    implements AddSaidaBloc {}

void main() {
  late MockGetVagasBloc bloc;
  late MockAddSaidaBloc addSaidaBloc;

  setUpAll(() async {
    bloc = MockGetVagasBloc();
    addSaidaBloc = MockAddSaidaBloc();

    getIt.registerSingleton<GetVagasBloc>(bloc);
    getIt.registerSingleton<ThemeCubit>(ThemeCubit());
    getIt.registerSingleton<AddSaidaBloc>(addSaidaBloc);
  });

  group('Home Screen | ', () {
    testWidgets('Deve aparecer uma listagem de vagas no estado de sucesso',
        (tester) async {
      final listVagas = [
        Vaga(id: 1, statusVaga: StatusVaga.livre),
        Vaga(id: 2, statusVaga: StatusVaga.livre),
        Vaga(id: 3, statusVaga: StatusVaga.preenchida)
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

    testWidgets('Deve aparecer um aviso no estado de erro', (tester) async {
      String message = "Erro ao buscar as vagas";

      whenListen(
          bloc,
          Stream.fromIterable(
              [GetVagasLoadingState(), GetVagasErrorState(message: message)]),
          initialState: GetVagasInitialState());

      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      await tester.pump();
      await tester.pumpAndSettle();

      final getVagasErrorWidgetFinder =
          find.byKey(const Key("getVagasErrorWidget"));
      expect(getVagasErrorWidgetFinder, findsOneWidget);
      expect(find.text(message), findsOneWidget);
    });
  });
}
