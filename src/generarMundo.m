function [posbloques,postubos] = generarMundo(iteraciones)

% Si no se indica la cantidad de iteraciones,
% se generan 40 pares de columnas
if nargin < 1
    iteraciones = 40;
end

% actividad6 recuerda si la iteracion anterior tuvo moneda en una
% variable persistent; se reinicia para que cada mundo generado
% empiece sin arrastrar memoria de una corrida previa
clear actividad6

% Generar mundo inicial
[~,posbloques,postubos] = inicio();

% Tomar los ultimos elementos del mundo inicial
bloquesfin = posbloques(:,end-1:end);
tubosfin = postubos(:,end);

% Espacio para almacenar lo generado
bloquesNuevos = ones(12,2*iteraciones);
tubosNuevos = ones(6,iteraciones);

% Generacion iterativa del escenario
for n = 1:iteraciones

    % Actividad 1: genera el piso
    [bloquesfin,tubosfin] = actividad1(bloquesfin,tubosfin);

    % Actividad 2: genera los tubos
    [bloquesfin,tubosfin] = actividad2(bloquesfin,tubosfin);

    bloquesfin([4 8],:) = normalizarContenidoOculto(bloquesfin([4 8],:));

    % Actividad 3: genera bloques en la fila 8
    [bloquesfin,tubosfin] = actividad3(bloquesfin,tubosfin);

    % Actividad 4: genera bloques en la fila 4
    [bloquesfin,tubosfin] = actividad4(bloquesfin,tubosfin);

    % Actividad 6: contenido oculto de interrogantes y monedas
    [bloquesfin,tubosfin] = actividad6(bloquesfin,tubosfin);

    % Actividad 5: genera bloques en la fila 2
    [bloquesfin,tubosfin] = actividad5(bloquesfin,tubosfin);
    
    % Actividad 7: genera bloques en la fila 2
    [bloquesfin,tubosfin] = actividad7(bloquesfin,tubosfin);

    % Guardar el nuevo par de bloques
    bloquesNuevos(:,2*n-1:2*n) = bloquesfin;

    % Guardar la nueva columna de tubos
    tubosNuevos(:,n) = tubosfin;

end

% Unir el mundo inicial con lo generado
posbloques = [posbloques bloquesNuevos];
postubos = [postubos tubosNuevos];

end