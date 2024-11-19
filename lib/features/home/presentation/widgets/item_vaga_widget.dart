// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gerenciador_vagas/features/home/domain/entities/vaga.dart';
import 'package:gerenciador_vagas/features/home/domain/repositories/add_saida_repository.dart';
import 'package:gerenciador_vagas/features/home/presentation/blocs/add_saida/add_saida_bloc.dart';
import 'package:gerenciador_vagas/features/home/presentation/blocs/add_saida/add_saida_event.dart';
import 'package:gerenciador_vagas/features/home/presentation/blocs/add_saida/add_saida_state.dart';
import 'package:gerenciador_vagas/features/home/presentation/blocs/get_vagas/get_vagas_bloc.dart';
import 'package:gerenciador_vagas/features/home/presentation/blocs/get_vagas/get_vagas_event.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

final GetIt getIt = GetIt.instance;

class ItemVagaWidget extends StatefulWidget {
  final Vaga vaga;
  const ItemVagaWidget({super.key, required this.vaga});

  @override
  State<ItemVagaWidget> createState() => _ItemVagaWidgetState();
}

class _ItemVagaWidgetState extends State<ItemVagaWidget> {
  TextTheme get textTheme => Theme.of(context).textTheme;
  ColorScheme get colorScheme => Theme.of(context).colorScheme;
  Vaga get vaga => widget.vaga;
  final AddSaidaBloc addSaidaBloc = getIt();
  final GetVagasBloc getVagasBloc = getIt();
  @override
  Widget build(BuildContext context) {
    return Card(
      color: colorScheme.surface,
      child: ListTile(
        title: Text(
          'Vaga ${vaga.id}',
          style: textTheme.titleMedium?.copyWith(color: colorScheme.onSurface),
        ),
        subtitle: vaga.statusVaga == StatusVaga.preenchida
            ? Text(
                'Placa: ${vaga.placaVeiculo}',
                style: textTheme.titleSmall
                    ?.copyWith(color: colorScheme.onSurface),
              )
            : null,
        trailing: Container(
          decoration: BoxDecoration(
              color: vaga.statusVaga == StatusVaga.preenchida
                  ? colorScheme.error
                  : Colors.green,
              borderRadius: BorderRadius.circular(6)),
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Text(
            vaga.statusVaga.name.toUpperCase(),
            style:
                textTheme.labelMedium?.copyWith(color: colorScheme.background),
          ),
        ),
        onTap: () {
          if (vaga.statusVaga == StatusVaga.livre) {
            context.go('/add_entrada', extra: vaga);
          } else {
            _mostrarDialogo();
          }
        },
      ),
    );
  }

  void _mostrarDialogo() {
    addSaidaBloc.add(ResetSaida());
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog.adaptive(
          title: const Text('Confirmação'),
          content: BlocConsumer<AddSaidaBloc, AddSaidaState>(
            bloc: addSaidaBloc,
            builder: (context, state) {
              if (state is AddSaidaInitialState) {
                return const Text('Deseja realizar a saída do Veículo?');
              }

              if (state is AddSaidaLoadingState) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is AddSaidaErrorState) {
                return Text(state.message);
              }
              return Container();
            },
            listener: (context, state) {
              if (state is AddSaidaSuccessState) {
                // Recarregar as vagas e sair do dialog
                getVagasBloc.add(BuscarVagas());
                context.pop();
              }
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                final params = ParamsAddSaida(
                    vagaId: vaga.id,
                    placaVeiculo: vaga.placaVeiculo!,
                    timestamp: DateTime.now().toIso8601String());
                addSaidaBloc.add(AddSaida(params));
              },
              child: const Text('Sim'),
            ),
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: const Text('Não'),
            ),
          ],
        );
      },
    );
  }
}
