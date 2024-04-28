import 'package:bloc/bloc.dart';
import 'package:gerenciador_vagas/features/home/domain/usecases/get_vagas_usecase.dart';
import 'package:gerenciador_vagas/features/home/presentation/blocs/get_vagas/get_vagas_state.dart';

class GetVagasBloc extends Cubit<GetVagasState> {
  final IGetVagasUsecase usecase;
  GetVagasBloc(this.usecase) : super(GetVagasInitialState());

  getVagas() async {
    emit(GetVagasLoadingState());
    final result = await usecase();

    result.fold((error) {
      emit(GetVagasErrorState(message: error.message));
    }, (vagas) {
      emit(GetVagasSuccessState(vagas: vagas));
    });
  }
}
