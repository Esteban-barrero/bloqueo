import 'package:flutter/material.dart';

import '../controlador/controlador_bloqueos.dart';
import '../../domain/entidades/bloqueo.dart';
import 'pantalla_editor.dart';
import 'pantalla_bloqueo.dart';

/// Pantalla principal: lista de bloqueos + acceso al editor y simulacion.
class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key, required this.controlador});

  final ControladorBloqueos controlador;

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  @override
  void initState() {
    super.initState();
    widget.controlador.cargar();
    widget.controlador.addListener(_onCambio);
  }

  void _onCambio() => setState(() {});

  @override
  void dispose() {
    widget.controlador.removeListener(_onCambio);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bloqueo Por Momento Jejeejj'),
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
        child: widget.controlador.cargando
            ? const Center(child: CircularProgressIndicator())
            : widget.controlador.bloqueos.isEmpty
                ? _vacio()
                : _lista(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _nuevoBloqueo,
        backgroundColor: const Color(0xFF7B2FF7),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo bloqueo'),
      ),
    );
  }

  Widget _vacio() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_open_rounded, size: 64, color: Colors.white54),
            const SizedBox(height: 16),
            const Text(
              'Aun no tienes bloqueos',
              style: TextStyle(fontSize: 18, color: Colors.white70),
            ),
            const SizedBox(height: 8),
            const Text(
              'Crea uno para proteger tu tiempo.',
              style: TextStyle(color: Colors.white54),
            ),
          ],
        ),
      ),
    );
  }

  Widget _lista() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.controlador.bloqueos.length,
      itemBuilder: (context, i) {
        final b = widget.controlador.bloqueos[i];
        return _tarjeta(b);
      },
    );
  }

  Widget _tarjeta(Bloqueo b) {
    final vigente = widget.controlador.vigentesAhora().contains(b);
    return Card(
      color: Colors.white.withValues(alpha: 0.06),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: vigente
              ? const Color(0xFF7B2FF7)
              : const Color(0xFF00E5FF),
          child: const Icon(Icons.apps, color: Colors.white),
        ),
        title: Text(b.appNombre, style: const TextStyle(color: Colors.white)),
        subtitle: Text(
          b.tipo == 'horario'
              ? 'Horario: ${_minToHora(b.horaInicio)} - ${_minToHora(b.horaFin)}'
              : 'Tiempo: ${b.duracionMinutos} min',
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.white70),
          onPressed: () => widget.controlador.eliminar(b.id),
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => PantallaBloqueo(
                appNombre: b.appNombre,
                mensaje: b.mensaje,
              ),
            ),
          );
        },
      ),
    );
  }

  void _nuevoBloqueo() async {
    final result = await Navigator.of(context).push<Bloqueo>(
      MaterialPageRoute(
        builder: (_) => PantallaEditor(controlador: widget.controlador),
      ),
    );
    if (result != null) {
      await widget.controlador.guardar(result);
    }
  }

  String _minToHora(int minutos) {
    final h = (minutos ~/ 60).toString().padLeft(2, '0');
    final m = (minutos % 60).toString().padLeft(2, '0');
    return '$h:$m';
  }
}
