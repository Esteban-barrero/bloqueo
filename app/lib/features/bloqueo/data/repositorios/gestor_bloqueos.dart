import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entidades/bloqueo.dart';

/// Persistencia local de bloqueos (sin backend, sin BD).
/// Clave única en SharedPreferences; datos sensibles del usuario.
///
/// Además de la lista principal, escribe una copia simplificada en
/// `bloqueos_nativo` para que el Accessibility Service de Android pueda
/// leerla y bloquear las aplicaciones de verdad.
class GestorBloqueos {
  GestorBloqueos(this._prefs);
  final SharedPreferences _prefs;

  static const String _clave = 'bloqueos';
  static const String _claveNativa = 'bloqueos_nativo';

  Future<List<Bloqueo>> cargar() async {
    final raw = _prefs.getString(_clave);
    if (raw == null || raw.isEmpty) return <Bloqueo>[];
    final lista = jsonDecode(raw) as List<dynamic>;
    return lista
        .map((e) => Bloqueo.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> guardar(Bloqueo bloqueo) async {
    final actual = await cargar();
    final idx = actual.indexWhere((b) => b.id == bloqueo.id);
    if (idx >= 0) {
      actual[idx] = bloqueo;
    } else {
      actual.add(bloqueo);
    }
    await _guardarLista(actual);
  }

  Future<void> eliminar(String id) async {
    final actual = await cargar();
    actual.removeWhere((b) => b.id == id);
    await _guardarLista(actual);
  }

  Future<void> limpiar() async {
    await _prefs.remove(_clave);
    await _prefs.remove(_claveNativa);
  }

  /// Persiste la lista principal y su versión para el servicio nativo.
  Future<void> _guardarLista(List<Bloqueo> lista) async {
    await _prefs.setString(
      _clave,
      jsonEncode(lista.map((b) => b.toJson()).toList()),
    );
    await _prefs.setString(
      _claveNativa,
      jsonEncode(
        lista
            .map((b) => {
                  'appPackage': b.appPackage,
                  'appNombre': b.appNombre,
                  'tipo': b.tipo,
                  'diasSemana': b.diasSemana,
                  'horaInicio': b.horaInicio,
                  'horaFin': b.horaFin,
                  'duracionMinutos': b.duracionMinutos,
                  'activo': b.activo,
                  'mensaje': b.mensaje,
                  'creadoEnMs': b.creadoEn?.millisecondsSinceEpoch ?? 0,
                })
            .toList(),
      ),
    );
  }
}
