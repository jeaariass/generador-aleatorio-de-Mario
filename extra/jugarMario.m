function jugarMario()
% JUGARMARIO Version jugable (extra, fuera de la rubrica) del escenario
% generado con ACTIVIDAD1: un pequeno plataformero de scroll lateral
% sobre el nivel generado, con musica de fondo sintetizada (chiptune).
%
% Controles:
%   Flecha izquierda / derecha : mover
%   Espacio o flecha arriba    : saltar
%   Esc                        : salir
%
% Requiere: inicio.m, actividad1.m, generarNivelActividad1.m,
%           mariomundo.m, va.m y las imagenes de bloques/tubos.

    %% Generar el nivel (Primera actividad) -------------------------------
    [~,posbloques,postubos] = inicio();
    [posbloques,postubos] = generarNivelActividad1(posbloques,postubos,40);

    tile = 16;
    worldRows = size(posbloques,1);
    worldCols = size(posbloques,2);
    worldW = worldCols*tile;
    worldH = worldRows*tile;

    tuboSolido = kron(postubos,ones(2,2)) == 2;
    solidMask = (posbloques ~= 1) | tuboSolido;

    %% Figura y escenario ---------------------------------------------------
    viewTiles = 25;
    viewW = viewTiles*tile;
    viewH = worldH;

    fig = figure('Name','Mario jugable - Actividad 1','NumberTitle','off', ...
        'Color','k','Position',[80,80,900,round(900*viewH/viewW)], ...
        'KeyPressFcn',@teclaPresionada,'KeyReleaseFcn',@teclaSoltada, ...
        'CloseRequestFcn',@cerrar,'MenuBar','none','ToolBar','none');

    mundo = mariomundo(posbloques,postubos); %#ok<NASGU> % dibuja el nivel completo
    ax = gca;
    hold(ax,'on');
    axis(ax,'image'); axis(ax,'off');

    cuerpo = rectangle('Position',[0,0,1,1],'FaceColor',[0.85,0.1,0.1],'EdgeColor','none');
    gorra  = rectangle('Position',[0,0,1,1],'FaceColor',[0.85,0.1,0.1],'EdgeColor','none');
    tituloTxt = title(ax,'','Color','w');

    %% Estado del jugador -----------------------------------------------
    playerW = 12; playerH = 28;
    spawnX = 16; spawnY = worldRows*tile - tile*2 - playerH; % de pie sobre la fila 12
    jugador = struct('x',spawnX,'y',spawnY,'vx',0,'vy',0,'enSuelo',false);

    gravedad = 1400;  % px/s^2
    velSalto = -430;  % px/s
    velMover = 150;   % px/s
    dt = 1/30;
    camX = 0;
    vivo = true;
    ganado = false;
    muertes = 0;

    teclas = struct('izq',false,'der',false,'salto',false);

    %% Musica (opcional, con try/catch por si no hay dispositivo de audio) --
    player = [];
    try
        [y,Fs] = marioTheme();
        player = audioplayer(y,Fs);
        player.StopFcn = @(src,~) play(src); % loop
        play(player);
    catch
        player = [];
    end

    %% Bucle de juego (timer) ---------------------------------------------
    t = timer('ExecutionMode','fixedRate','Period',dt,'TimerFcn',@actualizar);
    start(t);

    %% ---- Funciones anidadas -------------------------------------------
    function actualizar(~,~)
        if ~isvalid(fig)
            detener();
            return;
        end
        if ~vivo
            return;
        end

        % Movimiento horizontal deseado
        jugador.vx = 0;
        if teclas.izq,  jugador.vx = jugador.vx - velMover; end
        if teclas.der,  jugador.vx = jugador.vx + velMover; end

        if teclas.salto && jugador.enSuelo
            jugador.vy = velSalto;
            jugador.enSuelo = false;
        end

        % Gravedad
        jugador.vy = jugador.vy + gravedad*dt;

        % --- Eje X ---
        nuevaX = jugador.x + jugador.vx*dt;
        nuevaX = max(0,min(nuevaX,worldW-playerW));
        if ~colisiona(nuevaX,jugador.y)
            jugador.x = nuevaX;
        end

        % --- Eje Y ---
        nuevaY = jugador.y + jugador.vy*dt;
        if colisiona(jugador.x,nuevaY)
            if jugador.vy > 0
                % cayendo: apoyarse en la parte superior del tile
                filaTile = floor((nuevaY+playerH)/tile);
                jugador.y = filaTile*tile - playerH;
                jugador.enSuelo = true;
            else
                % golpeando techo
                filaTile = floor(nuevaY/tile)+1;
                jugador.y = filaTile*tile;
            end
            jugador.vy = 0;
        else
            jugador.y = nuevaY;
            jugador.enSuelo = false;
        end

        % Caida por un hueco (fila 12 = negro)
        if jugador.y > worldH + 80
            muertes = muertes + 1;
            jugador.x = max(0,jugador.x - 48); % reaparece un poco atras
            jugador.y = spawnY;
            jugador.vy = 0;
        end

        % Meta: llegar al final del nivel
        if jugador.x >= worldW - playerW - 4 && ~ganado
            ganado = true;
            vivo = false;
            set(tituloTxt,'String','¡Meta alcanzada!');
            if ~isempty(player) && isplaying(player)
                stop(player);
            end
        end

        dibujar();
    end

    function ocupado = colisiona(x,y)
        c1 = max(1,floor(x/tile)+1);
        c2 = min(worldCols,floor((x+playerW-0.01)/tile)+1);
        r1 = max(1,floor(y/tile)+1);
        r2 = min(worldRows,floor((y+playerH-0.01)/tile)+1);
        if r1>worldRows || r2<1 || c1>worldCols || c2<1
            ocupado = false;
            return;
        end
        ocupado = any(solidMask(r1:r2,c1:c2),'all');
    end

    function dibujar()
        camX = jugador.x + playerW/2 - viewW/2;
        camX = max(0,min(camX,worldW-viewW));
        xlim(ax,[camX,camX+viewW]);
        ylim(ax,[0,viewH]);

        set(cuerpo,'Position',[jugador.x,jugador.y+8,playerW,playerH-8]);
        set(gorra, 'Position',[jugador.x-1,jugador.y,playerW+2,8]);

        if vivo
            set(tituloTxt,'String',sprintf('Mario jugable - muertes: %d',muertes));
        end
        drawnow limitrate;
    end

    function teclaPresionada(~,evt)
        switch evt.Key
            case 'leftarrow',  teclas.izq = true;
            case 'rightarrow', teclas.der = true;
            case {'space','uparrow'}, teclas.salto = true;
            case 'escape', close(fig);
        end
    end

    function teclaSoltada(~,evt)
        switch evt.Key
            case 'leftarrow',  teclas.izq = false;
            case 'rightarrow', teclas.der = false;
            case {'space','uparrow'}, teclas.salto = false;
        end
    end

    function cerrar(~,~)
        detener();
        delete(fig);
    end

    function detener()
        try %#ok<TRYNC>
            if isvalid(t) && strcmp(t.Running,'on')
                stop(t);
            end
            delete(t);
        end
        try %#ok<TRYNC>
            if ~isempty(player) && isvalid(player) && isplaying(player)
                stop(player);
            end
        end
    end
end
