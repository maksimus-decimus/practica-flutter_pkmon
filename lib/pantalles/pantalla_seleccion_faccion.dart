import 'package:flutter/material.dart';
import '../models/faccion.dart';
import 'pantalla_batalla_tactica.dart';

/// Pantalla para seleccionar la facción antes de la batalla
class PantallaSeleccionFaccion extends StatelessWidget {
  const PantallaSeleccionFaccion({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey.shade900,
              Colors.grey.shade800,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 40),
              // Título
              Text(
                '⚔️ BATALLA TÁCTICA ⚔️',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber.shade400,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Sistema de Combate Estratégico',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 60),

              // Título de selección
              Text(
                'SELECCIONA TU FACCIÓN',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(height: 40),

              // Cards de facciones
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      // Facción Aliados
                      Expanded(
                        child: _construirCardFaccion(
                          context,
                          Faccion.aliados,
                        ),
                      ),
                      SizedBox(width: 20),
                      // Facción Eje
                      Expanded(
                        child: _construirCardFaccion(
                          context,
                          Faccion.eje,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Botón volver
              TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back, color: Colors.white70),
                label: Text(
                  'Volver al inicio',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  /// Construye una card para seleccionar facción
  Widget _construirCardFaccion(BuildContext context, Faccion faccion) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PantallaBatallaTactica(
              faccionJugador: faccion,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(faccion.color).withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Color(faccion.color),
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Color(faccion.color).withOpacity(0.5),
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icono de bandera (placeholder)
            Container(
              width: 120,
              height: 80,
              decoration: BoxDecoration(
                color: Color(faccion.color).withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Color(faccion.color),
                  width: 2,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.flag,
                  size: 50,
                  color: Color(faccion.color),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Nombre de la facción
            Text(
              faccion.nombre.toUpperCase(),
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
            SizedBox(height: 10),

            // Descripción
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                faccion == Faccion.aliados
                    ? '3 soldados de élite\nDefensores de la libertad'
                    : '3 soldados veteranos\nPoder y disciplina',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  height: 1.5,
                ),
              ),
            ),
            SizedBox(height: 20),

            // Botón
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              decoration: BoxDecoration(
                color: Color(faccion.color),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                'SELECCIONAR',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
