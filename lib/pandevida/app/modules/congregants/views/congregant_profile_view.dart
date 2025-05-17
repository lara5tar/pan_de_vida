import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pan_de_vida/pandevida/app/widgets/text_title_widget.dart';

import '../../../widgets/custom_scaffold.dart';
import '../../../widgets/button_widget.dart';
import '../../../widgets/loading_widget.dart';
import '../controllers/congregant_profile_controller.dart';

class CongregantProfileView extends GetView<CongregantProfileController> {
  const CongregantProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Obx(
        () {
          return controller.isLoading.value
              ? const LoadingWidget()
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextTitleWidget(
                          controller.congregant.nombreF,
                          center: true,
                        ),
                        // Row(
                        //   children: [
                        //     Expanded(
                        //       child: Container(
                        //         color: Colors.white.withOpacity(0.8),
                        //         child: Stack(
                        //           children: [
                        //             const Positioned(
                        //               top: 0,
                        //               child: CircleAvatar(
                        //                 radius: 70,
                        //               ),
                        //             ),
                        //             const SizedBox(height: 10),
                        //             ElevatedButton.icon(
                        //               onPressed: () {},
                        //               label: const Text(
                        //                 'Tomar Foto',
                        //                 style: TextStyle(
                        //                   color: Colors.white,
                        //                 ),
                        //               ),
                        //               icon: const Icon(Icons.camera_alt,
                        //                   color: Colors.white),
                        //               style: ElevatedButton.styleFrom(
                        //                 backgroundColor: Colors.blue.shade800,
                        //                 shape: RoundedRectangleBorder(
                        //                   borderRadius:
                        //                       BorderRadius.circular(5.0),
                        //                 ),
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        Container(
                          // padding: const EdgeInsets.all(10),
                          color: Colors.white.withOpacity(0.8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                onPressed: controller.toWhatsApp,
                                label: const Text(
                                  'WhatsApp',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                icon: const Icon(Icons.message,
                                    color: Colors.white),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton.icon(
                                onPressed: controller.toCall,
                                label: const Text(
                                  'Llamar',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                icon:
                                    const Icon(Icons.call, color: Colors.white),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ButtonWidget(
                          text: 'Datos Personales',
                          icon: Icons.fingerprint,
                          onTap: controller.toCongregantInfo,
                        ),
                        ButtonWidget(
                          text: 'Direccion',
                          icon: Icons.location_on,
                          onTap: controller.toCongregantAdress,
                        ),
                        ButtonWidget(
                          text: 'Afirmacion',
                          icon: Icons.info,
                          onTap: controller.toCongregantAffirmations,
                        ),
                        ButtonWidget(
                          text: 'Asistencia',
                          icon: Icons.school,
                          onTap: controller.toCongrengatAttendance,
                          isLast: true,
                        ),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }
}
