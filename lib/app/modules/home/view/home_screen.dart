import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poc_mvp/app/modules/home/model/cep.dart';
import 'package:poc_mvp/app/modules/home/presenter/cep_bloc.dart';
import 'package:poc_mvp/app/modules/home/presenter/cep_event.dart';
import 'package:poc_mvp/app/modules/home/presenter/cep_state.dart';
import 'package:poc_mvp/app/modules/home/view/widgets/address_section_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  _HomeScreenState createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  late final CepBloc _cepBloc;
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _cepBloc = CepBloc(
      cep: const Cep(
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
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Webservice de CEP'),
      ),
      body: BlocBuilder<CepBloc, CepState>(
        bloc: _cepBloc,
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _textEditingController,
                decoration: InputDecoration(
                  hintText: 'Digite o CEP',
                  labelText: 'CEP *',
                  suffixIcon: IconButton(
                    onPressed: state is LoadingCepState ? null : _getCepEvent,
                    icon: const Icon(Icons.search),
                  ),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CepInputFormatter(),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Builder(
                builder: (_) {
                  if (state is LoadingCepState) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          SizedBox(
                            height: 80,
                            width: 80,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Buscando dados, por favor aguarde...',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is ErrorCepState) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Center(
                            child: Icon(
                              Icons.error_outline,
                              size: 50,
                              color: Colors.green,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              state.messege,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is SucceedCepState) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CEP Pesquisado: ${_textEditingController.text}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          AddressSectionWidget(
                            label: 'CEP:',
                            value: state.cep.cep,
                          ),
                          const Divider(
                            color: Colors.green,
                          ),
                          AddressSectionWidget(
                            label: 'Logradouro:',
                            value: state.cep.logradouro,
                          ),
                          const Divider(
                            color: Colors.green,
                          ),
                          AddressSectionWidget(
                            label: 'Complemento:',
                            value: state.cep.complemento,
                          ),
                          const Divider(
                            color: Colors.green,
                          ),
                          AddressSectionWidget(
                            label: 'Bairro:',
                            value: state.cep.bairro,
                          ),
                          const Divider(
                            color: Colors.green,
                          ),
                          AddressSectionWidget(
                            label: 'Localidade:',
                            value: state.cep.localidade,
                          ),
                          const Divider(
                            color: Colors.green,
                          ),
                          AddressSectionWidget(
                            label: 'UF:',
                            value: state.cep.uf,
                          ),
                          const Divider(
                            color: Colors.green,
                          ),
                          AddressSectionWidget(
                            label: 'IBGE:',
                            value: state.cep.ibge,
                          ),
                          const Divider(
                            color: Colors.green,
                          ),
                          AddressSectionWidget(
                            label: 'GIA:',
                            value: state.cep.gia,
                          ),
                          const Divider(
                            color: Colors.green,
                          ),
                          AddressSectionWidget(
                            label: 'DDD:',
                            value: state.cep.ddd,
                          ),
                          const Divider(
                            color: Colors.green,
                          ),
                          AddressSectionWidget(
                            label: 'SIAFI:',
                            value: state.cep.siafi,
                          ),
                          const Divider(
                            color: Colors.green,
                          ),
                        ],
                      ),
                    );
                  }

                  return const SizedBox();
                },
              ),
            ],
          );
        },
      ),
    );
  }

  void _getCepEvent() {
    _cepBloc.add(
      GetCepEvent(
        cep: _textEditingController.text,
      ),
    );
  }
}
