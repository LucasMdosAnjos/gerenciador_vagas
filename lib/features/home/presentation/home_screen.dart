import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gerenciador_vagas/cubits/theme_cubit.dart';
import 'package:gerenciador_vagas/features/home/presentation/blocs/add_saida/add_saida_bloc.dart';
import 'package:gerenciador_vagas/features/home/presentation/blocs/get_vagas/get_vagas_bloc.dart';
import 'package:gerenciador_vagas/features/home/presentation/blocs/get_vagas/get_vagas_event.dart';
import 'package:gerenciador_vagas/features/home/presentation/blocs/get_vagas/get_vagas_state.dart';
import 'package:gerenciador_vagas/features/home/presentation/widgets/item_vaga_widget.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
final GetIt getIt = GetIt.instance;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GetVagasBloc getVagasBloc = getIt();
  final ThemeCubit themeCubit = getIt();
  final AddSaidaBloc addSaidaBloc = getIt();

  @override
  void initState() {
    super.initState();

    getVagasBloc.add(BuscarVagas());
  }

  TextTheme get textTheme => Theme.of(context).textTheme;
  ColorScheme get colorScheme => Theme.of(context).colorScheme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.inversePrimary,
        title: Text(
          'Gerenciador de Vagas',
          style: textTheme.headlineSmall,
        ),
        actions: [
          BlocBuilder<ThemeCubit, ThemeMode>(
              bloc: themeCubit,
              builder: (context, state) {
                if (state == ThemeMode.dark) {
                  return IconButton(
                      onPressed: () {
                        themeCubit.setTheme(ThemeMode.light);
                      },
                      icon: const Icon(Icons.light_mode),
                      color: colorScheme.secondary);
                } else {
                  return IconButton(
                    onPressed: () {
                      themeCubit.setTheme(ThemeMode.dark);
                    },
                    icon: const Icon(Icons.dark_mode),
                    color: colorScheme.secondary,
                  );
                }
              })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 8,
            ),
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      'Listagem de Vagas',
                      style: textTheme.titleLarge
                          ?.copyWith(color: colorScheme.onBackground),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  TextButton.icon(
                      onPressed: () {
                        context.go('/historico');
                      },
                      icon: const Icon(Icons.list),
                      label: const Text('Histórico'))
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Expanded(
              child: BlocBuilder<GetVagasBloc, GetVagasState>(
                bloc: getVagasBloc,
                builder: (context, state) {
                  if (state is GetVagasLoadingState) {
                    return Container(
                      key: const Key("getVagasLoadingWidget"),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (state is GetVagasErrorState) {
                    return Center(
                      key: const Key("getVagasErrorWidget"),
                      child: Text(
                        state.message,
                        style: textTheme.titleMedium
                            ?.copyWith(color: colorScheme.error),
                      ),
                    );
                  }
                  if (state is GetVagasSuccessState) {
                    final vagas = state.vagas;
                    return Container(
                      key: const Key("getVagasSuccessWidget"),
                      child: ListView(
                          children: AnimateList(
                        interval: const Duration(milliseconds: 100),
                        effects: const [
                          FadeEffect(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                              begin: 0,
                              end: 1),
                          MoveEffect(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                              begin: Offset(250, 0),
                              end: Offset(0, 0))
                        ],
                        children: vagas
                            .map((vaga) => ItemVagaWidget(vaga: vaga))
                            .toList(),
                      )),
                    );
                  }
                  return Container();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
