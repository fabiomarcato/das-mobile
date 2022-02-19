import 'package:dasmobile/repositories/product_repository.dart';
import 'package:flutter/material.dart';

import '../model/product.dart';
import '../widgets/sliver_appbar_delegate.dart';

class HomeProduct extends StatefulWidget {
  const HomeProduct({Key? key}) : super(key: key);

  @override
  State<HomeProduct> createState() => _HomeProductState();
}

class _HomeProductState extends State<HomeProduct> {
  @override
  Widget build(BuildContext context) {
    final _controller = ScrollController();
    return Scaffold(
      body: FutureBuilder<List<Product>>(
        future: ProductRepository().getProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                final product = snapshot.data?[index];
                return Column(
                  children: [
                    if (index == 0)
                      Container(
                        height: 200,
                        child: Row(
                          children: [Text("Produtos")],
                        ),
                      ),
                    Container(
                      child: Row(
                        children: [
                          ListTile(
                            title: Text("${product?.id.toString()}"),
                            subtitle: Text("${product?.description}"),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
    // return Scaffold(
    //   body: Container(
    //     color: Color(0xfff8f8ff),
    //     child: CustomScrollView(
    //       controller: _controller,
    //       slivers: <Widget>[
    //           SliverPersistentHeader(
    //             pinned: true,
    //             delegate: SliverAppBarDelegate(
    //                 child: PreferredSize(
    //               preferredSize: Size.fromHeight(128.0),
    //               child: Container(
    //                 height: 128,
    //                 child: Text("data"),
    //               ),
    //             )),
    //           ),
    //         SliverList(
    //           delegate: SliverChildBuilderDelegate(
    //             (BuildContext context, int index) {
    //               return FutureBuilder<List<Product>>(
    //   future: ProductRepository().getProducts(),
    //   builder: (context, snapshot) {
    //     if (snapshot.hasData) {
    //       return ListView.builder(
    //         itemCount: snapshot.data?.length,

    //         itemBuilder: (context, index) {
    //           final product = snapshot.data?[index];
    //           return ListTile(
    //             title: Text("${product?.id.toString()}"),
    //             subtitle: Text("${product?.description}"),
    //           );
    //         },
    //       );
    //     }
    //     return Center(child: CircularProgressIndicator());
    //   },
    // );
    //             },
    //             childCount:8,
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
