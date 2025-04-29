import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/mycart_controller.dart';
import '../widgets/cart_bottom_bar_widget.dart';
import '../widgets/cart_floating_buttons_widget.dart';
import '../widgets/cart_header_widget.dart';
import '../widgets/product_widget.dart';

class MycartView extends GetView<MycartController> {
  const MycartView({super.key});

  @override
  Widget build(BuildContext context) {
    var items = controller.cartItems;
    final FocusNode focusNode = FocusNode();

    // Asegurar que el FocusNode tenga el foco cuando la vista se construye
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focusNode);
    });
    return KeyboardListener(
      focusNode: focusNode,
      onKeyEvent: (event) {
        controller.getKeyDownEvent(event);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true,
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          titleSpacing: 10,
          scrolledUnderElevation: 0,
          title: const CartHeaderWidget(),
          toolbarHeight: 100,
          backgroundColor: Colors.grey.shade50,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Obx(
            () => Column(
              children: [
                for (var item in items)
                  ProductWidget(
                    cartItem: item,
                  ),
                const SizedBox(height: 255),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const CartBottomBarWidget(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: const CartFloatingButtonsWidget(),
      ),
    );
  }
}
