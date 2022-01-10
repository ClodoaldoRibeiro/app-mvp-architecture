import 'package:dio/dio.dart';

class CepFailure implements Exception {
  final String message;

  CepFailure({
    required this.message,
  });
}

class Cep {
  final String cep;
  final String logradouro;
  final String complemento;
  final String bairro;
  final String localidade;
  final String uf;
  final String ibge;
  final String gia;
  final String ddd;
  final String siafi;

  const Cep({
    required this.cep,
    required this.logradouro,
    required this.complemento,
    required this.bairro,
    required this.localidade,
    required this.uf,
    required this.ibge,
    required this.gia,
    required this.ddd,
    required this.siafi,
  });

  factory Cep.fromMap({
    required Map<String, dynamic> mapCep,
  }) {
    return Cep(
      cep: mapCep['cep'] ?? '',
      logradouro: mapCep['logradouro'] ?? '',
      complemento: mapCep['complemento'] ?? '',
      bairro: mapCep['bairro'] ?? '',
      localidade: mapCep['localidade'] ?? '',
      uf: mapCep['uf'] ?? '',
      ibge: mapCep['ibge'] ?? '',
      gia: mapCep['gia'] ?? '',
      ddd: mapCep['ddd'] ?? '',
      siafi: mapCep['siafi'] ?? '',
    );
  }

  void validateCepNumber({
    required String cepNumber,
  }) {
    if (cepNumber.isEmpty) {
      throw CepFailure(message: 'Cep não informado');
    }

    if (cepNumber.length != 8) {
      throw CepFailure(message: 'Cep com formato inválido');
    }

    if (cepNumber == '00000000' ||
        cepNumber == '11111111' ||
        cepNumber == '22222222' ||
        cepNumber == '44444444' ||
        cepNumber == '55555555' ||
        cepNumber == '66666666' ||
        cepNumber == '77777777' ||
        cepNumber == '88888888' ||
        cepNumber == '99999999' ||
        cepNumber == '12345678') {
      throw CepFailure(message: 'Cep inválido');
    }
  }

  String _cleanCepNumber({
    required String cepNumber,
  }) {
    cepNumber = cepNumber.replaceAll('.', '');
    cepNumber = cepNumber.replaceAll('-', '');
    return cepNumber;
  }

  Future<Cep> cepByNumber({
    required String cepNumber,
  }) async {
    try {
      cepNumber = _cleanCepNumber(
        cepNumber: cepNumber.trim(),
      );
      validateCepNumber(
        cepNumber: cepNumber,
      );

      var response =
          await Dio().get('https://viacep.com.br/ws/$cepNumber/json/');

      if (response.statusCode == 200) {
        return Cep.fromMap(mapCep: response.data);
      } else {
        return Future.error(
            'Falha ao tentar obter dados, por favor tente mais tarde.');
      }
    } on CepFailure catch (cepFailure) {
      return Future.error(cepFailure.message);
    } catch (cepFailure) {
      return Future.error(
          'Falha ao tentar obter dados, por favor tente mais tarde.');
    }
  }
}
