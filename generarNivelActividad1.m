function [posbloques,postubos] = generarNivelActividad1(posbloques,postubos,npares)
% GENERARNIVELACTIVIDAD1 Extiende un escenario aplicando ACTIVIDAD1 de
% forma iterativa.
%
% [posbloques,postubos] = GENERARNIVELACTIVIDAD1(posbloques,postubos,npares)
%
% posbloques, postubos : matrices del escenario actual (por ejemplo, las
%                         que retorna inicio()).
% npares                : numero de pares de columnas adicionales a
%                         generar (cada par se genera a partir del par
%                         anterior).
%
% Devuelve las matrices concatenadas con los npares*2 nuevas columnas de
% bloques (y npares nuevas columnas de tubos, siempre "sin tubo", pues la
% actividad 1 no modifica la matriz de tubos).

    if nargin < 3
        npares = 40;
    end

    parActual = posbloques(:,end-1:end);
    colTuboActual = postubos(:,end);

    bloquesNuevos = zeros(12,npares*2);
    for k = 1:npares
        [parActual,colTuboActual] = actividad1(parActual,colTuboActual);
        bloquesNuevos(:,(2*k-1):(2*k)) = parActual;
    end

    tubosNuevos = ones(6,npares); % actividad1 no genera tubos nuevos

    posbloques = [posbloques,bloquesNuevos];
    postubos = [postubos,tubosNuevos];
end
