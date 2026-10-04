function [bloquesfin, tubosfin] = actividad3(bloquesfin, tubosfin)
    % Extraer el estado anterior de la fila 8[cite: 8]
    estado_anterior = bloquesfin(8, :);
    
    % 1 = Vacío, 3 = Interrogante, 4 = Ladrillo[cite: 2, 8]
    x = [1, 3, 4]; 
    
    % p = [p_vacio, p_interrogante, p_ladrillo]
    %% Si hay vacío -vacío 
    if isequal(estado_anterior, [1, 1])
        p = [0.95, 0.0, 0.05];        
    %% Si hay ladrillo-ladrillo
    elseif isequal(estado_anterior, [4, 4])
        p = [0.5, 0.1, 0.4];
    %% Si hay interrogante-interrogante ó interrogante-ladrillo
    elseif isequal(estado_anterior, [3, 3]) || isequal(estado_anterior, [3, 4])        
        p = [0.0, 0.10, 0.9]; 
    %% Si hay ladrillo-interrogante ó vacío-interrogante
    elseif isequal(estado_anterior, [4, 3]) || isequal(estado_anterior, [1, 3])
        p = [0, 0.10, 0.9]; 
    %% Si hay ladrillo-vacío ó interrogante-vacío
    elseif isequal(estado_anterior, [4, 1]) || isequal(estado_anterior, [3, 1])
        p = [0.95, 0, 0.05];
    %% Si hay vacío-ladrillo
    elseif isequal(estado_anterior, [1, 4]) 
        p = [0, 0.10, 0.9];
    end    
    % Generar la nueva pareja de bloques en la fila 8[cite: 8]
    bloquesfin(8, :) = va(x, p, 1, 2);
end