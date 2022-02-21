import 'dart:convert';

import 'package:dasmobile/model/product.dart';

import 'api.dart';
import 'package:http/http.dart' as http;

class ProductRest {
  Future<List<Product>> getProducts() async {
    final http.Response response =
        await http.get(Uri.http(API.baseUrl, API.endpointProducts));
    if (response.statusCode == 200) {
      return Product.fromJsonList(response.body);
    } else {
      throw Exception('Erro buscando todos os produtos.');
    }
  }

  Future<bool> insertProduct(Product product) async {
    final http.Response response =
        await http.post(Uri.http(API.baseUrl, API.endpointProducts),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(product.toJson()));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> editProduct(Product product) async {
    final http.Response response =
        await http.put(Uri.http(API.baseUrl, API.endpointProducts+ "/" + product.id.toString()),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(product.toJson()));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteProduct(int id) async {
    final http.Response response = await http.delete(
        Uri.http(API.baseUrl, API.endpointProducts + "/" + id.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
}
