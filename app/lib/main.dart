import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/tema/cosmico.dart';
import 'features/bloqueo/data/repositorios/gestor_bloqueos.dart';
import 'features/bloqueo/presentation/controlador/controlador_bloqueos.dart';
import 'features/bloqueo/presentation/pantallas/pantalla_principal.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BloqueoApp());
}

class BloqueoApp extends StatefulWidget {
  const BloqueoApp({super.key});

  @override
  State<BloqueoApp> createState() => _BloqueoAppState();
}

class _BloqueoAppState extends State<BloqueoApp> {
  late final Future<ControladorBloqueos> _controllerFuture;

  @override
  void initState() {
    super.initState();
    _controllerFuture = _inicializar();
  }

  Future<ControladorBloqueos> _inicializar() async {
    final prefs = await SharedPreferences.getInstance();
    final gestor = GestorBloqueos(prefs);
    final controlador = ControladorBloqueos(gestor);
    await controlador.cargar();
    return controlador;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bloqueo Por Momento Jejeejj',
      debugShowCheckedModeBanner: false,
      theme: Cosmico.tema(),
      home: FutureBuilder<ControladorBloqueos>(
        future: _controllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Scaffold(
              backgroundColor: Cosmico.fondo,
              body: Center(
                child: CircularProgressIndicator(color: Cosmico.cian),
              ),
            );
          }
          return PantallaPrincipal(controlador: snapshot.data!);
        },
      ),
    );
  }
}
