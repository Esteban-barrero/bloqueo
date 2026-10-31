import 'package:flutter/material.dart';

/// Tema cósmico: espacio profundo, nebula y neón.
/// Paleta futurista para la app "Bloqueo Por Momento Jejeejj".
class Cosmico {
  Cosmico._();

  // Fondo espacio profundo.
  static const Color fondo = Color(0xFF050512);
  static const Color fondoSecundario = Color(0xFF0B0033);
  static const Color fondoTerciario = Color(0xFF12003A);

  // Neón.
  static const Color violeta = Color(0xFF7B2FF7);
  static const Color cian = Color(0xFF00E5FF);
  static const Color magenta = Color(0xFFFF00FF);
  static const Color azul = Color(0xFF2979FF);

  // Texto.
  static const Color textoPrincipal = Colors.white;
  static const Color textoSecundario = Colors.white70;
  static const Color textoTenue = Colors.white54;

  // Degradados.
  static const LinearGradient degradadoFondo = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [fondoSecundario, fondoTerciario, fondo],
  );

  static const LinearGradient degradadoNeon = LinearGradient(
    colors: [violeta, cian],
  );

  static const LinearGradient degradadoCosmico = LinearGradient(
    colors: [violeta, magenta, cian],
  );

  static ThemeData tema() {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: fondo,
      colorScheme: ColorScheme.dark(
        primary: violeta,
        secondary: cian,
        surface: fondoSecundario,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: textoPrincipal,
      ),
    );
  }
}
