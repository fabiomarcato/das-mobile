import 'package:flutter/material.dart';
import 'client/main_client.dart';
import 'order/main_order.dart';
import 'product/main_product.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyStatelessWidget(),
    );
  }
}

class MyStatelessWidget extends StatelessWidget {
  const MyStatelessWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.home),
              ),
              Tab(
                icon: Icon(Icons.group),
              ),
              Tab(
                icon: Icon(Icons.fastfood),
              ),
              Tab(
                icon: Icon(Icons.receipt_long),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                  Text("Edson Flausino Dias Junior"),
                  Text("Fábio Sanchez Marcato"),
                  Text("Jorge Miguel Carvalho Hernandes"),
                  Text("Marcello Santos Leite Ribeiro"),
                  Text("Valdir Pedroso")
                ])),
            Center(
              child: HomeClient(),
            ),
            Center(
              child: HomeProduct(),
            ),
            Center(
              child: HomeOrder(),
            )
          ],
        ),
      ),
    );
  }
}
