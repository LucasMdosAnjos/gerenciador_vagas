import 'package:bloc/bloc.dart';
import 'package:gerenciador_vagas/features/add_entrada/domain/usecases/add_entrada_usecase.dart';
import 'package:gerenciador_vagas/features/add_entrada/presentation/blocs/add_entrada_event.dart';
import 'package:gerenciador_vagas/features/add_entrada/presentation/blocs/add_entrada_state.dart';

class AddEntradaBloc extends Bloc<AddEntradaEvent, AddEntradaState> {
  final IAddEntradaUsecase usecase;
  AddEntradaBloc(this.usecase) : super(AddEntradaInitialState()) {
    on<AddEntrada>(
      (event, emit) async {
        emit(AddEntradaLoadingState());
        final result = await usecase(event.params);
        result.fold((error) {
          emit(AddEntradaErrorState(message: error.message));
        }, (result) {
          if (result == 200) {
            emit(AddEntradaSuccessState());
          } else {
            emit(AddEntradaErrorState(message: "Erro ao salvar entrada"));
          }
        });
      },
    );

    on<ResetEntrada>(
      (event, emit) => emit(AddEntradaInitialState()),
    );
  }
}
