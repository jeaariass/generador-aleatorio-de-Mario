function [bloques,tubos] = actividad5(bloques,tubos)

    % Si hay un tubo en la fila 6
    if tubos(6,1) == 2

        % Estados posibles:
        % 1 = sin planta
        % 3 = con planta
        estados = [1 3];

        % Probabilidades:
        % 70% sin planta
        % 30% con planta
        p = [0.70 0.30];

        % Decidir si aparece planta
        tubos(5,1) = va(estados,p);

    else

        % Si no hay tubo, no puede haber planta
        tubos(5,1) = 1;

    end

end