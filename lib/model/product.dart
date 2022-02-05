class Product {
  String? description;
  int? id;

  Product({this.description, this.id});

  Product.fromJson(Map<String, dynamic> json) {
    description = json['descricao'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['descricao'] = this.description;
    data['id'] = this.id;
    return data;
  }
}
