% EJECUTARACTIVIDAD1BASICA Script de demostracion de la version literal
% del enunciado (actividad1Basica.m): genera el escenario inicial, lo
% extiende 40 pares de columnas de forma independiente por columna y
% muestra el escenario completo. Util para el pantallazo de entrega.

[~,posbloques,postubos] = inicio();

par = posbloques(:,end-1:end);
col = postubos(:,end);

nuevos = zeros(12,80);
for k = 1:40
    [par,col] = actividad1Basica(par,col);
    nuevos(:,(2*k-1):(2*k)) = par;
end

posbloquesFinal = [posbloques,nuevos];
postubosFinal = [postubos,ones(6,40)];

figure;
mariomundo(posbloquesFinal,postubosFinal);
title('Escenario completo - Actividad 1 (version basica)');
