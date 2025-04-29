import '../models/product.dart';

class ProductRepository {
  var products = {
    "75000608": {
      "name": "Cloro 500ml",
      "price": 20.00,
    },
    "7501025462017": {
      "name": "Pinol 800ml",
      "price": 28.00,
    },
    "75055": {
      "name": "Puré de tomate del fuerte 345g",
      "price": 14.00,
    },
    "502236562466": {
      "name": "Suatun",
      "price": 10.00,
    },
    "38545010481": {
      "name": "Salsa botanera 370ml",
      "price": 15.00,
    },
    "500478044221": {
      "name": "Rufles queso chico",
      "price": 18.00,
    },
    "501011123588": {
      "name": "Doritos nacho chico",
      "price": 18.00,
    },
    "04722005833": {
      "name": "Papirringas chico",
      "price": 18.00,
    },
    "500478022502": {
      "name": "Emperador limón",
      "price": 18.00,
    },
    "500810032985": {
      "name": "Pan bimbo chico",
      "price": 38.00,
    },
    "500810014738": {
      "name": "Barritas piña",
      "price": 16.00,
    },
    "500478044146": {
      "name": "Paketaxo amarillo",
      "price": 18.00,
    },
    "503031287820": {
      "name": "Panditas bomba",
      "price": 15.00,
    },
    "ttpsÑ--qrco.de-bcG0dw": {
      "name": "Rexal",
      "price": 10.00,
    },
    "501030464242": {
      "name": "Doraditas Tia Rosa",
      "price": 22.00,
    },
  };

  Product? getProduct(String code) {
    if (!products.containsKey(code)) {
      return null;
    }
    var product = products[code];
    return Product(
      code: code,
      name: product!['name'] as String,
      price: product['price'] as double,
      codeType: CodeType.EAN,
      imageUrl: '',
      category: '',
    );
  }
}
