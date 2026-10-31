/// Entidad de dominio: un bloqueo de aplicacion.
class Bloqueo {
  Bloqueo({
    required this.id,
    required this.appPackage,
    required this.appNombre,
    required this.tipo,
    required this.diasSemana,
    required this.horaInicio,
    required this.horaFin,
    required this.duracionMinutos,
    required this.activo,
    required this.mensaje,
    this.creadoEn,
  });

  final String id;
  final String appPackage;
  final String appNombre;
  final String tipo; // 'horario' | 'tiempo'
  final List<int> diasSemana;
  final int horaInicio; // minutos desde 00:00
  final int horaFin; // minutos desde 00:00
  final int duracionMinutos;
  final bool activo;
  final String mensaje;
  final DateTime? creadoEn;

  Bloqueo copyWith({
    String? appPackage,
    String? appNombre,
    String? tipo,
    List<int>? diasSemana,
    int? horaInicio,
    int? horaFin,
    int? duracionMinutos,
    bool? activo,
    String? mensaje,
  }) {
    return Bloqueo(
      id: id,
      appPackage: appPackage ?? this.appPackage,
      appNombre: appNombre ?? this.appNombre,
      tipo: tipo ?? this.tipo,
      diasSemana: diasSemana ?? this.diasSemana,
      horaInicio: horaInicio ?? this.horaInicio,
      horaFin: horaFin ?? this.horaFin,
      duracionMinutos: duracionMinutos ?? this.duracionMinutos,
      activo: activo ?? this.activo,
      mensaje: mensaje ?? this.mensaje,
      creadoEn: creadoEn,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'appPackage': appPackage,
        'appNombre': appNombre,
        'tipo': tipo,
        'diasSemana': diasSemana,
        'horaInicio': horaInicio,
        'horaFin': horaFin,
        'duracionMinutos': duracionMinutos,
        'activo': activo,
        'mensaje': mensaje,
        'creadoEn': creadoEn?.toIso8601String(),
      };

  factory Bloqueo.fromJson(Map<String, dynamic> json) => Bloqueo(
        id: json['id'] as String,
        appPackage: json['appPackage'] as String,
        appNombre: json['appNombre'] as String,
        tipo: json['tipo'] as String,
        diasSemana: List<int>.from(json['diasSemana'] as List),
        horaInicio: json['horaInicio'] as int,
        horaFin: json['horaFin'] as int,
        duracionMinutos: json['duracionMinutos'] as int,
        activo: json['activo'] as bool,
        mensaje: json['mensaje'] as String,
        creadoEn: json['creadoEn'] == null
            ? null
            : DateTime.parse(json['creadoEn'] as String),
      );
}
