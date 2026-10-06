%% Inicializacion de las matrices del mundo
iteraciones = 40;

posbloques = ones(12,24+2*iteraciones);
postubos = ones(6,12+iteraciones);

%% Mundo inicial
posbloques(12,1:24) = 2;
posbloques(4,13:15) = 4;
posbloques(4,14) = 3;
posbloques(8,12:16) = 4;
posbloques(8,13) = 3;
posbloques(8,15) = 3;
postubos(6,10) = 2;

%% Seleccion de las columnas iniciales
bloquesfin = posbloques(:,23:24);
tubosfin = postubos(:,12);

%% Proceso iterativo que arma el escenario completo
clear actividad6
for n = 1:iteraciones

    [bloquesfin,tubosfin] = actividad1(bloquesfin,tubosfin);
    [bloquesfin,tubosfin] = actividad2(bloquesfin,tubosfin);
    bloquesfin([4 8],:) = normalizarContenidoOculto(bloquesfin([4 8],:));
    [bloquesfin,tubosfin] = actividad3(bloquesfin,tubosfin);
    [bloquesfin,tubosfin] = actividad4(bloquesfin,tubosfin);
    [bloquesfin,tubosfin] = actividad6(bloquesfin,tubosfin);
    [bloquesfin,tubosfin] = actividad5(bloquesfin,tubosfin);
    [bloquesfin,tubosfin] = actividad7(bloquesfin,tubosfin);
    

    posbloques(:,24+(2*n-1):24+2*n) = bloquesfin;
    postubos(:,12+n) = tubosfin;

end

mariomundo(posbloques,postubos);