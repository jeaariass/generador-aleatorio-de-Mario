function [bloques,tubos] = actividad2(bloques,tubos)

% Verifica el tamano de las matrices
if ~isequal(size(bloques),[12 2])
    error('bloques debe ser una matriz de 12x2');
end

if ~isequal(size(tubos),[6 1])
    error('tubos debe ser una matriz de 6x1');
end

% Estados posibles
% 1 = sin tubo
% 2 = con tubo
estados = [1 2];

% Matriz de transicion
%             Futuro
%             1     2
P = [        0.85  0.15;   % Presente = 1
    1.00  0.00];  % Presente = 2

% Estado actual de la fila 6
actual = tubos(6,1);

% Identifica el estado actual
estadoActual = find(estados == actual);

% Genera el siguiente estado usando va
estadoSiguiente = va(estados,P(estadoActual,:));

% Modifica solamente la fila 6
tubos(6,1) = estadoSiguiente;

% bloques se retorna sin modificaciones

end