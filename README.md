# Generador aleatorio de Mario

Trabajo 1 de Herramientas Matemáticas (2026-3) — **Primera actividad (con los pies en la tierra)**.

## Archivos

- `inicio.m`, `mariomundo.m`, `va.m` — provistos en el enunciado (base del escenario y visualización).
- `actividad1.m` — función pedida en la Primera actividad: recibe las últimas dos columnas de bloques (12x2) y la última columna de tubos (6x1); retorna la fila 12 regenerada aleatoriamente (negro=1 o baldosa=2), el resto intacto, y los tubos sin alterar.
- `generarNivelActividad1.m` — aplica `actividad1` de forma iterativa para extender el escenario N pares de columnas.
- `demoActividad1.m` — script que reproduce el escenario completo pedido en el enunciado (equivalente a `demot1a1`).
- `baldosa.png`, `interrogante.png`, `ladrillo.png`, `tubo.png` — sprites usados por `mariomundo.m`.

## Uso (rúbrica)

```matlab
demoActividad1;
```

Las probabilidades de la fila 12 se ajustan dentro de `actividad1.m` (variable `p`), actualmente `[0.12, 0.88]` (12% hueco / 88% baldosa) para que el piso se vea mayormente sólido con huecos ocasionales y saltables.

## Extra: versión jugable con música (fuera de la rúbrica)

```matlab
jugarMario;
```

Abre una ventana con el nivel generado por la Primera actividad; Mario (un sprite simplificado) se controla con las flechas y salta con espacio/flecha arriba. Suena de fondo un tema tipo chiptune inspirado en el tema principal, **sintetizado matemáticamente en `marioTheme.m`** (ondas cuadradas generadas por código, sin usar ningún archivo de audio con derechos de autor). Si caes en un hueco de la fila 12, reapareces un poco atrás. Esc cierra el juego.

Esto es un añadido para practicar/divertirse; lo único evaluado por la rúbrica es `actividad1.m` + `demoActividad1.m`.
