function pararMario()
% PARARMARIO Detiene por completo el juego lanzado con jugarMario:
% para el timer del bucle, detiene la musica y cierra la ventana. Sirve
% incluso si la ventana quedo trabada, sin responder, o si ya se cerro
% "a la mala" y quedaron el timer o el audio sonando de fondo.
%
% Ejecutar en la Command Window, en cualquier momento:
%
%   pararMario

    if isappdata(0,'marioTimer')
        t = getappdata(0,'marioTimer');
        try %#ok<TRYNC>
            if isvalid(t)
                stop(t);
                delete(t);
            end
        end
        rmappdata(0,'marioTimer');
    end

    if isappdata(0,'marioPlayer')
        p = getappdata(0,'marioPlayer');
        try %#ok<TRYNC>
            if isvalid(p) && isplaying(p)
                stop(p);
            end
        end
        rmappdata(0,'marioPlayer');
    end

    if isappdata(0,'marioFig')
        f = getappdata(0,'marioFig');
        try %#ok<TRYNC>
            if isvalid(f)
                delete(f);
            end
        end
        rmappdata(0,'marioFig');
    end

    % Por si quedo algun timer o figura huerfanos de una corrida anterior
    % que no paso por el registro de arriba (p. ej. tras un error).
    huerfanos = timerfindall('Tag','marioTimer');
    for k = 1:numel(huerfanos)
        try %#ok<TRYNC>
            stop(huerfanos(k));
            delete(huerfanos(k));
        end
    end

    figsHuerfanas = findall(0,'Type','figure','Tag','marioFig');
    for k = 1:numel(figsHuerfanas)
        try %#ok<TRYNC>
            delete(figsHuerfanas(k));
        end
    end
end
