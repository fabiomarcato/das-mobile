import 'package:flutter/material.dart';
import '../model/order.dart';
import '../repositories/order_repository.dart';

final _cpf = TextEditingController();
bool pressed = false;

_getClientOrders(BuildContext context) async {
  FutureBuilder<List<Order>>(
    future: OrderRepository().getOrders(),
    builder: (BuildContext context, snapshot) {
      if (snapshot.hasData) {
        return ListView.builder(
          itemCount: snapshot.data?.length,
          itemBuilder: (context, index) {
            final order = snapshot.data?[index];
            return ListTile(
              title: Text(order?.date! as String),
              subtitle: Text("${order?.orderId}"),
              trailing: Text('Teste'),
              leading: Text('Teste'),
            );
          },
        );
      }
      return Center(child: CircularProgressIndicator());
    },
  );
}

class ListOrder extends StatelessWidget {
  const ListOrder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Color(0xfff8f8ff),
      child: Column(
        children: <Widget>[
          Row(children: [
            Expanded(
                child: TextField(
                    controller: _cpf,
                    decoration: InputDecoration(
                        labelText: "Listar pedidos de clientes",
                        hintText: "Informe o CPF do cliente",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder()))),
            ElevatedButton(
              child: Text('Buscar'),
              onPressed: _getClientOrders(context),
            )
          ]),
          // Expanded(
          //   child: FutureBuilder<List<Order>>(
          //   future: OrderRepository().getOrders(),
          //   builder: (context, snapshot) {
          //     if (snapshot.hasData) {
          //       return ListView.builder(
          //         itemCount: snapshot.data?.length,
          //         itemBuilder: (context, index) {
          //           final order = snapshot.data?[index];
          //           return ListTile(
          //             title: Text(order?.date! as String),
          //             subtitle: Text("${order?.orderId}"),
          //             trailing: Text('Teste'),
          //             leading: Text('Teste'),
          //           );
          //         },
          //       );
          //     }
          //     return Center(child: CircularProgressIndicator());
          //   },
          // )),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    ));
  }
}

// FutureBuilder<List<Order>>(
//                   future: OrderRepository().getOrders(),
//                   builder: (context, snapshot) {
//                     if (snapshot.hasData) {
//                       return ListView.builder(
//                         itemCount: snapshot.data?.length,
//                         itemBuilder: (context, index) {
//                           final order = snapshot.data?[index];
//                           return ListTile(
//                             title: Text(order?.date! as String),
//                             subtitle: Text("${order?.orderId}"),
//                             trailing: Text('Teste'),
//                             leading: Text('Teste'),
//                           );
//                         },
//                       );
//                     }
//                     return Center(child: CircularProgressIndicator());
//                   },
//                 )

//   @override
//   Widget build(BuildContext context) {
//     return CustomScrollView(
//       slivers: <Widget>[
//         const SliverAppBar(
//           pinned: true,
//           expandedHeight: 150.0,
//           flexibleSpace: FlexibleSpaceBar(
//             title: Text('Inserir CPF do cliente'),
//           ),
//         ),
//         SliverFixedExtentList(
//           itemExtent: 100.0,
//           delegate:
//               SliverChildBuilderDelegate((BuildContext context, int index) {
//             return Container(
//               alignment: Alignment.center,
//               color: Color.fromARGB(255, 221, 235, 241),
//               child: FutureBuilder<List<Order>>(
//                 future: OrderRepository().getOrders(),
//                 builder: (context, snapshot) {
//                   if (snapshot.hasData) {
//                     return ListView.builder(
//                       itemCount: snapshot.data?.length,
//                       itemBuilder: (context, index) {
//                         final order = snapshot.data?[index];
//                         return ListTile(
//                             title: Text(order?.date! as String),
//                             subtitle: Text("${order?.orderId}"),
//                             trailing: Text('Teste'),
//                             leading: Text('Teste'));
//                       },
//                     );
//                   }
//                   return Center(child: CircularProgressIndicator());
//                 },
//               ),
//             );
//           }, childCount: 6),
//         ),
//       ],
//     );
//   }