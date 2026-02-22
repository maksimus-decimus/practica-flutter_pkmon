import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import '../models/soldado.dart';

/// Servicio centralizado para gestionar todos los efectos de sonido del juego
class ServicioAudio {
  static final ServicioAudio _instancia = ServicioAudio._interno();
  factory ServicioAudio() => _instancia;
  ServicioAudio._interno();

  // Pool de reproductores para permitir sonidos simultáneos
  final List<AudioPlayer> _reproductores = [];
  final int _maxReproductores = 3;
  
  bool _sonidoHabilitado = true;

  /// Obtiene un reproductor disponible del pool
  AudioPlayer _obtenerReproductor() {
    // Buscar un reproductor inactivo
    for (var reproductor in _reproductores) {
      if (reproductor.state != PlayerState.playing) {
        return reproductor;
      }
    }

    // Si no hay reproductores disponibles y el pool no está lleno, crear uno nuevo
    if (_reproductores.length < _maxReproductores) {
      final nuevoReproductor = AudioPlayer();
      _reproductores.add(nuevoReproductor);
      return nuevoReproductor;
    }

    // Si el pool está lleno, usar el primero (interrupción)
    return _reproductores[0];
  }

  /// Reproduce un sonido desde la ruta especificada
  Future<void> reproducir(String rutaArchivo) async {
    if (!_sonidoHabilitado) return;

    try {
      final reproductor = _obtenerReproductor();
      await reproductor.stop(); // Detener cualquier sonido previo
      await reproductor.play(AssetSource(rutaArchivo));
    } catch (e) {
      print('Error al reproducir sonido $rutaArchivo: $e');
    }
  }

  /// Reproduce el sonido de ataque según el tipo de soldado
  Future<void> reproducirAtaque(TipoSoldado tipo) async {
    switch (tipo) {
      case TipoSoldado.ametralladora:
        await reproducir('sprites/sonido/metralla.m4a');
        break;
      case TipoSoldado.rifle:
        await reproducir('sprites/sonido/rifle.m4a');
        break;
      case TipoSoldado.asalto:
        // El asalto puede usar el sonido de rifle (es similar)
        await reproducir('sprites/sonido/rifle.m4a');
        break;
    }
  }

  /// Reproduce un sonido de fallo aleatorio
  Future<void> reproducirFallo() async {
    final random = Random();
    final falloNum = random.nextBool() ? '1' : '2';
    await reproducir('sprites/sonido/fallo$falloNum.m4a');
  }

  /// Activa o desactiva el sonido globalmente
  void configurarSonido(bool habilitado) {
    _sonidoHabilitado = habilitado;
  }

  /// Obtiene el estado actual del sonido
  bool get sonidoHabilitado => _sonidoHabilitado;

  /// Limpia todos los recursos de audio
  Future<void> dispose() async {
    for (var reproductor in _reproductores) {
      await reproductor.dispose();
    }
    _reproductores.clear();
  }
}
