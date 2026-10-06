function [bloques,tubos] = actividad6(bloques,tubos)

filasConBloques = [4 8];

%% Contenido de los interrogantes 

for fila = filasConBloques

    for col = 1:2

        if bloques(fila,col) == 3

            % 1=nada, 2=flor, 3=estrella
            contenido = va([1 2 3],[1/3 1/3 1/3]);

            if contenido == 2
                bloques(fila,col) = 30;
            elseif contenido == 3
                bloques(fila,col) = 31;
            end

        end

    end

end

%% Monedas en ladrillo-ladrillo

for fila = filasConBloques

    estadoFila = bloques(fila,:);

    if isequal(estadoFila,[4 4])

        % 2/3 de probabilidad de generar una moneda
        aparece = va([1 2],[2/3 1/3]);

        if aparece == 1

            % La moneda aparece en uno de los dos bloques, no en ambos
            colMoneda = va([1 2],[0.5 0.5]);

            bloques(fila,colMoneda) = 40;

        end

    elseif isequal(estadoFila,[1 4])

        % Vacio-ladrillo: 40% de probabilidad de moneda en el ladrillo
        aparece = va([1 2],[0.40 0.60]);

        if aparece == 1
            bloques(fila,2) = 40;
        end

    elseif isequal(estadoFila,[4 1])

        % Ladrillo-vacio: 30% de probabilidad de moneda en el ladrillo
        aparece = va([1 2],[0.30 0.70]);

        if aparece == 1
            bloques(fila,1) = 40;
        end

    end

end

end
