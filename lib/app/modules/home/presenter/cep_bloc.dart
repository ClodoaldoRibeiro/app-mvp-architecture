import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poc_mvp/app/modules/home/model/cep.dart';
import 'package:poc_mvp/app/modules/home/presenter/cep_event.dart';
import 'package:poc_mvp/app/modules/home/presenter/cep_state.dart';

class CepBloc extends Bloc<CepEvent, CepState> {
  final Cep _cep;

  CepBloc({
    required Cep cep,
  })  : _cep = cep,
        super(InitialCepState()) {
    on<GetCepEvent>(_getCepEvent);
  }

  Future<void> _getCepEvent(
    GetCepEvent event,
    Emitter<CepState> emit,
  ) async {
    emit(state.loadingCepState());
    try {
      final _cepEncontrado = await _cep.cepByNumber(
        cepNumber: event.cep,
      );

      emit(state.succeedCepState(
        cep: _cepEncontrado,
      ));
    } catch (error) {
      emit(state.errorCepState(
        messege: error.toString(),
      ));
    }
  }
}
