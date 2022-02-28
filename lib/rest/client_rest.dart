import 'dart:convert';
import '../model/client.dart';
import 'api.dart';
import 'package:http/http.dart' as http;

class ClientRest {
  Future<List<Client>> getClient() async {
    final http.Response response = await http.get(
        Uri.http(API.baseUrl, API.endpointClient),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=latin1',
        });
    if (response.statusCode == 200) {
      return Client.fromJsonList(response.body);
    } else {
      throw Exception('Erro buscando todos os Clientes.');
    }
  }

  Future<List<Client>> getClientByCpf(String cpf) async {
    final http.Response response = await http
        .get(Uri.http(API.baseUrl, API.endpointCpfClient + '/' + cpf));
    if (response.statusCode == 200) {
      return Client.fromJsonList(response.body);
    } else {
      throw Exception('Erro buscando Cliente por CPF.');
    }
  }

  Future<String> insertClient(Client client) async {
    final http.Response response =
        await http.post(Uri.http(API.baseUrl, API.endpointClient),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(client.toJson()));

    return response.body;
  }

  Future<String> DeleteClient(int id) async {
    final http.Response response = await http.delete(
        Uri.http(API.baseUrl, API.endpointClient + "/" + id.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });

    return response.body;
  }

  Future<String> EditClient(Client client, int id) async {
    final http.Response response = await http.put(
        Uri.http(API.baseUrl, API.endpointClient + "/" + id.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(client.toJson()));

    return response.body;
  }
}
