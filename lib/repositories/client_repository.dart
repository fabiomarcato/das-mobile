import '../model/client.dart';
import '../rest/client_rest.dart';

class ClientRepository {
  final ClientRest api = ClientRest();

  Future<List<Client>> getClient() async {
    return await api.getClient();
  }

  Future<Client> insertClient(Client client) async {
   return await api.insertClient(client);
  }
}
