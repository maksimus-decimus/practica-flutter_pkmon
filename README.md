# 🎮 Batalla Táctica - Proyecto Flutter

Videojuego de estrategia por turnos estilo **Darkest Dungeon** con mecánicas de combate táctico entre escuadrones militares.

## 📋 Descripción

Juego de batalla táctica donde dos escuadrones de 3 soldados cada uno se enfrentan en combate por turnos. Cada soldado tiene características únicas, diferentes tipos de ataque y la capacidad de descansar para recuperar munición (PP). El jugador selecciona su facción, elige qué soldado ataca y a qué enemigo, con animaciones de zoom durante los ataques.

## ✨ Características Implementadas

### Sistema de Juego
- ✅ **Dos facciones**: Aliados vs Eje
- ✅ **3 tipos de soldados** por escuadrón:
  - **Ametralladora (MG)**: 150 PS / 25 PP - Tanque con alta resistencia
  - **Rifle**: 100 PS / 30 PP - Balanceado
  - **Asalto**: 80 PS / 35 PP - Alto daño, baja vida
  
### Mecánicas de Combate
- ✅ **Sistema de turnos** por soldado individual
- ✅ **Selección de atacante y objetivo**: Elige quién ataca y a quién
- ✅ **3 tipos de ataque**:
  - Rápido (5 PP): Bajo daño
  - Normal (10 PP): Daño medio
  - Fuerte (20 PP): Alto daño
- ✅ **Descansar**: Recupera 8-15 PP aleatorios
- ✅ **Daño variable** según tipo de soldado
- ✅ **Victoria**: Elimina todos los soldados enemigos

### Interfaz Estilo Darkest Dungeon
- ✅ **Formación horizontal**: Soldados dispuestos en fila
  - Aliados a la izquierda (→)
  - Enemigos a la derecha (←)
- ✅ **Animación de zoom**: Al atacar, hace zoom entre atacante y objetivo
- ✅ **IA enemiga**: Ataca automáticamente en su turno
- ✅ **Barras de vida y munición** en cada soldado
- ✅ **Sistema de selección visual**: Resaltado amarillo para atacante, rojo para objetivo
- ✅ **Panel de acciones**: Aparece al seleccionar soldado

### Visual y UX
- ✅ Selección de facción con cards visuales
- ✅ Colores distintivos por facción (Azul/Rojo)
- ✅ Animaciones suaves con `AnimationController`
- ✅ Mensajes de combate con `SnackBar`
- ✅ Estados visuales (KO, seleccionado, objetivo)
- ✅ Iconos diferenciados por tipo de soldado

## 📁 Estructura del Proyecto

```
practica_flutter/
├── lib/
│   ├── main.dart                              # Punto de entrada
│   ├── models/
│   │   ├── faccion.dart                       # Enum de facciones (Aliados/Eje)
│   │   ├── soldado.dart                       # Clase Soldado con 3 tipos
│   │   └── escuadron.dart                     # Escuadrón de 3 soldados
│   └── pantalles/
│       ├── pantalla_inicio.dart               # Menú principal
│       ├── pantalla_seleccion_faccion.dart    # Selección Aliados/Eje
│       ├── pantalla_batalla_tactica.dart      # Combate estilo Darkest Dungeon
│       └── pantalla_final.dart                # Resultados
├── assets/
│   ├── images/
│   │   ├── banderas/                          # Banderas de facciones
│   │   │   ├── aliados.png
│   │   │   └── eje.png
│   │   └── soldados/                          # Sprites de soldados
│   │       ├── aliados_mg.png
│   │       ├── aliados_rifle.png
│   │       ├── aliados_asalto.png
│   │       ├── eje_mg.png
│   │       ├── eje_rifle.png
│   │       └── eje_asalto.png
│   └── sounds/                                # Sonidos (opcional)
│       ├── rifle_aliados.mp3
│       └── rifle_eje.mp3
├── pubspec.yaml                               # Configuración
└── README.md                                  # Este archivo
```

## 🚀 Cómo Ejecutar

1. **Instalar Flutter** (si no lo tienes):
   ```bash
   # Visita: https://flutter.dev/docs/get-started/install
   ```

2. **Verificar la instalación**:
   ```bash
   flutter doctor
   ```

3. **Navegar al directorio del proyecto**:
   ```bash
   cd practica_flutter
   ```

4. **Obtener dependencias**:
   ```bash
   flutter pub get
   ```

5. **Ejecutar en emulador o dispositivo**:
   ```bash
   flutter run
   ```

## 🎯 Flujo del Juego

1. **Pantalla de Inicio**: Botón "Comenzar Batalla"
2. **Selección de Facción**: Elige entre Aliados o Eje
   - El oponente automáticamente usa la facción contraria
3. **Batalla Táctica**:
   - 3 soldados por bando enfrentados
   - Formación horizontal estilo Darkest Dungeon
   - **Tu turno**:
     1. Selecciona un soldado de tu escuadrón (click)
     2. Elige acción: Ataque Rápido, Normal, Fuerte o Descansar
     3. Si atacas: selecciona objetivo enemigo
     4. Animación de zoom entre atacante y objetivo
   - **Turno enemigo**: IA ataca automáticamente
   - Repite hasta que un escuadrón sea eliminado
4. **Pantalla Final**: 
   - Muestra ganador y estadísticas
   - Nueva batalla o volver al inicio

## 🎮 Controles y Mecánicas

### Selección de Soldado
- **Click** en un soldado de tu escuadrón para seleccionarlo
- Aparece resaltado en **amarillo**
- Se muestra panel de acciones en la parte inferior

### Acciones Disponibles
- **Ataque Rápido** (5 PP): 
  - MG: 8-12 daño
  - Rifle: 12-17 daño
  - Asalto: 15-20 daño
  
- **Ataque Normal** (10 PP):
  - MG: 15-22 daño
  - Rifle: 20-27 daño
  - Asalto: 25-34 daño
  
- **Ataque Fuerte** (20 PP):
  - MG: 30-39 daño
  - Rifle: 35-49 daño
  - Asalto: 45-59 daño
  
- **Descansar** (0 PP):
  - Recupera 8-15 PP aleatorios
  - Pasa el turno inmediatamente

### Selección de Objetivo
- Tras elegir ataque, **click** en soldado enemigo
- Objetivo resaltado en **rojo**
- Animación de zoom al ejecutar

### Tipos de Soldado

| Tipo | PS | PP | Rol | Estrategia |
|------|----|----|-----|------------|
| **MG** | 150 | 25 | Tanque | Absorbe daño, aguante prolongado |
| **Rifle** | 100 | 30 | Versátil | Balanceado, buena elección general |
| **Asalto** | 80 | 35 | DPS | Elimina enemigos rápido pero frágil |

## 🔧 Personalización

### Agregar Imágenes de Soldados y Banderas

1. **Coloca las imágenes en las carpetas correspondientes**:
   - Banderas: `assets/images/banderas/`
   - Soldados: `assets/images/soldados/`
   
2. **Nombra los archivos correctamente**:
   - `aliados.png`, `eje.png` (banderas)
   - `aliados_mg.png`, `aliados_rifle.png`, etc. (soldados)
   
3. **No necesitas modificar código** - las rutas ya están configuradas

**Ver README en cada carpeta de assets para más detalles**

### Agregar Sonidos (Opcional)

1. **Instala el paquete audioplayers**:
   ```yaml
   dependencies:
     audioplayers: ^5.0.0
   ```

2. **Coloca archivos MP3** en `assets/sounds/`

3. **Implementa en el código**:
   ```dart
   import 'package:audioplayers/audioplayers.dart';
   
   final player = AudioPlayer();
   await player.play(AssetSource('sounds/rifle_aliados.mp3'));
   ```

### Modificar Estadísticas de Soldados

En [soldado.dart](lib/models/soldado.dart), ajusta valores en `TipoSoldadoExtension`:

```dart
int get psMaximos {
  switch (this) {
    case TipoSoldado.ametralladora:
      return 200; // Aumentar vida del tanque
    // ...
  }
}
```

### Agregar Más Facciones

1. Añade enum en [faccion.dart](lib/models/faccion.dart):
   ```dart
   enum Faccion {
     aliados,
     eje,
     sovieticos, // Nueva facción
   }
   ```

2. Actualiza extensión con nombre, bandera y colores

3. Agrega assets correspondientes

### Cambiar Animación de Zoom

En [pantalla_batalla_tactica.dart](lib/pantalles/pantalla_batalla_tactica.dart):

```dart
_animationController = AnimationController(
  duration: Duration(milliseconds: 1000), // Más rápido
  vsync: this,
);

_scaleAnimation = Tween<double>(begin: 1.0, end: 3.0).animate(
  // Más zoom
  CurvedAnimation(
    parent: _animationController,
    curve: Curves.elasticOut, // Diferente curva
  ),
);
```

## 📚 Conceptos de Flutter Utilizados

- `StatefulWidget` y `StatelessWidget`
- `setState()` para actualización de UI
- `Navigator` para navegación entre pantallas
- `AnimationController` y `Tween` para animaciones complejas
- `SingleTickerProviderStateMixin` para animaciones
- `GestureDetector` para detección de toques
- `LinearProgressIndicator` para barras de vida/munición
- `Stack` y `Positioned` para overlays
- `AnimatedBuilder` para reconstruir durante animaciones
- Enums y extensiones para organizar datos
- Gestión de listas de objetos complejos
- Separación de lógica (models) y presentación (widgets)

## 🎨 Referencias de Diseño

Este juego está inspirado en:
- **Darkest Dungeon**: Sistema de formación y combate
- **XCOM**: Combate táctico por turnos
- **Into the Breach**: Selección de objetivo visual

## 🚀 Ideas para Expandir

- [ ] Más tipos de soldados (francotirador, médico, ingeniero)
- [ ] Habilidades especiales únicas por soldado
- [ ] Sistema de experiencia y nivel
- [ ] Múltiples misiones/campañas
- [ ] Efectos de estado (aturdido, envenenado, etc.)
- [ ] Cobertura y posicionamiento táctico
- [ ] Mejoras de equipo entre batallas
- [ ] Sonidos y música ambiente
- [ ] Modo multijugador local
- [ ] Guardado de progreso con SharedPreferences

## 📝 Notas Técnicas

- El proyecto usa **Material Design 3** (`useMaterial3: true`)
- Animaciones optimizadas con `SingleTickerProviderStateMixin`
- IA enemiga simple: ataca soldado aleatorio con ataque normal
- Assets organizados por tipo (banderas, soldados, sonidos)
- Código modular y fácil de extender
- Sin dependencias externas (excepto Flutter SDK)

## 🐛 Troubleshooting

### "No se ven las imágenes"
- Verifica que ejecutaste `flutter pub get`
- Comprueba que los nombres coinciden exactamente
- Revisa que `pubspec.yaml` tenga los assets configurados

### "Error al compilar"
- Ejecuta `flutter clean`
- Ejecuta `flutter pub get`
- Reinicia el IDE

### "Animación se ve mal"
- Ajusta `duration` y `Tween` valores en `_iniciarAnimaciones()`
- Prueba diferentes `Curves` (easeIn, bounceOut, etc.)

---

**Asignatura**: 0488 Desenvolupament d'Interfícies  
**Ciclo**: DAM (Desarrollo de Aplicaciones Multiplataforma)  
**Tecnología**: Flutter / Dart

---

¡Disfruta del combate táctico! ⚔️🎖️
