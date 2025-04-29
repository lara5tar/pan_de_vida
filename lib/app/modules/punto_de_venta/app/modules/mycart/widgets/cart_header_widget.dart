import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../controllers/mycart_controller.dart';

class CartHeaderWidget extends GetView<MycartController> {
  const CartHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Nueva venta',
                textAlign: TextAlign.left,
                style: GoogleFonts.barlow(
                  fontSize: 36,
                  color: Colors.grey[900],
                  // fontFamily:
                  //     Theme.of(context).textTheme.bodyMedium?.fontFamily,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Expanded(child: Container()),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey[400],
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                elevation: 0,
              ),
              onPressed: () {},
              child: Icon(Symbols.settings, color: Colors.white, size: 28),
            ),
          ],
        ),
        SizedBox(height: 15),
        Row(
          children: [
            SizedBox(
              width: 80,
              child: Text(
                'CANT.',
                style: GoogleFonts.barlow(
                  color: Colors.grey[900],
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
            ),
            Expanded(
              child: Text(
                'PRODUCTO',
                style: GoogleFonts.barlow(
                    color: Colors.grey[900],
                    fontWeight: FontWeight.w800,
                    fontSize: 18),
              ),
            ),
            SizedBox(
              width: 95,
              child: Text(
                'SUBTOTAL',
                style: GoogleFonts.barlow(
                    color: Colors.grey[900],
                    fontWeight: FontWeight.w800,
                    fontSize: 18),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
