// ignore_for_file: prefer_collection_literals, unnecessary_this
import 'client.dart';
import 'product.dart';
import 'dart:convert';

class Order {
  int? orderId;
  String? date;
  Client? client;
  List<OrderItems>? orderItems;

  Order({this.orderId, this.date, this.client, this.orderItems});

  Order.fromJson(Map<String, dynamic> json) {
    orderId = json['idPedido'];
    date = json['data'];
    client = json['cliente'] != null ? Client.fromJson(json['cliente']) : null;
    if (json['itensDoPedido'] != null) {
      orderItems = <OrderItems>[];
      json['itensDoPedido'].forEach((v) {
        orderItems!.add(OrderItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['data'] = this.date;
    if (this.client != null) {
      data['idCliente'] = this.client!.id;
    }
    if (this.orderItems != null) {
      data['itensDoPedido'] = this.orderItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  static List<Order> fromJsonList(String j) {
    final parsed = jsonDecode(j).cast<Map<String, dynamic>>();
    return parsed.map<Order>((map) => Order.fromJson(map)).toList();
  }
}

class OrderItems {
  int? orderItemId;
  int? quantity;
  String? clientId;
  Product? product;

  OrderItems({this.orderItemId, this.quantity, this.clientId, this.product});

  OrderItems.fromJson(Map<String, dynamic> json) {
    orderItemId = json['idItemDoPedido'];
    quantity = json['quantidade'];
    clientId = json['idCliente'];
    product =
        json['produto'] != null ? Product.fromJson(json['produto']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['quantidade'] = this.quantity;
    data['idCliente'] = this.clientId;
    if (this.product != null) {
      data['produto'] = this.product!.toJson();
    }
    return data;
  }
}
