import '../model/product.dart';
import '../repositories/product_repository.dart';

class ControllerProduct {
  static Future<List<Product>> getProduct() async {
    return await ProductRepository().getProducts();
  }

  static Future<bool> addProduct(String? description) async {
    return await ProductRepository()
        .insertProduct(Product(description: description!));
  }

  static Future<bool> deleteProduto(int id) async {
    return await ProductRepository().deleteProduct(id);
  }

  static Future<bool> editProduct(Product product) async {
    return await ProductRepository().editProduct(product);
  }
}
