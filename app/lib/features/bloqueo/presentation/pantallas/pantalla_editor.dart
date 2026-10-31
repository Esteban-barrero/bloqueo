import 'package:flutter/material.dart';

import '../../domain/entidades/bloqueo.dart';

/// Editor de un bloqueo (app, tipo, horario/tiempo, mensaje).
class PantallaEditor extends StatefulWidget {
  const PantallaEditor({super.key, this.controlador});

  final dynamic controlador;

  @override
  State<PantallaEditor> createState() => _PantallaEditorState();
}

class _PantallaEditorState extends State<PantallaEditor> {
  final _formKey = GlobalKey<FormState>();
  final _mensajeController = TextEditingController(
    text: 'Oye, no pierdas el tiempo...',
  );
  final _appCustomController = TextEditingController();

  String _appNombre = 'Instagram';
  String _appPackage = 'com.instagram.android';
  String _tipo = 'tiempo'; // 'tiempo' | 'horario'

  // Tiempo.
  int _duracionMinutos = 120;

  // Horario.
  final Set<int> _dias = {1, 2, 3, 4, 5}; // lun-vie
  TimeOfDay _horaInicio = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _horaFin = const TimeOfDay(hour: 4, minute: 0);

  bool _usarAppCustom = false;

  static const List<Map<String, String>> _apps = [
    {'nombre': 'Instagram', 'package': 'com.instagram.android'},
    {'nombre': 'TikTok', 'package': 'com.zhiliaoapp.musically'},
    {'nombre': 'YouTube', 'package': 'com.google.android.youtube'},
    {'nombre': 'WhatsApp', 'package': 'com.whatsapp'},
    {'nombre': 'Facebook', 'package': 'com.facebook.katana'},
    {'nombre': 'Twitter / X', 'package': 'com.twitter.android'},
    {'nombre': 'Snapchat', 'package': 'com.snapchat.android'},
    {'nombre': 'Reddit', 'package': 'com.reddit.frontpage'},
    {'nombre': 'Netflix', 'package': 'com.netflix.mediaclient'},
    {'nombre': 'Twitch', 'package': 'tv.twitch.android.app'},
  ];

  @override
  void dispose() {
    _mensajeController.dispose();
    _appCustomController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarHora(bool inicio) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: inicio ? _horaInicio : _horaFin,
    );
    if (picked != null) {
      setState(() {
        if (inicio) {
          _horaInicio = picked;
        } else {
          _horaFin = picked;
        }
      });
    }
  }

  int _timeOfDayToMin(TimeOfDay t) => t.hour * 60 + t.minute;

  void _guardar() {
    if (!_formKey.currentState!.validate()) return;

    final nombre = _usarAppCustom
        ? _appCustomController.text.trim()
        : _appNombre;
    final paquete = _usarAppCustom
        ? _appCustomController.text.trim().toLowerCase().replaceAll(' ', '')
        : _appPackage;

    final bloqueo = Bloqueo(
      id: 'bloqueo-${DateTime.now().microsecondsSinceEpoch}',
      appPackage: paquete,
      appNombre: nombre,
      tipo: _tipo,
      diasSemana: _tipo == 'horario' ? _dias.toList() : <int>[],
      horaInicio: _tipo == 'horario' ? _timeOfDayToMin(_horaInicio) : 0,
      horaFin: _tipo == 'horario' ? _timeOfDayToMin(_horaFin) : 0,
      duracionMinutos: _tipo == 'tiempo' ? _duracionMinutos : 0,
      activo: true,
      mensaje: _mensajeController.text.trim().isEmpty
          ? 'Oye, no pierdas el tiempo...'
          : _mensajeController.text.trim(),
      creadoEn: DateTime.now(),
    );

    Navigator.of(context).pop(bloqueo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo bloqueo'),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0B0033), Color(0xFF12003A), Color(0xFF050510)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _seccion('Aplicación a bloquear'),
              SwitchListTile(
                title: const Text('Ingresar manualmente',
                    style: TextStyle(color: Colors.white)),
                value: _usarAppCustom,
                onChanged: (v) => setState(() => _usarAppCustom = v),
                activeThumbColor: const Color(0xFF00E5FF),
              ),
              if (!_usarAppCustom)
                DropdownButtonFormField<String>(
                  initialValue: _appNombre,
                  dropdownColor: const Color(0xFF14102B),
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Aplicación',
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                  items: _apps
                      .map((a) => DropdownMenuItem<String>(
                            value: a['nombre'],
                            child: Text(a['nombre']!),
                          ))
                      .toList(),
                  onChanged: (v) {
                    if (v == null) return;
                    final app = _apps.firstWhere((a) => a['nombre'] == v);
                    setState(() {
                      _appNombre = v;
                      _appPackage = app['package']!;
                    });
                  },
                )
              else
                TextFormField(
                  controller: _appCustomController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Nombre de la aplicación',
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Requerido' : null,
                ),
              const SizedBox(height: 16),
              _seccion('Tipo de bloqueo'),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'tiempo', label: Text('Por tiempo')),
                  ButtonSegment(value: 'horario', label: Text('Por horario')),
                ],
                selected: {_tipo},
                onSelectionChanged: (s) => setState(() => _tipo = s.first),
              ),
              const SizedBox(height: 16),
              if (_tipo == 'tiempo') ...[
                _seccion('Duración (minutos)'),
                Slider(
                  value: _duracionMinutos.toDouble(),
                  min: 5,
                  max: 480,
                  divisions: 95,
                  label: '$_duracionMinutos min',
                  activeColor: const Color(0xFF00E5FF),
                  onChanged: (v) => setState(() => _duracionMinutos = v.round()),
                ),
                Text(
                  '$_duracionMinutos minutos',
                  style: const TextStyle(color: Colors.white70),
                ),
              ] else ...[
                _seccion('Días de la semana'),
                Wrap(
                  spacing: 8,
                  children: List.generate(7, (i) {
                    final dia = (i + 1) % 7;
                    const nombres = ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'];
                    final sel = _dias.contains(dia);
                    return FilterChip(
                      label: Text(nombres[i]),
                      selected: sel,
                      onSelected: (v) => setState(() {
                        if (v) {
                          _dias.add(dia);
                        } else {
                          _dias.remove(dia);
                        }
                      }),
                      selectedColor: const Color(0xFF7B2FF7),
                      checkmarkColor: Colors.white,
                      labelStyle: const TextStyle(color: Colors.white),
                    );
                  }),
                ),
                const SizedBox(height: 16),
                _seccion('Rango horario'),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _seleccionarHora(true),
                        child: Text(
                          'Inicio: ${_horaInicio.format(context)}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _seleccionarHora(false),
                        child: Text(
                          'Fin: ${_horaFin.format(context)}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),
              _seccion('Mensaje de bloqueo'),
              TextFormField(
                controller: _mensajeController,
                style: const TextStyle(color: Colors.white),
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Escribe el mensaje que veras al bloquear...',
                  hintStyle: TextStyle(color: Colors.white54),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white24),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7B2FF7), Color(0xFF00E5FF)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextButton(
                    onPressed: _guardar,
                    child: const Text(
                      'Guardar bloqueo',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _seccion(String titulo) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 8),
      child: Text(
        titulo,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
