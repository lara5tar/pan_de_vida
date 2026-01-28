import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/mycart_controller.dart';
import '../widgets/book_widget.dart';
import '../widgets/cart_bottom_bar_widget.dart';
import '../widgets/cart_floating_buttons_widget.dart';
import '../widgets/cart_header_widget.dart';

class MycartView extends GetView<MycartController> {
  const MycartView({super.key});

  @override
  Widget build(BuildContext context) {
    var items = controller.cartItems;
    final FocusNode focusNode = FocusNode();

    // Asegurar que el FocusNode tenga el foco cuando la vista se construye
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Solo enfocamos si no estamos en un diálogo
      if (!controller.inDialog.value) {
        FocusScope.of(context).requestFocus(focusNode);
      }
    });

    return KeyboardListener(
      focusNode: focusNode,
      onKeyEvent: (event) {
        // Solo procesamos eventos cuando no estamos en un diálogo
        if (!controller.inDialog.value) {
          controller.getKeyDownEvent(event);
        }
      },
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background_general.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          resizeToAvoidBottomInset:
              true, // Permitir que el contenido se desplace con el teclado
          extendBody: true,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            titleSpacing: 10,
            scrolledUnderElevation: 0,
            title: const CartHeaderWidget(),
            toolbarHeight: 100,
            backgroundColor: Colors.transparent,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
            ),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Obx(
                  () => Column(
                    children: [
                      for (var item in items)
                        BookWidget(
                          cartItem: item,
                        ),
                      const SizedBox(height: 255),
                    ],
                  ),
                ),
              ),
              // Overlay para mostrar indicador de carga
              Obx(() => controller.isLoading.value
                  ? Container(
                      color: Colors.black.withOpacity(0.3),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : const SizedBox()),
            ],
          ),
          bottomNavigationBar: const CartBottomBarWidget(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: const CartFloatingButtonsWidget(),
        ),
      ),
    );
  }
}
