# Generador aleatorio de Mario

Trabajo 1 de Herramientas Matemáticas (2026-3).

## Estructura del proyecto

```
generador-aleatorio-de-Mario/
├── iniciarProyecto.m        <- ejecutar primero, siempre
├── src/                     <- funciones base del enunciado
│   ├── inicio.m
│   ├── mariomundo.m
│   └── va.m
├── actividades/
│   └── actividad1/          
│       ├── actividad1.m
│       ├── generarNivelActividad1.m
│       └── ejecutarActividad1.m
├── recursos/                <- sprites de bloques y tubos
│   ├── baldosa.png
│   ├── interrogante.png
│   ├── ladrillo.png
│   └── tubo.png
└── extra/                   <- version jugable, fuera de la rubrica
    ├── jugarMario.m
    └── marioTheme.m
```

Cada actividad futura (2, 3, 4, 5) iría en su propia carpeta dentro de `actividades/`
(`actividades/actividad2/`, etc.) siguiendo el mismo patrón: la(s) función(es) pedida(s)
+ un script `ejecutarActividadN.m` que la corre y muestra el resultado.

## Cómo ejecutarlo (MATLAB Desktop u Online)

1. Abre MATLAB (desktop, o [matlab.mathworks.com](https://matlab.mathworks.com) si usas MATLAB Online con este repo sincronizado en MATLAB Drive).
2. En el panel **Current Folder**, navega hasta esta carpeta (`generador-aleatorio-de-Mario`) — debe ser la carpeta *raíz* del proyecto, no una subcarpeta.
3. En la **Command Window**, escribe y da Enter:
   ```matlab
   iniciarProyecto
   ```
   Esto agrega `src/`, `actividades/`, `recursos/` y `extra/` al path de MATLAB, así no importa en qué subcarpeta estés parado. Solo hace falta correrlo una vez por sesión de MATLAB.
4. Ya puedes ejecutar cualquier función por su nombre:
   ```matlab
   ejecutarActividad1
   ```
   Esto genera el escenario inicial, lo extiende 40 pares de columnas usando `actividad1.m` y muestra el escenario completo (equivalente a `demot1a1` del enunciado).

## Extra: versión jugable con música (fuera de la rúbrica)

```matlab
jugarMario
```

Abre una ventana con el nivel generado por la Primera actividad; Mario se controla con las flechas y salta con espacio/flecha arriba. Si caes en un hueco de la fila 12, **el nivel reinicia desde cero** (posición inicial, cámara al principio; el contador de muertes sube).

Por defecto usa un sprite simplificado (rectángulo) y un tema mp3 descargado.

- `recursos/mario.png` — sprite de Mario, PNG con canal alfa (fondo transparente), de pie, ideal 16x32 o 32x32 px.
- `recursos/tema.mp3` — música de fondo, cualquier mp3.

Si no están esos archivos, el juego sigue funcionando igual con el sprite/música por defecto.


