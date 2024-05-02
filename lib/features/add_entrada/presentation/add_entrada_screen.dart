import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:gerenciador_vagas/features/add_entrada/presentation/blocs/add_entrada_bloc.dart';
import 'package:gerenciador_vagas/features/add_entrada/presentation/blocs/add_entrada_event.dart';
import 'package:gerenciador_vagas/features/add_entrada/presentation/blocs/add_entrada_state.dart';
import 'package:gerenciador_vagas/features/add_entrada/presentation/widgets/add_entrada_form.dart';
import 'package:gerenciador_vagas/features/home/domain/entities/vaga.dart';
import 'package:gerenciador_vagas/features/home/presentation/blocs/get_vagas/get_vagas_bloc.dart';
import 'package:gerenciador_vagas/features/home/presentation/blocs/get_vagas/get_vagas_event.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

final GetIt getIt = GetIt.instance;

class AddEntradaScreen extends StatefulWidget {
  final Vaga vaga;
  const AddEntradaScreen({super.key, required this.vaga});

  @override
  State<AddEntradaScreen> createState() => _AddEntradaScreenState();
}

class _AddEntradaScreenState extends State<AddEntradaScreen> {
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
    // Resetar Estado para estado inicial do bloc de Adicionar Entrada
    bloc.add(ResetEntrada());
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
    return Scaffold(
        appBar: AppBar(
          backgroundColor: colorScheme.inversePrimary,
          title: Text(
            'Adicionar Entrada',
            style: textTheme.headlineSmall,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  'Vaga ${widget.vaga.id}',
                  style: textTheme.titleLarge
                      ?.copyWith(color: colorScheme.onBackground),
                  textAlign: TextAlign.center,
                ),
              ),
              BlocConsumer<AddEntradaBloc, AddEntradaState>(
                bloc: bloc,
                builder: (context, state) {
                  if (state is AddEntradaInitialState) {
                    return const AddEntradaForm();
                  }

                  return Container();
                },
                listener: (BuildContext context, AddEntradaState state) {
                  if (state is AddEntradaSuccessState) {
                    // puxar as vagas novamente e mandar de volta pra home
                    final GetVagasBloc bloc = getIt();
                    bloc.add(BuscarVagas());
                    context.pop();
                  }
                },
              ),
            ],
          ),
        ));
  }
}

enum TipoPlacaForm {
  mercosul(descricao: "Placa Mercosul"),
  antiga(descricao: "Placa Antiga");

  final String descricao;

  const TipoPlacaForm({required this.descricao});
}
