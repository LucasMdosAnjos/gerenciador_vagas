import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:gerenciador_vagas/features/home/domain/entities/vaga.dart';
import 'package:gerenciador_vagas/features/home/domain/errors/errors.dart';
import 'package:gerenciador_vagas/features/home/domain/repositories/get_vagas_repository.dart';
import 'package:gerenciador_vagas/features/home/domain/usecases/get_vagas_usecase.dart';
import 'package:gerenciador_vagas/features/home/presentation/blocs/get_vagas/get_vagas_bloc.dart';
import 'package:gerenciador_vagas/features/home/presentation/blocs/get_vagas/get_vagas_event.dart';
import 'package:gerenciador_vagas/features/home/presentation/blocs/get_vagas/get_vagas_state.dart';
import 'package:mocktail/mocktail.dart';

class GetVagasRepositoryMock extends Mock implements GetVagasRepository {}

void main() {
  late GetVagasRepositoryMock repository;
  late IGetVagasUsecase usecase;
  late GetVagasBloc bloc;

  setUp(() {
    repository = GetVagasRepositoryMock();
    usecase = GetVagasUsecase(repository);
    bloc = GetVagasBloc(usecase);
  });
  group('Get Vagas Bloc | ', () {
    test('Deve retornar uma lista de vagas vindo do repository', () async {
      final listVagas = [
        Vaga(id: 1, statusVaga: StatusVaga.livre),
        Vaga(id: 2, statusVaga: StatusVaga.livre),
        Vaga(id: 3, statusVaga: StatusVaga.preenchida)
      ];
      when(
        () => repository.getVagas(),
      ).thenAnswer((invocation) async => Right(listVagas));

      expect(
          bloc.stream,
          emitsInOrder([
            isA<GetVagasLoadingState>(),
            isA<GetVagasSuccessState>(),
          ]));

      bloc.add(BuscarVagas());
    });

    test('Deve retornar um erro vindo do repository', () async {
      when(
        () => repository.getVagas(),
      ).thenAnswer((invocation) async =>
          Left(GetVagasException(message: "Erro ao acessar lista de vagas")));

      expect(
          bloc.stream,
          emitsInOrder([
            isA<GetVagasLoadingState>(),
            isA<GetVagasErrorState>(),
          ]));

      bloc.add(BuscarVagas());
    });
  });
}
