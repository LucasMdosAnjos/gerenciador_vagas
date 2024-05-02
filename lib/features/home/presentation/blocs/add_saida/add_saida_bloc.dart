import 'package:bloc/bloc.dart';
import 'package:gerenciador_vagas/features/home/domain/usecases/add_saida_usecase.dart';
import 'package:gerenciador_vagas/features/home/presentation/blocs/add_saida/add_saida_event.dart';
import 'package:gerenciador_vagas/features/home/presentation/blocs/add_saida/add_saida_state.dart';

class AddSaidaBloc extends Bloc<AddSaidaEvent, AddSaidaState> {
  final IAddSaidaUsecase usecase;
  AddSaidaBloc(this.usecase) : super(AddSaidaInitialState()) {
    on<AddSaida>(
      (event, emit) async {
        emit(AddSaidaLoadingState());
        final result = await usecase(event.params);
        result.fold((error) {
          emit(AddSaidaErrorState(message: error.message));
        }, (result) {
          if (result == 200) {
            emit(AddSaidaSuccessState());
          } else {
            emit(AddSaidaErrorState(message: "Erro ao salvar saída"));
          }
        });
      },
    );

    on<ResetSaida>(
      (event, emit) => emit(AddSaidaInitialState()),
    );
  }
}
