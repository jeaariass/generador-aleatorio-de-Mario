function [bloquesfin, tubosfin] = actividad1(bloquesfin, tubosfin)

    % Extraer el estado anterior 
    estado_anterior = bloquesfin(12, :);
    
    %  1 = Vacio, 2 = Baldosa
    x = [1, 2]; 

    % Evaluar el estado previo y asignar las probabilidades de transicion p = [p_vacio, p_baldosa]
    if isequal(estado_anterior, [1, 1])
        p = [0.05, 0.95]; 
    elseif isequal(estado_anterior, [2, 2])
        p = [0.15, 0.85]; 
    elseif isequal(estado_anterior, [1, 2])
        p = [0.05, 0.95];
    elseif isequal(estado_anterior, [2, 1])
        p = [0.15, 0.85];
    end

    % Generar la nueva pareja de bloques
    bloquesfin(12, :) = va(x, p, 1, 2);
end