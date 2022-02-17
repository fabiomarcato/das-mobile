import '../rest/order_rest.dart';
import '../model/order.dart';

class OrderRepository {
  final OrderRest api = OrderRest();

  Future<List<Order>> getOrders() async {
    return await api.getOrders();
  }

  Future<List<Order>> getClientOrders(String cpf) async {
    return await api.getClientOrders(cpf);
  }

  Future<Order> insertOrder(Order order) async {
    return await api.insertOrder(order);
  }
}
