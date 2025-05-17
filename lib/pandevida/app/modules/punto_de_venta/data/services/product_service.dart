import 'package:get/get.dart';

import '../models/product.dart';
import '../repositories/product_repository.dart';

class ProductService extends GetxService {
  var productRepository = Get.find<ProductRepository>();

  Product? readProductByCode(String code) {
    return productRepository.getProduct(code);
  }
}
