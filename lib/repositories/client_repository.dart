import '../model/client.dart';
import '../rest/client_rest.dart';

class ClientRepository {
  final ClientRest api = ClientRest();

  Future<List<Client>> getClient() async {
    return await api.getClient();
  }

  Future<String> insertClient(Client client) async {
   return await api.insertClient(client);
  }

    Future<String> deleteClient(int id) async {
   return await api.DeleteClient(id);
  }

    Future<String> editClient(Client client, int id) async {
   return await api.EditClient(client, id);
  }
}
