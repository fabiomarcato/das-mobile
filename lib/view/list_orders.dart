import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../model/order.dart';
import '../model/client.dart';
import '../repositories/order_repository.dart';
import '../repositories/client_repository.dart';
import 'package:brasil_fields/brasil_fields.dart';

class ListOrder extends StatefulWidget {
  const ListOrder({Key? key}) : super(key: key);

  @override
  State<ListOrder> createState() => _ListOrder();
}

class _ListOrder extends State<ListOrder> {
  final _cpf = TextEditingController();
  List<Order> orders = [];

  _loadOrders(cpf) async {
    orders = await OrderRepository().getClientOrders(cpf);
    setState(() {});
  }

  _dialogBuilder(BuildContext context, orderItem) {
    List<OrderItems> orderItems = orderItem;
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 200,
            child: Center(
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    height: 20.0,
                    width: 150,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.lightBlue)),
                    child: Align(
                        alignment: Alignment.center,
                        child: Text('Produto',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                            textAlign: TextAlign.center)),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    height: 20.0,
                    width: 70,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.lightBlue)),
                    child: Align(
                        alignment: Alignment.center,
                        child: const Text('Quantidade',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                            textAlign: TextAlign.center)),
                  ),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                    margin: EdgeInsets.only(),
                    height: 150,
                    width: 220,
                    child: ListView.builder(
                      itemCount: orderItems.length,
                      itemBuilder: (context, index) => Flexible(
                          child: Row(
                        children: [
                          Container(
                            height: 20,
                            width: 150,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.lightBlue)),
                            child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                    "${orderItems[index].product?.toJson()['descricao']}",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.black),
                                    textAlign: TextAlign.center)),
                          ),
                          Container(
                            height: 20,
                            width: 70,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.lightBlue)),
                            child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                    "${orderItems[index].quantity}",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.black),
                                    textAlign: TextAlign.center)),
                          ),
                        ],
                      )),
                    ))
              ])
            ]),
          ));
        });
  }

  _showOrder(BuildContext context, orderItem) {
    List<OrderItems> orderItems = orderItem;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('ID do cliente:'),
              content: SizedBox(
                  height: 200,
                  child: ListView.builder(
                      itemCount: orderItems.length,
                      itemBuilder: (context, index) => SizedBox(
                          height: 200,
                          child: Row(children: [
                            Text(
                                "Descrição: ${orderItems[index].product?.toJson()['descricao']}"),
                            Text("Descrição: ${orderItems[index].quantity}")
                          ])))),
              actions: [
                TextButton(
                    child: Text("Fechar"),
                    onPressed: () {
                      Navigator.of(context).pop(); // fecha a dialog
                    })
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
            pinned: false,
            snap: false,
            floating: false,
            backgroundColor: Colors.lightBlue[900],
            expandedHeight: 90.0,
            collapsedHeight: 90.0,
            flexibleSpace: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 25),
                    height: 60,
                    width: 250,
                    child: TextField(
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(),
                          labelText: 'Insira o CPF do cliente',
                        ),
                        controller: _cpf,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          CpfInputFormatter()
                        ],
                        maxLength: 14),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    height: 40.0,
                    width: 100,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 15)),
                      onPressed: () async {
                        _loadOrders(_cpf.text);
                      },
                      child: const Text('Pesquisar'),
                    ),
                  ),
                ],
              ),
            ])),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              final order = orders[index];
              if (orders.isNotEmpty) {
                return Container(
                  color: index.isOdd ? Colors.white : Colors.lightBlue[100],
                  height: 50.0,
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        child: Text('ID ${order.orderId}'),
                        width: 50,
                      ),
                      SizedBox(
                        child: Text(order.date!),
                        width: 200,
                      ),
                      SizedBox(
                          child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 15)),
                        onPressed: () async {
                          //_showOrder(context, order.orderItems);
                          _dialogBuilder(context, order.orderItems);
                        },
                        child: const Text('Ver'),
                      )),
                    ],
                  )),
                );
              }
            },
            childCount: orders.length,
          ),
        ),
      ],
    ));
  }
}
