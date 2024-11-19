import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gerenciador_vagas/features/historico/presentation/blocs/get_movimentacoes_bloc.dart';
import 'package:gerenciador_vagas/features/historico/presentation/blocs/get_movimentacoes_event.dart';
import 'package:gerenciador_vagas/features/historico/presentation/blocs/get_movimentacoes_state.dart';
import 'package:gerenciador_vagas/features/historico/presentation/widgets/item_movimentacao_widget.dart';
import 'package:gerenciador_vagas/main.dart';

class HistoricoScreen extends StatefulWidget {
  const HistoricoScreen({super.key});

  @override
  State<HistoricoScreen> createState() => _HistoricoScreenState();
}

class _HistoricoScreenState extends State<HistoricoScreen> {
  final GetMovimentacoesBloc bloc = getIt();

  @override
  void initState() {
    super.initState();
    bloc.add(BuscarHistorico());
  }

  TextTheme get textTheme => Theme.of(context).textTheme;
  ColorScheme get colorScheme => Theme.of(context).colorScheme;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: colorScheme.inversePrimary,
          title: Text(
            'Histórico',
            style: textTheme.headlineSmall,
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 8,
                  ),
                  Expanded(
                    child: BlocBuilder<GetMovimentacoesBloc,
                        GetMovimentacoesState>(
                      bloc: bloc,
                      builder: (context, state) {
                        if (state is GetMovimentacoesLoadingState) {
                          return Container(
                            key: const Key("getMovimentacoesLoadingWidget"),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        if (state is GetMovimentacoesErrorState) {
                          return Center(
                            key: const Key("getMovimentacoesErrorWidget"),
                            child: Text(
                              state.message,
                              style: textTheme.titleMedium
                                  ?.copyWith(color: colorScheme.error),
                            ),
                          );
                        }
                        if (state is GetMovimentacoesSuccessState) {
                          final movimentacoes = state.movimentacoes;
                          return Container(
                            key: const Key("getMovimentacoesSuccessWidget"),
                            child: movimentacoes.isEmpty
                                ? Align(
                                    alignment: Alignment.topCenter,
                                    child: Text(
                                      'Ainda não existem movimentações',
                                      style: textTheme.bodyLarge,
                                    ))
                                : ListView(
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
                                    children: movimentacoes
                                        .map((movimentacao) =>
                                            ItemMovimentacaoWidget(
                                                movimentacao: movimentacao))
                                        .toList(),
                                  )),
                          );
                        }
                        return Container();
                      },
                    ),
                  )
                ])));
  }
}
