function [posbloques2,postubos2] = actividad1(posbloques,postubos)

    if ~isequal(size(posbloques),[12,2])
        error('actividad1:tamano','posbloques debe ser 12x2.');
    end
    if ~isequal(size(postubos),[6,1])
        error('actividad1:tamano','postubos debe ser 6x1.');
    end

    % --- Probabilidades de cada combinacion: DEFINIRLAS AQUI -----------
    pBB = [0.90];   % baldosa-baldosa
    pHH = [0.05];   % hueco-hueco
    pHB = [0.025];   % hueco-baldosa
    pBH = [0.025];   % baldosa-hueco

    p = [pBB,pHH,pHB,pBH];

    pares = {[2,2],[1,1],[1,2],[2,1]};

    % --- Dependencia: no repetir HH si la pareja anterior ya era HH ----
    parAnterior = posbloques(12,:);
    if isequal(parAnterior,[1,1])
        p(1) = p(1) + p(2);
        p(2) = 0;
    end

    idx = va(1:4,p,1,1);

    posbloques2 = posbloques;
    posbloques2(12,:) = pares{idx};

    postubos2 = postubos;
end
