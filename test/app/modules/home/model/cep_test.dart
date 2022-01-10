import 'package:flutter_test/flutter_test.dart';
import 'package:poc_mvp/app/modules/home/model/cep.dart';

void main() {
  test('description', () async {
    const cep = Cep(
      cep: '',
      logradouro: '',
      complemento: '',
      bairro: '',
      localidade: '',
      uf: '',
      ibge: '',
      gia: '',
      ddd: '',
      siafi: '',
    );

    var _cep = await cep.cepByNumber(
      cepNumber: '56312320-00',
    );

    print(_cep.toString());
  });
}
