import 'package:flutter/material.dart';

void main() => runApp(const BloqueoApp());

class BloqueoApp extends StatelessWidget {
  const BloqueoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bloqueo Por Momento Jejeejj',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const PantallaBloqueo(),
    );
  }
}

/// Mockup de la pantalla de bloqueo (futurista).
/// Muestra el mensaje configurable del bloqueo (RF-07).
class PantallaBloqueo extends StatefulWidget {
  const PantallaBloqueo({super.key, this.appNombre = 'Instagram', this.mensaje});

  final String appNombre;
  final String? mensaje;

  @override
  State<PantallaBloqueo> createState() => _PantallaBloqueoState();
}

class _PantallaBloqueoState extends State<PantallaBloqueo>
    with TickerProviderStateMixin {
  late final AnimationController _entrada;
  late final Animation<double> _opacidad;
  late final Animation<double> _escala;
  late final AnimationController _resplandor;

  @override
  void initState() {
    super.initState();
    _entrada = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    );
    _opacidad = CurvedAnimation(parent: _entrada, curve: Curves.easeOut);
    _escala = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _entrada, curve: Curves.easeOutBack));
    _resplandor = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _entrada.forward();
  }

  @override
  void dispose() {
    _entrada.dispose();
    _resplandor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050510),
      body: Stack(
        children: [
          _resplandorNaranja(),
          _resplandorVioleta(),
          SafeArea(
            child: Center(
              child: FadeTransition(
                opacity: _opacidad,
                child: ScaleTransition(
                  scale: _escala,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _iconoBloqueado(),
                      const SizedBox(height: 28),
                      Text(
                        'Está bloqueado',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.appNombre,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Esta aplicación está en modo enfoque',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white54,
                        ),
                      ),
                      const SizedBox(height: 30),
                      _tarjetaMensaje(),
                      const SizedBox(height: 34),
                      _botonCancelar(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Resplandor naranja/índigo en el fondo (estética futurista).
  Widget _resplandorNaranja() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF7B2FF7).withValues(alpha: 0.16 * _resplandor.value),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF7B2FF7).withValues(
                alpha: 0.4 * _resplandor.value,
              ),
              blurRadius: 110 * _resplandor.value,
              spreadRadius: 30 * _resplandor.value,
            ),
          ],
        ),
      ),
    );
  }

  Widget _resplandorVioleta() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF00E5FF).withValues(alpha: 0.10 * _resplandor.value),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF00E5FF).withValues(
                alpha: 0.3 * _resplandor.value,
              ),
              blurRadius: 90 * _resplandor.value,
              spreadRadius: 24 * _resplandor.value,
            ),
          ],
        ),
      ),
    );
  }

  /// Icono de la app bloqueada con resplandor.
  Widget _iconoBloqueado() {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFF7B2FF7), Color(0xFF00E5FF)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7B2FF7),
            blurRadius: 38 * _resplandor.value,
            spreadRadius: 10 * _resplandor.value,
          ),
        ],
      ),
      child: const Center(
        child: Icon(Icons.lock_rounded, size: 46, color: Colors.white),
      ),
    );
  }

  /// Tarjeta con el mensaje configurable.
  Widget _tarjetaMensaje() {
    return Container(
      width: 320,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 26),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.14),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 30,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.mensaje ?? 'Oye, no pierdas el tiempo...',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              color: Colors.white.withValues(alpha: 0.92),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: Colors.white.withValues(alpha: 0.35),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'Cancelar bloqueo',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _botonCancelar() {
    return SizedBox(
      width: 220,
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF7B2FF7), Color(0xFF00E5FF)],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            'Salir',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
