import '../model/client.dart';
import '../rest/client_rest.dart';

class ClientRepository {
  final ClientRest api = ClientRest();

  Future<List<Client>> getClient() async {
    return await api.getClient();
  }


  Future<Client> getClientByCpf(String cpf) async {
    return await api.getClientByCpf(cpf);
  }

  Future<Client> insertClient(Client client) async {
    return await api.insertClient(client);
  }

    Future<String> removeClient(int id) async {
   return await api.RemoveClient(id);
  }

    Future<String> editClient(Client client, int id) async {
   return await api.EditClient(client, id);
  }
}
