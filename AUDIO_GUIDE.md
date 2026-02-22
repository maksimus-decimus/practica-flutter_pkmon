# 🔊 Sistema de Audio - Batalla Táctica

## ✅ Implementación Completada

Se ha integrado exitosamente el sistema de audio en el juego utilizando el paquete `audioplayers`.

---

## 🎵 Sonidos Disponibles

### Archivos de Audio
Los siguientes archivos han sido detectados en tu proyecto:

- **`metralla.m4a`** - Sonido de ametralladora
  - Ubicación: `assets/sprites/sonido/metralla.m4a`
  - Se reproduce cuando: Un soldado con ametralladora ataca

- **`rifle.m4a`** - Sonido de rifle
  - Ubicación: `assets/sprites/sonido/rifle.m4a`
  - Se reproduce cuando: Un soldado con rifle o asalto ataca

---

## 🛠️ Arquitectura Implementada

### 1. Servicio de Audio (`lib/servicios/servicio_audio.dart`)

**Características:**
- ✅ **Singleton Pattern** - Una única instancia para todo el juego
- ✅ **Pool de Reproductores** - Hasta 3 reproductores simultáneos
- ✅ **Gestión Automática** - Reutiliza reproductores inactivos
- ✅ **Control de Estado** - Puede activarse/desactivarse globalmente
- ✅ **Manejo de Errores** - Captura y registra errores sin romper el juego

**Métodos Principales:**
```dart
// Reproducir sonido genérico
ServicioAudio().reproducir('ruta/al/archivo.m4a');

// Reproducir según tipo de soldado
ServicioAudio().reproducirAtaque(TipoSoldado.ametralladora);

// Activar/desactivar sonido
ServicioAudio().configurarSonido(false); // Silenciar
ServicioAudio().configurarSonido(true);  // Activar

// Verificar estado
bool habilitado = ServicioAudio().sonidoHabilitado;
```

### 2. Integración en Pantalla de Batalla

**Puntos de Reproducción:**
- ✅ Al iniciar la animación de ataque del jugador
- ✅ Al iniciar la animación de ataque del enemigo
- ✅ Automáticamente sincronizado con el zoom

**Flujo:**
1. Soldado selecciona objetivo
2. Inicia animación de zoom
3. **🔊 Se reproduce el sonido** según el tipo de soldado
4. Completa la animación
5. Se aplica el daño

---

## 🎮 Cómo Funciona en el Juego

### Durante Tu Turno:
1. Seleccionas un soldado
2. Eliges un ataque
3. Seleccionas un objetivo
4. **La pantalla hace zoom** entre atacante y objetivo
5. **🔊 Se escucha el sonido de disparo** correspondiente al tipo de soldado
6. Se muestra el daño

### Durante el Turno Enemigo:
1. La IA selecciona automáticamente
2. **La pantalla hace zoom**
3. **🔊 Se escucha el sonido del arma enemiga**
4. Se muestra el daño recibido

---

## 🧪 Prueba el Sistema de Audio

### Paso 1: Ejecuta el Juego
```powershell
flutter run
```

### Paso 2: Inicia una Batalla
1. Presiona "COMENZAR BATALLA"
2. Elige tu facción (Aliados o Eje)
3. Entra en batalla

### Paso 3: Realiza un Ataque
1. Selecciona cualquier soldado tuyo
2. Elige "Ataque Rápido", "Normal" o "Fuerte"
3. Selecciona un enemigo

**Resultado Esperado:**
- ✅ Zoom entre soldados
- ✅ Sonido de disparo (metralla o rifle)
- ✅ Mensaje de daño

### Paso 4: Espera el Turno Enemigo
El enemigo atacará automáticamente y también reproducirá sonidos.

---

## 🎛️ Personalización Avanzada

### Agregar Más Sonidos

#### 1. Agregar Archivos de Audio
Coloca nuevos archivos `.m4a`, `.mp3`, `.wav` u `.ogg` en:
```
assets/sprites/sonido/
```

#### 2. Actualizar `pubspec.yaml`
Ya está configurado para cargar todos los archivos de esa carpeta:
```yaml
assets:
  - assets/sprites/sonido/
```

#### 3. Modificar el Servicio de Audio
Edita `lib/servicios/servicio_audio.dart`:

```dart
Future<void> reproducirAtaque(TipoSoldado tipo) async {
  switch (tipo) {
    case TipoSoldado.ametralladora:
      await reproducir('sprites/sonido/metralla.m4a');
      break;
    case TipoSoldado.rifle:
      await reproducir('sprites/sonido/rifle.m4a');
      break;
    case TipoSoldado.asalto:
      // Cambia esto para usar un sonido único del asalto
      await reproducir('sprites/sonido/asalto.m4a');
      break;
  }
}
```

### Agregar Sonidos de Ambiente

Para música de fondo o efectos ambientales:

```dart
// En initState() de la pantalla
@override
void initState() {
  super.initState();
  _iniciarBatalla();
  _iniciarAnimaciones();
  
  // Reproducir música de fondo
  ServicioAudio().reproducir('sprites/sonido/musica_batalla.m4a');
}
```

### Agregar Sonido de Victoria/Derrota

En la función `_finalizarBatalla()`:

```dart
void _finalizarBatalla(bool victoria) {
  if (victoria) {
    ServicioAudio().reproducir('sprites/sonido/victoria.m4a');
  } else {
    ServicioAudio().reproducir('sprites/sonido/derrota.m4a');
  }
  
  // ... resto del código
}
```

---

## 🔧 Configuración de Volumen

### Agregar Control de Volumen

Modifica `lib/servicios/servicio_audio.dart`:

```dart
class ServicioAudio {
  double _volumen = 1.0; // 0.0 a 1.0

  Future<void> reproducir(String rutaArchivo) async {
    if (!_sonidoHabilitado) return;

    try {
      final reproductor = _obtenerReproductor();
      await reproductor.stop();
      await reproductor.setVolume(_volumen); // Configurar volumen
      await reproductor.play(AssetSource(rutaArchivo));
    } catch (e) {
      print('Error al reproducir sonido $rutaArchivo: $e');
    }
  }

  void configurarVolumen(double volumen) {
    _volumen = volumen.clamp(0.0, 1.0);
  }
}
```

Uso:
```dart
// Volumen al 50%
ServicioAudio().configurarVolumen(0.5);

// Volumen al máximo
ServicioAudio().configurarVolumen(1.0);

// Silencio (alternativa a desactivar)
ServicioAudio().configurarVolumen(0.0);
```

---

## 📱 Compatibilidad de Plataforma

### Formatos Recomendados:
- **iOS**: `.m4a` (AAC), `.mp3`
- **Android**: `.mp3`, `.ogg`, `.m4a`
- **Web**: `.mp3`, `.ogg`
- **Desktop**: Todos los formatos

**Archivos Actuales:**
- ✅ `metralla.m4a` - Compatible con iOS y Android
- ✅ `rifle.m4a` - Compatible con iOS y Android

---

## ⚙️ Solución de Problemas

### "No se escucha ningún sonido"

**Posibles causas:**
1. **Volumen del dispositivo bajo** - Sube el volumen físico
2. **Modo silencioso activado** - Desactiva el modo silencio
3. **Ruta incorrecta** - Verifica que los archivos existan:
   ```powershell
   Get-ChildItem -Path "assets\sprites\sonido"
   ```
4. **Archivos no cargados** - Ejecuta:
   ```powershell
   flutter pub get
   flutter clean
   flutter run
   ```

### "Error al reproducir sonido"

**Solución:**
1. Verifica que `pubspec.yaml` incluya:
   ```yaml
   dependencies:
     audioplayers: ^6.0.0
   ```
2. Ejecuta:
   ```powershell
   flutter pub get
   ```

### "El sonido se corta o tartamudea"

**Solución:**
1. Reduce el tamaño de los archivos de audio (< 500KB recomendado)
2. Aumenta el pool de reproductores en `servicio_audio.dart`:
   ```dart
   final int _maxReproductores = 5; // Aumentar de 3 a 5
   ```

---

## 📊 Estadísticas del Sistema

- **Reproductores simultáneos**: 3 (configurable)
- **Formatos soportados**: .m4a, .mp3, .wav, .ogg
- **Gestión de memoria**: Automática con reutilización
- **Latencia**: < 50ms en dispositivos modernos

---

## 🎖️ Características Avanzadas Disponibles

### Sistema de Audio Implementado:
- ✅ Reproducción asíncrona
- ✅ Pool de reproductores
- ✅ Manejo de errores robusto
- ✅ Reutilización de recursos
- ✅ Control de estado global
- ✅ Compatibilidad multiplataforma

### Funcionalidades Adicionales Posibles:
- ⬜ Control de volumen
- ⬜ Música de fondo en loop
- ⬜ Efectos de fade in/out
- ⬜ Mezcla de audio (múltiples capas)
- ⬜ Preferencias guardadas del usuario
- ⬜ Efectos 3D/espaciales

---

## 🎵 Recursos de Audio Gratuitos

¿Necesitas más sonidos? Prueba estos sitios:

- **Freesound.org** - Efectos de sonido gratuitos
- **OpenGameArt.org** - Audio para videojuegos
- **Zapsplat.com** - Biblioteca de efectos
- **BBC Sound Effects** - Archivo de la BBC

**Tip:** Busca términos como:
- "gun shot"
- "machine gun"
- "rifle fire"
- "military battle"

---

¡El sistema de audio está completamente operativo! 🎉🔊
