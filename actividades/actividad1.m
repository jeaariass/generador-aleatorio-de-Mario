function [bloques,tubos] = actividad1(bloques,tubos)

% Estados posibles de los dos bloques
estados = [1 1;
    1 2;
    2 1;
    2 2];

% Matriz de transicion
P = [0   0 0   1;
     0   0.2   0.2 0.6;
     0 0.167 0 0.833;
     0 0.103   0.172 0.724];

% Estado actual de los dos bloques de la fila 12
actual = bloques(12,:);

% Identificar el estado actual
for i = 1:4
    if isequal(actual,estados(i,:))
        estadoActual = i;
        break;
    end
end

% Generar el siguiente estado usando la funcion va
estadoSiguiente = va([1 2 3 4],P(estadoActual,:));

% Asignar el siguiente par de bloques
bloques(12,:) = estados(estadoSiguiente,:);

% tubos se retorna sin modificaciones

end
