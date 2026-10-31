import '../entidades/bloqueo.dart';

/// Lógica de dominio: determina si un bloqueo está vigente ahora (RN-01..RN-04).
class Vigencia {
  Vigencia._();

  /// Retorna true si el bloqueo está vigente en el instante [ahora].
  static bool estaActiva(Bloqueo b, DateTime ahora) {
    if (!b.activo) return false;

    if (b.tipo == 'tiempo') {
      if (b.creadoEn == null) return false;
      final fin = b.creadoEn!.add(Duration(minutes: b.duracionMinutos));
      return !ahora.isAfter(fin);
    }

    // tipo == 'horario'
    final dia = ahora.weekday % 7; // 0=domingo..6=sabado
    if (!b.diasSemana.contains(dia)) return false;
    final minutos = ahora.hour * 60 + ahora.minute;
    if (b.horaInicio <= b.horaFin) {
      return minutos >= b.horaInicio && minutos < b.horaFin;
    }
    // Cruce de medianoche.
    return minutos >= b.horaInicio || minutos < b.horaFin;
  }
}
