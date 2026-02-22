import 'package:flutter/material.dart';
import 'pantalla_inicio.dart';
import 'pantalla_batalla.dart';

/// Pantalla final que muestra los resultados de la batalla
class PantallaFinal extends StatelessWidget {
  final String ganador;
  final int totalAtaques;
  final Duration duracion;

  const PantallaFinal({
    super.key,
    required this.ganador,
    required this.totalAtaques,
    required this.duracion,
  });

  String _formatearDuracion(Duration duracion) {
    final minutos = duracion.inMinutes;
    final segundos = duracion.inSeconds % 60;
    return '$minutos min $segundos seg';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.amber.shade700,
              Colors.orange.shade900,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Título de victoria
                Icon(
                  Icons.emoji_events,
                  size: 100,
                  color: Colors.yellow.shade300,
                ),
                SizedBox(height: 20),
                Text(
                  '¡VICTORIA!',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),

                // Ganador
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'GANADOR',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        ganador.toUpperCase(),
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber.shade800,
                        ),
                      ),
                      SizedBox(height: 30),

                      // Estadísticas
                      _construirEstadistica(
                        Icons.flash_on,
                        'Ataques totales',
                        totalAtaques.toString(),
                        Colors.orange,
                      ),
                      SizedBox(height: 16),
                      _construirEstadistica(
                        Icons.access_time,
                        'Duración',
                        _formatearDuracion(duracion),
                        Colors.blue,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50),

                // Botón Nueva Batalla
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PantallaBatalla(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 8,
                  ),
                  child: Text(
                    '⚔️ NUEVA BATALLA',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Botón Volver al Inicio
                ElevatedButton(
                  onPressed: () {
                    // Vuelve al inicio eliminando todas las pantallas intermedias
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PantallaInicio(),
                      ),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 8,
                  ),
                  child: Text(
                    '🏠 VOLVER AL INICIO',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Construye una fila de estadística
  Widget _construirEstadistica(IconData icono, String etiqueta, String valor, Color color) {
    return Row(
      children: [
        Icon(icono, size: 30, color: color),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                etiqueta,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                valor,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
