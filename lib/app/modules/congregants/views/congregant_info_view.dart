import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pan_de_vida/app/modules/congregants/controllers/congregant_info_controller.dart';
import 'package:pan_de_vida/app/modules/widgets/button_widget.dart';
import 'package:pan_de_vida/app/widgets/custom_scaffold.dart';

class CongregantInfoView extends GetView<CongregantInfoController> {
  const CongregantInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomScaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextTitleWidget('Datos Generales'),
            ButtonWidget(icon: Icons.info_outline, title: 'N/A'),
            ButtonWidget(icon: Icons.person, title: 'N/A'),
            ButtonWidget(icon: Icons.calendar_month, title: 'N/A'),
            ButtonWidget(icon: Icons.wc, title: 'N/A'),
            ButtonWidget(icon: Icons.favorite, title: 'N/A'),
            ButtonWidget(icon: Icons.phone, title: 'N/A'),
            ButtonWidget(icon: Icons.smartphone, title: 'N/A'),
            ButtonWidget(icon: Icons.email, title: 'N/A'),
            ButtonWidget(
              icon: Icons.watch_later_outlined,
              title: 'N/A',
              isLast: true,
            ),
            TextTitleWidget('Datos Congregacionales'),
            ButtonWidget(icon: Icons.warning, title: 'N/A'),
            ButtonWidget(icon: Icons.train, title: 'N/A'),
            ButtonWidget(icon: Icons.apartment, title: 'N/A'),
            ButtonWidget(icon: Icons.search, title: 'N/A'),
            ButtonWidget(icon: Icons.check, title: 'N/A'),
            ButtonWidget(
              icon: Icons.check_circle_outline,
              title: 'N/A',
              isLast: true,
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class TextTitleWidget extends StatelessWidget {
  final String title;
  const TextTitleWidget(
    this.title, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Container(
        color: Colors.white.withOpacity(0.8),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
          child: Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
