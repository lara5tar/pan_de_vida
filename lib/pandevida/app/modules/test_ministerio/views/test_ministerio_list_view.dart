import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/custom_scaffold.dart';
import '../../../widgets/elevated_button_widget.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/text_title_widget.dart';
import '../controllers/test_ministerio_list_controller.dart';

class TestMinisterioListView extends GetView<TestMinisterioListController> {
  const TestMinisterioListView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Obx(
        () => controller.isLoading.value
            ? const LoadingWidget()
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const TextTitleWidget('Tests de Ministerio'),
                    
                    for (var test in controller.tests)
                      Container(
                        // margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(15),
                          title: Text(
                            test.titulo,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          // subtitle: Padding(
                          //   padding: const EdgeInsets.only(top: 8),
                          //   child: Text(test.descripcion),
                          // ),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () => controller.toTestPreguntas(test),
                        ),
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}
