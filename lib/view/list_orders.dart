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
  bool _loading = true;
  bool _pinned = true;
  bool _snap = false;
  bool _floating = false;

  _loadOrders(cpf) async {
    orders = await OrderRepository().getClientOrders(cpf);
    _loading = false;
    setState(() {});
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
        SliverToBoxAdapter(
          child: Container(
            height: 75,
            color: Colors.white12,
            child: Center(
                child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    height: 20.0,
                    width: 220,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.lightBlue)),
                    child: Align(
                        alignment: Alignment.center,
                        child: Text('Nome Cliente',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                            textAlign: TextAlign.center)),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    height: 20.0,
                    width: 150,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.lightBlue)),
                    child: Align(
                        alignment: Alignment.center,
                        child: const Text('CPF',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                            textAlign: TextAlign.center)),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 25.0,
                    width: 220,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.lightBlue)),
                    child: Align(
                        alignment: Alignment.center,
                        child: const Text('-',
                            style: TextStyle(fontSize: 12, color: Colors.black),
                            textAlign: TextAlign.center)),
                  ),
                  Container(
                    height: 25.0,
                    width: 150,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.lightBlue)),
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(_cpf.text,
                            style: TextStyle(fontSize: 12, color: Colors.black),
                            textAlign: TextAlign.center)),
                  ),
                ],
              )
            ])),
          ),
        ),
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
                        child: Text('${order.orderId}'),
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
                        onPressed: () async {},
                        child: const Text('Ver'),
                      )),
                    ],
                  )),
                );
              }
              orders = [];
            },
            childCount: orders.length,
          ),
        ),
      ],
    ));
  }
}
