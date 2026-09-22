function [posbloques2,postubos2] = actividad1(posbloques,postubos)
% ACTIVIDAD1 Primera actividad (con los pies en la tierra).
%
% [posbloques2,postubos2] = ACTIVIDAD1(posbloques,postubos)
%
% Entradas:
%   posbloques : matriz 12x2 con las dos ultimas columnas de la matriz
%                de bloques del escenario.
%   postubos   : vector 6x1 con la ultima columna de la matriz de tubos.
%
% Salidas:
%   posbloques2 : matriz 12x2. Las filas 1 a 11 quedan intactas (iguales
%                 a las de entrada). La fila 12 (piso) se genera de
%                 forma aleatoria y solo puede tomar los valores 1
%                 (negro/hueco) o 2 (baldosa).
%   postubos2   : igual a postubos, sin ninguna alteracion.
%
% Las probabilidades de la fila 12 se fijan aqui abajo; ajustelas para
% controlar la proporcion de huecos frente a piso solido (ver Tarea 6).

    if ~isequal(size(posbloques),[12,2])
        error('actividad1:tamano','posbloques debe ser 12x2.');
    end
    if ~isequal(size(postubos),[6,1])
        error('actividad1:tamano','postubos debe ser 6x1.');
    end

    % Valores posibles para la fila 12 y su probabilidad.
    x = [1,2];               % 1 = negro (hueco), 2 = baldosa (piso)
    p = [0.12,0.88];         % ajustar segun Tarea 6

    posbloques2 = posbloques;
    posbloques2(12,:) = va(x,p,1,2);

    postubos2 = postubos;
end
