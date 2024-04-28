import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gerenciador_vagas/features/home/domain/entities/vaga.dart';
import 'package:gerenciador_vagas/features/home/domain/repositories/get_vagas_repository.dart';
import 'package:gerenciador_vagas/features/home/domain/usecases/get_vagas_usecase.dart';
import 'package:gerenciador_vagas/features/home/presentation/blocs/get_vagas/get_vagas_bloc.dart';
import 'package:gerenciador_vagas/features/home/presentation/blocs/get_vagas/get_vagas_state.dart';
import 'package:gerenciador_vagas/features/home/presentation/home_screen.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

final GetIt getIt = GetIt.instance;

class GetVagasRepositoryMock extends Mock implements GetVagasRepository {}

void main() {
  late GetVagasRepositoryMock repository;

  setUp(() async {
    await getIt.reset();
    repository = GetVagasRepositoryMock();
    getIt.registerSingleton<GetVagasRepository>(repository);
    getIt.registerSingleton<IGetVagasUsecase>(GetVagasUsecase(getIt()));
    getIt.registerSingleton<GetVagasBloc>(GetVagasBloc(getIt()));
  });
  group('Home Screen | ', () {
    testWidgets('Deve aparecer uma listagem de vagas', (tester) async {
      final listVagas = [
        Vaga(id: 1, statusVaga: StatusVaga.livre),
        Vaga(id: 2, statusVaga: StatusVaga.livre),
        Vaga(id: 3, statusVaga: StatusVaga.preeenchida)
      ];

      when(
        () => repository.getVagas(),
      ).thenAnswer((invocation) async => Right(listVagas));

      await tester.pumpWidget(const MaterialApp(
        home: HomeScreen(),
      ));

      await tester.pumpAndSettle();

      await tester.pump(const Duration(seconds: 2));

      // final getVagasSuccessWidgetFinder = find.byKey(
      //   const Key("getVagasSuccessWidget"),
      // );

      // // Verifica se os widgets estão na tela
      // expect(getVagasSuccessWidgetFinder, findsWidgets);
    });
  });
}
