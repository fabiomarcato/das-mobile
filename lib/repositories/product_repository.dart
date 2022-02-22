import 'package:dasmobile/model/product.dart';
import '../rest/product_rest.dart';

class ProductRepository {
  final ProductRest api = ProductRest();

  Future<List<Product>> getProducts() async {
    return await api.getProducts();
  }

  Future<bool> insertProduct(Product client) async {
    return await api.insertProduct(client);
  }

  Future<bool> deleteProduct(int id) async {
    return await api.deleteProduct(id);
  }

  Future<bool> editProduct(Product product) async {
    return await api.editProduct(product);
  }
}
