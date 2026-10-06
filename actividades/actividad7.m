+
function [bloquesfin,tubosfin] = actividad7(bloquesfin,tubosfin)

%% Generacion de nubes en la fila 2

% Estado anterior de la fila 2
estado_anterior = bloquesfin(2,:);

% Estados:
% 1  = vacio
% 21 = nube
x_nubes = [1 21];


% Vacio - vacio
if isequal(estado_anterior,[1 1])

    p_nubes = [0.90 0.10];


    % Vacio - nube o nube - vacio
elseif isequal(estado_anterior,[1 21]) || ...
        isequal(estado_anterior,[21 1])

    p_nubes = [0.10 0.90];


    % Nube - nube
elseif isequal(estado_anterior,[21 21])

    p_nubes = [0.50 0.50];

end


% Generar las dos posiciones de la fila 2
bloquesfin(2,:) = va(x_nubes,p_nubes,1,2);


%% Generacion de Lakitu en la fila 1

% Primero dejar la fila 1 vacia
bloquesfin(1,:) = [1 1];


% Revisar cada columna
for j = 1:2

    % Lakitu solamente puede aparecer
    % si debajo existe una nube
    if bloquesfin(2,j) == 21

        % 90% sin Lakitu
        % 10% con Lakitu
        bloquesfin(1,j) = ...
            va([1 20],[0.90 0.10]);

    end

end


% tubosfin se retorna sin modificaciones

end