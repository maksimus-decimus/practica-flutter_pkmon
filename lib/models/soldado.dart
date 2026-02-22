import 'dart:math';
import 'faccion.dart';

/// Resultado de un ataque
class ResultadoAtaque {
  final int dano;
  final bool esCritico;
  final bool fallo;

  ResultadoAtaque({
    required this.dano,
    this.esCritico = false,
    this.fallo = false,
  });

  factory ResultadoAtaque.fallo() => ResultadoAtaque(dano: 0, fallo: true);
}

/// Tipo de soldado según su arma y rol
enum TipoSoldado {
  ametralladora, // MG - Tanque con mucha vida
  rifle, // Rifle - Balanceado
  asalto, // Asalto - Alto daño, poca vida
}

/// Extensión para obtener datos de cada tipo de soldado
extension TipoSoldadoExtension on TipoSoldado {
  String get nombre {
    switch (this) {
      case TipoSoldado.ametralladora:
        return 'Ametralladora';
      case TipoSoldado.rifle:
        return 'Rifle';
      case TipoSoldado.asalto:
        return 'Asalto';
    }
  }

  String get nombreCorto {
    switch (this) {
      case TipoSoldado.ametralladora:
        return 'MG';
      case TipoSoldado.rifle:
        return 'Rifle';
      case TipoSoldado.asalto:
        return 'Asalto';
    }
  }

  /// PS máximos según el tipo
  int get psMaximos {
    switch (this) {
      case TipoSoldado.ametralladora:
        return 150; // Más resistente
      case TipoSoldado.rifle:
        return 100; // Balanceado
      case TipoSoldado.asalto:
        return 80; // Frágil
    }
  }

  /// PP máximos según el tipo
  int get ppMaximos {
    switch (this) {
      case TipoSoldado.ametralladora:
        return 25; // Consume más munición
      case TipoSoldado.rifle:
        return 30; // Balanceado
      case TipoSoldado.asalto:
        return 35; // Más munición
    }
  }

  /// Obtener ruta de imagen del soldado
  String obtenerImagen(Faccion faccion) {
    final fac = faccion == Faccion.aliados ? 'aliados' : 'eje';
    switch (this) {
      case TipoSoldado.ametralladora:
        return 'assets/images/soldados/${fac}_mg.png';
      case TipoSoldado.rifle:
        return 'assets/images/soldados/${fac}_rifle.png';
      case TipoSoldado.asalto:
        return 'assets/images/soldados/${fac}_asalto.png';
    }
  }
}

/// Clase que representa un soldado individual
class Soldado {
  final TipoSoldado tipo;
  final Faccion faccion;
  final int psMaximos;
  final int ppMaximos;
  int psActuales;
  int ppActuales;
  final int posicion; // 0, 1, 2 (izq a derecha)

  Soldado({
    required this.tipo,
    required this.faccion,
    required this.posicion,
  })  : psMaximos = tipo.psMaximos,
        ppMaximos = tipo.ppMaximos,
        psActuales = tipo.psMaximos,
        ppActuales = tipo.ppMaximos;

  /// Nombre completo del soldado
  String get nombre => '${tipo.nombre} (${faccion.nombre})';

  /// Verifica si el soldado puede atacar
  bool puedeAtacar(int costePP) {
    return ppActuales >= costePP && !estaKO();
  }

  /// Consume PP al atacar
  void consumirPP(int cantidad) {
    ppActuales -= cantidad;
    if (ppActuales < 0) ppActuales = 0;
  }

  /// Recibe daño
  void recibirDano(int dano) {
    psActuales -= dano;
    if (psActuales < 0) psActuales = 0;
  }

  /// Verifica si está KO
  bool estaKO() {
    return psActuales <= 0;
  }

  /// Descansa y recupera PP
  int descansar() {
    final random = Random();
    final ppRecuperados = 8 + random.nextInt(8); // 8 a 15 PP
    ppActuales = (ppActuales + ppRecuperados).clamp(0, ppMaximos);
    return ppRecuperados;
  }

  /// Se cura y recupera PS
  int curar() {
    final random = Random();
    final psRecuperados = 15 + random.nextInt(16); // 15 a 30 PS
    final psAntes = psActuales;
    psActuales = (psActuales + psRecuperados).clamp(0, psMaximos);
    return psActuales - psAntes; // Retorna lo realmente curado
  }

  /// Ataque rápido (chance 5% de fallo, 5% de crítico)
  ResultadoAtaque ataqueRapido() {
    final random = Random();
    final probabilidad = random.nextInt(100);
    
    // 5% de probabilidad de fallo
    if (probabilidad < 5) {
      return ResultadoAtaque.fallo();
    }
    
    // 5% de probabilidad de crítico (90-94)
    final esCritico = probabilidad >= 90;
    
    int danoBase;
    switch (tipo) {
      case TipoSoldado.ametralladora:
        danoBase = 8 + random.nextInt(5); // 8-12
        break;
      case TipoSoldado.rifle:
        danoBase = 12 + random.nextInt(6); // 12-17
        break;
      case TipoSoldado.asalto:
        danoBase = 15 + random.nextInt(6); // 15-20
        break;
    }
    
    final danoFinal = esCritico ? (danoBase * 1.5).round() : danoBase;
    return ResultadoAtaque(dano: danoFinal, esCritico: esCritico);
  }

  /// Ataque normal (chance 8% de fallo, 8% de crítico)
  ResultadoAtaque ataqueNormal() {
    final random = Random();
    final probabilidad = random.nextInt(100);
    
    // 8% de probabilidad de fallo
    if (probabilidad < 8) {
      return ResultadoAtaque.fallo();
    }
    
    // 8% de probabilidad de crítico (92-99)
    final esCritico = probabilidad >= 92;
    
    int danoBase;
    switch (tipo) {
      case TipoSoldado.ametralladora:
        danoBase = 15 + random.nextInt(8); // 15-22
        break;
      case TipoSoldado.rifle:
        danoBase = 20 + random.nextInt(8); // 20-27
        break;
      case TipoSoldado.asalto:
        danoBase = 25 + random.nextInt(10); // 25-34
        break;
    }
    
    final danoFinal = esCritico ? (danoBase * 1.5).round() : danoBase;
    return ResultadoAtaque(dano: danoFinal, esCritico: esCritico);
  }

  /// Ataque fuerte (chance 12% de fallo, 12% de crítico)
  ResultadoAtaque ataqueFuerte() {
    final random = Random();
    final probabilidad = random.nextInt(100);
    
    // 12% de probabilidad de fallo
    if (probabilidad < 12) {
      return ResultadoAtaque.fallo();
    }
    
    // 12% de probabilidad de crítico (88-99)
    final esCritico = probabilidad >= 88;
    
    int danoBase;
    switch (tipo) {
      case TipoSoldado.ametralladora:
        danoBase = 30 + random.nextInt(10); // 30-39
        break;
      case TipoSoldado.rifle:
        danoBase = 35 + random.nextInt(15); // 35-49
        break;
      case TipoSoldado.asalto:
        danoBase = 45 + random.nextInt(15); // 45-59
        break;
    }
    
    final danoFinal = esCritico ? (danoBase * 1.5).round() : danoBase;
    return ResultadoAtaque(dano: danoFinal, esCritico: esCritico);
  }

  /// Porcentaje de PS (0.0 a 1.0)
  double get porcentajePS => psActuales / psMaximos;

  /// Porcentaje de PP (0.0 a 1.0)
  double get porcentajePP => ppActuales / ppMaximos;

  /// Ruta de imagen
  String get imagenPath => tipo.obtenerImagen(faccion);
}
