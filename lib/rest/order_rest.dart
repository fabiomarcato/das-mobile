import 'api.dart';
import '../model/order.dart';
import 'package:http/http.dart' as http;

class OrderRest {
  Future<List<Order>> getOrders() async {
    final http.Response response =
        await http.get(Uri.http(API.endpoint, "pedidos"));
    if (response.statusCode == 200) {
      return Order.fromJsonList(response.body);
    } else {
      throw Exception('Erro buscando todos os pedidos.');
    }
  }

  Future<Order> insertOrder(Order order) async {
    final http.Response response =
        await http.post(Uri.http(API.endpoint, 'pedidos'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: order.toJson());
    if (response.statusCode == 201) {
      return Order.fromJson(response.body as Map<String, dynamic>);
    } else {
      throw Exception('Erro inserindo pedido.');
    }
  }
}
