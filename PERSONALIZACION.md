# 🎨 Guía de Personalización - Batalla Pokémon

Esta guía te ayudará a personalizar y ampliar el proyecto base según tus preferencias.

## 🖼️ Agregar Imágenes de Pokémon

### 1. Preparar las imágenes
- Crea una carpeta `assets/images/` en la raíz del proyecto
- Agrega tus imágenes (por ejemplo: `pikachu.png`, `charmander.png`)

### 2. Actualizar pubspec.yaml
```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/images/
```

### 3. Usar las imágenes en el código
En `pantalla_batalla.dart`, dentro de `_construirCartaPokemon()`:
```dart
// Agregar antes del nombre del Pokémon
Image.asset(
  'assets/images/${pokemon.nombre.toLowerCase()}.png',
  width: 100,
  height: 100,
  errorBuilder: (context, error, stackTrace) {
    return Icon(Icons.catching_pokemon, size: 100);
  },
),
```

## 🎭 Cambiar Nombres de Pokémon

En [pantalla_batalla.dart](lib/pantalles/pantalla_batalla.dart#L26-L27):
```dart
void _iniciarBatalla() {
  pokemon1 = Pokemon(nombre: 'Tu Pokémon 1');
  pokemon2 = Pokemon(nombre: 'Tu Pokémon 2');
  turnoActual = 1;
  totalAtaques = 0;
  tiempoInicio = DateTime.now();
}
```

## ✨ Agregar Animaciones

### Animación de Ataque
En [pantalla_batalla.dart](lib/pantalles/pantalla_batalla.dart), agregar al State:
```dart
bool _animandoAtaque = false;

void _realizarAtaque(String tipoAtaque) async {
  setState(() => _animandoAtaque = true);
  
  await Future.delayed(Duration(milliseconds: 300));
  
  setState(() {
    _animandoAtaque = false;
    // ... resto del código de ataque
  });
}
```

### Animación en la carta del Pokémon
```dart
AnimatedOpacity(
  opacity: pokemon.estaKO() ? 0.3 : 1.0,
  duration: Duration(milliseconds: 500),
  child: // ... tu carta de Pokémon
)
```

## 🎵 Agregar Sonidos

### 1. Instalar el paquete
En `pubspec.yaml`:
```yaml
dependencies:
  flutter:
    sdk: flutter
  audioplayers: ^5.0.0
```

### 2. Agregar archivos de audio
```
assets/
  sounds/
    ataque.mp3
    victoria.mp3
```

### 3. Actualizar pubspec.yaml
```yaml
flutter:
  assets:
    - assets/sounds/
```

### 4. Usar en el código
```dart
import 'package:audioplayers/audioplayers.dart';

final player = AudioPlayer();

void _reproducirSonido(String sonido) async {
  await player.play(AssetSource('sounds/$sonido.mp3'));
}

// Al atacar:
_reproducirSonido('ataque');
```

## 🎨 Usar Google Fonts

### 1. Instalar el paquete
En `pubspec.yaml`:
```yaml
dependencies:
  flutter:
    sdk: flutter
  google_fonts: ^6.0.0
```

### 2. Usar en main.dart
```dart
import 'package:google_fonts/google_fonts.dart';

theme: ThemeData(
  primarySwatch: Colors.red,
  useMaterial3: true,
  textTheme: GoogleFonts.pressStart2pTextTheme(),
),
```

## 🎮 Agregar Selección de Pokémon

### 1. Crear nueva pantalla
[pantalla_seleccion.dart](lib/pantalles/pantalla_seleccion.dart):
```dart
class PantallaSeleccion extends StatelessWidget {
  final List<String> pokemones = ['Pikachu', 'Charmander', 'Bulbasaur', 'Squirtle'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Selecciona tu Pokémon')),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: pokemones.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PantallaBatalla(
                    nombrePokemon1: pokemones[index],
                  ),
                ),
              );
            },
            child: Card(
              child: Center(
                child: Text(pokemones[index]),
              ),
            ),
          );
        },
      ),
    );
  }
}
```

### 2. Modificar PantallaBatalla
```dart
class PantallaBatalla extends StatefulWidget {
  final String? nombrePokemon1;
  final String? nombrePokemon2;

  const PantallaBatalla({
    super.key,
    this.nombrePokemon1,
    this.nombrePokemon2,
  });
}

void _iniciarBatalla() {
  pokemon1 = Pokemon(nombre: widget.nombrePokemon1 ?? 'Pikachu');
  pokemon2 = Pokemon(nombre: widget.nombrePokemon2 ?? 'Charmander');
  // ...
}
```

## 💫 Agregar Movimientos Especiales

### En pokemon.dart, agregar nuevos métodos:
```dart
// Curación (restaura 20 PS, cuesta 15 PP)
void curarse() {
  if (ppActuales >= 15) {
    ppActuales -= 15;
    psActuales = (psActuales + 20).clamp(0, psMaximos);
  }
}

// Ataque Crítico (2x daño, 5% probabilidad)
int calcularDanoCritico(int danoBase) {
  final random = Random();
  if (random.nextInt(100) < 5) {
    return danoBase * 2; // ¡Crítico!
  }
  return danoBase;
}

// Ataque que puede fallar (90% precisión)
bool ataqueAcierta() {
  final random = Random();
  return random.nextInt(100) < 90;
}
```

### En pantalla_batalla.dart:
```dart
void _realizarAtaque(String tipoAtaque) {
  setState(() {
    // Verificar si el ataque acierta
    if (!atacante.ataqueAcierta()) {
      _mostrarMensaje('¡${atacante.nombre} falló el ataque!');
      turnoActual = turnoActual == 1 ? 2 : 1;
      return;
    }
    
    // Calcular daño con posibilidad de crítico
    int dano = // ... calcular daño normal
    dano = atacante.calcularDanoCritico(dano);
    
    // ... resto del código
  });
}

// Agregar botón de curación
_construirBotonCuracion() {
  return ElevatedButton(
    onPressed: pokemon.ppActuales >= 15
        ? () {
            setState(() {
              pokemon.curarse();
              turnoActual = turnoActual == 1 ? 2 : 1;
            });
          }
        : null,
    child: Text('Curarse\n(15 PP)'),
  );
}
```

## 📊 Historial de Movimientos

### 1. Agregar al State de PantallaBatalla:
```dart
List<String> historial = [];

void _registrarMovimiento(String movimiento) {
  historial.add(movimiento);
}
```

### 2. Agregar widget de historial:
```dart
// En el build(), agregar:
Expanded(
  child: ListView.builder(
    itemCount: historial.length,
    itemBuilder: (context, index) {
      return ListTile(
        leading: Icon(Icons.flash_on),
        title: Text(historial[index]),
      );
    },
  ),
)
```

## 🏆 Estadísticas Avanzadas

### En pantalla_final.dart, agregar más estadísticas:
```dart
class PantallaFinal extends StatelessWidget {
  final String ganador;
  final int totalAtaques;
  final Duration duracion;
  final int danoTotalInfligido;
  final int ppTotalConsumido;
  final int ataquesCriticos;

  // ... constructor

  // Agregar widgets para mostrar las estadísticas adicionales
}
```

## 🎨 Temas Personalizados

### Tema Oscuro/Claro
En [main.dart](lib/main.dart):
```dart
class BatallaPokemonApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Batalla Pokémon',
      debugShowCheckedModeBanner: false,
      
      // Tema claro
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.red,
        useMaterial3: true,
      ),
      
      // Tema oscuro
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.red,
        useMaterial3: true,
      ),
      
      // Usar tema del sistema
      themeMode: ThemeMode.system,
      
      home: const PantallaInicio(),
    );
  }
}
```

## 🎯 Efectos Visuales Adicionales

### Vibración al atacar
Instalar: `vibration: ^1.8.4`
```dart
import 'package:vibration/vibration.dart';

void _realizarAtaque(String tipoAtaque) {
  Vibration.vibrate(duration: 100);
  // ... resto del código
}
```

### Partículas de impacto
Instalar: `flutter_particle_system: ^0.1.0`
```dart
// Agregar efectos de partículas al golpear
```

## 💡 Consejos de Desarrollo

1. **Prueba frecuentemente**: Ejecuta `flutter run` después de cada cambio importante
2. **Hot Reload**: Usa `r` en la terminal para recargar sin reiniciar
3. **DevTools**: Ejecuta `flutter pub global activate devtools` para herramientas de debugging
4. **Errores de compilación**: Asegúrate de que `pubspec.yaml` esté correctamente indentado
5. **Assets**: Siempre ejecuta `flutter pub get` después de modificar `pubspec.yaml`

## 🔧 Comandos Útiles

```bash
# Obtener dependencias
flutter pub get

# Limpiar caché de build
flutter clean

# Ejecutar en Web
flutter run -d chrome

# Generar APK
flutter build apk

# Ver dispositivos disponibles
flutter devices

# Analizar código
flutter analyze
```

---

¡Personaliza tu juego y hazlo único! 🚀
