import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/custom_scaffold.dart';
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
            : controller.tests.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.assignment_outlined,
                            size: 60, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          controller.errorMessage.value.isNotEmpty
                              ? controller.errorMessage.value
                              : 'No hay tests disponibles',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: controller.loadTests,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const TextTitleWidget('Tests de Ministerio'),
                        for (var test in controller.tests)
                          Container(
                            decoration: BoxDecoration(
                              color: test.completado
                                  ? Colors.grey.shade100.withOpacity(0.8)
                                  : Colors.white.withOpacity(0.8),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(15),
                              title: Text(
                                test.titulo,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: test.completado
                                      ? Colors.grey
                                      : Colors.black87,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (test.descripcion.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Text(
                                        test.descripcion,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: test.completado
                                              ? Colors.grey.shade400
                                              : Colors.black54,
                                        ),
                                      ),
                                    ),
                                  if (test.completado)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Row(
                                        children: [
                                          Icon(Icons.check_circle,
                                              size: 14,
                                              color: Colors.green.shade400),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Ya completado',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.green.shade400,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                              trailing: test.completado
                                  ? Icon(Icons.check_circle,
                                      color: Colors.green.shade400)
                                  : const Icon(Icons.arrow_forward_ios),
                              onTap: test.completado
                                  ? null
                                  : () => controller.toTestPreguntas(test),
                            ),
                          ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
