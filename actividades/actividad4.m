function [bloques,tubos] = actividad4(bloques,tubos)

% Estado anterior de la fila 4
estadoAnteriorFila4 = bloques(4,:);

% La fila 4 depende de si hay plataforma (bloque) en la fila 8
hayPlataforma8 = any(bloques(8,:) ~= 1);

if ~hayPlataforma8

    % Sin plataforma debajo, en la fila 4 no puede haber nada
    bloques(4,:) = [1 1];

elseif isequal(estadoAnteriorFila4,[1 1])

    % Hay plataforma en fila 8 y la fila 4 estaba vacia:
    % alta probabilidad de que empiece a generarse algo
    opciones = [1 4; 4 1; 1 1];
    p = [0.35 0.35 0.30];

    idx = va([1 2 3],p);
    bloques(4,:) = opciones(idx,:);

elseif any(estadoAnteriorFila4 == 3)

    % Si antes habia interrogante, solo puede pasar a ladrillo-ladrillo
    bloques(4,:) = [4 4];

else

    % Habia algo (ladrillo o mixto) sin interrogante:
    % puede aparecer un interrogante o consolidarse en ladrillo-ladrillo
    opciones = [3 4; 4 3; 4 4];
    p = [0.20 0.20 0.60];

    idx = va([1 2 3],p);
    bloques(4,:) = opciones(idx,:);

end

% tubos se retorna sin modificaciones

end
