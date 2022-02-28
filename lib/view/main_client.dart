import 'dart:convert';
import 'package:dasmobile/model/client.dart';
import 'package:dasmobile/view/progress_step_indicator.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../repositories/client_repository.dart';
import '../model/client.dart';
import 'dart:convert' show utf8;

class HomeClient extends StatefulWidget {
  const HomeClient({Key? key}) : super(key: key);

  @override
  State<HomeClient> createState() => _HomeClientState();
}

class _HomeClientState extends State<HomeClient> {
  final _cpf = TextEditingController();
  final _nome = TextEditingController();
  final _sobreNome = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _id;
  String Retorno = "";
  final maskCpf = MaskTextInputFormatter(
      mask: "###.###.###-##", filter: {"#": RegExp(r'[0-9]')});
  List<Client> Clientes = [];

  _SalvarCliente() async {
    DialogsProgress.showLoadingDialog(context, false, "Salvando Cliente");
    final Client NovoCliente = Client(s
        cpf: _cpf.text, name: _nome.text, lastName: _sobreNome.text, id: 0);
    Retorno = await ClientRepository().insertClient(NovoCliente);
    Retorno = _utf8Decode(Retorno);
    setState(() {});
    Navigator.of(context).pop(false);
  }

  _EditCliente() async {
    DialogsProgress.showLoadingDialog(context, false, "Atualizando Cliente");
    final Client NovoCliente = Client(
        cpf: _cpf.text, name: _nome.text, lastName: _sobreNome.text, id: _id);
    Retorno = await ClientRepository().editClient(NovoCliente, _id);
    Retorno = _utf8Decode(Retorno);
    setState(() {});
    Navigator.of(context).pop(false);
  }

  _RemoveCliente(int id) async {
    DialogsProgress.showLoadingDialog(context, false, "Removendo Cliente");
    Retorno = await ClientRepository().deleteClient(id);
    Retorno = _utf8Decode(Retorno);
    setState(() {});
    Navigator.of(context).pop(false);
  }

  _LimparCampos() async {
    _cpf.text = "";
    _nome.text = "";
    _sobreNome.text = "";
  }

  _SetCampos(String cpf, String nome, String sobreNome, int id) async {
    _cpf.text = cpf;
    _nome.text = nome;
    _sobreNome.text = sobreNome;
    _id = id;
  }

  _utf8Decode(var texto) {
    var encoded = utf8.encode(texto);
    return texto = utf8.decode(encoded);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manter Cliente"),
      ),
      body: Center(
//Lista de Clientes

        child: FutureBuilder<List<Client>>(
          future: ClientRepository().getClient(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  final client = snapshot.data?[index];
                  return InkWell(
                    onTap: () async => {
                      await _SetCampos(
                          client!.cpf.toString(),
                          client.name.toString(),
                          client.lastName.toString(),
                          client.id!.toInt()),
                      showModalBottomSheet<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            height: 800,
                            color: Color.fromARGB(255, 248, 248, 248),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const Text('Editar Cliente'),
                                  Form(
                                    key: _formKey,
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextFormField(
                                            readOnly: true,
                                            controller: _cpf,
                                            decoration: InputDecoration(),
                                            keyboardType: TextInputType.text,
                                            validator: (value1) {
                                              if (value1!.isEmpty) {
                                                return "Obrigatório";
                                              }
                                              return null;
                                            },
                                          ),
                                          TextFormField(
                                            controller: _nome,
                                            decoration: InputDecoration(
                                              hintText: "Nome",
                                            ),
                                            keyboardType: TextInputType.text,
                                            validator: (value1) {
                                              if (value1!.isEmpty) {
                                                return "Obrigatório";
                                              }
                                              return null;
                                            },
                                          ),
                                          TextFormField(
                                            controller: _sobreNome,
                                            decoration: InputDecoration(),
                                            keyboardType: TextInputType.text,
                                            validator: (value1) {
                                              if (value1!.isEmpty) {
                                                return "Obrigatório";
                                              }
                                              return null;
                                            },
                                          )
                                        ]),
                                  ),
                                  Row(children: const [Text("")]), //Pula linha
                                  Row(children: const [Text("")]), //Pula linha
                                  Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        ElevatedButton(
                                          child: const Text('Atualizar'),
                                          onPressed: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              await _EditCliente();
                                              await _LimparCampos();
                                              Navigator.pop(context);

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(Retorno),
                                                      duration: const Duration(
                                                          seconds: 10),
                                                      action: SnackBarAction(
                                                        label: "OK",
                                                        onPressed: () {},
                                                      )));
                                            }
                                          },
                                        ),
                                        ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.red),
                                          ),
                                          child: const Text('Excluir'),
                                          onPressed: () async {
                                            await _RemoveCliente(
                                                client.id!.toInt());
                                            await _LimparCampos();
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(Retorno),
                                                    duration: const Duration(
                                                        seconds: 10),
                                                    action: SnackBarAction(
                                                      label: "OK",
                                                      onPressed: () {},
                                                    )));
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                  Row(children: const [Text("")]), //Pula linha
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    },
                    child: ListTile(
                      title: Text("${client?.cpf}"),
                      subtitle: Text("${_utf8Decode(client?.name as String)}"),
                    ),
                  );
                },
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text("Deseja Cadastrar um Cliente?"),
              duration: const Duration(seconds: 5),
              action: SnackBarAction(
                label: "SIM",
                onPressed: () {
                  _LimparCampos();
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 800,
                        color: Color.fromARGB(130, 248, 248, 248),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const Text('Cadastro de Cliente'),
                              Form(
                                key: _formKey,
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextFormField(
                                        inputFormatters: [maskCpf],
                                        controller: _cpf,
                                        decoration: InputDecoration(
                                          hintText: "CPF",
                                        ),
                                        keyboardType: TextInputType.text,
                                        validator: (value1) {
                                          if (value1!.isEmpty) {
                                            return "Obrigatório";
                                          }
                                          return null;
                                        },
                                      ),

                                      TextFormField(
                                        controller: _nome,
                                        decoration: InputDecoration(
                                          hintText: "Nome",
                                        ),
                                        keyboardType: TextInputType.text,
                                        validator: (value2) {
                                          if (value2!.isEmpty) {
                                            return "Obrigatório";
                                          }
                                          return null;
                                        },
                                      ),

                                      TextFormField(
                                        controller: _sobreNome,
                                        decoration: InputDecoration(
                                          hintText: "SobreNome",
                                        ),
                                        keyboardType: TextInputType.text,
                                        validator: (value3) {
                                          if (value3!.isEmpty) {
                                            return "Obrigatório";
                                          }
                                          return null;
                                        },
                                      ), // Expanded
                                      // children
                                    ]),
                              ),
                              Row(children: const [Text("")]), //Pula linha
                              ElevatedButton(
                                child: const Text('Salvar'),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    await _SalvarCliente();
                                    await _LimparCampos();
                                    Navigator.pop(context);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(Retorno),
                                            duration:
                                                const Duration(seconds: 15),
                                            action: SnackBarAction(
                                              label: "OK",
                                              onPressed: () {},
                                            )));
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              )));
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
