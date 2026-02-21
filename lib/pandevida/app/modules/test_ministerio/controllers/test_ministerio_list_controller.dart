import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../data/models/test_ministerio_model.dart';
import '../../../routes/app_pages.dart';

class TestMinisterioListController extends GetxController {
  var tests = <TestMinisterio>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadTests();
  }

  Future<void> loadTests() async {
    try {
      // Cargar los 4 tests desde los archivos JSON
      final testIds = ['test_1', 'test_2', 'test_3', 'test_4'];
      final loadedTests = <TestMinisterio>[];

      for (var testId in testIds) {
        try {
          final jsonString = await rootBundle
              .loadString('assets/tests_ministerio/$testId.json');
          final jsonData = json.decode(jsonString);
          final test = TestMinisterio.fromJson(jsonData);
          loadedTests.add(test);
        } catch (e) {
          print('Error cargando test $testId: $e');
        }
      }

      tests.value = loadedTests;
    } catch (e) {
      Get.snackbar('Error', 'No se pudieron cargar los tests');
      print('Error en loadTests: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void toTestPreguntas(TestMinisterio test) {
    Get.toNamed(
      Routes.TEST_MINISTERIO_PREGUNTAS,
      arguments: {'test': test},
    );
  }
}
