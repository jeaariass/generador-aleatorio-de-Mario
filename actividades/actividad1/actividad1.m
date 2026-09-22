function [posbloques2,postubos2] = actividad1(posbloques,postubos)

    if ~isequal(size(posbloques),[12,2])
        error('actividad1:tamano','posbloques debe ser 12x2.');
    end
    if ~isequal(size(postubos),[6,1])
        error('actividad1:tamano','postubos debe ser 6x1.');
    end

    % Valores posibles para la fila 12 y su probabilidad.
    x = [1,2];               % 1 = negro (hueco), 2 = baldosa (piso)
    p = [0.12,0.88];         

    posbloques2 = posbloques;
    posbloques2(12,:) = va(x,p,1,2);

    postubos2 = postubos;
end
