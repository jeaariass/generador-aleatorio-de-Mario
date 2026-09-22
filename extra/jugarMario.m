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
% Si la ventana queda trabada o algo no cierra bien, ejecuta en la
% Command Window (sin necesidad de que la ventana tenga el foco):
%
%   pararMario
%
% Requiere: inicio.m, actividad1.m, generarNivelActividad1.m,
%           mariomundo.m, va.m y las imagenes de bloques/tubos.
%
% Assets reales opcionales (no incluidos, ponlos tu si los consigues por
% tu cuenta): si existen, se usan automaticamente; si no, se usa el
% sprite/musica sintetizados de este proyecto.
%   recursos/mario.png  -> sprite de Mario, PNG con canal alfa (fondo
%                          transparente), de pie, ~16x32 o 32x32 px.
%   recursos/tema.mp3   -> musica de fondo, cualquier mp3.

    recursosDir = fullfile(fileparts(mfilename('fullpath')),'..','recursos');

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

    % Si ya habia una partida abierta (o quedo huerfana), la cerramos
    % primero para no acumular timers/figuras/musica sueltos.
    pararMario();

    fig = figure('Name','Mario jugable - Actividad 1','NumberTitle','off', ...
        'Tag','marioFig', ...
        'Color','k','Position',[80,80,900,round(900*viewH/viewW)], ...
        'KeyPressFcn',@teclaPresionada,'KeyReleaseFcn',@teclaSoltada, ...
        'CloseRequestFcn',@cerrar,'MenuBar','none','ToolBar','none');

    mundo = mariomundo(posbloques,postubos); %#ok<NASGU> % dibuja el nivel completo
    ax = gca;
    hold(ax,'on');
    axis(ax,'image'); axis(ax,'off');

    % Sprite de Mario: usa recursos/mario.png si existe, si no dibuja un
    % rectangulo simple (cuerpo + gorra) como marcador.
    usarSprite = false;
    spriteImg = [];
    rutaSprite = fullfile(recursosDir,'mario.png');
    if isfile(rutaSprite)
        try
            [img,mapa,alpha] = imread(rutaSprite);
            if ~isempty(mapa) && ismatrix(img)
                % PNG de colores indexados: aplicar la paleta, si no,
                % se ven los indices crudos pintados con el colormap
                % por defecto (franja morada/azul).
                img = im2uint8(ind2rgb(img,mapa));
            end
            spriteImg = image(ax,'CData',img,'XData',[0,1],'YData',[0,1]);
            if ~isempty(alpha)
                set(spriteImg,'AlphaData',double(alpha)/255);
            end
            usarSprite = true;
        catch
            usarSprite = false;
        end
    end
    if ~usarSprite
        cuerpo = rectangle('Position',[0,0,1,1],'FaceColor',[0.85,0.1,0.1],'EdgeColor','none');
        gorra  = rectangle('Position',[0,0,1,1],'FaceColor',[0.85,0.1,0.1],'EdgeColor','none');
    end
    tituloTxt = title(ax,'','Color','w');
    mirando = 1; % 1 = derecha, -1 = izquierda (para voltear el sprite)

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
    % Usa recursos/tema.mp3 si existe; si no, el tema sintetizado (chiptune).
    player = [];
    try
        rutaTema = fullfile(recursosDir,'tema.mp3');
        if isfile(rutaTema)
            [y,Fs] = audioread(rutaTema);
        else
            [y,Fs] = marioTheme();
        end
        player = audioplayer(y,Fs);
        player.StopFcn = @(src,~) play(src); % loop
        play(player);
    catch
        player = [];
    end

    %% Bucle de juego (timer) ---------------------------------------------
    t = timer('ExecutionMode','fixedRate','Period',dt,'TimerFcn',@actualizar, ...
        'Tag','marioTimer');
    start(t);

    % Registrar handles a nivel global para poder forzar el cierre desde
    % fuera (pararMario) aunque la ventana quede sin responder.
    setappdata(0,'marioTimer',t);
    setappdata(0,'marioPlayer',player);
    setappdata(0,'marioFig',fig);

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
        if jugador.vx ~= 0
            mirando = sign(jugador.vx);
        end

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

        % Caida por un hueco (fila 12 = negro): reinicia el nivel desde cero
        if jugador.y > worldH + 80
            muertes = muertes + 1;
            jugador.x = spawnX;
            jugador.y = spawnY;
            jugador.vx = 0;
            jugador.vy = 0;
            jugador.enSuelo = false;
            mirando = 1;
            camX = 0;
        end

        % Meta: llegar al final del nivel
        if jugador.x >= worldW - playerW - 4 && ~ganado
            ganado = true;
            vivo = false;
            set(tituloTxt,'String','¡Meta alcanzada!');
            if ~isempty(player) && isvalid(player)
                player.StopFcn = ''; % si no, el loop se reinicia solo al parar
                if isplaying(player)
                    stop(player);
                end
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

        if usarSprite
            if mirando >= 0
                xd = [jugador.x, jugador.x+playerW];
            else
                xd = [jugador.x+playerW, jugador.x];
            end
            set(spriteImg,'XData',xd,'YData',[jugador.y,jugador.y+playerH]);
        else
            set(cuerpo,'Position',[jugador.x,jugador.y+8,playerW,playerH-8]);
            set(gorra, 'Position',[jugador.x-1,jugador.y,playerW+2,8]);
        end

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
            if ~isempty(player) && isvalid(player)
                player.StopFcn = ''; % si no, el loop se reinicia solo al parar
                if isplaying(player)
                    stop(player);
                end
            end
        end
    end
end
