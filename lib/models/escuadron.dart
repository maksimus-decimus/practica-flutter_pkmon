import 'soldado.dart';
import 'faccion.dart';

/// Clase que representa un escuadrón de 3 soldados
class Escuadron {
  final Faccion faccion;
  final List<Soldado> soldados;

  Escuadron({required this.faccion})
      : soldados = [
          Soldado(
            tipo: TipoSoldado.ametralladora,
            faccion: faccion,
            posicion: 0,
          ),
          Soldado(
            tipo: TipoSoldado.rifle,
            faccion: faccion,
            posicion: 1,
          ),
          Soldado(
            tipo: TipoSoldado.asalto,
            faccion: faccion,
            posicion: 2,
          ),
        ];

  /// Obtener soldado por posición
  Soldado obtenerSoldado(int posicion) => soldados[posicion];

  /// Verifica si todos los soldados están KO
  bool estaDerrotado() {
    return soldados.every((soldado) => soldado.estaKO());
  }

  /// Obtiene lista de soldados vivos
  List<Soldado> get soldadosVivos {
    return soldados.where((s) => !s.estaKO()).toList();
  }

  /// Obtiene el número de soldados vivos
  int get numeroSoldadosVivos {
    return soldadosVivos.length;
  }

  /// Reinicia el escuadrón
  void reiniciar() {
    for (var soldado in soldados) {
      soldado.psActuales = soldado.psMaximos;
      soldado.ppActuales = soldado.ppMaximos;
    }
  }
}
