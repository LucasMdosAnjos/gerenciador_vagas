// ignore_for_file: public_member_api_docs, sort_constructors_first
abstract class AddEntradaState {}

class AddEntradaInitialState implements AddEntradaState {}

class AddEntradaLoadingState implements AddEntradaState {}

class AddEntradaErrorState implements AddEntradaState {
  String message;
  AddEntradaErrorState({
    required this.message,
  });
}

class AddEntradaSuccessState implements AddEntradaState {}
