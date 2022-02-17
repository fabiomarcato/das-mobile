import 'package:dasmobile/model/client.dart';
import 'package:flutter/material.dart';
import '../repositories/client_repository.dart';

class HomeClient extends StatelessWidget {
//const HomeClient({Key? key}) : super(key: key);
  final _cpf = TextEditingController();
  final _nome = TextEditingController();
  final _sobreNome = TextEditingController();

  List<Client> Clientes = [];

  _SalvarCliente() async {
    final Client NovoCliente = Client(
        cpf: _cpf.text, name: _nome.text, lastName: _sobreNome.text, id: 0);
    ClientRepository().insertClient(NovoCliente);
  }

  _LimparCampos() async {
    _cpf.text = "";
    _nome.text = "";
    _sobreNome.text = "";
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
                      onPressed: () async {},
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
                              Row(children: [Text("")]), //Pula linha
                              Row(children: [Text("")]), //Pula linha
                              ElevatedButton(
                                child: const Text('Salvar'),
                                onPressed: () async {
                                  _SalvarCliente();
                                  _LimparCampos();
                                  Navigator.pop(context);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: const Text(
                                              "Cadastro efetuado com sucesso"),
                                          duration: const Duration(seconds: 5),
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
