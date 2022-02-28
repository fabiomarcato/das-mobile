import 'package:dasmobile/helper/error.dart';
import 'package:dasmobile/model/product.dart';
import 'package:dasmobile/repositories/product_repository.dart';
import 'package:flutter/material.dart';
import '../model/order.dart';
import '../model/client.dart';
import '../repositories/order_repository.dart';
import '../repositories/client_repository.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class HomeOrder extends StatefulWidget {
  const HomeOrder({Key? key}) : super(key: key);

  @override
  State<HomeOrder> createState() => _HomeOrder();
}

class _HomeOrder extends State<HomeOrder> {
  String _clientName = '-';
  String _clientCpf = '-';
  final maskCpf = MaskTextInputFormatter(
      mask: "###.###.###-##", filter: {"#": RegExp(r'[0-9]')});
  List<Client>? _client;
  List<Product> _products = [];
  List _productControllers = [];
  Order? _order;
  final _searchCpf = TextEditingController();

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
              expandedHeight: 130.0,
              collapsedHeight: 130.0,
              flexibleSpace: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Text(
                        'Pedidos',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.lightBlue[100]),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 25),
                      height: 40.0,
                      width: 250,
                      child: TextField(
                        controller: _searchCpf,
                        keyboardType: TextInputType.number,
                        inputFormatters: [maskCpf],
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
                        onPressed: () async {
                          final ClientRepository clientRepository =
                              ClientRepository();
                          try {
                            _client = await clientRepository
                                .getClientByCpfList(_searchCpf.text);
                            setState(() {
                              _clientName = _client?[0].name! as String;
                              _clientCpf = _client?[0].cpf! as String;
                            });
                            final ProductRepository productRepository =
                                ProductRepository();
                            final List<Product> products =
                                await productRepository.getProducts();
                            setState(() {
                              _products = products;
                              _productControllers =
                                  _createProductControllers(_products);
                            });
                          } catch (e) {
                            showError(context, '', 'Nenhum Cliente encontrado');
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
                return Container(
                  color: index.isOdd ? Colors.white : Colors.lightBlue[100],
                  height: 50.0,
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        child: Text('${_products[index].description}'),
                        width: 180,
                      ),
                      Container(
                          width: 160,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (int.parse(
                                              _productControllers[index].text) >
                                          0) {
                                        _productControllers[index].text =
                                            '${int.parse(_productControllers[index].text) - 1}';
                                      }
                                    });
                                  },
                                  icon: Icon(
                                    Icons.remove_circle,
                                    size: 18,
                                    color: index.isOdd
                                        ? Colors.lightBlue
                                        : Colors.lightBlue[900],
                                  )),
                              Container(
                                height: 20,
                                width: 45,
                                child: TextField(
                                  controller: _productControllers[index],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _productControllers[index].text =
                                          '${int.parse(_productControllers[index].text) + 1}';
                                    });
                                  },
                                  icon: Icon(
                                    Icons.add_circle,
                                    size: 18,
                                    color: index.isOdd
                                        ? Colors.lightBlue
                                        : Colors.lightBlue[900],
                                  )),
                            ],
                          )),
                    ],
                  )),
                );
              },
              childCount: _products.length,
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
                      onPressed: _isProductSelected(_productControllers)
                          ? () {
                              _cleanProductControllers(_productControllers);
                            }
                          : null,
                      child: const Text('Limpar'),
                    ),
                  ),
                  Container(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 15)),
                      onPressed: _isProductSelected(_productControllers)
                          ? () {
                              _order = _formatProductList(
                                  _products, _productControllers, _client);

                              showModalBottomSheet<void>(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (BuildContext context) {
                                    return Container(
                                      height: 605,
                                      color: Color.fromARGB(255, 248, 248, 248),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Column(children: [
                                              Container(
                                                margin:
                                                    EdgeInsets.only(top: 15),
                                                child: Text(
                                                  'Confirmação de Pedido',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        top: 15),
                                                    height: 20.0,
                                                    width: 220,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors
                                                                .lightBlue)),
                                                    child: Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                            'Nome Cliente',
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black),
                                                            textAlign: TextAlign
                                                                .center)),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        top: 15),
                                                    height: 20.0,
                                                    width: 150,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors
                                                                .lightBlue)),
                                                    child: Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: const Text('CPF',
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black),
                                                            textAlign: TextAlign
                                                                .center)),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    height: 25.0,
                                                    width: 220,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors
                                                                .lightBlue)),
                                                    child: Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(_clientName,
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .black),
                                                            textAlign: TextAlign
                                                                .center)),
                                                  ),
                                                  Container(
                                                    height: 25.0,
                                                    width: 150,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors
                                                                .lightBlue)),
                                                    child: Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(_clientCpf,
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .black),
                                                            textAlign: TextAlign
                                                                .center)),
                                                  ),
                                                ],
                                              )
                                            ]),
                                            Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: 25),
                                                      height: 20.0,
                                                      width: 270,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: Colors
                                                                  .lightBlue)),
                                                      child: Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text('Produto',
                                                              style: TextStyle(
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center)),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: 25),
                                                      height: 20.0,
                                                      width: 100,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: Colors
                                                                  .lightBlue)),
                                                      child: Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: const Text(
                                                              'Quantidade',
                                                              style: TextStyle(
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center)),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                    height: 400,
                                                    width: 370,
                                                    child: ListView.builder(
                                                        itemCount: _order
                                                            ?.orderItems
                                                            ?.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                height: 25.0,
                                                                width: 270,
                                                                decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .lightBlue)),
                                                                child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: Text(
                                                                        _order?.orderItems?[index].product?.description
                                                                            as String,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            color: Colors
                                                                                .black),
                                                                        textAlign:
                                                                            TextAlign.center)),
                                                              ),
                                                              Container(
                                                                height: 25.0,
                                                                width: 100,
                                                                decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .lightBlue)),
                                                                child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: Text(
                                                                        _order?.orderItems?[index].quantity.toString()
                                                                            as String,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            color: Colors
                                                                                .black),
                                                                        textAlign:
                                                                            TextAlign.center)),
                                                              ),
                                                            ],
                                                          );
                                                        })),
                                                Container(
                                                    child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                textStyle:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            15)),
                                                        onPressed: () async {
                                                          OrderRepository
                                                              _orderRepository =
                                                              OrderRepository();
                                                          final order =
                                                              _formatProductList(
                                                                  _products,
                                                                  _productControllers,
                                                                  _client);
                                                          String response =
                                                              await _orderRepository
                                                                  .insertOrder(
                                                                      order);
                                                          Navigator.pop(
                                                              context);
                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                              SnackBar(
                                                                  content: Text(
                                                                      response),
                                                                  duration:
                                                                      const Duration(
                                                                          seconds:
                                                                              10),
                                                                  action:
                                                                      SnackBarAction(
                                                                    label: "OK",
                                                                    onPressed:
                                                                        () {},
                                                                  )));
                                                          setState(() {
                                                            _order = null;
                                                            _client = null;
                                                            _clientCpf = '';
                                                            _clientName = '';
                                                            _products = [];
                                                            _productControllers =
                                                                [];
                                                          });
                                                        },
                                                        child:
                                                            Text('Finalizar'))),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            }
                          : null,
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

_createProductControllers(products) {
  List<TextEditingController> controllers = [];
  for (Product product in products) {
    controllers.add(TextEditingController(text: '0'));
  }
  return controllers;
}

_cleanProductControllers(controllers) {
  for (TextEditingController controller in controllers) {
    controller.text = '0';
  }
}

_formatProductList(products, controllers, client) {
  List<OrderItems> orderItems = [];

  for (int i = 0; i < products.length; i++) {
    if (int.parse(controllers[i].text) > 0) {
      orderItems.add(OrderItems(
        clientId: client[0].id.toString(),
        product: products[i],
        quantity: int.parse(controllers[i].text),
      ));
    }
  }

  return Order(
    date: DateTime.now().toString(),
    client: client[0],
    orderItems: orderItems,
  );
}

_isProductSelected(controllers) {
  for (TextEditingController controller in controllers) {
    if (int.parse(controller.text) > 0) {
      return true;
    }
  }
  return false;
}
