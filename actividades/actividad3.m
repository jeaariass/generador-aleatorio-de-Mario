function [bloques,tubos] = actividad3(bloques,tubos)

% Verifica el tamano de las matrices
if ~isequal(size(bloques),[12 2])
    error('bloques debe ser una matriz de 12x2');
end

if ~isequal(size(tubos),[6 1])
    error('tubos debe ser una matriz de 6x1');
end

% Estado anterior de la fila 8
estadoAnterior = bloques(8,:);

% Estados posibles
% 1 = vacio
% 3 = interrogante
% 4 = ladrillo
x = [1 3 4];

% Probabilidades segun el estado anterior

% Vacio - vacio
if isequal(estadoAnterior,[1 1])

    p = [0.95 0.00 0.05];

    % Ladrillo - ladrillo
elseif isequal(estadoAnterior,[4 4])

    p = [0.50 0.10 0.40];

    % Interrogante - interrogante
    % o interrogante - ladrillo
elseif isequal(estadoAnterior,[3 3]) || ...
        isequal(estadoAnterior,[3 4])

    p = [0.00 0.10 0.90];

    % Ladrillo - interrogante
    % o vacio - interrogante
elseif isequal(estadoAnterior,[4 3]) || ...
        isequal(estadoAnterior,[1 3])

    p = [0.00 0.10 0.90];

    % Ladrillo - vacio
    % o interrogante - vacio
elseif isequal(estadoAnterior,[4 1]) || ...
        isequal(estadoAnterior,[3 1])

    p = [0.95 0.00 0.05];

    % Vacio - ladrillo
elseif isequal(estadoAnterior,[1 4])

    p = [0.00 0.10 0.90];

else
    error('Estado no valido en la fila 8');
end

% Generar los dos nuevos bloques de la fila 8
bloques(8,:) = va(x,p,1,2);

% tubos se retorna sin modificaciones

end