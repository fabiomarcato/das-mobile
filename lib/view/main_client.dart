import 'dart:convert';
import 'package:dasmobile/model/client.dart';
import 'package:flutter/material.dart';
import '../repositories/client_repository.dart';
import '../model/client.dart';


class HomeClient extends StatelessWidget {

  final _cpf = TextEditingController();
  final _nome = TextEditingController();
  final _sobreNome = TextEditingController();
  var _id;
  String Retorno = "";
  List<Client> Clientes = [];

  _SalvarCliente() async {
    final Client NovoCliente = Client(
        cpf: _cpf.text, name: _nome.text, lastName: _sobreNome.text, id: 0);      
    Retorno =  await ClientRepository().insertClient(NovoCliente);
    Retorno = json.decode(Retorno)['Status'];
  }

  _EditCliente() async {
    final Client NovoCliente = Client(
        cpf: _cpf.text, name: _nome.text, lastName: _sobreNome.text, id: _id);      
    Retorno =  await ClientRepository().editClient(NovoCliente,_id);
    Retorno = json.decode(Retorno)['Status'];
  }

  _RemoveCliente(int id) async {
    Retorno = await ClientRepository().removeClient(id);
    Retorno = json.decode(Retorno)['Status'];
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
                  return ListTile(
                    title: Text("${client?.cpf}"),
                    subtitle: Text("${client?.name}"),
                    trailing: ElevatedButton(
                      child: const Text('Editar'),
                      onPressed: () async {
                       await _SetCampos(client!.cpf.toString(), client.name.toString(), client.lastName.toString(),client.id!.toInt());
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
                              Row(children: [
                                const Text("CPF: "),
                                Expanded(
                                    child: TextField(
                                        readOnly: true,
                                        controller: _cpf,
                                        decoration: InputDecoration(),
                                        keyboardType: 
                                            TextInputType.text)) // Expanded
                              ] // children
                                  ),
                              Row(children: [
                                const Text("Nome: "),
                                Expanded(
                                    child: TextField(
                                        controller: _nome,
                                        decoration: InputDecoration(),
                                        keyboardType:
                                            TextInputType.text)) // Expanded
                              ] // children
                                  ),
                              Row(children: [
                                const Text("Sobre Nome: "),
                                Expanded(
                                    child: TextField(
                                        controller: _sobreNome,
                                        decoration: InputDecoration(),
                                        keyboardType:
                                            TextInputType.text)) // Expanded
                              ] // children
                                  ),
                              Row(children: const [Text("")]), //Pula linha
                              Row(children: const [Text("")]), //Pula linha
                              ElevatedButton(
                                child: const Text('Atualizar'),
                                onPressed: () async {
                                 await  _EditCliente();
                                 await  _LimparCampos();
                                  Navigator.pop(context);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              Retorno),
                                          duration: const Duration(seconds: 10),
                                          action: SnackBarAction(
                                            label: "OK",
                                            onPressed: () {},
                                          )));
                                },
                              ),
                              Row(children: const [Text("")]), //Pula linha
                              ElevatedButton(
                                child: const Text('Excluir'),
                                onPressed: () async {
                                await  _RemoveCliente(client.id!.toInt());
                                 await  _LimparCampos();
                                  Navigator.pop(context);
                                  

                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              Retorno),
                                          duration: const Duration(seconds: 10),
                                          action: SnackBarAction(
                                            label: "OK",
                                            onPressed: () {},
                                          )));
                                },
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                    },
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
                        color: Color.fromARGB(255, 248, 248, 248),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const Text('Cadastro de Cliente'),
                              Row(children: [
                                const Text("CPF: "),
                                Expanded(
                                    child: TextField(
                                        controller: _cpf,
                                        decoration: InputDecoration(),
                                        keyboardType:
                                            TextInputType.text)) // Expanded
                              ] // children
                                  ),
                              Row(children: [
                                const Text("Nome: "),
                                Expanded(
                                    child: TextField(
                                        controller: _nome,
                                        decoration: InputDecoration(),
                                        keyboardType:
                                            TextInputType.text)) // Expanded
                              ] // children
                                  ),
                              Row(children: [
                                const Text("Sobre Nome: "),
                                Expanded(
                                    child: TextField(
                                        controller: _sobreNome,
                                        decoration: InputDecoration(),
                                        keyboardType:
                                            TextInputType.text)) // Expanded
                              ] // children
                                  ),
                              Row(children: const [Text("")]), //Pula linha
                              Row(children: const [Text("")]), //Pula linha
                              ElevatedButton(
                                child: const Text('Salvar'),
                                onPressed: () async {
                                 await  _SalvarCliente();
                                 await  _LimparCampos();
                                  Navigator.pop(context);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              Retorno),
                                          duration: const Duration(seconds: 10),
                                          action: SnackBarAction(
                                            label: "OK",
                                            onPressed: () {},
                                          )));
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
