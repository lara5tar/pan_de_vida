import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/cart_controller.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Punto de Venta - Libros'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: Obx(() {
              return controller.isSearching.value
                  ? _buildSearchResults()
                  : _buildCartItems();
            }),
          ),
        ],
      ),
      bottomSheet: Obx(() {
        if (controller.items.isEmpty) return const SizedBox.shrink();
        return _buildCheckoutSection();
      }),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por título o código de barras',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    controller.searchController.clear();
                    controller.searchResults.clear();
                    controller.isSearching.value = false;
                  },
                ),
              ),
              onChanged: (value) => controller.searchBooks(value),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () => _openBarcodeScanner(),
            style: IconButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return controller.searchResults.isEmpty
        ? const Center(child: Text('No se encontraron resultados'))
        : ListView.builder(
            padding: const EdgeInsets.only(bottom: 120),
            itemCount: controller.searchResults.length,
            itemBuilder: (context, index) {
              final book = controller.searchResults[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(Icons.book, color: Colors.blue[800]),
                  ),
                  title: Text(book.title),
                  subtitle: Text(
                      'Código: ${book.barcode} - Precio: \$${book.price.toStringAsFixed(2)}'),
                  trailing: ElevatedButton(
                    onPressed: () {
                      controller.addToCart(book);
                      // Mostrar un mensaje más elegante al agregar un producto
                      Get.snackbar(
                        'Agregado al carrito',
                        'Se agregó "${book.title}" al carrito',
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.green.withOpacity(0.9),
                        colorText: Colors.white,
                        duration: const Duration(seconds: 2),
                        margin: const EdgeInsets.all(10),
                        borderRadius: 10,
                        icon: const Icon(
                          Icons.check_circle_outline,
                          color: Colors.white,
                        ),
                      );
                    },
                    child: const Text('Agregar'),
                  ),
                ),
              );
            },
          );
  }

  Widget _buildCartItems() {
    return controller.items.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_cart_outlined,
                    size: 80, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'El carrito está vacío',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Busca libros para agregar al carrito',
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.only(bottom: 200),
            itemCount: controller.items.length,
            itemBuilder: (context, index) {
              final item = controller.items[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 5, right: 15, top: 10, bottom: 10),
                  child: Row(
                    children: [
                      // Botón de eliminar movido al lado izquierdo
                      IconButton(
                        icon:
                            const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => controller.removeFromCart(item.id),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Precio: \$${item.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Total: \$${(item.price * item.quantity).toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _quantityButton(
                            icon: Icons.remove,
                            onPressed: () =>
                                controller.decreaseQuantity(item.id),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            width: 60,
                            height: 34,
                            child: TextField(
                              controller: item.quantityController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide:
                                      BorderSide(color: Colors.blue.shade300),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide:
                                      BorderSide(color: Colors.blue.shade200),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: const BorderSide(
                                      color: Colors.blue, width: 1.5),
                                ),
                                isDense: true,
                                isCollapsed: true,
                              ),
                              onSubmitted: (value) {
                                final newQuantity = int.tryParse(value);
                                if (newQuantity != null && newQuantity > 0) {
                                  controller.setQuantity(item.id, newQuantity);
                                } else {
                                  item.quantityController.text =
                                      item.quantity.toString();
                                }
                              },
                            ),
                          ),
                          _quantityButton(
                            icon: Icons.add,
                            onPressed: () =>
                                controller.increaseQuantity(item.id),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }

  Widget _quantityButton(
      {required IconData icon, required VoidCallback onPressed}) {
    return Container(
      width: 34,
      height: 34, // Ajustado a 34px para coincidir
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon,
            color: Colors.white, size: 20), // Aumentado el tamaño del icono
        onPressed: onPressed,
        constraints: const BoxConstraints(),
      ),
    );
  }

  Widget _buildCheckoutSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Customer type switcher
          Row(
            children: [
              const Text(
                'Tipo de cliente:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Obx(() => Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => controller.isSupplier.value = false,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: !controller.isSupplier.value
                                    ? Colors.blue
                                    : Colors.grey[200],
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  bottomLeft: Radius.circular(8),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Regular',
                                style: TextStyle(
                                  color: !controller.isSupplier.value
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => controller.isSupplier.value = true,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: controller.isSupplier.value
                                    ? Colors.blue
                                    : Colors.grey[200],
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Proveedor',
                                style: TextStyle(
                                  color: controller.isSupplier.value
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Payment receipt section
          Row(
            children: [
              const Text(
                'Comprobante de pago:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Obx(() {
                  final hasImage = controller.paymentReceiptImage.value != null;
                  return hasImage
                      ? Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: FileImage(
                                        controller.paymentReceiptImage.value!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => controller.clearPaymentReceipt(),
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => controller
                                    .getPaymentReceipt(ImageSource.gallery),
                                icon: const Icon(Icons.photo_library),
                                label: const Text('Galería'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => controller
                                    .getPaymentReceipt(ImageSource.camera),
                                icon: const Icon(Icons.camera_alt),
                                label: const Text('Cámara'),
                              ),
                            ),
                          ],
                        );
                }),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Price summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                _buildSummaryRow(
                    'Subtotal:', '\$${controller.subtotal.toStringAsFixed(2)}'),
                Obx(() {
                  if (!controller.isSupplier.value)
                    return const SizedBox.shrink();
                  return _buildSummaryRow(
                    'Descuento (${controller.supplierDiscountPercentage.value.toStringAsFixed(0)}%):',
                    '-\$${controller.discountAmount.toStringAsFixed(2)}',
                    valueColor: Colors.green,
                  );
                }),
                const Divider(),
                _buildSummaryRow(
                  'Total:',
                  '\$${controller.total.toStringAsFixed(2)}',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Checkout button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => controller.completePurchase(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Completar Compra',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    Color? valueColor,
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  void _openBarcodeScanner() {
    Get.bottomSheet(
      SizedBox(
        height: Get.height * 0.7,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Escanear código de barras',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: MobileScanner(
                controller: MobileScannerController(
                  detectionSpeed: DetectionSpeed.normal,
                  facing: CameraFacing.back,
                ),
                onDetect: (capture) {
                  final barcodes = capture.barcodes;
                  if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
                    final barcode = barcodes.first.rawValue!;
                    controller.searchByBarcode(barcode);
                    Get.back();
                  }
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    );
  }
}
