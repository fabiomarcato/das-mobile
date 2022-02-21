import 'package:flutter/material.dart';
import '../model/order.dart';
import '../model/client.dart';
import '../repositories/order_repository.dart';
import '../repositories/client_repository.dart';

class HomeOrder extends StatefulWidget {
  const HomeOrder({Key? key}) : super(key: key);

  @override
  State<HomeOrder> createState() => _HomeOrder();
}

class _HomeOrder extends State<HomeOrder> {
  bool _pinned = true;
  bool _snap = false;
  bool _floating = false;

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
                      height: 40.0,
                      width: 250,
                      child: const TextField(
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(),
                          labelText: 'Insira o CPF',
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 25),
                      height: 35.0,
                      width: 100,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 15)),
                        onPressed: () {},
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
                          child: const Text('-',
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
                return Container(
                  color: index.isOdd ? Colors.white : Colors.lightBlue[100],
                  height: 50.0,
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        child: Text('Lapiseira Marota'),
                        width: 220,
                      ),
                      Container(
                          width: 120,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(
                                Icons.remove_circle,
                                size: 18,
                                color: index.isOdd
                                    ? Colors.lightBlue
                                    : Colors.lightBlue[900],
                              ),
                              Container(
                                height: 20,
                                width: 35,
                                child: TextField(
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: OutlineInputBorder(),
                                    labelText: '0',
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.add_circle,
                                size: 18,
                                color: index.isOdd
                                    ? Colors.lightBlue
                                    : Colors.lightBlue[900],
                              ),
                            ],
                          )),
                    ],
                  )),
                );
              },
              childCount: 10,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: OverflowBar(
            overflowAlignment: OverflowBarAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 15)),
                      onPressed: () {},
                      child: const Text('Limpar'),
                    ),
                  ),
                  Container(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 15)),
                      onPressed: () {},
                      child: const Text('Salvar'),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
