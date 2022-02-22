import 'package:flutter/material.dart';

import '../controller/con_product.dart';
import '../model/product.dart';
import 'progress_step_indicator.dart';

class HomeProduct extends StatefulWidget {
  const HomeProduct({Key? key}) : super(key: key);

  @override
  State<HomeProduct> createState() => _HomeProductState();
}

class _HomeProductState extends State<HomeProduct> {
  List<Product> items = [];
  bool _loading = true;
  String? editDescription;
  final _controller = ScrollController();
  final _description = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  _loadData() async {
    items = await ControllerProduct.getProduct();
    _loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !_loading
          ? CustomScrollView(
              controller: _controller,
              slivers: <Widget>[
                SliverAppBar(
                    pinned: true,
                    snap: false,
                    floating: false,
                    backgroundColor: Colors.lightBlue[900],
                    expandedHeight: 100.0,
                    collapsedHeight: 100.0,
                    flexibleSpace: Center(
                        child: Container(
                            child: Text(
                      "Produtos",
                      style: TextStyle(
                          color: Theme.of(context).primaryColorLight,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    )))),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return InkWell(
                        onTap: () => {
                          _showEditProduct(context, items[index]),
                        },
                        child: Container(
                          color: index.isOdd
                              ? Colors.white
                              : Colors.lightBlue[100],
                          height: 80.0,
                          child: Center(
                            child: Text(items[index].description ?? '',
                                textScaleFactor: 1),
                          ),
                        ),
                      );
                    },
                    childCount: items.length,
                  ),
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
      floatingActionButton: _floatingButton(context),
    );
  }

  _floatingButton(BuildContext context) {
    return Visibility(
      visible: !_loading,
      child: FloatingActionButton(
        onPressed: () {
          _showAddProduct(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  _showAddProduct(BuildContext context) {
    var alert = AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text(
                'Adicionar Produto',
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
          ],
        ),
        content: Form(
          key: _formKey,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextFormField(
              textAlign: TextAlign.center,
              controller: _description,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Descrição",
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Obrigatório";
                }
                return null;
              },
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              child: const Text('Salvar'),
              onPressed: () async {
                saveProduct(_description.text);
              },
            ),
          ]),
        ));
    showDialog(context: context, builder: (context) => alert);
  }

  _showEditProduct(BuildContext context, Product product) {
    var alert = AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              'Editar',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ],
        ),
        content: Form(
          key: _formKey,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextFormField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              initialValue: product.description,
              decoration: InputDecoration(
                hintText: "Descrição",
              ),
              validator: (value) {
                editDescription = value;
                if (value!.isEmpty) {
                  return "Obrigatório";
                }
                return null;
              },
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  child: const Text('Salvar'),
                  onPressed: () async {
                    editProduct(
                        Product(id: product.id, description: editDescription));
                  },
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red)),
                  child: const Text('Excluir'),
                  onPressed: () async {
                    _showDialogConfirm(context, product);
                  },
                ),
              ],
            ),
          ]),
        ));
    showDialog(context: context, builder: (context) => alert);
  }

  _showDialogConfirm(context, Product item) {
    var alert = AlertDialog(
      title: Text("Atenção"),
      content: Text("Deseja excluir esse item?"),
      actions: [
        FlatButton(
          child: Text("Não"),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
        FlatButton(
          child: Text("Sim"),
          onPressed: () async {
            deleteProduct(item.id!);
          },
        ),
      ],
    );
    showDialog(context: context, builder: (context) => alert);
  }

  void editProduct(Product product) async {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop(false);
      DialogsProgress.showLoadingDialog(context, false, "Editando Produto");
      bool checkInsert = await ControllerProduct.editProduct(product);

      if (checkInsert) {
        _loadData();
        setState(() {});
        _showToast(context, "Produto Editado");
      } else {
        _showToast(context, "Erro, tente novamente");
      }

      Navigator.of(context).pop(false);
    }
  }

  deleteProduct(int id) async {
    Navigator.of(context).pop(false);
    Navigator.of(context).pop(false);
    DialogsProgress.showLoadingDialog(context, false, "Excluindo Produto");
    bool checkInsert = await ControllerProduct.deleteProduto(id);

    if (checkInsert) {
      _loadData();
      setState(() {});
      _showToast(context, "Produto deletado");
    } else {
      _showToast(context, "Erro, tente novamente");
    }
    Navigator.of(context).pop(false);
  }

  Future<void> saveProduct(String description) async {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop(false);
      DialogsProgress.showLoadingDialog(context, false, "Salvando Produto");
      bool checkInsert = await ControllerProduct.addProduct(description);
      if (checkInsert) {
        _loadData();
        setState(() {});
        _showToast(context, "Produto Adicionado");
      } else {
        _showToast(context, "Erro, tente novamente");
      }
      Navigator.of(context).pop(false);
    }
  }

  void _showToast(BuildContext context, String text) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }
}
