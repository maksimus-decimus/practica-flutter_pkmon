import 'dart:math';

/// Clase que representa un Pokémon en la batalla
class Pokemon {
  final String nombre;
  final int psMaximos;
  final int ppMaximos;
  int psActuales;
  int ppActuales;

  Pokemon({
    required this.nombre,
    this.psMaximos = 120,
    this.ppMaximos = 30,
  })  : psActuales = psMaximos,
        ppActuales = ppMaximos;

  /// Verifica si el Pokémon puede realizar un ataque según el coste de PP
  bool puedeAtacar(int costePP) {
    return ppActuales >= costePP && psActuales > 0;
  }

  /// Consume PP al realizar un ataque
  void consumirPP(int cantidad) {
    ppActuales -= cantidad;
    if (ppActuales < 0) ppActuales = 0;
  }

  /// Recibe daño y actualiza los PS
  void recibirDano(int dano) {
    psActuales -= dano;
    if (psActuales < 0) psActuales = 0;
  }

  /// Verifica si el Pokémon está KO (derrotado)
  bool estaKO() {
    return psActuales <= 0;
  }

  /// Reinicia los valores del Pokémon a sus máximos
  void reiniciar() {
    psActuales = psMaximos;
    ppActuales = ppMaximos;
  }

  /// Descansa y recupera PP aleatorios (5 a 10 PP)
  int descansar() {
    final random = Random();
    final ppRecuperados = 5 + random.nextInt(6); // 5 a 10 PP
    ppActuales = (ppActuales + ppRecuperados).clamp(0, ppMaximos);
    return ppRecuperados;
  }

  /// Realiza un ataque rápido (5 PP, 10-15 daño)
  int ataqueRapido() {
    final random = Random();
    return 10 + random.nextInt(6); // 10 a 15
  }

  /// Realiza un ataque normal (10 PP, 20-25 daño)
  int ataqueNormal() {
    final random = Random();
    return 20 + random.nextInt(6); // 20 a 25
  }

  /// Realiza un ataque fuerte (20 PP, 35-45 daño)
  int ataqueFuerte() {
    final random = Random();
    return 35 + random.nextInt(11); // 35 a 45
  }

  /// Obtiene el porcentaje de PS actual (0.0 a 1.0)
  double get porcentajePS => psActuales / psMaximos;

  /// Obtiene el porcentaje de PP actual (0.0 a 1.0)
  double get porcentajePP => ppActuales / ppMaximos;
}
