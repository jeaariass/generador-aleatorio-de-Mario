function [y,Fs] = marioTheme()
% MARIOTHEME Sintetiza (onda cuadrada, estilo chiptune) una version corta
% y reconocible del tema principal de Super Mario Bros, para uso
% academico dentro de este ejercicio. No usa ningun archivo de audio
% original: las notas se generan matematicamente.
%
% [y,Fs] = MARIOTHEME() retorna el vector de audio y y la frecuencia de
% muestreo Fs.

    Fs = 11025;

    notas = containers.Map();
    notas('C4')=261.63; notas('D4')=293.66; notas('E4')=329.63;
    notas('F4')=349.23; notas('G4')=392.00; notas('A4')=440.00;
    notas('B4')=493.88; notas('Bb4')=466.16;
    notas('C5')=523.25; notas('D5')=587.33; notas('E5')=659.25;
    notas('F5')=698.46; notas('G5')=783.99; notas('A5')=880.00;
    notas('C6')=1046.50;
    notas('R')=0;

    % {nota, duracion en segundos}
    secuencia = {
        'E5',0.10; 'E5',0.10; 'R',0.10; 'E5',0.10; 'R',0.10; 'C5',0.10; 'E5',0.10; 'R',0.10;
        'G5',0.20; 'R',0.20; 'G4',0.20; 'R',0.20;
        'C5',0.15; 'R',0.05; 'G4',0.15; 'R',0.05; 'E4',0.15; 'R',0.05;
        'A4',0.10; 'R',0.05; 'B4',0.10; 'R',0.05; 'Bb4',0.10; 'A4',0.20;
        'G4',0.13; 'E5',0.13; 'G5',0.13; 'A5',0.20; 'R',0.05; 'F5',0.10; 'G5',0.10; 'R',0.05;
        'E5',0.20; 'C5',0.10; 'D5',0.10; 'B4',0.30;
    };

    y = [];
    for i = 1:size(secuencia,1)
        f = notas(secuencia{i,1});
        d = secuencia{i,2};
        y = [y, notaChip(f,d,Fs)]; %#ok<AGROW>
    end
end

function s = notaChip(freq,dur,Fs)
    t = 0:1/Fs:dur;
    if freq <= 0
        s = zeros(1,numel(t));
        return;
    end
    s = 0.18*sign(sin(2*pi*freq*t));
    n = numel(s);
    a = max(1,round(0.01*Fs));
    a = min(a,floor(n/2));
    env = ones(1,n);
    env(1:a) = linspace(0,1,a);
    env(end-a+1:end) = linspace(1,0,a);
    s = s.*env;
end
