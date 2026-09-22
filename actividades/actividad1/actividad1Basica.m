function [posbloques2,postubos2] = actividad1Basica(posbloques,postubos)
% ACTIVIDAD1BASICA Primera actividad, version literal del enunciado (sin
% la dependencia extra entre parejas de columnas): recibe las ultimas
% dos columnas de bloques (12x2) y la ultima columna de tubos (6x1), y
% genera los dos bloques de la fila 12 de forma aleatoria e
% independiente entre si (cada columna con la misma probabilidad, sin
% mirar la columna vecina). Solo pueden ser negro (1) o baldosa (2).

    if ~isequal(size(posbloques),[12,2])
        error('actividad1Basica:tamano','posbloques debe ser 12x2.');
    end
    if ~isequal(size(postubos),[6,1])
        error('actividad1Basica:tamano','postubos debe ser 6x1.');
    end

    x = [1,2];          % 1 = negro (hueco), 2 = baldosa
    p = [0.12,0.88];     % ajustar aqui

    posbloques2 = posbloques;
    posbloques2(12,:) = va(x,p,1,2);

    postubos2 = postubos;
end
