function [mundo,posbloques,postubos] = inicio()
% INICIO Genera el escenario base de Super Mario Bros del enunciado.
posbloques = ones(12,24);
posbloques(12,:) = 2;
posbloques(4,13:15) = 4;
posbloques(4,14) = 3;
posbloques(8,12:16) = 4;
posbloques(8,13) = 3;
posbloques(8,15) = 3;

postubos = ones(6,12);
postubos(6,10) = 2;

mundo = mariomundo(posbloques,postubos);
end
