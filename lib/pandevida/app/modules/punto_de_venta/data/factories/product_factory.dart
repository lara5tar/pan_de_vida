import '../models/product.dart';
import 'base_factory.dart';

class ProductFactory extends Factory<Product> {
  final Function(Product)? addItem;

  ProductFactory({
    this.addItem,
  });

  List<String> productsNamesWithDescription = [
    'Coca-Cola 2L',
    'Pepsi 2L',
    'Fanta 2L',
    'Sprite 2L',
    'Guarana 2L',
    'Coca-Cola 350ml',
    'Pepsi 350ml',
    'Fanta 350ml',
    'Sprite 350ml',
    'Guarana 350ml',
    'Coca-Cola 600ml',
    'Pepsi 600ml',
    'Fanta 600ml',
    'Sprite 600ml',
    'Guarana 600ml',
    'Coca-Cola 1L',
    'Pepsi 1L',
    'Fanta 1L',
    'Sprite 1L',
    'Guarana 1L',
  ];

  void addProducts(int count) {
    createMany(count).forEach((product) {
      addItem!(product);
    });
  }

  @override
  Product create() {
    return Product(
      code: faker.randomGenerator.numberOfLength(13),
      codeType: CodeType.values[random.nextInt(CodeType.values.length)],
      name: productsNamesWithDescription[random.nextInt(
        productsNamesWithDescription.length,
      )],
      imageUrl: faker.image.loremPicsum(),
      category: faker.food.dish(),
      price: double.parse(
        faker.randomGenerator
            .decimal(
              min: 1,
              scale: 2,
            )
            .toStringAsFixed(2),
      ),
    );
  }
}
