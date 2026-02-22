/// Enumeración de facciones/naciones disponibles
enum Faccion {
  aliados,
  eje,
}

/// Extensión para obtener datos de cada facción
extension FaccionExtension on Faccion {
  /// Nombre descriptivo de la facción
  String get nombre {
    switch (this) {
      case Faccion.aliados:
        return 'Aliados';
      case Faccion.eje:
        return 'Eje';
    }
  }

  /// Ruta de la imagen de la bandera
  String get bandera {
    switch (this) {
      case Faccion.aliados:
        return 'assets/images/banderas/aliados.png';
      case Faccion.eje:
        return 'assets/images/banderas/eje.png';
    }
  }

  /// Color representativo de la facción
  int get color {
    switch (this) {
      case Faccion.aliados:
        return 0xFF2196F3; // Azul
      case Faccion.eje:
        return 0xFFE53935; // Rojo
    }
  }

  /// Facción oponente
  Faccion get oponente {
    switch (this) {
      case Faccion.aliados:
        return Faccion.eje;
      case Faccion.eje:
        return Faccion.aliados;
    }
  }

  /// Sonido de ataque de la facción
  String get sonidoAtaque {
    switch (this) {
      case Faccion.aliados:
        return 'assets/sounds/rifle_aliados.mp3';
      case Faccion.eje:
        return 'assets/sounds/rifle_eje.mp3';
    }
  }
}
