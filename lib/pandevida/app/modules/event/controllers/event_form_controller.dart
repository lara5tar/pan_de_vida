import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pan_de_vida/pandevida/app/data/models/event_model.dart';
import 'package:pan_de_vida/pandevida/app/data/services/event_service.dart';

class EventFormController extends GetxController {
  final title = TextEditingController();
  final description = TextEditingController();
  final location = TextEditingController();
  final urlImage = TextEditingController();
  final startDate = TextEditingController();
  final endDate = TextEditingController();
  final startTime = TextEditingController();
  final endTime = TextEditingController();

  // Add isActive reactive variable
  final isRecurrent = false.obs;
  final isAllDay = false.obs;

  final endDateRecurrence = TextEditingController();

  // Lista para los días de la semana seleccionados (L, M, Mi, J, V, S, D)
  // Inicialmente todos están deseleccionados (false)
  final selectedWeekdays = List.generate(7, (index) => false).obs;

  // Add edit mode properties
  final isEditMode = false.obs;
  String? currentEventId;

  EventService eventService = EventService();

  Event? event;

  // Variables reactivas para la gestión de imágenes
  final picker = ImagePicker();
  Rx<File?> selectedImage = Rx<File?>(null);

  @override
  void onInit() {
    super.onInit();
    // Check if we received an event for editing
    if (Get.arguments != null && Get.arguments is Event) {
      final eventAux = Get.arguments as Event;
      event = eventAux;
      loadEventData(eventAux);
    }
  }

  void toggleWeekday(int dayIndex, bool value) {
    selectedWeekdays[dayIndex] = value;
  }

  // Method to load existing event data
  void loadEventData(Event event) {
    isEditMode.value = true;
    currentEventId = event.id;

    title.text = event.title;
    description.text = event.description;
    location.text = event.location;
    urlImage.text = event.urlImage;
    startDate.text = event.startDate;
    endDate.text = event.endDate;
    startTime.text = event.startTime;
    endTime.text = event.endTime;

    isRecurrent.value = event.isRecurrent;
    isAllDay.value = event.isAllDay;
    endDateRecurrence.text = event.endDateRecurrence;

    // Load selected weekdays
    if (event.isRecurrent && event.daysOfWeek.isNotEmpty) {
      final List<String> weekdays = ['L', 'M', 'Mi', 'J', 'V', 'S', 'D'];
      final List<String> selectedDays = event.daysOfWeek.split(', ');

      for (int i = 0; i < weekdays.length; i++) {
        selectedWeekdays[i] = selectedDays.contains(weekdays[i]);
      }
    }
  }

  // Método para obtener los días seleccionados como string
  String getSelectedDaysString() {
    final List<String> weekdays = ['L', 'M', 'Mi', 'J', 'V', 'S', 'D'];
    final List<String> selected = [];

    for (int i = 0; i < 7; i++) {
      if (selectedWeekdays[i]) {
        selected.add(weekdays[i]);
      }
    }

    return selected.join(', ');
  }

  void guardar() async {
    if (title.text.isEmpty ||
        description.text.isEmpty ||
        location.text.isEmpty ||
        urlImage.text.isEmpty) {
      errorDialog();
      return;
    }

    if (!isRecurrent.value && (startDate.text.isEmpty)) {
      errorDialog();
      return;
    }

    if (isRecurrent.value && (getSelectedDaysString().isEmpty)) {
      errorDialog();
      return;
    }

    if (!isAllDay.value && (startTime.text.isEmpty || endTime.text.isEmpty)) {
      errorDialog();
      return;
    }

    //dialogo que no se quita al pinchar fuera
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );
    String url = '';

    if (selectedImage.value != null) {
      url = await uploadImage();
    }

    print('URL: $url');

    Event eventData = Event(
      id: isEditMode.value
          ? currentEventId!
          : '', // Use existing ID when editing
      title: title.text,
      description: description.text,
      location: location.text,
      urlImage: url.isNotEmpty ? url : urlImage.text,
      startDate: isRecurrent.value ? '' : startDate.text,
      endDate: isRecurrent.value ? '' : endDate.text,
      startTime: isAllDay.value ? '00:00' : startTime.text,
      endTime: isAllDay.value ? '23:59' : endTime.text,
      isRecurrent: isRecurrent.value,
      isAllDay: isAllDay.value,
      endDateRecurrence: endDateRecurrence.text,
      daysOfWeek: getSelectedDaysString(),
    );

    Map<String, dynamic> result;

    if (isEditMode.value) {
      result = await eventService.update(eventData);
    } else {
      result = await eventService.add(eventData);
    }

    Get.back(); // Close loading dialog

    if (result['error']) {
      Get.dialog(
        AlertDialog(
          title: const Text('Error'),
          content: Text(
              'Ocurrió un error al ${isEditMode.value ? 'actualizar' : 'guardar'} el evento'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    } else {
      Get.dialog(
        AlertDialog(
          title: const Text('Éxito'),
          content: Text(
              'El evento se ${isEditMode.value ? 'actualizó' : 'guardó'} correctamente'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
                Get.back(); // Return to previous screen after successful save
              },
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    }
  }

  errorDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Error'),
        content: const Text('Todos los campos son requeridos'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  desactivar() {
    Get.dialog(
      AlertDialog(
        title: const Text('Desactivar evento'),
        content: const Text('¿Estás seguro de desactivar este evento?'),
        actions: [
          TextButton(
            onPressed: () async {
              Get.back();
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              if (event == null) {
                Get.back();
                return;
              }
              var result = await eventService.update(
                event!.copyWith(isDesactivated: true),
              );

              if (result['error']) {
                Get.dialog(
                  AlertDialog(
                    title: const Text('Error'),
                    content:
                        const Text('Ocurrió un error al desactivar el evento'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text('Aceptar'),
                      ),
                    ],
                  ),
                );
              } else {
                Get.dialog(
                  AlertDialog(
                    title: const Text('Éxito'),
                    content: const Text('El evento se desactivó correctamente'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Get.back();
                          Get.back();
                        },
                        child: const Text('Aceptar'),
                      ),
                    ],
                  ),
                );
              }
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  void seleccionarImagen() async {
    await pickImage();

    Get.dialog(
      AlertDialog(
        title: const Text('Seleccionar imagen'),
        content: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selectedImage.value != null)
                Image.file(
                  selectedImage.value!,
                  width: 200,
                  height: 200,
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              selectedImage.value = null;
              urlImage.text = '';

              Get.back();
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
      urlImage.text = pickedFile.path.split('/').last;
    } else {
      Get.snackbar('Error', 'No se seleccionó ninguna imagen');
    }
  }

  Future<String> uploadImage() async {
    if (selectedImage.value == null) {
      Get.snackbar('Error', 'No se ha seleccionado ninguna imagen');
      return '';
    }

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://sistemasdevida.com/pan/eventos_img/upload_eventos_image.php'),
      );

      String nameImage = '${DateTime.now().millisecondsSinceEpoch}.jpg';

      request.files.add(
        await http.MultipartFile.fromPath('image', selectedImage.value!.path,
            filename: isEditMode.value ? urlImage.text : nameImage),
      );

      var response = await request.send();

      if (response.statusCode == 200) {
        String imageUrl = await response.stream.bytesToString();
        print(imageUrl);

        Get.snackbar('Éxito', 'Imagen subida correctamente');
        return 'https://sistemasdevida.com/pan/eventos_img/${isEditMode.value ? urlImage.text : nameImage}';
      } else {
        Get.snackbar('Error', 'No se pudo subir la imagen');
        return '';
      }
    } catch (e) {
      Get.back(); // Close loading dialog
      Get.snackbar('Error', 'Error al subir la imagen: $e');
      return '';
    }
  }
}
