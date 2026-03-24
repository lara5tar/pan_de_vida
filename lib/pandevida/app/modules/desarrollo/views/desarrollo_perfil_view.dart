import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/discipulo_model.dart';
import '../../../data/services/discipulos_service.dart';
import '../../../modules/congregants/controllers/congregant_profile_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/button_widget.dart';
import '../../../widgets/custom_scaffold.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/text_subtitle_widget.dart';
import '../../../widgets/text_title_widget.dart';

class DesarrolloPerfilView extends GetView<CongregantProfileController> {
  const DesarrolloPerfilView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Obx(
        () => controller.isLoading.value
            ? const LoadingWidget()
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextSubtitleWidget(
                          'ID: ${controller.congregant.codCongregant}'),
                      TextTitleWidget(
                        controller.congregant.nombreF,
                        center: true,
                      ),
                      Container(
                        color: Colors.white.withValues(alpha: 0.8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: controller.toWhatsApp,
                              label: const Text(
                                'WhatsApp',
                                style: TextStyle(color: Colors.white),
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
                                style: TextStyle(color: Colors.white),
                              ),
                              icon: const Icon(Icons.call, color: Colors.white),
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
                      // Botón Elegido (solo hasta nivel nietos)
                      if ((int.tryParse(Get.parameters['gen'] ?? '0') ?? 0) < 2)
                        Obx(
                        () => Container(
                          color: Colors.white.withValues(alpha: 0.8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                onPressed: controller.isTogglingElegido.value
                                    ? null
                                    : controller.toggleElegido,
                                label: controller.isTogglingElegido.value
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        controller.isElegido.value
                                            ? 'Elegido'
                                            : 'Elegir',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                icon: controller.isTogglingElegido.value
                                    ? const SizedBox.shrink()
                                    : Icon(
                                        controller.isElegido.value
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: Colors.white,
                                      ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: controller.isElegido.value
                                      ? Colors.amber.shade700
                                      : Colors.grey.shade600,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ButtonWidget(
                        text: 'Datos Personales',
                        icon: Icons.fingerprint,
                        onTap: () => Get.toNamed(Routes.CONGREGANT_INFO),
                      ),
                      ButtonWidget(
                        text: 'RPAS',
                        icon: Icons.star_border_outlined,
                        onTap: () => Get.toNamed(
                          Routes.DESARROLLO_RPA,
                          parameters: {
                            'id': controller.congregant.codCongregant,
                          },
                        ),
                      ),
                      ButtonWidget(
                        text: 'Asistencias',
                        icon: Icons.calendar_month_outlined,
                        onTap: () => Get.toNamed(
                          Routes.DESARROLLO_ASISTENCIAS,
                          parameters: {
                            'id': controller.congregant.codCongregant,
                          },
                        ),
                      ),
                      ButtonWidget(
                        text: 'Historial Escuelas',
                        icon: Icons.school_outlined,
                        isLast: true,
                        onTap: () => Get.toNamed(
                          Routes.DESARROLLO_ESCUELA_HISTORIAL,
                          parameters: {
                            'id': controller.congregant.codCongregant,
                          },
                        ),
                      ),
                      // ─── Sección de discípulos jerárquicos ───────────
                      if ((int.tryParse(Get.parameters['gen'] ?? '0') ?? 0) > 0)
                        _DiscipulosSection(
                          codCongregante: controller.congregant.codCongregant,
                          gen: int.tryParse(Get.parameters['gen'] ?? '1') ?? 1,
                        ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

// ── Sección jerárquica de discípulos ─────────────────────────────────────────
class _DiscipulosSection extends StatefulWidget {
  final String codCongregante;
  final int gen;

  const _DiscipulosSection({
    required this.codCongregante,
    required this.gen,
  });

  @override
  State<_DiscipulosSection> createState() => _DiscipulosSectionState();
}

class _DiscipulosSectionState extends State<_DiscipulosSection> {
  bool _isLoading = true;
  String _error = '';
  List<Discipulo> sinRegistro = [];
  List<Discipulo> noMarcador = [];
  List<Discipulo> marcador = [];

  static String _genLabel(int gen) {
    switch (gen) {
      case 1:
        return 'Nietos';
      case 2:
        return 'Bisnietos';
      case 3:
        return 'Tataranietos';
      default:
        return 'Generación $gen';
    }
  }

  @override
  void initState() {
    super.initState();
    _loadDiscipulos();
  }

  Future<void> _loadDiscipulos() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });
    final result =
        await DiscipulosService.getDiscipulosByID(widget.codCongregante);
    if (!mounted) return;
    if (result['error'] == false) {
      setState(() {
        sinRegistro = result['sinRegistro'] as List<Discipulo>;
        noMarcador = result['noMarcador'] as List<Discipulo>;
        marcador = result['marcador'] as List<Discipulo>;
        _isLoading = false;
      });
    } else {
      setState(() {
        _error = result['message'] ?? 'Error al cargar';
        _isLoading = false;
      });
    }
  }

  bool get _isEmpty =>
      sinRegistro.isEmpty && noMarcador.isEmpty && marcador.isEmpty;

  void _toPerfilDiscipulo(String id) {
    Get.delete<CongregantProfileController>(force: true);
    Get.toNamed(
      Routes.DESARROLLO_PERFIL,
      parameters: {'id': id, 'gen': (widget.gen + 1).toString()},
      preventDuplicates: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final label = _genLabel(widget.gen);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        TextTitleWidget(label),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (_error.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(_error, style: const TextStyle(color: Colors.red)),
          )
        else if (_isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            child: Text(
              'Sin discípulos',
              style: TextStyle(
                  color: Colors.grey, fontStyle: FontStyle.italic),
            ),
          )
        else ...[
          _DiscipulosGrupo(
            titulo: 'No han capturado esta semana',
            discipulos: sinRegistro,
            onTap: _toPerfilDiscipulo,
          ),
          _DiscipulosGrupo(
            titulo: 'No movieron el marcador',
            discipulos: noMarcador,
            onTap: _toPerfilDiscipulo,
          ),
          _DiscipulosGrupo(
            titulo: 'Sí movieron el marcador',
            discipulos: marcador,
            onTap: _toPerfilDiscipulo,
          ),
        ],
      ],
    );
  }
}

// ── Grupo dentro de la sección ────────────────────────────────────────────────
class _DiscipulosGrupo extends StatelessWidget {
  final String titulo;
  final List<Discipulo> discipulos;
  final void Function(String id) onTap;

  const _DiscipulosGrupo({
    required this.titulo,
    required this.discipulos,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (discipulos.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextSubtitleWidget(titulo),
        for (int i = 0; i < discipulos.length; i++)
          _DiscipuloButton(
            discipulo: discipulos[i],
            isLast: i == discipulos.length - 1,
            onTap: () => onTap(discipulos[i].codCongregante),
          ),
      ],
    );
  }
}

// ── Item individual de discípulo (mismo diseño que desarrollo_view) ───────────
class _DiscipuloButton extends StatelessWidget {
  final Discipulo discipulo;
  final bool isLast;
  final VoidCallback onTap;

  const _DiscipuloButton({
    required this.discipulo,
    required this.isLast,
    required this.onTap,
  });

  /// Convierte un color hex a Color
  Color _colorFromHex(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      return Color(int.parse('ff$hex', radix: 16));
    }
    return Colors.amber;
  }

  /// Construye el widget de la estrella si el rol no es "Creyente"
  Widget? _buildStarIcon() {
    // Si tiene rolNivel y no es "Creyente", mostrar estrella con color
    if (discipulo.rolNivel.isNotEmpty && discipulo.rolNivel != 'Creyente') {
      final color = discipulo.rolColor.isNotEmpty
          ? _colorFromHex(discipulo.rolColor)
          : Colors.amber;
      return Icon(Icons.star, size: 32, color: color);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ButtonWidget(
      title: discipulo.rolNivel.isNotEmpty ? discipulo.rolNivel : null,
      titleColor: discipulo.rolColor.isNotEmpty ? _colorFromHex(discipulo.rolColor) : null,
      showTitleAsPill: discipulo.rolNivel.isNotEmpty && discipulo.rolNivel != 'Creyente',
      text: discipulo.nombreCompleto,
      subtitle: discipulo.grupoVida,
      icon: Icons.person,
      iconWidget: _buildStarIcon(),
      onTap: onTap,
      isLast: isLast,
    );
  }
}
