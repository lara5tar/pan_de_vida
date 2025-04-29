import 'product.dart';

enum PaymentMethod { cash, card, transfer }

class Sale {
  final String id;
  final DateTime date;
  final double total;
  final PaymentMethod paymentMethod;
  final List<Product> products;
  final String customerName;

  Sale({
    required this.id,
    required this.date,
    required this.total,
    required this.paymentMethod,
    required this.products,
    required this.customerName,
  });

  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      id: json['id'],
      date: DateTime.parse(json['date']),
      total: json['total'].toDouble(),
      paymentMethod: PaymentMethod.values.firstWhere(
        (e) => e.toString() == 'PaymentMethod.${json['paymentMethod']}',
      ),
      products:
          List<Product>.from(json['products'].map((x) => Product.fromJson(x))),
      customerName: json['customerName'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'total': total,
        'paymentMethod': paymentMethod.toString().split('.').last,
        'products': products.map((x) => x.toJson()).toList(),
        'customerName': customerName,
      };
}
