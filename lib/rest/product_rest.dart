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
}
