import 'dart:convert';

class Client {
  String? cpf;
  String? name;
  String? lastName;
  int? id;

  Client({this.cpf, this.name, this.lastName, this.id});

  Client.fromJson(Map<String, dynamic> json) {
    cpf = json['cpf'];
    name = json['nome'];
    lastName = json['sobreNome'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['cpf'] = this.cpf;
    data['nome'] = this.name;
    data['sobreNome'] = this.lastName;
    data['id'] = this.id;
    return data;
  }

  static List<Client> fromJsonList(String j) {
    final parsed = jsonDecode(j).cast<Map<String, dynamic>>();
    return parsed.map<Client>((map) => Client.fromJson(map)).toList();
  }

  @override
  String toString() {
    return 'Cliente{CPF: $cpf, Nome: $name, SobreNome: $lastName}';
  }
}
