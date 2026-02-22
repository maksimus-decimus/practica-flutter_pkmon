import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import 'pantalla_final.dart';

/// Pantalla principal de batalla con sistema de turnos
class PantallaBatalla extends StatefulWidget {
  const PantallaBatalla({super.key});

  @override
  State<PantallaBatalla> createState() => _PantallaBatallaState();
}

class _PantallaBatallaState extends State<PantallaBatalla> {
  late Pokemon pokemon1;
  late Pokemon pokemon2;
  int turnoActual = 1; // 1 para Pokémon 1, 2 para Pokémon 2
  int totalAtaques = 0;
  DateTime? tiempoInicio;

  @override
  void initState() {
    super.initState();
    _iniciarBatalla();
  }

  /// Inicializa los Pokémon y el tiempo de inicio
  void _iniciarBatalla() {
    pokemon1 = Pokemon(nombre: 'Pikachu');
    pokemon2 = Pokemon(nombre: 'Charmander');
    turnoActual = 1;
    totalAtaques = 0;
    tiempoInicio = DateTime.now();
  }

  /// Saltar turno y descansar para recuperar PP
  void _saltarTurno() {
    setState(() {
      Pokemon atacante = turnoActual == 1 ? pokemon1 : pokemon2;
      
      // Recuperar PP aleatorios
      int ppRecuperados = atacante.descansar();
      
      // Mostrar mensaje de descanso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${atacante.nombre} descansó y recuperó $ppRecuperados PP!',
            style: TextStyle(fontSize: 16),
          ),
          duration: Duration(milliseconds: 1500),
          backgroundColor: Colors.blue.shade700,
        ),
      );
      
      // Cambiar turno
      turnoActual = turnoActual == 1 ? 2 : 1;
    });
  }

  /// Realiza un ataque y cambia el turno
  void _realizarAtaque(String tipoAtaque) {
    setState(() {
      Pokemon atacante = turnoActual == 1 ? pokemon1 : pokemon2;
      Pokemon defensor = turnoActual == 1 ? pokemon2 : pokemon1;

      int dano = 0;
      int costePP = 0;

      // Determinar daño y coste según el tipo de ataque
      switch (tipoAtaque) {
        case 'rapido':
          costePP = 5;
          dano = atacante.ataqueRapido();
          break;
        case 'normal':
          costePP = 10;
          dano = atacante.ataqueNormal();
          break;
        case 'fuerte':
          costePP = 20;
          dano = atacante.ataqueFuerte();
          break;
      }

      // Aplicar el ataque
      if (atacante.puedeAtacar(costePP)) {
        atacante.consumirPP(costePP);
        defensor.recibirDano(dano);
        totalAtaques++;

        // Mostrar mensaje de ataque
        _mostrarMensajeAtaque(atacante.nombre, tipoAtaque, dano);

        // Verificar si la batalla ha terminado
        if (defensor.estaKO()) {
          _finalizarBatalla();
        } else {
          // Cambiar turno
          turnoActual = turnoActual == 1 ? 2 : 1;
        }
      }
    });
  }

  /// Muestra un SnackBar con información del ataque
  void _mostrarMensajeAtaque(String nombreAtacante, String tipoAtaque, int dano) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$nombreAtacante usó ${_nombreAtaque(tipoAtaque)} e hizo $dano de daño!',
          style: TextStyle(fontSize: 16),
        ),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.orange.shade800,
      ),
    );
  }

  /// Obtiene el nombre descriptivo del ataque
  String _nombreAtaque(String tipo) {
    switch (tipo) {
      case 'rapido':
        return 'Ataque Rápido';
      case 'normal':
        return 'Ataque Normal';
      case 'fuerte':
        return 'Ataque Fuerte';
      default:
        return '';
    }
  }

  /// Finaliza la batalla y navega a la pantalla final
  void _finalizarBatalla() {
    final duracion = DateTime.now().difference(tiempoInicio!);
    final ganador = pokemon1.estaKO() ? pokemon2 : pokemon1;

    // Pequeño delay para que se vea el último golpe
    Future.delayed(Duration(milliseconds: 500), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PantallaFinal(
            ganador: ganador.nombre,
            totalAtaques: totalAtaques,
            duracion: duracion,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('⚔️ Batalla Pokémon'),
        centerTitle: true,
        backgroundColor: Colors.red.shade700,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade100,
              Colors.green.shade100,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Indicador de turno
              Container(
                padding: EdgeInsets.all(12),
                color: turnoActual == 1 ? Colors.blue.shade200 : Colors.red.shade200,
                child: Center(
                  child: Text(
                    'TURNO DE: ${turnoActual == 1 ? pokemon1.nombre.toUpperCase() : pokemon2.nombre.toUpperCase()}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),

              // Contenido con scroll
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 16),
                      // Pokémon 1
                      _construirCartaPokemon(pokemon1, 1),

                      // Icono VS
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.yellow.shade600,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            'VS',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      // Pokémon 2
                      _construirCartaPokemon(pokemon2, 2),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              // Estadísticas de batalla
              Container(
                padding: EdgeInsets.all(8),
                color: Colors.grey.shade300,
                child: Text(
                  'Ataques totales: $totalAtaques',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Construye la tarjeta de un Pokémon con sus estadísticas y botones de ataque
  Widget _construirCartaPokemon(Pokemon pokemon, int numeroPokemon) {
    bool esSuTurno = turnoActual == numeroPokemon;
    Color colorTarjeta = numeroPokemon == 1 ? Colors.blue.shade50 : Colors.red.shade50;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorTarjeta,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: esSuTurno ? Colors.yellow.shade700 : Colors.grey,
          width: esSuTurno ? 4 : 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Nombre del Pokémon
          Text(
            pokemon.nombre.toUpperCase(),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: numeroPokemon == 1 ? Colors.blue.shade900 : Colors.red.shade900,
            ),
          ),
          SizedBox(height: 16),

          // Barra de PS
          _construirBarraEstadistica(
            'PS',
            pokemon.psActuales,
            pokemon.psMaximos,
            pokemon.porcentajePS,
            Colors.green,
          ),
          SizedBox(height: 12),

          // Barra de PP
          _construirBarraEstadistica(
            'PP',
            pokemon.ppActuales,
            pokemon.ppMaximos,
            pokemon.porcentajePP,
            Colors.blue,
          ),
          SizedBox(height: 16),

          // Botones de ataque
          if (esSuTurno) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _construirBotonAtaque(
                  'Rápido\n(5 PP)',
                  'rapido',
                  5,
                  pokemon,
                  Colors.green.shade600,
                ),
                _construirBotonAtaque(
                  'Normal\n(10 PP)',
                  'normal',
                  10,
                  pokemon,
                  Colors.orange.shade600,
                ),
                _construirBotonAtaque(
                  'Fuerte\n(20 PP)',
                  'fuerte',
                  20,
                  pokemon,
                  Colors.red.shade600,
                ),
              ],
            ),
            SizedBox(height: 12),
            // Botón de descansar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _saltarTurno(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple.shade600,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: Icon(Icons.self_improvement, size: 20),
                label: Text(
                  'DESCANSAR (+5-10 PP)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ] else ...[
            Text(
              'Esperando turno...',
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Construye una barra de estadística (PS o PP)
  Widget _construirBarraEstadistica(
    String nombre,
    int valorActual,
    int valorMaximo,
    double porcentaje,
    Color colorBase,
  ) {
    // Color dinámico según el porcentaje
    Color colorBarra;
    if (porcentaje > 0.6) {
      colorBarra = colorBase;
    } else if (porcentaje > 0.3) {
      colorBarra = Colors.orange;
    } else {
      colorBarra = Colors.red;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              nombre,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              '$valorActual / $valorMaximo',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: porcentaje,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(colorBarra),
            minHeight: 20,
          ),
        ),
      ],
    );
  }

  /// Construye un botón de ataque
  Widget _construirBotonAtaque(
    String texto,
    String tipoAtaque,
    int costePP,
    Pokemon pokemon,
    Color color,
  ) {
    bool puedeAtacar = pokemon.puedeAtacar(costePP);

    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton(
          onPressed: puedeAtacar ? () => _realizarAtaque(tipoAtaque) : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            disabledBackgroundColor: Colors.grey.shade400,
          ),
          child: Text(
            texto,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
