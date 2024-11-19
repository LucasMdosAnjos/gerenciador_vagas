import 'package:bloc/bloc.dart';
import 'package:gerenciador_vagas/features/historico/domain/usecases/get_movimentacoes_usecase.dart';
import 'package:gerenciador_vagas/features/historico/presentation/blocs/get_movimentacoes_event.dart';
import 'package:gerenciador_vagas/features/historico/presentation/blocs/get_movimentacoes_state.dart';

class GetMovimentacoesBloc
    extends Bloc<GetMovimentacoesEvent, GetMovimentacoesState> {
  final IGetMovimentacoesUsecase usecase;
  GetMovimentacoesBloc(this.usecase) : super(GetMovimentacoesInitialState()) {
    on<BuscarHistorico>((event, emit) async {
      emit(GetMovimentacoesLoadingState());
      final result = await usecase();
      result.fold((error) {
        emit(GetMovimentacoesErrorState(message: error.message));
      }, (movimentacoes) {
        emit(GetMovimentacoesSuccessState(movimentacoes: movimentacoes));
      });
    });
  }
}
