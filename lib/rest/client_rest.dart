import 'dart:convert';
import '../model/client.dart';
import 'api.dart';
import 'package:http/http.dart' as http;

class ClientRest {
  Future<List<Client>> getClient() async {
    final http.Response response =
        await http.get(Uri.http(API.baseUrl, API.endpointClient));
    if (response.statusCode == 200) {
      return Client.fromJsonList(response.body);
    } else {
      throw Exception('Erro buscando todos os Clientes.');
    }
  }

    Future<Client> insertClient(Client client) async {
    final http.Response response =
        await http.post(Uri.http(API.baseUrl, API.endpointClient),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(client.toJson()));
    if (response.statusCode == 201) {
      return Client.fromJson(response.body as Map<String, dynamic>);
    } else {
      throw Exception('Erro ao Inserir Cliente.');
    }
  }
}
