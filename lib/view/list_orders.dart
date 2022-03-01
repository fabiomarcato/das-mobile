import 'package:dasmobile/repositories/client_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../helper/error.dart';
import '../model/order.dart';
import '../model/client.dart';
import '../repositories/order_repository.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'progress_step_indicator.dart';

class ListOrder extends StatefulWidget {
  const ListOrder({Key? key}) : super(key: key);

  @override
  State<ListOrder> createState() => _ListOrder();
}

class _ListOrder extends State<ListOrder> {
  final _cpf = TextEditingController();
  List<Order> orders = [];
  List<Client>? _client;
  String _clientName = '-';
  String _clientCpf = '-';

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
                          border: OutlineInputBorder(
                          ),
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
                        try {
                          _searchClient(_cpf.text);
                        } catch (e) {
                          showError(context, '', e.toString());
                        }
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
                          child: Text(_clientName,
                              style:
                                  TextStyle(fontSize: 12, color: Colors.black),
                              textAlign: TextAlign.center)),
                    ),
                    Container(
                      height: 25.0,
                      width: 150,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.lightBlue)),
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(_clientCpf,
                              style:
                                  TextStyle(fontSize: 12, color: Colors.black),
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
                        child: Text('ID ${order.orderId}'),
                        width: 50,
                      ),
                      SizedBox(
                        child: Text(_formatedDate(order.date!)),
                        width: 200,
                      ),
                      SizedBox(
                          child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 15)),
                        onPressed: () async {
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

  _formatedDate(String date) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String formatted =
        formatter.format(DateTime.parse(date.substring(0, 10)));
    return formatted + " | " + date.substring(11, 15);
  }

  _searchClient(cpf) async {
    final ClientRepository clientRepository = ClientRepository();
    DialogsProgress.showLoadingDialog(context, false, "Buscando cliente");
    try {
      _client = await clientRepository.getClientByCpf(cpf);
      _searchOrders(cpf);
      _clientName = _client![0].name!;
      _clientCpf = _client![0].cpf!;
      Navigator.of(context).pop(false);
    } catch (e) {
      Navigator.of(context).pop(false);
      showError(context, "", "Cliente não encontrado");
      _resetClientInfo();
      setState(() {
        orders = [];
      });
    }
  }

  _searchOrders(cpf) async {
    final OrderRepository orderRepository = OrderRepository();
    DialogsProgress.showLoadingDialog(context, false, "Buscando pedidos");
    try {
      orders = await orderRepository.getClientOrders(cpf);
      setState(() {});
      Navigator.of(context).pop(false);
    } catch (e) {
      Navigator.of(context).pop(false);
      showError(context, "", "Cliente não possui pedidos");
      _resetClientInfo();
      setState(() {
        orders = [];
      });
    }
  }

  _resetClientInfo(){
    _clientName = '-';
    _clientCpf = '-';
  }

  _dialogBuilder(BuildContext context, orderItem) {
    List<OrderItems> orderItems = orderItem;
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
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
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                                textAlign: TextAlign.center)),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 15),
                        height: 20.0,
                        width: 90,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.lightBlue)),
                        child: Align(
                            alignment: Alignment.center,
                            child: const Text('Quantidade',
                                style: TextStyle(
                                    fontSize: 15,
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
                        width: 240,
                        child: ListView.builder(
                          itemCount: orderItems.length,
                          itemBuilder: (context, index) => Flexible(
                              child: Row(
                            children: [
                              Container(
                                height: 20,
                                width: 150,
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.lightBlue)),
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                        "${orderItems[index].product?.toJson()['descricao']}",
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.black),
                                        textAlign: TextAlign.center)),
                              ),
                              Container(
                                height: 20,
                                width: 90,
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.lightBlue)),
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Text("${orderItems[index].quantity}",
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.black),
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
}
