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
              pinned: true,
              snap: false,
              floating: false,
              backgroundColor: Colors.lightBlue[900],
              expandedHeight: 250.0,
              collapsedHeight: 100.0,
              flexibleSpace: Container(
                  child: Column(
                children: [
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
                  )
                ],
              ))),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  color: index.isOdd ? Colors.white : Colors.lightBlue[100],
                  height: 80.0,
                  child: Center(
                    child: Text('Contruir lista de produtos aqui',
                        textScaleFactor: 1),
                  ),
                );
              },
              childCount: 20,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: OverflowBar(
            overflowAlignment: OverflowBarAlignment.center,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text('pinned'),
                  Switch(
                    onChanged: (bool val) {
                      setState(() {
                        _pinned = val;
                      });
                    },
                    value: _pinned,
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text('snap'),
                  Switch(
                    onChanged: (bool val) {
                      setState(() {
                        _snap = val;
                        // Snapping only applies when the app bar is floating.
                        _floating = _floating || _snap;
                      });
                    },
                    value: _snap,
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[Text('Botões de salvar aqui')],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
