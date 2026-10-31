import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/tema/cosmico.dart';

/// Pantalla de bloqueo (cosmica): mensaje + Desbloquear + Salir.
class PantallaBloqueo extends StatefulWidget {
  const PantallaBloqueo({
    super.key,
    this.appNombre = 'Instagram',
    this.mensaje = 'Oye, no pierdas el tiempo...',
    this.onDesbloquear,
  });

  final String appNombre;
  final String mensaje;
  final VoidCallback? onDesbloquear;

  @override
  State<PantallaBloqueo> createState() => _PantallaBloqueoState();
}

class _PantallaBloqueoState extends State<PantallaBloqueo>
    with TickerProviderStateMixin {
  late final AnimationController _entrada;
  late final Animation<double> _opacidad;
  late final Animation<double> _escala;
  late final AnimationController _resplandor;
  late String _mensaje;
  final TextEditingController _controllerMensaje = TextEditingController();

  @override
  void initState() {
    super.initState();
    _mensaje = widget.mensaje;
    _controllerMensaje.text = _mensaje;
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
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _entrada.forward();
  }

  @override
  void dispose() {
    _controllerMensaje.dispose();
    _entrada.dispose();
    _resplandor.dispose();
    super.dispose();
  }

  Future<void> _editarMensaje() async {
    _controllerMensaje.text = _mensaje;
    final nuevo = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Cosmico.fondoSecundario,
        title: const Text(
          'Mensaje de bloqueo',
          style: TextStyle(color: Cosmico.textoPrincipal),
        ),
        content: TextField(
          controller: _controllerMensaje,
          style: const TextStyle(color: Cosmico.textoPrincipal),
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Escribe el mensaje...',
            hintStyle: TextStyle(color: Cosmico.textoTenue),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white24),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Cosmico.textoSecundario),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(_controllerMensaje.text),
            child: const Text(
              'Guardar',
              style: TextStyle(color: Cosmico.cian),
            ),
          ),
        ],
      ),
    );
    if (nuevo != null && nuevo.trim().isNotEmpty) {
      setState(() => _mensaje = nuevo.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cosmico.fondo,
      body: Stack(
        children: [
          const _FondoCosmico(),
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
                          color: Cosmico.textoPrincipal,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.appNombre,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Cosmico.textoSecundario,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Esta aplicación está en modo enfoque',
                        style: TextStyle(fontSize: 13, color: Cosmico.textoTenue),
                      ),
                      const SizedBox(height: 30),
                      _tarjetaMensaje(),
                      const SizedBox(height: 24),
                      _botonDesbloquear(),
                      const SizedBox(height: 12),
                      _botonSalir(),
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

  Widget _iconoBloqueado() {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: Cosmico.degradadoNeon,
        boxShadow: [
          BoxShadow(
            color: Cosmico.violeta.withValues(alpha: 0.5 * _resplandor.value),
            blurRadius: 40,
            spreadRadius: 10,
          ),
          BoxShadow(
            color: Cosmico.cian.withValues(alpha: 0.3 * _resplandor.value),
            blurRadius: 60,
            spreadRadius: 15,
          ),
        ],
      ),
      child: const Center(
        child: Icon(Icons.lock_rounded, size: 46, color: Colors.white),
      ),
    );
  }

  Widget _tarjetaMensaje() {
    return Container(
      width: 320,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 26),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
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
          GestureDetector(
            onTap: _editarMensaje,
            child: Row(
              children: [
                const Icon(Icons.lock_rounded, color: Cosmico.cian, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _mensaje,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Cosmico.textoPrincipal.withValues(alpha: 0.92),
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _botonDesbloquear() {
    return SizedBox(
      width: 320,
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: Cosmico.degradadoNeon,
          borderRadius: BorderRadius.circular(16),
        ),
        child: TextButton(
          onPressed: widget.onDesbloquear,
          child: const Text(
            'Desbloquear',
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

  Widget _botonSalir() {
    return SizedBox(
      width: 220,
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Center(
          child: Text(
            'Salir',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Cosmico.textoPrincipal.withValues(alpha: 0.85),
            ),
          ),
        ),
      ),
    );
  }
}

/// Fondo cósmico con estrellas y nebula.
class _FondoCosmico extends StatelessWidget {
  const _FondoCosmico();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: Cosmico.degradadoFondo),
      child: CustomPaint(
        painter: _PintorEstrellas(),
        size: Size.infinite,
      ),
    );
  }
}

class _PintorEstrellas extends CustomPainter {
  static final List<_Estrella> _estrellas = List.generate(80, (i) {
    final rnd = Random(i * 9973);
    return _Estrella(
      x: rnd.nextDouble(),
      y: rnd.nextDouble(),
      r: rnd.nextDouble() * 1.6 + 0.4,
      a: rnd.nextDouble() * 0.6 + 0.2,
    );
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final e in _estrellas) {
      final paint = Paint()..color = Colors.white.withValues(alpha: e.a);
      canvas.drawCircle(
        Offset(e.x * size.width, e.y * size.height),
        e.r,
        paint,
      );
    }
    // Nebula suave.
    final nebula = Paint()
      ..shader = RadialGradient(
        colors: [
          Cosmico.violeta.withValues(alpha: 0.25),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * 0.3, size.height * 0.2),
          radius: size.width * 0.6,
        ),
      );
    canvas.drawCircle(
      Offset(size.width * 0.3, size.height * 0.2),
      size.width * 0.6,
      nebula,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Estrella {
  const _Estrella({required this.x, required this.y, required this.r, required this.a});
  final double x;
  final double y;
  final double r;
  final double a;
}
