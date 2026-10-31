import 'package:flutter_test/flutter_test.dart';

import 'package:bloqueo/features/bloqueo/domain/entidades/bloqueo.dart';
import 'package:bloqueo/features/bloqueo/domain/casos_de_uso/vigencia.dart';

Bloqueo _bloqueo({
  required String tipo,
  List<int> dias = const [],
  int horaInicio = 0,
  int horaFin = 0,
  int duracion = 0,
  DateTime? creadoEn,
  bool activo = true,
}) {
  return Bloqueo(
    id: 'test',
    appPackage: 'com.test',
    appNombre: 'Test',
    tipo: tipo,
    diasSemana: dias,
    horaInicio: horaInicio,
    horaFin: horaFin,
    duracionMinutos: duracion,
    activo: activo,
    mensaje: 'mensaje',
    creadoEn: creadoEn,
  );
}

void main() {
  group('Vigencia por tiempo', () {
    test('activo dentro de la duracion', () {
      final creado = DateTime(2026, 10, 31, 10, 0);
      final b = _bloqueo(tipo: 'tiempo', duracion: 120, creadoEn: creado);
      expect(Vigencia.estaActiva(b, DateTime(2026, 10, 31, 11, 0)), isTrue);
    });

    test('inactivo al vencer la duracion', () {
      final creado = DateTime(2026, 10, 31, 10, 0);
      final b = _bloqueo(tipo: 'tiempo', duracion: 120, creadoEn: creado);
      expect(Vigencia.estaActiva(b, DateTime(2026, 10, 31, 12, 1)), isFalse);
    });
  });

  group('Vigencia por horario', () {
    test('activo dentro del rango', () {
      final b = _bloqueo(
        tipo: 'horario',
        dias: [1, 2, 3, 4, 5],
        horaInicio: 22 * 60,
        horaFin: 4 * 60,
      );
      // Lunes 23:00
      expect(
        Vigencia.estaActiva(b, DateTime(2026, 10, 26, 23, 0)),
        isTrue,
      );
    });

    test('inactivo fuera del rango', () {
      final b = _bloqueo(
        tipo: 'horario',
        dias: [1, 2, 3, 4, 5],
        horaInicio: 22 * 60,
        horaFin: 4 * 60,
      );
      // Lunes 12:00
      expect(
        Vigencia.estaActiva(b, DateTime(2026, 10, 26, 12, 0)),
        isFalse,
      );
    });

    test('inactivo en dia no seleccionado', () {
      final b = _bloqueo(
        tipo: 'horario',
        dias: [1, 2, 3, 4, 5],
        horaInicio: 22 * 60,
        horaFin: 4 * 60,
      );
      // Sabado 23:00
      expect(
        Vigencia.estaActiva(b, DateTime(2026, 10, 31, 23, 0)),
        isFalse,
      );
    });
  });
}
