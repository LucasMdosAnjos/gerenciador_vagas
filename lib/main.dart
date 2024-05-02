import 'package:flutter/material.dart';
import 'package:gerenciador_vagas/features/add_entrada/data/sqflite/sf_add_entrada.dart';
import 'package:gerenciador_vagas/features/add_entrada/domain/repositories/add_entrada_repository.dart';
import 'package:gerenciador_vagas/features/add_entrada/domain/usecases/add_entrada_usecase.dart';
import 'package:gerenciador_vagas/features/add_entrada/infra/datasources/add_entrada_datasource.dart';
import 'package:gerenciador_vagas/features/add_entrada/infra/repositories/add_entrada_repository_impl.dart';
import 'package:gerenciador_vagas/features/add_entrada/presentation/add_entrada_screen.dart';
import 'package:gerenciador_vagas/features/add_entrada/presentation/blocs/add_entrada_bloc.dart';
import 'package:gerenciador_vagas/features/home/data/sqflite/sf_get_vagas.dart';
import 'package:gerenciador_vagas/features/home/domain/entities/vaga.dart';
import 'package:gerenciador_vagas/features/home/domain/repositories/get_vagas_repository.dart';
import 'package:gerenciador_vagas/features/home/domain/usecases/get_vagas_usecase.dart';
import 'package:gerenciador_vagas/features/home/infra/datasources/get_vagas_datasource.dart';
import 'package:gerenciador_vagas/features/home/infra/repositories/get_vagas_repository_impl.dart';
import 'package:gerenciador_vagas/features/home/presentation/blocs/get_vagas/get_vagas_bloc.dart';
import 'package:gerenciador_vagas/helpers/db_helper.dart';
import 'package:gerenciador_vagas/features/home/presentation/home_screen.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:sqflite/sqflite.dart';

final GetIt getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  getIt.registerSingletonAsync<Database>(() => DatabaseHelper().database);

  await getIt.allReady();

  getIt.registerSingleton<GetVagasDatasource>(SfGetVagas(getIt()));
  getIt.registerSingleton<GetVagasRepository>(GetVagasRepositoryImpl(getIt()));
  getIt.registerSingleton<IGetVagasUsecase>(GetVagasUsecase(getIt()));
  getIt.registerSingleton<GetVagasBloc>(GetVagasBloc(getIt()));

  getIt.registerSingleton<AddEntradaDatasource>(SfAddEntrada(getIt()));
  getIt.registerSingleton<AddEntradaRepository>(
      AddEntradaRepositoryImpl(getIt()));
  getIt.registerSingleton<IAddEntradaUsecase>(AddEntradaUsecase(getIt()));
  getIt.registerSingleton<AddEntradaBloc>(AddEntradaBloc(getIt()));

  runApp(const MyApp());
}

// GoRouter configuration
final _router = GoRouter(
  routes: [
    GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'add_entrada',
            builder: (context, state) =>
                AddEntradaScreen(vaga: state.extra! as Vaga),
          )
        ]),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Gerenciador de Vagas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.indigo, brightness: Brightness.light),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.indigo, brightness: Brightness.dark),
      ),
      themeMode: ThemeMode.system,
      routerConfig: _router,
    );
  }
}
