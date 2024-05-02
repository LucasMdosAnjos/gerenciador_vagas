// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:gerenciador_vagas/features/home/domain/entities/vaga.dart';
import 'package:go_router/go_router.dart';

class ItemVagaWidget extends StatefulWidget {
  final Vaga vaga;
  const ItemVagaWidget({super.key, required this.vaga});

  @override
  State<ItemVagaWidget> createState() => _ItemVagaWidgetState();
}

class _ItemVagaWidgetState extends State<ItemVagaWidget> {
  TextTheme get textTheme => Theme.of(context).textTheme;
  ColorScheme get colorScheme => Theme.of(context).colorScheme;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: colorScheme.surface,
      child: ListTile(
        title: Text(
          'Vaga ${widget.vaga.id}',
          style: textTheme.titleMedium?.copyWith(color: colorScheme.onSurface),
        ),
        subtitle: widget.vaga.statusVaga == StatusVaga.preenchida
            ? Text(
                'Placa: ${widget.vaga.placaVeiculo}',
                style: textTheme.titleSmall
                    ?.copyWith(color: colorScheme.onSurface),
              )
            : null,
        trailing: Container(
          decoration: BoxDecoration(
              color: widget.vaga.statusVaga == StatusVaga.preenchida
                  ? colorScheme.error
                  : Colors.green,
              borderRadius: BorderRadius.circular(6)),
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Text(
            widget.vaga.statusVaga.name.toUpperCase(),
            style:
                textTheme.labelMedium?.copyWith(color: colorScheme.background),
          ),
        ),
        onTap: () {
          context.go('/add_entrada', extra: widget.vaga);
        },
      ),
    );
  }
}
