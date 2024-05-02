import 'package:flutter/material.dart';
import 'package:gerenciador_vagas/features/historico/domain/entity/movimentacao.dart';
import 'package:gerenciador_vagas/helpers/utils.dart';

class ItemMovimentacaoWidget extends StatefulWidget {
  final Movimentacao movimentacao;
  const ItemMovimentacaoWidget({super.key, required this.movimentacao});

  @override
  State<ItemMovimentacaoWidget> createState() => _ItemMovimentacaoWidgetState();
}

class _ItemMovimentacaoWidgetState extends State<ItemMovimentacaoWidget> {
  TextTheme get textTheme => Theme.of(context).textTheme;
  ColorScheme get colorScheme => Theme.of(context).colorScheme;
  @override
  Widget build(BuildContext context) {
    final movimentacao = widget.movimentacao;
    return Card(
      color: colorScheme.surface,
      child: ListTile(
        title: Text(
          'Vaga ${movimentacao.vagaId} (${movimentacao.placaVeiculo})',
          style: textTheme.titleMedium?.copyWith(color: colorScheme.onSurface),
        ),
        subtitle: Text(
          'Data: ${Utils.formatDatetime(movimentacao.data)}',
          style: textTheme.titleSmall?.copyWith(color: colorScheme.onSurface),
        ),
        trailing: Container(
          decoration: BoxDecoration(
              color: movimentacao.tipoMovimentacao == TipoMovimentacao.saida
                  ? colorScheme.error
                  : Colors.green,
              borderRadius: BorderRadius.circular(6)),
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Text(
            movimentacao.tipoMovimentacao.name.toUpperCase(),
            style:
                textTheme.labelMedium?.copyWith(color: colorScheme.background),
          ),
        ),
      ),
    );
  }
}
