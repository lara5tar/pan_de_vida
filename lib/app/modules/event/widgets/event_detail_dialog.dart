import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/event_model.dart';

// Muestra un diálogo con los detalles completos del evento
void showEventDetailDialog(
    Event event, String Function(String) formatDateHeader) {
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Container(
          width: Get.width * 0.9,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 5),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Imagen del evento más grande
              if (event.urlImage.isNotEmpty)
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: Container(
                    color: Colors.grey[900],
                    constraints: BoxConstraints(
                      maxHeight: Get.height * 0.5,
                    ),
                    width: double.infinity,
                    child: Image.network(
                      event.urlImage,
                      fit: BoxFit.fill,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          color: Colors.grey[200],
                          child: const Center(
                            child:
                                Icon(Icons.error, color: Colors.red, size: 40),
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 200,
                          color: Colors.grey[200],
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

              // Contenido del evento
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título del evento
                    Text(
                      event.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff0f4c75),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Fecha y horario
                    if (event.startDate.isNotEmpty)
                      _buildInfoRow(
                        Icons.calendar_today,
                        formatDateHeader(event.startDate),
                      ),

                    // Horario
                    if (!event.isAllDay)
                      _buildInfoRow(
                        Icons.access_time,
                        '${event.startTime} - ${event.endTime}',
                      )
                    else
                      _buildInfoRow(
                        Icons.access_time,
                        'Todo el día',
                      ),

                    // Ubicación
                    if (event.location.isNotEmpty)
                      _buildInfoRow(
                        Icons.location_on,
                        event.location,
                      ),

                    // Si es recurrente
                    if (event.isRecurrent && event.daysOfWeek.isNotEmpty)
                      _buildInfoRow(
                        Icons.repeat,
                        'Evento recurrente: ${event.daysOfWeek}',
                      ),

                    const SizedBox(height: 16),

                    // Descripción
                    const Text(
                      'Descripción',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff0f4c75),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      event.description,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),

              // Botón para cerrar
              Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, bottom: 16.0),
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff0f4c75),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Cerrar'),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

// Widget auxiliar para mostrar información con icono
Widget _buildInfoRow(IconData icon, String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xff3282b8)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    ),
  );
}
