clc; clear; close all;

% Iteraciones
iteraciones = 40;

% Inicializacion de matrices
posbloques = ones(12, 2 + 2*iteraciones);
postubos = ones(6, 1 + iteraciones);

% Estado inicial del suelo
posbloques(12, 1:2) = 2;
postubos(6, 1) = 2;

bloquesfin = posbloques(:, 1:2);
tubosfin = ones(6, 1); 

% Bucle 
for n = 1:iteraciones
    [bloquesfin, tubosfin] = actividad1(bloquesfin, tubosfin);
    [bloquesfin, tubosfin] = actividad3(bloquesfin, tubosfin);
    [bloquesfin, tubosfin] = actividad7(bloquesfin, tubosfin);
    posbloques(:, 2 + (2*n-1) : 2 + 2*n) = bloquesfin;
    postubos(:, 1 + n) = tubosfin;
end

% Renderizado y visualizacion del mapa final
escenario = mariomundo(posbloques, postubos);
imshow(escenario);
