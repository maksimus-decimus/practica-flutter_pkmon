import 'dart:math';
import 'package:flutter/material.dart';
import '../models/faccion.dart';
import '../models/soldado.dart';
import '../models/escuadron.dart';
import '../servicios/servicio_audio.dart';
import 'pantalla_final.dart';

/// Pantalla de batalla táctica estilo Darkest Dungeon
class PantallaBatallaTactica extends StatefulWidget {
  final Faccion faccionJugador;

  const PantallaBatallaTactica({
    super.key,
    required this.faccionJugador,
  });

  @override
  State<PantallaBatallaTactica> createState() => _PantallaBatallaTacticaState();
}

class _PantallaBatallaTacticaState extends State<PantallaBatallaTactica>
    with SingleTickerProviderStateMixin {
  late Escuadron escuadronJugador;
  late Escuadron escuadronEnemigo;

  // Control de selección
  Soldado? soldadoSeleccionado; // Quien ataca
  bool seleccionandoObjetivo = false;
  String? accionSeleccionada; // 'rapido', 'normal', 'fuerte', 'descansar', 'curar'

  // Control de turno
  bool turnoJugador = true;
  int totalAtaques = 0;
  DateTime? tiempoInicio;
  
  // Servicio de audio
  final ServicioAudio _audioServicio = ServicioAudio();

  // Animación (4 fases tipo Darkest Dungeon)
  late AnimationController _animationController;
  late Animation<double> _anticipationAnim;
  late Animation<double> _dashAnim;
  late Animation<double> _reactionAnim;
  late Animation<double> _recoveryAnim;
  late Animation<double> _flashAnim;
  late Animation<double> _slashAnim;
  late Animation<double> _cameraShakeAnim;
  
  bool _impactFreezeActive = false;
  bool enAnimacion = false;
  Soldado? atacanteAnimacion;
  Soldado? objetivoAnimacion;
  bool ataqueExitoso = true; // Para determinar si hubo impacto o fallo
  ResultadoAtaque? resultadoAtaqueActual; // Resultado completo del ataque actual

  @override
  void initState() {
    super.initState();
    _iniciarBatalla();
    _iniciarAnimaciones();
  }

  void _iniciarBatalla() {
    escuadronJugador = Escuadron(faccion: widget.faccionJugador);
    escuadronEnemigo = Escuadron(faccion: widget.faccionJugador.oponente);
    turnoJugador = true;
    totalAtaques = 0;
    tiempoInicio = DateTime.now();
  }

  void _iniciarAnimaciones() {
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    // Fase 1: Anticipación (0-200ms) - 0.0 a 0.25
    _anticipationAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.25, curve: Curves.easeOut),
      ),
    );

    // Fase 2: Dash/Impacto (200-400ms) - 0.25 a 0.5
    _dashAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.25, 0.5, curve: Curves.easeIn),
      ),
    );

    // Fase 3: Reacción (400-600ms) - 0.5 a 0.75
    _reactionAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.5, 0.75, curve: Curves.easeOut),
      ),
    );

    // Fase 4: Recovery (600-800ms) - 0.75 a 1.0
    _recoveryAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.75, 1.0, curve: Curves.easeOutBack),
      ),
    );

    // Flash de impacto (peak en 350ms)
    _flashAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.35, 0.5, curve: Curves.easeInOut),
      ),
    );

    // Sprite de slash (aparece rápido en el impacto)
    _slashAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.25, 0.4, curve: Curves.easeOut),
      ),
    );

    // Camera shake (durante impacto y reacción)
    _cameraShakeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.25, 0.6, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _audioServicio.dispose();
    super.dispose();
  }

  /// Selecciona un soldado para atacar
  void _seleccionarAtacante(Soldado soldado) {
    if (!turnoJugador || soldado.estaKO() || enAnimacion) return;

    setState(() {
      soldadoSeleccionado = soldado;
      seleccionandoObjetivo = false;
      accionSeleccionada = null;
    });
  }

  /// Selecciona una acción (ataque, descansar o curar)
  void _seleccionarAccion(String accion) {
    if (soldadoSeleccionado == null || enAnimacion) return;

    // Verificar PP antes de permitir ataque
    if (accion == 'rapido' || accion == 'normal' || accion == 'fuerte') {
      int costePP = 0;
      switch (accion) {
        case 'rapido':
          costePP = 5;
          break;
        case 'normal':
          costePP = 10;
          break;
        case 'fuerte':
          costePP = 20;
          break;
      }
      
      if (!soldadoSeleccionado!.puedeAtacar(costePP)) {
        _audioServicio.reproducirFallo();
        _mostrarMensaje(
          'PP insuficiente para atacar',
          Colors.red,
        );
        return;
      }
    }

    setState(() {
      accionSeleccionada = accion;
      if (accion == 'descansar') {
        _ejecutarDescanso();
      } else if (accion == 'curar') {
        _ejecutarCuracion();
      } else {
        seleccionandoObjetivo = true;
      }
    });
  }

  /// Ejecuta el descanso
  void _ejecutarDescanso() {
    if (soldadoSeleccionado == null) return;

    final ppRecuperados = soldadoSeleccionado!.descansar();

    _mostrarMensaje(
      '${soldadoSeleccionado!.tipo.nombreCorto} descansó (+$ppRecuperados PP)',
      Colors.blue,
    );

    _finalizarTurno();
  }
  /// Ejecuta la curación
  void _ejecutarCuracion() {
    if (soldadoSeleccionado == null) return;

    final psRecuperados = soldadoSeleccionado!.curar();

    _mostrarMensaje(
      '❤️ ${soldadoSeleccionado!.tipo.nombreCorto} se curó (+$psRecuperados PS)',
      Colors.green,
    );

    _finalizarTurno();
  }
  /// Selecciona el objetivo y ejecuta el ataque
  void _seleccionarObjetivo(Soldado objetivo) async {
    if (!seleccionandoObjetivo ||
        soldadoSeleccionado == null ||
        objetivo.estaKO() ||
        enAnimacion) return;

    // Pre-calcular el resultado del ataque (para determinar la animación)
    ResultadoAtaque resultado;
    switch (accionSeleccionada!) {
      case 'rapido':
        resultado = soldadoSeleccionado!.ataqueRapido();
        break;
      case 'normal':
        resultado = soldadoSeleccionado!.ataqueNormal();
        break;
      case 'fuerte':
        resultado = soldadoSeleccionado!.ataqueFuerte();
        break;
      default:
        return;
    }

    setState(() {
      enAnimacion = true;
      atacanteAnimacion = soldadoSeleccionado;
      objetivoAnimacion = objetivo;
      ataqueExitoso = !resultado.fallo;
      resultadoAtaqueActual = resultado;
    });

    // Ejecutar animación de zoom
    await _animarAtaque();

    // Calcular y aplicar daño
    _ejecutarAtaque(objetivo);
  }

  /// Anima el ataque con sistema de 4 fases tipo Darkest Dungeon
  Future<void> _animarAtaque() async {
    // Iniciar animación hasta el punto de impacto (250ms)
    await _animationController.animateTo(
      0.31, // 250ms de 800ms
      duration: Duration(milliseconds: 250),
    );
    
    // Reproducir sonido en el momento del impacto
    if (atacanteAnimacion != null) {
      if (ataqueExitoso) {
        _audioServicio.reproducirAtaque(atacanteAnimacion!.tipo);
      } else {
        _audioServicio.reproducirFallo();
      }
    }
    
    // IMPACT FREEZE: Micro pausa de 40ms en el momento del impacto
    setState(() => _impactFreezeActive = true);
    await Future.delayed(Duration(milliseconds: 40));
    setState(() => _impactFreezeActive = false);
    
    // Continuar el resto de la animación (550ms restantes)
    await _animationController.forward();
    
    // Resetear para próxima animación
    await _animationController.reverse();
  }

  /// Ejecuta el ataque
  void _ejecutarAtaque(Soldado objetivo) {
    if (soldadoSeleccionado == null || accionSeleccionada == null || resultadoAtaqueActual == null) return;

    int costePP = 0;

    switch (accionSeleccionada!) {
      case 'rapido':
        costePP = 5;
        break;
      case 'normal':
        costePP = 10;
        break;
      case 'fuerte':
        costePP = 20;
        break;
    }

    if (soldadoSeleccionado!.puedeAtacar(costePP)) {
      soldadoSeleccionado!.consumirPP(costePP);
      
      // Verificar si el ataque falló
      if (resultadoAtaqueActual!.fallo) {
        _mostrarMensaje(
          '❌ ${soldadoSeleccionado!.tipo.nombreCorto} falló el ataque!',
          Colors.grey,
        );
      } else {
        objetivo.recibirDano(resultadoAtaqueActual!.dano);
        totalAtaques++;

        // Mensaje diferente según si fue crítico o no
        if (resultadoAtaqueActual!.esCritico) {
          _mostrarMensaje(
            '✨ ¡CRÍTICO! ${soldadoSeleccionado!.tipo.nombreCorto} → ${objetivo.tipo.nombreCorto}: ${resultadoAtaqueActual!.dano} daño!',
            Colors.yellow,
          );
        } else {
          _mostrarMensaje(
            '💥 ${soldadoSeleccionado!.tipo.nombreCorto} → ${objetivo.tipo.nombreCorto}: ${resultadoAtaqueActual!.dano} daño',
            Colors.orange,
          );
        }

        // Verificar victoria
        if (escuadronEnemigo.estaDerrotado()) {
          _finalizarBatalla(true);
          return;
        }
      }
    } else {
      // Sin PP suficiente - reproducir sonido de fallo
      _audioServicio.reproducirFallo();
      _mostrarMensaje(
        '⚠️ ${soldadoSeleccionado!.tipo.nombreCorto} no tiene PP suficiente!',
        Colors.red,
      );
    }

    _finalizarTurno();
  }

  /// Finaliza el turno
  void _finalizarTurno() {
    setState(() {
      soldadoSeleccionado = null;
      seleccionandoObjetivo = false;
      accionSeleccionada = null;
      enAnimacion = false;
      atacanteAnimacion = null;
      objetivoAnimacion = null;

      if (turnoJugador) {
        turnoJugador = false;
        // IA enemiga actúa después de un delay
        Future.delayed(Duration(milliseconds: 800), () {
          _turnoIA();
        });
      } else {
        turnoJugador = true;
      }
    });
  }

  /// Turno de la IA (simple: ataca aleatoriamente)
  void _turnoIA() async {
    if (escuadronJugador.estaDerrotado()) return;

    final soldadosVivosIA = escuadronEnemigo.soldadosVivos;
    final objetivosPosibles = escuadronJugador.soldadosVivos;

    if (soldadosVivosIA.isEmpty || objetivosPosibles.isEmpty) return;

    // Seleccionar soldado aleatorio de IA
    soldadosVivosIA.shuffle();
    final atacanteIA = soldadosVivosIA.first;

    // Verificar si tiene PP suficiente para atacar
    if (!atacanteIA.puedeAtacar(10)) {
      // Si no tiene PP, descansar
      final ppRecuperados = atacanteIA.descansar();
      setState(() {
        _mostrarMensaje(
          '⚙️ ENEMIGO: ${atacanteIA.tipo.nombreCorto} descansó (+$ppRecuperados PP)',
          Colors.blue,
        );
      });
      _finalizarTurno();
      return;
    }

    // Seleccionar objetivo aleatorio
    objetivosPosibles.shuffle();
    final objetivoIA = objetivosPosibles.first;

    // Pre-calcular el resultado del ataque
    final resultado = atacanteIA.ataqueNormal();

    setState(() {
      enAnimacion = true;
      atacanteAnimacion = atacanteIA;
      objetivoAnimacion = objetivoIA;
      ataqueExitoso = !resultado.fallo;
      resultadoAtaqueActual = resultado;
    });

    await _animarAtaque();

    // Ejecutar ataque IA
    atacanteIA.consumirPP(10);
    
    if (resultado.fallo) {
      _mostrarMensaje(
        '✅ ENEMIGO falló el ataque!',
        Colors.grey,
      );
    } else {
      objetivoIA.recibirDano(resultado.dano);
      totalAtaques++;

      if (resultado.esCritico) {
        _mostrarMensaje(
          '⚠️ ¡CRÍTICO ENEMIGO! ${atacanteIA.tipo.nombreCorto} → ${objetivoIA.tipo.nombreCorto}: ${resultado.dano} daño!',
          Colors.yellow,
        );
      } else {
        _mostrarMensaje(
          'ENEMIGO: ${atacanteIA.tipo.nombreCorto} → ${objetivoIA.tipo.nombreCorto}: ${resultado.dano} daño!',
          Colors.red,
        );
      }

      if (escuadronJugador.estaDerrotado()) {
        _finalizarBatalla(false);
        return;
      }
    }

    _finalizarTurno();
  }

  /// Muestra un mensaje
  void _mostrarMensaje(String mensaje, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          mensaje,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        duration: Duration(milliseconds: 1200),
        backgroundColor: color,
      ),
    );
  }

  /// Finaliza la batalla
  void _finalizarBatalla(bool victoria) {
    final duracion = DateTime.now().difference(tiempoInicio!);
    final ganador = victoria
        ? escuadronJugador.faccion.nombre
        : escuadronEnemigo.faccion.nombre;

    Future.delayed(Duration(milliseconds: 800), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PantallaFinal(
            ganador: ganador,
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
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: Text(turnoJugador ? 'TU TURNO' : 'TURNO ENEMIGO'),
        centerTitle: true,
        backgroundColor:
            turnoJugador ? Color(widget.faccionJugador.color) : Colors.red,
      ),
      body: Stack(
        children: [
          // Campo de batalla principal
          Column(
            children: [
              // Estadísticas superiores
              _construirPanelEstadisticas(),

              // Campo de batalla
              Expanded(
                child: _construirCampoBatalla(),
              ),

              // Panel de acciones
              if (soldadoSeleccionado != null && turnoJugador)
                _construirPanelAcciones(),
            ],
          ),

          // Overlay de animación
          if (enAnimacion && atacanteAnimacion != null && objetivoAnimacion != null)
            _construirAnimacionZoom(),
        ],
      ),
    );
  }

  /// Panel de estadísticas superior
  Widget _construirPanelEstadisticas() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      color: Colors.black87,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: _construirEstadisticaEscuadron(escuadronJugador, true),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.military_tech, color: Colors.amber, size: 20),
                SizedBox(height: 2),
                Text(
                  '$totalAtaques',
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _construirEstadisticaEscuadron(escuadronEnemigo, false),
          ),
        ],
      ),
    );
  }

  Widget _construirEstadisticaEscuadron(Escuadron escuadron, bool esJugador) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          esJugador ? 'TUS' : 'ENEMIGOS',
          style: TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 2),
        Text(
          '${escuadron.numeroSoldadosVivos}/3',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  /// Campo de batalla con soldados
  Widget _construirCampoBatalla() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          // Escuadrón jugador (izquierda)
          Expanded(
            child: _construirFormacion(escuadronJugador, true),
          ),

          // Zona central
          Container(
            width: 60,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.adjust, color: Colors.amber, size: 40),
                SizedBox(height: 10),
                Text(
                  'VS',
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Escuadrón enemigo (derecha)
          Expanded(
            child: _construirFormacion(escuadronEnemigo, false),
          ),
        ],
      ),
    );
  }

  /// Construye la formación de soldados
  Widget _construirFormacion(Escuadron escuadron, bool esJugador) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: escuadron.soldados.map((soldado) {
        final esSeleccionado = soldadoSeleccionado == soldado;
        final puedeSerObjetivo =
            seleccionandoObjetivo && !soldado.estaKO() && !esJugador;

        return GestureDetector(
          onTap: () {
            if (esJugador && turnoJugador) {
              _seleccionarAtacante(soldado);
            } else if (puedeSerObjetivo) {
              _seleccionarObjetivo(soldado);
            }
          },
          child: _construirSoldado(
            soldado,
            esJugador,
            esSeleccionado,
            puedeSerObjetivo,
          ),
        );
      }).toList(),
    );
  }

  /// Construye un soldado individual
  Widget _construirSoldado(
    Soldado soldado,
    bool esJugador,
    bool esSeleccionado,
    bool puedeSerObjetivo,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: soldado.estaKO() ? Colors.grey.shade800 : Colors.black54,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: esSeleccionado
              ? Colors.amber
              : (puedeSerObjetivo ? Colors.red : Colors.grey.shade700),
          width: esSeleccionado || puedeSerObjetivo ? 3 : 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Sprite de soldado
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Color(soldado.faccion.color).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Color(soldado.faccion.color),
                width: 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Transform.flip(
                flipX: !esJugador, // Enemigos miran a la izquierda
                child: Image.asset(
                  _obtenerSpriteSoldado(soldado.faccion, soldado.tipo),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      _iconoPorTipo(soldado.tipo),
                      color: Color(soldado.faccion.color),
                      size: 25,
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 6),

          // Tipo
          Text(
            soldado.tipo.nombreCorto,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4),

          // Barra PS
          _construirBarraMini('PS', soldado.porcentajePS, Colors.red),
          SizedBox(height: 2),

          // Barra PP
          _construirBarraMini('PP', soldado.porcentajePP, Colors.blue),
        ],
      ),
    );
  }

  IconData _iconoPorTipo(TipoSoldado tipo) {
    switch (tipo) {
      case TipoSoldado.ametralladora:
        return Icons.shield;
      case TipoSoldado.rifle:
        return Icons.bolt;
      case TipoSoldado.asalto:
        return Icons.local_fire_department;
    }
  }

  Widget _construirBarraMini(String label, double porcentaje, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          width: 18,
          child: Text(
            label,
            style: TextStyle(color: Colors.white70, fontSize: 9),
            overflow: TextOverflow.clip,
          ),
        ),
        SizedBox(width: 2),
        Expanded(
          child: LinearProgressIndicator(
            value: porcentaje,
            backgroundColor: Colors.grey.shade700,
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 5,
          ),
        ),
      ],
    );
  }

  /// Panel de acciones (botones de ataque y curar/descansar)
  Widget _construirPanelAcciones() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black87,
        border: Border(
          top: BorderSide(
            color: Color(widget.faccionJugador.color),
            width: 3,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'SOLDADO: ${soldadoSeleccionado!.tipo.nombre}',
            style: TextStyle(
              color: Colors.amber,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _botonAccion(
                  'Rápido',
                  '5 PP',
                  'rapido',
                  5,
                  Colors.green,
                ),
              ),
              SizedBox(width: 6),
              Expanded(
                child: _botonAccion(
                  'Normal',
                  '10 PP',
                  'normal',
                  10,
                  Colors.orange,
                ),
              ),
              SizedBox(width: 6),
              Expanded(
                child: _botonAccion(
                  'Fuerte',
                  '20 PP',
                  'fuerte',
                  20,
                  Colors.red,
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: _botonAccion(
                  'Descansar',
                  '+PP',
                  'descansar',
                  0,
                  Colors.purple,
                ),
              ),
              SizedBox(width: 6),
              Expanded(
                child: _botonAccion(
                  'Curar',
                  '+PS',
                  'curar',
                  0,
                  Colors.teal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _botonAccion(String titulo, String subtitulo, String accion, int costePP, Color color) {
    // Solo deshabilitar si el soldado está KO
    final habilitado = !soldadoSeleccionado!.estaKO();
    // Cambiar opacidad si no hay suficiente PP
    final tienePP = accion == 'descansar' || accion == 'curar' || soldadoSeleccionado!.puedeAtacar(costePP);

    return Opacity(
      opacity: tienePP ? 1.0 : 0.5,
      child: ElevatedButton(
        onPressed: habilitado ? () => _seleccionarAccion(accion) : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          disabledBackgroundColor: Colors.grey.shade700,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 2),
            Text(
              subtitulo,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.normal,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  /// Overlay de animación con sistema de 4 fases tipo Darkest Dungeon
  Widget _construirAnimacionZoom() {
    final esAtacanteJugador = escuadronJugador.soldados.contains(atacanteAnimacion);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Distancias base
    final distanciaTotal = screenWidth * 0.35;

    // CAMERA SHAKE (afecta toda la pantalla)
    final cameraShakeX = _cameraShakeAnim.value > 0
        ? sin(_cameraShakeAnim.value * 3.14 * 6) * 8
        : 0.0;
    final cameraShakeY = _cameraShakeAnim.value > 0
        ? sin(_cameraShakeAnim.value * 3.14 * 5) * 5
        : 0.0;

    // FASE 1: Anticipación (retroceso + squash/stretch)
    final anticipacion = -20.0 * _anticipationAnim.value;
    final squashScale = 1.0 + (_anticipationAnim.value * 0.15); // Se achata ligeramente

    // FASE 2: Dash (lanzamiento hacia objetivo)
    final dashAvance = distanciaTotal * _dashAnim.value;

    // FASE 3: Reacción (shake del objetivo)
    final shakeObjetivo = _reactionAnim.value > 0
        ? (sin(_reactionAnim.value * 3.14 * 4) * 5) // Oscilación rápida
        : 0.0;

    // FASE 4: Recovery (retorno con overshoot)
    final recovery = _recoveryAnim.value;

    // Calcular posición final del atacante
    double desplazamientoAtacante;
    if (recovery > 0) {
      // En recovery, vuelve a posición original
      final retorno = dashAvance * (1 - recovery);
      desplazamientoAtacante = esAtacanteJugador
          ? anticipacion + retorno
          : -(anticipacion + retorno);
    } else {
      // En anticipación y dash
      desplazamientoAtacante = esAtacanteJugador
          ? anticipacion + dashAvance
          : -(anticipacion + dashAvance);
    }

    // Escala del atacante (crece en dash, con squash en anticipación)
    final escalaAtacante = squashScale * (1.0 + (_dashAnim.value * 0.4));

    // Rotación del objetivo al recibir impacto
    final rotacionObjetivo = _reactionAnim.value * 0.15 * (esAtacanteJugador ? -1 : 1);

    // Flash blanco al momento del impacto
    final flashIntensidad = ataqueExitoso ? _flashAnim.value : 0.0;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(cameraShakeX, cameraShakeY),
          child: Stack(
            children: [
              // Oscurecimiento de fondo (más intenso durante anticipación)
              Container(
                color: Colors.black.withOpacity(
                  0.3 + (_anticipationAnim.value * 0.3) + (_dashAnim.value * 0.2),
                ),
              ),

              // Flash de impacto (blanco normal, amarillo crítico)
              if (flashIntensidad > 0 && ataqueExitoso)
                Container(
                  color: (resultadoAtaqueActual?.esCritico ?? false)
                      ? Colors.yellow.withOpacity(flashIntensidad * 0.6)
                      : Colors.white.withOpacity(flashIntensidad * 0.5),
                ),

              // Sprite de SLASH (efecto visual de corte)
              if (_slashAnim.value > 0 && ataqueExitoso)
                Positioned(
                  left: esAtacanteJugador ? screenWidth * 0.45 : screenWidth * 0.35,
                  top: screenHeight * 0.3,
                  child: Transform.scale(
                    scale: 1.5 + (_slashAnim.value * 0.8),
                    child: Transform.rotate(
                      angle: esAtacanteJugador ? -0.3 : 0.3,
                      child: Opacity(
                        opacity: 1.0 - _slashAnim.value,
                        child: Icon(
                          Icons.close,
                          size: (resultadoAtaqueActual?.esCritico ?? false) ? 150 : 120,
                          color: (resultadoAtaqueActual?.esCritico ?? false)
                              ? Colors.yellow.withOpacity(0.9)
                              : Colors.red.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ),
                ),

              // Atacante que se mueve
              if (atacanteAnimacion != null)
                Positioned(
                  left: esAtacanteJugador ? 50 : null,
                  right: esAtacanteJugador ? null : 50,
                  top: screenHeight * 0.35,
                  child: Transform.translate(
                    offset: Offset(desplazamientoAtacante, 0),
                    child: Transform.scale(
                      scale: escalaAtacante,
                      child: Opacity(
                        opacity: 0.8 + (_anticipationAnim.value * 0.2), // Oscurecimiento en anticipación
                        child: _construirSoldadoAnimado(atacanteAnimacion!, true, esAtacanteJugador),
                      ),
                    ),
                  ),
                ),

            // Objetivo que recibe el impacto
            if (objetivoAnimacion != null)
              Positioned(
                left: esAtacanteJugador ? null : 50,
                right: esAtacanteJugador ? 50 : null,
                top: screenHeight * 0.35,
                child: Transform.translate(
                  offset: Offset(shakeObjetivo, 0),
                  child: Transform.rotate(
                    angle: rotacionObjetivo,
                    child: Opacity(
                      opacity: ataqueExitoso ? (1.0 - (_reactionAnim.value * 0.3)) : 1.0,
                      child: ColorFiltered(
                        colorFilter: _reactionAnim.value > 0 && ataqueExitoso
                            ? ColorFilter.mode(
                                Colors.red.withOpacity(_reactionAnim.value * 0.5),
                                BlendMode.srcATop,
                              )
                            : ColorFilter.mode(Colors.transparent, BlendMode.dst),
                        child: _construirSoldadoAnimado(objetivoAnimacion!, false, !esAtacanteJugador),
                      ),
                    ),
                  ),
                ),
              ),

              // Texto de FALLO si falló
              if (!ataqueExitoso && _dashAnim.value > 0.5)
                Center(
                  child: Transform.scale(
                    scale: 1.0 + (_dashAnim.value * 0.5),
                    child: Text(
                      '¡FALLO!',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 10,
                            color: Colors.black,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // Número de daño flotante (si fue exitoso)
              if (ataqueExitoso && resultadoAtaqueActual != null && _reactionAnim.value > 0)
                Positioned(
                  left: esAtacanteJugador ? screenWidth * 0.6 : screenWidth * 0.25,
                  top: screenHeight * 0.25 - (_reactionAnim.value * 50), // Sube mientras avanza la animación
                  child: Transform.scale(
                    scale: resultadoAtaqueActual!.esCritico 
                        ? 1.5 + (_reactionAnim.value * 0.5)
                        : 1.0 + (_reactionAnim.value * 0.3),
                    child: Opacity(
                      opacity: 1.0 - (_reactionAnim.value * 0.5),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Texto de CRÍTICO
                          if (resultadoAtaqueActual!.esCritico)
                            Text(
                              '¡CRÍTICO!',
                              style: TextStyle(
                                color: Colors.yellow,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    blurRadius: 15,
                                    color: Colors.orange,
                                    offset: Offset(0, 0),
                                  ),
                                  Shadow(
                                    blurRadius: 5,
                                    color: Colors.black,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                            ),
                          // Número de daño
                          Text(
                            '${resultadoAtaqueActual!.dano}',
                            style: TextStyle(
                              color: resultadoAtaqueActual!.esCritico 
                                  ? Colors.yellow 
                                  : Colors.red,
                              fontSize: resultadoAtaqueActual!.esCritico ? 80 : 60,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  blurRadius: resultadoAtaqueActual!.esCritico ? 20 : 10,
                                  color: resultadoAtaqueActual!.esCritico 
                                      ? Colors.orange 
                                      : Colors.black,
                                  offset: Offset(0, 0),
                                ),
                                Shadow(
                                  blurRadius: 5,
                                  color: Colors.black,
                                  offset: Offset(3, 3),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              // Indicador visual de IMPACT FREEZE
              if (_impactFreezeActive)
                Center(
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white,
                          blurRadius: 20,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _construirSoldadoAnimado(Soldado soldado, bool esAtacante, bool miraIzquierda) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: esAtacante
            ? Colors.amber.shade800.withOpacity(0.7)
            : Colors.red.shade800.withOpacity(0.7),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: esAtacante ? Colors.amber : Colors.red,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: (esAtacante ? Colors.amber : Colors.red).withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Color(soldado.faccion.color).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Color(soldado.faccion.color),
                width: 3,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(9),
              child: Transform.flip(
                flipX: !miraIzquierda, // Flip si mira a la derecha
                child: Image.asset(
                  _obtenerSpriteSoldado(soldado.faccion, soldado.tipo),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      _iconoPorTipo(soldado.tipo),
                      color: Color(soldado.faccion.color),
                      size: 50,
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            soldado.tipo.nombreCorto,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// Obtiene la ruta del sprite del soldado según facción y tipo
  String _obtenerSpriteSoldado(Faccion faccion, TipoSoldado tipo) {
    final carpeta = faccion == Faccion.aliados ? 'fra' : 'aleman';
    String archivo;

    switch (tipo) {
      case TipoSoldado.ametralladora:
        archivo = faccion == Faccion.aliados ? 'mg_rifle.webp' : 'MG_aleman.webp';
        break;
      case TipoSoldado.rifle:
        archivo = faccion == Faccion.aliados ? 'rifle_fr.webp' : 'rifle_aleman.webp';
        break;
      case TipoSoldado.asalto:
        archivo = faccion == Faccion.aliados ? 'asalto_fr.webp' : 'asalto_aleman.webp';
        break;
    }

    return 'assets/sprites/$carpeta/$archivo';
  }
}
