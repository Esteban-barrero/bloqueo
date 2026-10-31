import 'package:flutter/foundation.dart';

import '../../domain/entidades/bloqueo.dart';
import '../../domain/casos_de_uso/vigencia.dart';
import '../../data/repositorios/gestor_bloqueos.dart';

/// Controlador de bloqueos (sin Riverpod, siguiendo convención StatefulWidget + repos).
class ControladorBloqueos extends ChangeNotifier {
  ControladorBloqueos(this._gestor);

  final GestorBloqueos _gestor;
  List<Bloqueo> _bloqueos = <Bloqueo>[];
  bool _cargando = false;

  List<Bloqueo> get bloqueos => List<Bloqueo>.unmodifiable(_bloqueos);
  bool get cargando => _cargando;

  /// Bloqueos vigentes ahora.
  List<Bloqueo> vigentesAhora() {
    final ahora = DateTime.now();
    return _bloqueos.where((b) => Vigencia.estaActiva(b, ahora)).toList();
  }

  Future<void> cargar() async {
    _cargando = true;
    notifyListeners();
    _bloqueos = await _gestor.cargar();
    _cargando = false;
    notifyListeners();
  }

  Future<void> guardar(Bloqueo bloqueo) async {
    await _gestor.guardar(bloqueo);
    await cargar();
  }

  Future<void> eliminar(String id) async {
    await _gestor.eliminar(id);
    await cargar();
  }
}
