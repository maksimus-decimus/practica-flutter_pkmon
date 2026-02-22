# 🎮 Guía Completa - Batalla Táctica

## 📖 Introducción

Bienvenido a **Batalla Táctica**, un juego de estrategia por turnos donde comandas un escuadrón de 3 soldados en combate contra las fuerzas enemigas. Inspirado en juegos como Darkest Dungeon, cada decisión cuenta y la estrategia es clave para la victoria.

---

## 🎯 Objetivo del Juego

**Elimina a los 3 soldados enemigos antes de que ellos eliminen a los tuyos.**

---

## 🚀 Cómo Empezar

### 1. Pantalla de Inicio
- Presiona **"COMENZAR BATALLA"** para iniciar
- O **"SALIR"** para cerrar el juego

### 2. Selección de Facción
Elige tu bando:

#### 🔵 ALIADOS
- Color: Azul
- Representan: Fuerzas democráticas
- Estrategia sugerida: Equilibrio entre defensa y ataque

#### 🔴 EJE
- Color: Rojo
- Representan: Fuerzas del eje
- Estrategia sugerida: Agresión y poder de fuego

**El enemigo automáticamente tomará la facción contraria.**

---

## ⚔️ Pantalla de Batalla

### Disposición del Campo

```
┌─────────────────────────────────────────────┐
│     TU ESCUADRÓN         VS    ENEMIGO      │
├─────────────────────────────────────────────┤
│                                             │
│   [MG] ───────────────────────> [MG]       │
│                                             │
│   [Rifle] ─────────────────────> [Rifle]   │
│                                             │
│   [Asalto] ────────────────────> [Asalto]  │
│                                             │
└─────────────────────────────────────────────┘
```

- **Izquierda**: Tu escuadrón (mirando a la derecha →)
- **Derecha**: Escuadrón enemigo (mirando a la izquierda ←)
- **Centro**: Zona de combate

---

## 👥 Tipos de Soldados

### 🛡️ Ametralladora (MG)
**Rol**: Tanque / Soporte de fuego

| Estadística | Valor |
|-------------|-------|
| Puntos de Salud (PS) | 150 |
| Puntos de Poder (PP) | 25 |
| Icono | Escudo 🛡️ |

**Daño por Ataque**:
- Rápido (5 PP): 8-12
- Normal (10 PP): 15-22
- Fuerte (20 PP): 30-39

**Estrategia**: 
- Usa al MG para absorber daño
- Perfecto para ataques sostenidos
- Mantén vivo para proteger unidades frágiles

---

### ⚡ Rifle
**Rol**: Unidad versátil / Daño balanceado

| Estadística | Valor |
|-------------|-------|
| Puntos de Salud (PS) | 100 |
| Puntos de Poder (PP) | 30 |
| Icono | Rayo ⚡ |

**Daño por Ataque**:
- Rápido (5 PP): 12-17
- Normal (10 PP): 20-27
- Fuerte (20 PP): 35-49

**Estrategia**:
- Unidad más equilibrada
- Buena elección para cualquier situación
- Usa cuando no estés seguro de qué hacer

---

### 🔥 Asalto
**Rol**: DPS (Daño por Segundo) / Eliminador

| Estadística | Valor |
|-------------|-------|
| Puntos de Salud (PS) | 80 |
| Puntos de Poder (PP) | 35 |
| Icono | Fuego 🔥 |

**Daño por Ataque**:
- Rápido (5 PP): 15-20
- Normal (10 PP): 25-34
- Fuerte (20 PP): 45-59

**Estrategia**:
- Máximo daño pero muy frágil
- Elimina objetivos débiles rápidamente
- Protégelo, puede decidir la batalla

---

## 🎮 Cómo Jugar Tu Turno

### Paso 1: Selecciona tu Soldado
1. Es **TU TURNO** (indicado en la barra superior)
2. **Click** en uno de tus soldados (izquierda)
3. El soldado seleccionado se resalta en **amarillo**
4. Aparece el panel de acciones abajo

### Paso 2: Elige una Acción

Verás 4 botones:

#### 🟢 Ataque Rápido (5 PP)
- Bajo coste de munición
- Daño moderado
- Úsalo cuando tengas poco PP

#### 🟠 Ataque Normal (10 PP)
- Coste medio
- Buen daño
- Opción más común

#### 🔴 Ataque Fuerte (20 PP)
- Alto coste
- Daño devastador
- Úsalo para rematar enemigos

#### 🟣 Descansar (0 PP)
- No ataca
- Recupera **8-15 PP aleatorios**
- Pasa el turno
- Úsalo cuando tengas poco PP

### Paso 3: Selecciona Objetivo (Solo para ataques)

Si elegiste un ataque:
1. Los soldados enemigos se iluminan
2. **Click** en el enemigo que quieres atacar
3. El objetivo se resalta en **rojo**

### Paso 4: Animación de Ataque

1. La pantalla hace **zoom** entre atacante y objetivo
2. Se muestra el ataque en grande
3. Se aplica el daño
4. Aparece mensaje con el resultado
5. Vuelve a la vista normal

### Paso 5: Turno Enemigo

Automáticamente la IA enemiga:
1. Selecciona un soldado
2. Ataca a uno de tus soldados
3. Se muestra la animación
4. Vuelve a ser tu turno

---

## 📊 Interfaz de Usuario

### Barra Superior
```
┌───────────────────────────────────────────┐
│  TU ESCUADRÓN    🎖️ Ataques: 12   ENEMIGO │
│    3/3 vivos                      2/3 vivos│
└───────────────────────────────────────────┘
```

### Carta de Soldado
```
┌─────────────┐
│   [Icono]   │ ← Tipo de soldado
│     MG      │ ← Nombre
│ PS ████░░   │ ← Barra de vida
│ PP ███░░░   │ ← Barra de munición
└─────────────┘
```

### Panel de Acciones (Cuando seleccionas soldado)
```
┌───────────────────────────────────────────┐
│        SOLDADO: Ametralladora             │
├──────┬──────┬──────┬──────────────────────┤
│Rápido│Normal│Fuerte│    Descansar         │
│(5 PP)│(10PP)│(20PP)│   (+8-15 PP)         │
└──────┴──────┴──────┴──────────────────────┘
```

---

## 🎖️ Estrategias y Consejos

### ✅ Tácticas Efectivas

#### 1. **Prioriza Objetivos Débiles**
- Elimina primero a soldados con pocos PS
- Un enemigo menos = menos ataques contra ti

#### 2. **Gestiona tu Munición (PP)**
- No uses siempre ataques fuertes
- Descansa cuando tengas menos de 10 PP
- Equilibra daño y sostenibilidad

#### 3. **Protege al Asalto**
- Tu soldado de Asalto hace más daño
- Si muere temprano, pierdes poder de fuego
- Haz que el enemigo ataque al MG primero

#### 4. **Usa el MG como Escudo**
- Tiene 150 PS (el más resistente)
- Puede aguantar varios ataques
- Regenera PP con descansar para seguir atacando

#### 5. **Ataca al Asalto Enemigo Primero**
- Es el más peligroso (45-59 de daño fuerte)
- Eliminarlo reduce amenaza significativamente
- Vale la pena gastar ataques fuertes en él

#### 6. **Calcula el PP Enemigo**
- Si un enemigo tiene poco PP, probablemente descanse
- Aprovecha ese turno para atacar o descansar tú también

---

### ❌ Errores Comunes

1. **Usar siempre ataques fuertes**
   - Te quedas sin PP rápidamente
   - No podrás atacar cuando más lo necesites

2. **Ignorar las barras de estado**
   - Revisa PS y PP antes de actuar
   - Un soldado con 10 PS puede morir en cualquier momento

3. **No descansar nunca**
   - Descansar es una acción válida y necesaria
   - Es mejor descansar que no poder atacar

4. **Atacar siempre al mismo objetivo**
   - Distribuye el daño a veces
   - Deja varios enemigos débiles para rematar después

---

## 🏆 Victoria y Derrota

### Condición de Victoria
**Elimina a los 3 soldados enemigos** (PS = 0)

### Condición de Derrota
**Tus 3 soldados son eliminados** (PS = 0)

### Pantalla Final
Al terminar la batalla verás:
- 👑 **Facción ganadora**
- ⚔️ **Total de ataques** realizados en la batalla
- ⏱️ **Duración** del combate

Opciones:
- **Nueva Batalla**: Reinicia con todos los soldados al máximo
- **Volver al Inicio**: Regresa al menú principal

---

## 🎨 Personalizaciones Avanzadas

### Agregar Imágenes Propias

#### Banderas de Facciones
Coloca en `assets/images/banderas/`:
- `aliados.png` (300x200 px recomendado)
- `eje.png` (300x200 px recomendado)

#### Sprites de Soldados
Coloca en `assets/images/soldados/`:
- `aliados_mg.png` (mirando →)
- `aliados_rifle.png` (mirando →)
- `aliados_asalto.png` (mirando →)
- `eje_mg.png` (mirando ←)
- `eje_rifle.png` (mirando ←)
- `eje_asalto.png` (mirando ←)

**Tamaño recomendado**: 128x128 o 256x256 px, formato PNG transparente

### Agregar Sonidos
1. Instala: `audioplayers: ^5.0.0` en pubspec.yaml
2. Coloca MP3 en `assets/sounds/`
3. Implementa en el código (ver README.md)

---

## 🐛 Problemas Frecuentes

### "No puedo seleccionar mi soldado"
- Verifica que sea tu turno (dice "TU TURNO" arriba)
- El soldado debe estar vivo (no en gris)
- No debe haber una animación en curso

### "Los botones de ataque están deshabilitados"
- Revisa que tengas suficiente PP para ese ataque
- Ataque rápido: mínimo 5 PP
- Ataque normal: mínimo 10 PP
- Ataque fuerte: mínimo 20 PP

### "El enemigo no hace nada"
- La IA actúa automáticamente tras tu turno
- Hay un delay de 0.8 segundos
- Si todos sus soldados están KO, has ganado

### "La animación es muy lenta/rápida"
- Por ahora dura 1.5 segundos (configurable)
- Para cambiarla, modifica el código (ver README.md)

---

## 📝 Créditos

**Inspiración**:
- Darkest Dungeon (sistema de formación)
- XCOM (combate táctico)
- Into the Breach (selección visual)

**Tecnología**: Flutter + Dart

---

## 🎯 Desafíos Adicionales

¿Ya dominas el juego? Prueba estos desafíos:

- [ ] Ganar sin perder ningún soldado
- [ ] Ganar usando solo ataques rápidos
- [ ] Ganar sin usar la acción Descansar
- [ ] Eliminar primero al MG enemigo
- [ ] Ganar en menos de 20 ataques totales
- [ ] Completar 5 batallas consecutivas

---

¡Buena suerte, comandante! ⚔️🎖️
