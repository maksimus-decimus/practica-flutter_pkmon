import 'package:flutter/material.dart';
import 'pantalles/pantalla_inicio.dart';

void main() {
  runApp(const BatallaPokemonApp());
}

/// Aplicación principal del juego de batalla Pokémon
class BatallaPokemonApp extends StatelessWidget {
  const BatallaPokemonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Batalla Pokémon',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const PantallaInicio(),
    );
  }
}
