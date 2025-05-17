import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class BookItem {
  final String id;
  final String title;
  final String barcode;
  final double price;
  int quantity;
  final String imageUrl;
  final TextEditingController quantityController;

  BookItem({
    required this.id,
    required this.title,
    required this.barcode,
    required this.price,
    this.quantity = 1,
    required this.imageUrl,
  }) : quantityController = TextEditingController(text: '1');

  double get totalPrice => price * quantity;
}

class CartController extends GetxController {
  // Observable list of items in cart
  final RxList<BookItem> items = <BookItem>[].obs;

  // Search related
  final searchController = TextEditingController();
  final RxList<BookItem> searchResults = <BookItem>[].obs;
  final RxBool isSearching = false.obs;

  // Customer type and discount
  final RxBool isSupplier = false.obs;
  final RxDouble supplierDiscountPercentage =
      10.0.obs; // Default 10% discount for suppliers

  // Payment receipt
  final Rx<File?> paymentReceiptImage = Rx<File?>(null);

  // Mock book database (replace with real database later)
  final List<BookItem> bookDatabase = [
    BookItem(
      id: '1',
      title: 'El principio del poder',
      barcode: '9781234567897',
      price: 350.0,
      imageUrl: 'assets/book1.jpg',
    ),
    BookItem(
      id: '2',
      title: 'Vida con propósito',
      barcode: '9789876543210',
      price: 280.0,
      imageUrl: 'assets/book2.jpg',
    ),
    BookItem(
      id: '3',
      title: 'La batalla por tu mente',
      barcode: '9785432109876',
      price: 320.0,
      imageUrl: 'assets/book3.jpg',
    ),
    BookItem(
      id: '4',
      title: 'Rompe los límites',
      barcode: '9788765432109',
      price: 290.0,
      imageUrl: 'assets/book4.jpg',
    ),
    BookItem(
      id: '5',
      title: 'Esperanza en tiempos difíciles',
      barcode: '9787654321098',
      price: 315.0,
      imageUrl: 'assets/book5.jpg',
    ),
  ];

  @override
  void onClose() {
    searchController.dispose();
    for (var item in items) {
      item.quantityController.dispose();
    }
    super.onClose();
  }

  // Search books by title or barcode
  void searchBooks(String query) {
    if (query.isEmpty) {
      searchResults.clear();
      isSearching.value = false;
      return;
    }

    isSearching.value = true;
    final results = bookDatabase.where((book) {
      return book.title.toLowerCase().contains(query.toLowerCase()) ||
          book.barcode.contains(query);
    }).toList();

    searchResults.assignAll(results);
  }

  // Search book by barcode (for scanner)
  void searchByBarcode(String barcode) {
    final results = bookDatabase.where((book) {
      return book.barcode == barcode;
    }).toList();

    searchResults.assignAll(results);
    isSearching.value = results.isNotEmpty;
  }

  // Add book to cart
  void addToCart(BookItem book) {
    final existingIndex = items.indexWhere((item) => item.id == book.id);

    if (existingIndex >= 0) {
      // Book already in cart, increment quantity
      items[existingIndex].quantity++;
      items[existingIndex].quantityController.text =
          items[existingIndex].quantity.toString();
      items.refresh();
    } else {
      // Add new book to cart
      final newBook = BookItem(
        id: book.id,
        title: book.title,
        barcode: book.barcode,
        price: book.price,
        quantity: 1,
        imageUrl: book.imageUrl,
      );
      newBook.quantityController.text = '1';
      items.add(newBook);
    }

    // Clear search and show the cart
    searchController.clear();
    searchResults.clear();
    isSearching.value = false;
  }

  // Remove book from cart
  void removeFromCart(String id) {
    items.removeWhere((item) => item.id == id);
  }

  // Increase book quantity
  void increaseQuantity(String id) {
    final index = items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      items[index].quantity++;
      items[index].quantityController.text = items[index].quantity.toString();
      items.refresh();
    }
  }

  // Decrease book quantity
  void decreaseQuantity(String id) {
    final index = items.indexWhere((item) => item.id == id);
    if (index >= 0 && items[index].quantity > 1) {
      items[index].quantity--;
      items[index].quantityController.text = items[index].quantity.toString();
      items.refresh();
    } else if (index >= 0 && items[index].quantity == 1) {
      // If quantity becomes 0, remove the item
      removeFromCart(id);
    }
  }

  // Set specific quantity for a book
  void setQuantity(String id, int quantity) {
    if (quantity <= 0) {
      removeFromCart(id);
      return;
    }

    final index = items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      items[index].quantity = quantity;
      items[index].quantityController.text = quantity.toString();
      items.refresh();
    }
  }

  // Toggle customer type (regular/supplier)
  void toggleCustomerType() {
    isSupplier.toggle();
  }

  // Update supplier discount
  void updateSupplierDiscount(double percentage) {
    supplierDiscountPercentage.value = percentage;
  }

  // Calculate subtotal
  double get subtotal {
    return items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  // Calculate discount amount
  double get discountAmount {
    return isSupplier.value
        ? (subtotal * supplierDiscountPercentage.value / 100)
        : 0;
  }

  // Calculate total
  double get total {
    return subtotal - discountAmount;
  }

  // Upload or take a photo of payment receipt
  Future<void> getPaymentReceipt(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      paymentReceiptImage.value = File(image.path);
    }
  }

  // Clear payment receipt
  void clearPaymentReceipt() {
    paymentReceiptImage.value = null;
  }

  // Complete purchase
  Future<void> completePurchase() async {
    // This is where we would send the order to a backend service
    // For now, we'll just simulate a successful purchase

    await Future.delayed(const Duration(seconds: 1));

    // Clear the cart after purchase
    items.clear();
    paymentReceiptImage.value = null;
    isSupplier.value = false;

    Get.snackbar(
      'Compra Realizada',
      'La compra se ha completado con éxito',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}
