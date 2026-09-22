function [posbloques2,postubos2] = actividad1(posbloques,postubos)
% ACTIVIDAD1 Primera actividad (con los pies en la tierra).
%
% [posbloques2,postubos2] = ACTIVIDAD1(posbloques,postubos)
%
% Entradas:
%   posbloques : matriz 12x2 con las dos ultimas columnas de la matriz
%                de bloques del escenario (es decir, el par hueco/baldosa
%                de la fila 12 generado en la iteracion anterior).
%   postubos   : vector 6x1 con la ultima columna de la matriz de tubos.
%
% Salidas:
%   posbloques2 : matriz 12x2. Las filas 1 a 11 quedan intactas (iguales
%                 a las de entrada). La fila 12 (piso) se genera de
%                 forma aleatoria como PAREJA (las dos columnas juntas,
%                 no cada una por separado) y solo puede tomar los
%                 valores 1 (negro/hueco) o 2 (baldosa).
%   postubos2   : igual a postubos, sin ninguna alteracion.
%
% Las 4 combinaciones posibles para la nueva pareja de columnas son:
%   BB = [2,2]  baldosa-baldosa
%   HH = [1,1]  hueco-hueco
%   HB = [1,2]  hueco-baldosa
%   BH = [2,1]  baldosa-hueco
%
% Dependencia impuesta (ver Tarea 6 / tema del curso): si la pareja
% anterior (la que llega en posbloques) ya era HH, la nueva pareja NO
% puede volver a ser HH, para no encadenar mas de 2 huecos seguidos.
% Cuando eso pasa, la probabilidad de HH se excluye y se reparte
% proporcionalmente entre BB, HB y BH.

    if ~isequal(size(posbloques),[12,2])
        error('actividad1:tamano','posbloques debe ser 12x2.');
    end
    if ~isequal(size(postubos),[6,1])
        error('actividad1:tamano','postubos debe ser 6x1.');
    end

    % --- Probabilidades de cada combinacion: DEFINIRLAS AQUI -----------
    % Deben sumar 1 entre las 4 (pBB + pHH + pHB + pBH = 1).
    pBB = [];   % baldosa-baldosa
    pHH = [];   % hueco-hueco
    pHB = [];   % hueco-baldosa
    pBH = [];   % baldosa-hueco

    if isempty(pBB) || isempty(pHH) || isempty(pHB) || isempty(pBH)
        error('actividad1:probabilidades', ...
            'Define pBB, pHH, pHB y pBH en actividad1.m antes de ejecutar.');
    end

    p = [pBB,pHH,pHB,pBH];
    if abs(sum(p)-1) > 1e-9
        warning('actividad1:probabilidades', ...
            'pBB+pHH+pHB+pBH deberia sumar 1 (suma actual: %.6f).',sum(p));
    end

    pares = {[2,2],[1,1],[1,2],[2,1]}; % BB, HH, HB, BH (mismo orden que p)

    % --- Dependencia: no repetir HH si la pareja anterior ya era HH ----
    parAnterior = posbloques(12,:);
    if isequal(parAnterior,[1,1])
        p(2) = 0;
        if sum(p) == 0
            error('actividad1:probabilidades', ...
                'pBB, pHB y pBH no pueden ser todas 0 (se necesitan para reemplazar a pHH).');
        end
        p = p/sum(p);
    end

    idx = va(1:4,p,1,1);

    posbloques2 = posbloques;
    posbloques2(12,:) = pares{idx};

    postubos2 = postubos;
end
