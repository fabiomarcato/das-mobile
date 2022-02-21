import 'dart:convert';

class Product {
  String? description;
  int? id;

  Product({this.description, this.id});

  Product.fromJson(Map<String, dynamic> json) {
    description = json['descricao'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['descricao'] = description;
    return data;
  }

  static List<Product> fromJsonList(String j) {
    final parsed = jsonDecode(j).cast<Map<String, dynamic>>();
    return parsed.map<Product>((map) => Product.fromJson(map)).toList();
  }
}
