import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gerenciador_vagas/features/add_entrada/presentation/add_entrada_screen.dart';
import 'package:gerenciador_vagas/features/add_entrada/presentation/blocs/add_entrada_bloc.dart';
import 'package:gerenciador_vagas/features/add_entrada/presentation/blocs/add_entrada_event.dart';
import 'package:gerenciador_vagas/features/add_entrada/presentation/blocs/add_entrada_state.dart';
import 'package:gerenciador_vagas/features/home/domain/entities/vaga.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

class MockAddEntradaBloc extends MockBloc<AddEntradaEvent, AddEntradaState>
    implements AddEntradaBloc {}

void main() {
  late MockAddEntradaBloc addEntradaBloc;

  setUpAll(() async {
    addEntradaBloc = MockAddEntradaBloc();

    getIt.registerSingleton<AddEntradaBloc>(addEntradaBloc);
  });

  group('Add Entrada Screen | ', () {
    testWidgets('Deve Validar o formulário com sucesso', (tester) async {
      String message = 'a placa não corresponde ao padrão';

      String message2 = 'A placa não pode ser vazia';
      final vaga = Vaga(id: 1, statusVaga: StatusVaga.livre);

      whenListen(
          addEntradaBloc, Stream.fromIterable([AddEntradaInitialState()]),
          initialState: AddEntradaInitialState());

      await tester.pumpWidget(MaterialApp(
          home: AddEntradaScreen(
        vaga: vaga,
      )));
      await tester.pump();
      await tester
          .pumpAndSettle(); // Isso aguardará todas as animações e construções de estado

      // Encontrar o Text Form Field de Placa Veiculo
      final textFormFieldPlacaVeiculoFinder =
          find.byKey(const Key("textFormFieldPlacaVeiculo"));

      expect(textFormFieldPlacaVeiculoFinder, findsOneWidget);

      // Encontrar o Botão de Salvar Entrada
      final buttonSalvarEntradaFinder =
          find.byKey(const Key('buttonSalvarEntrada'));

      // Colocar Placa Mercosul errada
      await tester.enterText(textFormFieldPlacaVeiculoFinder, 'ABC1D23');

      // Clicar no botão
      await tester.tap(buttonSalvarEntradaFinder);

      // Pump
      await tester.pump();

      // Espero encontrar nenhum texto de erro no textfield
      expect(find.textContaining(message), findsNothing);
      expect(find.textContaining(message2), findsNothing);
    });
    testWidgets('Deve Mostrar Widget de Erro com a placa errada',
        (tester) async {
      String message = 'a placa não corresponde ao padrão';
      final vaga = Vaga(id: 1, statusVaga: StatusVaga.livre);

      whenListen(
          addEntradaBloc, Stream.fromIterable([AddEntradaInitialState()]),
          initialState: AddEntradaInitialState());

      await tester.pumpWidget(MaterialApp(
          home: AddEntradaScreen(
        vaga: vaga,
      )));
      await tester.pump();
      await tester
          .pumpAndSettle(); // Isso aguardará todas as animações e construções de estado

      // Encontrar o Text Form Field de Placa Veiculo
      final textFormFieldPlacaVeiculoFinder =
          find.byKey(const Key("textFormFieldPlacaVeiculo"));

      expect(textFormFieldPlacaVeiculoFinder, findsOneWidget);

      // Encontrar o Botão de Salvar Entrada
      final buttonSalvarEntradaFinder =
          find.byKey(const Key('buttonSalvarEntrada'));

      // Colocar Placa Mercosul errada
      await tester.enterText(textFormFieldPlacaVeiculoFinder, 'ABC1123');

      // Tap the Button
      await tester.tap(buttonSalvarEntradaFinder);

      // Rebuild the widget after the state has changed
      await tester.pump();

      // Expect the text to be changed after tapping the button
      expect(find.textContaining(message), findsOneWidget);
    });

    testWidgets('Deve Mostrar Widget de Erro com a placa vazia',
        (tester) async {
      String message = 'A placa não pode ser vazia';
      final vaga = Vaga(id: 1, statusVaga: StatusVaga.livre);
      whenListen(
          addEntradaBloc, Stream.fromIterable([AddEntradaInitialState()]),
          initialState: AddEntradaInitialState());

      await tester.pumpWidget(MaterialApp(
          home: AddEntradaScreen(
        vaga: vaga,
      )));
      await tester.pump();
      await tester
          .pumpAndSettle(); // Isso aguardará todas as animações e construções de estado

      // Encontrar o Botão de Salvar Entrada
      final buttonSalvarEntradaFinder =
          find.byKey(const Key('buttonSalvarEntrada'));

      // Tap the Button
      await tester.tap(buttonSalvarEntradaFinder);

      // Rebuild the widget after the state has changed
      await tester.pump();

      // Expect the text to be changed after tapping the button
      expect(find.textContaining(message), findsOneWidget);
    });
  });
}
