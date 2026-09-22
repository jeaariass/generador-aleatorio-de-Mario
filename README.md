# Generador aleatorio de Mario

Trabajo 1 de Herramientas Matemáticas (2026-3) — **Primera actividad (con los pies en la tierra)**.

## Estructura del proyecto

```
generador-aleatorio-de-Mario/
├── iniciarProyecto.m        <- ejecutar primero, siempre
├── src/                     <- funciones base del enunciado
│   ├── inicio.m
│   ├── mariomundo.m
│   └── va.m
├── actividades/
│   └── actividad1/          <- Primera actividad (la unica evaluada aqui)
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

No es una terminal de shell: es la **Command Window** de MATLAB.

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

## Primera actividad — resumen

- `actividad1.m` — función pedida en la rúbrica: recibe las últimas dos columnas de bloques (12x2) y la última columna de tubos (6x1); retorna la fila 12 regenerada aleatoriamente (negro=1 o baldosa=2), el resto intacto, y los tubos sin alterar.
- `generarNivelActividad1.m` — aplica `actividad1` de forma iterativa para extender el escenario N pares de columnas.
- `ejecutarActividad1.m` — script que arma y muestra el escenario completo.

Las probabilidades de la fila 12 se ajustan dentro de `actividad1.m` (variable `p`), actualmente `[0.12, 0.88]` (12% hueco / 88% baldosa) para que el piso se vea mayormente sólido con huecos ocasionales y saltables.

## Extra: versión jugable con música (fuera de la rúbrica)

```matlab
jugarMario
```

Abre una ventana con el nivel generado por la Primera actividad; Mario (un sprite simplificado) se controla con las flechas y salta con espacio/flecha arriba. Suena de fondo un tema tipo chiptune inspirado en el tema principal, **sintetizado matemáticamente en `marioTheme.m`** (ondas cuadradas generadas por código, sin usar ningún archivo de audio con derechos de autor). Si caes en un hueco de la fila 12, reapareces un poco atrás. Esc cierra el juego.

Esto es un añadido para practicar/divertirse; lo único evaluado por la rúbrica es `actividad1.m` + `ejecutarActividad1.m`.
