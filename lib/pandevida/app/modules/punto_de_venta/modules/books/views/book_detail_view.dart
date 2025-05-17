import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/book_detail_controller.dart';
import '../../../../../widgets/custom_scaffold.dart';
import '../../../../../widgets/button_widget.dart';
import '../../../../../widgets/text_title_widget.dart';

class BookDetailView extends GetView<BookDetailController> {
  const BookDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      setBanner: true,
      setLeading: true,
      setNotificationBar: true,
      floatingActionButton: FloatingButtonWidget(
        onPressed: controller.editBook,
        icon: Icons.edit,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.book.value == null) {
          return const Center(
            child: Text(
              'No se encontró información del libro',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          );
        }

        final book = controller.book.value!;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Detalle del Libro',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    const TextTitleWidget('Identificación'),
                    ButtonWidget(
                      text: book.id,
                      icon: Icons.qr_code,
                      title: 'Código único',
                      colorIcon: Colors.blue,
                      isLast: true,
                    ),
                    const TextTitleWidget('Información del Libro'),
                    ButtonWidget(
                      text: book.nombre,
                      icon: Icons.book,
                      title: 'Nombre del libro',
                      isLast: false,
                    ),
                    ButtonWidget(
                      text: '\$${book.precio.toStringAsFixed(2)}',
                      icon: Icons.attach_money,
                      title: 'Precio',
                      colorIcon: Colors.green,
                      isLast: true,
                    ),
                    const SizedBox(height: 16),
                    const TextTitleWidget('Inventario'),
                    ButtonWidget(
                      text: '${book.cantidadEnStock} unidades',
                      icon: Icons.inventory_2,
                      title: 'Cantidad en stock',
                      subtitle: _getStockStatus(book.cantidadEnStock),
                      colorIcon: book.cantidadEnStock > 10
                          ? Colors.green
                          : book.cantidadEnStock > 0
                              ? Colors.orange
                              : Colors.red,
                      isLast: true,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  String _getStockStatus(int stock) {
    if (stock <= 0) {
      return 'Agotado';
    } else if (stock < 5) {
      return 'Stock crítico';
    } else if (stock < 10) {
      return 'Stock bajo';
    } else {
      return 'Disponible';
    }
  }
}
