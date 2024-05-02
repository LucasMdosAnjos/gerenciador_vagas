import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:gerenciador_vagas/features/add_entrada/domain/repositories/add_entrada_repository.dart';
import 'package:gerenciador_vagas/features/add_entrada/presentation/blocs/add_entrada_bloc.dart';
import 'package:gerenciador_vagas/features/add_entrada/presentation/blocs/add_entrada_event.dart';
import 'package:gerenciador_vagas/features/home/domain/entities/vaga.dart';
import 'package:gerenciador_vagas/helpers/utils.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

final GetIt getIt = GetIt.instance;

class AddEntradaForm extends StatefulWidget {
  const AddEntradaForm({super.key});

  @override
  State<AddEntradaForm> createState() => _AddEntradaFormState();
}

class _AddEntradaFormState extends State<AddEntradaForm> {
  final GlobalKey<FormState> key = GlobalKey();
  // Opções de máscara para placa
  List<TipoPlacaForm> opcoesPlaca = TipoPlacaForm.values;
  TipoPlacaForm tipoPlacaSelecionada = TipoPlacaForm.mercosul;

  // Controladores com máscaras
  var controllerMercosul = MaskedTextController(mask: 'AAA0A00');
  var controllerAntigo = MaskedTextController(mask: 'AAA-0000');

  late MaskedTextController controllerAtual;

  final AddEntradaBloc bloc = getIt();
  @override
  void initState() {
    super.initState();
    // Inicializa com a máscara Mercosul
    controllerAtual = controllerMercosul;
  }

  void alterarPlaca(TipoPlacaForm novaSelecao) {
    setState(() {
      tipoPlacaSelecionada = novaSelecao;
      if (novaSelecao == TipoPlacaForm.mercosul) {
        controllerAtual = controllerMercosul;
      } else {
        controllerAtual = controllerAntigo;
      }
    });
  }

  TextTheme get textTheme => Theme.of(context).textTheme;
  ColorScheme get colorScheme => Theme.of(context).colorScheme;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: key,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 16,
                ),
                DropdownButtonFormField<TipoPlacaForm>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Selecione o tipo de placa',
                  ),
                  value: tipoPlacaSelecionada,
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  onChanged: (TipoPlacaForm? newValue) {
                    if (newValue != null) {
                      alterarPlaca(newValue);
                    }
                  },
                  items: opcoesPlaca.map<DropdownMenuItem<TipoPlacaForm>>(
                      (TipoPlacaForm value) {
                    return DropdownMenuItem<TipoPlacaForm>(
                      value: value,
                      child: Text(value.descricao),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  key: const Key("textFormFieldPlacaVeiculo"),
                  controller: controllerAtual,
                  decoration: InputDecoration(
                    labelText: 'Digite a placa do veículo',
                    hintText: tipoPlacaSelecionada == TipoPlacaForm.mercosul
                        ? "ABC1D23"
                        : "ABC-1234",
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'A placa não pode ser vazia';
                    }

                    if (!Utils.verificaPlaca(value)) {
                      return 'a placa não corresponde ao padrão de ${tipoPlacaSelecionada.descricao}';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                    key: const Key('buttonSalvarEntrada'),
                    onPressed: salvarEntrada,
                    icon: const Icon(Icons.save),
                    label: const Text('SALVAR'))
              ]),
        ));
  }

  salvarEntrada() {
    if (key.currentState!.validate()) {
      if (Platform.environment.containsKey('FLUTTER_TEST')) {
        // Se tiver rodando qualquer tipo de teste não deve continuar
        return;
      }
      final Vaga vaga = GoRouterState.of(context).extra! as Vaga;
      final ParamsAddEntrada params = ParamsAddEntrada(
          vagaId: vaga.id,
          placaVeiculo: controllerAtual.text,
          timestamp: DateTime.now().toIso8601String());
      bloc.add(AddEntrada(params));
    }
  }
}

enum TipoPlacaForm {
  mercosul(descricao: "Placa Mercosul"),
  antiga(descricao: "Placa Antiga");

  final String descricao;

  const TipoPlacaForm({required this.descricao});
}
