import 'package:dasmobile/model/product.dart';
import '../rest/product_rest.dart';

class ProductRepository {
  final ProductRest api = ProductRest();

  Future<List<Product>> getProducts() async {
    return await api.getProducts();
  }
}
