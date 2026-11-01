import 'package:flutter/services.dart';

/// Puente con el código nativo Android (accesibilidad).
class ServicioNativo {
  ServicioNativo._();

  static const MethodChannel _canal = MethodChannel('bloqueo/nativo');

  /// Abre la pantalla de ajustes de accesibilidad del sistema.
  static Future<void> abrirAjustesAccesibilidad() async {
    try {
      await _canal.invokeMethod('abrirAccesibilidad');
    } on PlatformException {
      // En plataformas no Android no hay ajustes de accesibilidad.
    } on MissingPluginException {
      // Plataforma sin implementacion nativa.
    }
  }

  /// Abre la pantalla de informacion/ajustes de esta app
  /// (donde esta el menu de 3 puntos para "Permitir ajustes restringidos").
  static Future<void> abrirAjustesApp() async {
    try {
      await _canal.invokeMethod('abrirAjustesApp');
    } on PlatformException {
      // Ignorar.
    } on MissingPluginException {
      // Ignorar.
    }
  }

  /// Indica si el servicio de accesibilidad esta habilitado.
  static Future<bool> estaActivado() async {
    try {
      final v = await _canal.invokeMethod<bool>('estaActivado');
      return v ?? false;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }
}
