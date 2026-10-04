function [bloquesfin, tubosfin] = actividad7(bloquesfin, tubosfin)
   estado_anterior = bloquesfin(2, :);

    x_nubes = [1, 21]; % 1 = Vacío, 21 = Nube
    
    % Estado anterior de la Fila 2
    %% Si hay vacío -vacío 
    if isequal(estado_anterior, [1, 1])
        p_nubes = [0.9, 0.10]; 
    %% Si hay vacío-nube -- nube - vacío
    elseif isequal(estado_anterior, [1, 21]) ||  isequal(estado_anterior, [21, 1])
        p_nubes = [0.10, 0.90]; 
     %% Si hay nube - nube
    elseif isequal(estado_anterior, [21, 21])
        p_nubes = [0.50, 0.50]; 
    end
    
    % Se guarda enla Fila 2
    bloquesfin(2, :) = va(x_nubes, p_nubes, 1, 2);


    %Lakitu, según lo que quedó en la Fila 2

    x_lakitu = [1, 20]; % 1 = Vacío, 20 = Lakitu
    
    % Estado fila 2
    estado_fila2 = bloquesfin(2, :);
    
    % Si en la Fila 2 hay un cúmulo de nubes [21, 21]:
    if isequal(estado_fila2, [21, 21])
        p_lakitu = [0.9, 0.10]; 
    else
        p_lakitu = [1.00, 0.00];
    end
    
    % Se guarda en la Fila 1
    bloquesfin(1, :) = va(x_lakitu, p_lakitu, 1, 2);
end