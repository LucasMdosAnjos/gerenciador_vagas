import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gerenciador_vagas/features/home/presentation/blocs/get_vagas/get_vagas_bloc.dart';
import 'package:gerenciador_vagas/features/home/presentation/blocs/get_vagas/get_vagas_event.dart';
import 'package:gerenciador_vagas/features/home/presentation/blocs/get_vagas/get_vagas_state.dart';
import 'package:gerenciador_vagas/features/home/presentation/widgets/item_vaga_widget.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GetVagasBloc bloc = getIt();

  @override
  void initState() {
    super.initState();
    bloc.add(BuscarVagas());
  }

  TextTheme get textTheme => Theme.of(context).textTheme;
  ColorScheme get colorScheme => Theme.of(context).colorScheme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          'Gerenciador de Vagas',
          style: textTheme.headlineSmall,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 16,
          ),
          SizedBox(
            width: double.infinity,
            child: Text(
              'Listagem de Vagas',
              style: textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Expanded(
            child: BlocBuilder<GetVagasBloc, GetVagasState>(
              bloc: bloc,
              builder: (context, state) {
                print(state);
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
                            begin: Offset(-100, 0),
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
    );
  }
}
