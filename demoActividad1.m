% DEMOACTIVIDAD1 Script de demostracion de la Primera actividad.
%
% Genera el escenario inicial, lo extiende 40 pares de columnas usando
% ACTIVIDAD1 y muestra el escenario completo (equivalente a demot1a1 del
% enunciado).

[presente,posbloques,postubos] = inicio();

[posbloquesFinal,postubosFinal] = generarNivelActividad1(posbloques,postubos,40);

figure;
mariomundo(posbloquesFinal,postubosFinal);
title('Escenario completo - Actividad 1');
