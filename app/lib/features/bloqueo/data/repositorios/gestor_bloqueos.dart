import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entidades/bloqueo.dart';

/// Persistencia local de bloqueos (sin backend, sin BD).
/// Clave única en SharedPreferences; datos sensibles del usuario.
class GestorBloqueos {
  GestorBloqueos(this._prefs);
  final SharedPreferences _prefs;
  static const String _clave = 'bloqueos';

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
    await _prefs.setString(
      _clave,
      jsonEncode(actual.map((b) => b.toJson()).toList()),
    );
  }

  Future<void> eliminar(String id) async {
    final actual = await cargar();
    actual.removeWhere((b) => b.id == id);
    await _prefs.setString(
      _clave,
      jsonEncode(actual.map((b) => b.toJson()).toList()),
    );
  }

  Future<void> limpiar() async {
    await _prefs.remove(_clave);
  }
}
