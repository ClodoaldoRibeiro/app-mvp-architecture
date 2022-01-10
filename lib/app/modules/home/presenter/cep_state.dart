import 'package:equatable/equatable.dart';
import 'package:poc_mvp/app/modules/home/model/cep.dart';

abstract class CepState extends Equatable {
  InitialCepState initialCepState() {
    return InitialCepState();
  }

  LoadingCepState loadingCepState() {
    return LoadingCepState();
  }

  SucceedCepState succeedCepState({
    required Cep cep,
  }) {
    return SucceedCepState(cep: cep);
  }

  ErrorCepState errorCepState({
    required String messege,
  }) {
    return ErrorCepState(messege: messege);
  }

  @override
  List<Object?> get props {
    return [];
  }
}

class InitialCepState extends CepState {}

class LoadingCepState extends CepState {}

class SucceedCepState extends CepState {
  final Cep cep;

  SucceedCepState({
    required this.cep,
  });

  @override
  List<Object?> get props {
    return [
      ...super.props,
      cep,
    ];
  }
}

class ErrorCepState extends CepState {
  final String messege;

  ErrorCepState({
    required this.messege,
  });

  @override
  List<Object?> get props {
    return [
      ...super.props,
      messege,
    ];
  }
}
