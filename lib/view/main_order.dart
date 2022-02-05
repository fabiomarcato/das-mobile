import 'package:flutter/material.dart';
import '../model/order.dart';
import '../repositories/order_repository.dart';

class HomeOrder extends StatelessWidget {
  const HomeOrder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Order>>(
      future: OrderRepository().getOrders(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data?.length,
            itemBuilder: (context, index) {
              final order = snapshot.data?[index];
              return ListTile(
                title: Text(order?.date! as String),
                subtitle: Text('order.description'),
                trailing: Text('dsadsadsa'),
              );
            },
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

Future<List<Order>> _getAll() async {
  List<Order> tempLista = <Order>[];
  OrderRepository repository = OrderRepository();
  tempLista = await repository.getOrders();
  return tempLista;
}
