function jugarMario()

% JUGARMARIO Version jugable del escenario generado.
%
% Controles:
%   Flecha izquierda / derecha : mover
%   Espacio o flecha arriba    : saltar
%   Esc                        : salir
%
% Si la ventana queda trabada:
%   pararMario


%% Recursos ----------------------------------------------------------

recursosDir = fullfile( ...
    fileparts(mfilename('fullpath')), ...
    '..', ...
    'recursos');


%% Generar el nivel -------------------------------------------------

[posbloques,postubos] = generarMundo(40);


%% Localizar plantas ------------------------------------------------
% actividad5 utiliza:
% 1 = vacio
% 2 = tubo
% 3 = planta

columnasPlantas = find(postubos(5,:) == 3);


%% Dimensiones del mundo --------------------------------------------

tile = 16;

worldRows = size(posbloques,1);
worldCols = size(posbloques,2);

worldW = worldCols*tile;
worldH = worldRows*tile;


%% Colisiones -------------------------------------------------------
% Los tubos son elementos solidos.
% Las plantas NO se agregan a solidMask.

tuboSolido = kron(postubos,ones(2,2)) == 2;

solidMask = (posbloques ~= 1) | tuboSolido;


%% ================================================================
% BLOQUES ROMPIBLES Y CONTENIDO OCULTO (actividad 6)
% ================================================================
% 3  = interrogante (sin contenido especial)
% 30 = interrogante con flor
% 31 = interrogante con estrella
% 4  = ladrillo normal (se puede romper)
% 40 = ladrillo con moneda (NO se rompe)
%
% bloquesVivos es una copia mutable: al romper un ladrillo se vuelve
% vacio. tilesUsados evita repetir el premio de un mismo bloque.

bloquesVivos = posbloques;

tilesUsados = false(worldRows,worldCols);

usadoImg = imresize(imread(fullfile(recursosDir,'baldosa.png')),[tile,tile]);

[monedaImg,monedaAlpha]     = cargarItemSiExiste(fullfile(recursosDir,'moneda.png'));
[florImg,florAlpha]         = cargarItemSiExiste(fullfile(recursosDir,'flor.jpg'));
[estrellaImg,estrellaAlpha] = cargarItemSiExiste(fullfile(recursosDir,'estrella.png'));

popups = struct('img',{},'vida',{},'duracion',{},'alphaBase',{},'y0',{});


%% Figura y escenario -----------------------------------------------

viewTiles = 25;

viewW = viewTiles*tile;
viewH = worldH;


% Cerrar una partida anterior si existe
pararMario();


fig = figure( ...
    'Name','Mario jugable', ...
    'NumberTitle','off', ...
    'Tag','marioFig', ...
    'Color','k', ...
    'Position',[80,80,900,round(900*viewH/viewW)], ...
    'KeyPressFcn',@teclaPresionada, ...
    'KeyReleaseFcn',@teclaSoltada, ...
    'CloseRequestFcn',@cerrar, ...
    'MenuBar','none', ...
    'ToolBar','none');


%% Dibujar mundo sin plantas fijas ---------------------------------
% Se crea una copia de postubos.
% En esta copia los 3 se convierten en 1.
%
% Esto permite dibujar posteriormente las plantas como objetos
% independientes y hacerlas aparecer/desaparecer.

postubosFondo = postubos;

postubosFondo(postubosFondo == 3) = 1;


[mundo,imgHandle] = mariomundo(posbloques,postubosFondo);

% Copia intacta del mundo recien generado, para poder restaurar todos
% los bloques (rotos/usados) cuando el jugador muere
mundoOriginal = mundo;


%% Configurar ejes --------------------------------------------------

ax = gca;

hold(ax,'on');

axis(ax,'image');
axis(ax,'off');

% Dejar una franja arriba reservada para el HUD (sin superponerse)
set(ax,'Units','normalized','Position',[0,0,1,0.90]);


%% ================================================================
% PLANTAS
% ================================================================

rutaPlanta = fullfile(recursosDir,'planta.png');


cantidadPlantas = length(columnasPlantas);


% Arreglo donde se guardaran los objetos graficos
plantas = gobjects(1,cantidadPlantas);


plantasDisponibles = ...
    cantidadPlantas > 0 && isfile(rutaPlanta);


if plantasDisponibles

    [imgPlanta,mapaPlanta,alphaPlanta] = ...
        imread(rutaPlanta);


    % Si la imagen esta indexada convertirla a RGB
    if ~isempty(mapaPlanta) && ismatrix(imgPlanta)

        imgPlanta = ...
            im2uint8(ind2rgb(imgPlanta,mapaPlanta));

    end


    % Cada columna de postubos equivale a 32 pixeles
    anchoTubo = 2*tile;


    % Dimensiones reales del sprite
    altoPlanta = size(imgPlanta,1);

    anchoPlanta = size(imgPlanta,2);


    for i = 1:cantidadPlantas

        columna = columnasPlantas(i);


        % Centro horizontal del tubo
        centroTubo = ...
            (columna - 0.5)*anchoTubo;


        % Centrar la planta horizontalmente sobre el tubo
        x1 = centroTubo - anchoPlanta/2;

        x2 = centroTubo + anchoPlanta/2;


        % La planta esta ubicada en la fila 5 de postubos
        y1 = (5-1)*anchoTubo;

        y2 = y1 + altoPlanta;


        % Crear la planta.
        % Inicialmente permanece escondida.
        plantas(i) = image(ax, ...
            'CData',imgPlanta, ...
            'XData',[x1 x2], ...
            'YData',[y1 y2], ...
            'Visible','off');


        % Utilizar transparencia si el PNG la tiene
        if ~isempty(alphaPlanta)

            set(plantas(i), ...
                'AlphaData',double(alphaPlanta)/255);

        end

    end

end


%% ================================================================
% SPRITE DE MARIO
% ================================================================

% Usa recursos/mario.png si existe.
% Si no, utiliza los rectangulos originales.

usarSprite = false;

spriteImg = [];


rutaSprite = fullfile(recursosDir,'mario.png');


if isfile(rutaSprite)

    try

        [img,mapa,alpha] = imread(rutaSprite);


        if ~isempty(mapa) && ismatrix(img)

            % PNG de colores indexados
            img = im2uint8(ind2rgb(img,mapa));

        end


        if isempty(alpha)

            % El PNG no trae canal alfa: el fondo blanco/gris claro
            % quedo "quemado" en los pixeles. Se vuelve transparente
            % por chroma-key (todo pixel casi blanco se descarta).
            alpha = uint8(255*(~all(img >= 220,3)));

        end


        spriteImg = image(ax, ...
            'CData',img, ...
            'XData',[0,1], ...
            'YData',[0,1]);


        set(spriteImg, ...
            'AlphaData',double(alpha)/255);


        usarSprite = true;


    catch

        usarSprite = false;

    end

end


%% Mario alternativo si no existe mario.png -------------------------

if ~usarSprite

    cuerpo = rectangle( ...
        'Position',[0,0,1,1], ...
        'FaceColor',[0.85,0.1,0.1], ...
        'EdgeColor','none');


    gorra = rectangle( ...
        'Position',[0,0,1,1], ...
        'FaceColor',[0.85,0.1,0.1], ...
        'EdgeColor','none');

end


%% Titulo -----------------------------------------------------------

tituloTxt = title(ax,'','Color','w');


%% ================================================================
% HUD DE MONEDAS (icono + numero, fijo en pantalla)
% ================================================================
% Eje aparte, en coordenadas de figura (no de mundo), para que no se
% mueva cuando la camara hace scroll.

hudAxes = axes(fig, ...
    'Units','normalized', ...
    'Position',[0.02,0.91,0.16,0.08], ...
    'Color','none');

axis(hudAxes,'off');

set(hudAxes,'XLim',[0,3],'YLim',[0,1],'YDir','reverse');

hold(hudAxes,'on');

if ~isempty(monedaImg)

    image(hudAxes, ...
        'CData',monedaImg, ...
        'AlphaData',double(monedaAlpha)/255, ...
        'XData',[0,1], ...
        'YData',[0,1]);

end

textoMonedas = text(hudAxes,1.3,0.5,'0', ...
    'Color','w', ...
    'FontSize',18, ...
    'FontWeight','bold', ...
    'VerticalAlignment','middle', ...
    'HorizontalAlignment','left');

uistack(hudAxes,'top');

axes(ax); %#ok<LAXES>  % volver a dejar ax como el eje activo


%% Direccion de Mario -----------------------------------------------
% 1 = derecha
% -1 = izquierda

mirando = 1;


%% Boton de reinicio ------------------------------------------------

botonReiniciar = uicontrol( ...
    fig, ...
    'Style','pushbutton', ...
    'String','Reiniciar (nuevo mundo)', ...
    'FontSize',11, ...
    'Units','normalized', ...
    'Position',[0.32,0.45,0.36,0.1], ...
    'Visible','off', ...
    'Callback',@reiniciarJuego);


%% ================================================================
% ESTADO DEL JUGADOR
% ================================================================

playerW = 12;

playerH = 28;


spawnX = 16;

spawnY = ...
    worldRows*tile - tile*2 - playerH;


jugador = struct( ...
    'x',spawnX, ...
    'y',spawnY, ...
    'vx',0, ...
    'vy',0, ...
    'enSuelo',false);


%% Fisica -----------------------------------------------------------

gravedad = 1400;

velSalto = -500;

velMover = 150;

dt = 0.033;


%% Estado general ---------------------------------------------------

camX = 0;

vivo = true;

ganado = false;

muertes = 0;

monedas = 0;


teclas = struct( ...
    'izq',false, ...
    'der',false, ...
    'salto',false);


%% ================================================================
% DISTANCIAS DE ACTIVACION DE LAS PLANTAS
% ================================================================
%
% Logica:
%
% Muy lejos:
%     planta escondida
%
% Distancia media:
%     planta visible
%
% Muy cerca:
%     planta escondida


% Si Mario esta a 48 px o menos:
% la planta se esconde
distanciaCerca = 48;


% Entre 48 y 160 px:
% la planta aparece
distanciaActivacion = 160;


%% Musica -----------------------------------------------------------

player = [];


try

    rutaTema = fullfile(recursosDir,'tema.mp3');


    if isfile(rutaTema)

        [y,Fs] = audioread(rutaTema);

    else

        [y,Fs] = marioTheme();

    end


    player = audioplayer(y,Fs);


    % Repetir musica
    player.StopFcn = @(src,~) play(src);


    play(player);


catch

    player = [];

end


%% ================================================================
% BUCLE DEL JUEGO
% ================================================================

t = timer( ...
    'ExecutionMode','fixedRate', ...
    'Period',dt, ...
    'TimerFcn',@actualizar, ...
    'Tag','marioTimer');


start(t);


% Guardar referencias globales
setappdata(0,'marioTimer',t);

setappdata(0,'marioPlayer',player);

setappdata(0,'marioFig',fig);


%% ================================================================
% FUNCIONES INTERNAS
% ================================================================


%% Actualizar juego -------------------------------------------------

    function actualizar(~,~)

        if ~isvalid(fig)

            detener();

            return;

        end


        if ~vivo

            return;

        end


        %% Movimiento horizontal

        jugador.vx = 0;


        if teclas.izq

            jugador.vx = jugador.vx - velMover;

        end


        if teclas.der

            jugador.vx = jugador.vx + velMover;

        end


        if jugador.vx ~= 0

            mirando = sign(jugador.vx);

        end


        %% Salto

        if teclas.salto && jugador.enSuelo

            jugador.vy = velSalto;

            jugador.enSuelo = false;

        end


        %% Gravedad

        jugador.vy = ...
            jugador.vy + gravedad*dt;


        %% Movimiento eje X

        nuevaX = ...
            jugador.x + jugador.vx*dt;


        nuevaX = ...
            max(0,min(nuevaX,worldW-playerW));


        if ~colisiona(nuevaX,jugador.y)

            jugador.x = nuevaX;

        end


        %% Movimiento eje Y

        nuevaY = ...
            jugador.y + jugador.vy*dt;


        if colisiona(jugador.x,nuevaY)


            if jugador.vy > 0

                % Mario esta cayendo
                filaTile = ...
                    floor((nuevaY+playerH)/tile);


                jugador.y = ...
                    filaTile*tile - playerH;


                jugador.enSuelo = true;


            else

                % Mario golpea el techo. El jugador mide mas que un
                % tile (playerH > tile), asi que su cabeza puede
                % abarcar 2 filas: hay que buscar cual de ellas es
                % la que realmente esta solida, no asumir que es la
                % primera fila que toca el borde superior.
                filaTile = filaSolidaDesdeArriba(nuevaY,jugador.x);

                jugador.y = ...
                    filaTile*tile;


                golpearFila(filaTile,jugador.x);

            end


            jugador.vy = 0;


        else

            jugador.y = nuevaY;

            jugador.enSuelo = false;

        end


        %% Caida por un hueco

        if jugador.y > worldH + 80

            muertes = muertes + 1;


            jugador.x = spawnX;

            jugador.y = spawnY;


            jugador.vx = 0;

            jugador.vy = 0;


            jugador.enSuelo = false;


            mirando = 1;

            camX = 0;


            % Al morir, el mundo vuelve a quedar como recien generado:
            % se deshacen los bloques rotos/usados
            bloquesVivos = posbloques;

            tilesUsados = false(worldRows,worldCols);

            solidMask = (posbloques ~= 1) | tuboSolido;

            mundo = mundoOriginal;

            set(imgHandle,'CData',mundo);

            for p = 1:numel(popups)

                delete(popups(p).img);

            end

            popups = struct('img',{},'vida',{},'duracion',{},'alphaBase',{},'y0',{});

        end


        %% Meta

        if jugador.x >= ...
                worldW - playerW - 4 && ~ganado


            ganado = true;

            vivo = false;


            set(tituloTxt, ...
                'String','¡Meta alcanzada!');


            if ~isempty(player) && isvalid(player)

                % Evitar que vuelva a comenzar al detenerlo
                player.StopFcn = '';


                if isplaying(player)

                    stop(player);

                end

            end


            set(botonReiniciar, ...
                'Visible','on');

        end


        %% Actualizar las plantas

        actualizarPlantas();


        %% Actualizar items flotantes (moneda/flor/estrella)

        actualizarPopups();


        %% Dibujar Mario y camara

        dibujar();

    end


%% ================================================================
% ACTUALIZAR PLANTAS
% ================================================================

    function actualizarPlantas()


        % Si este mundo no genero plantas
        if ~plantasDisponibles

            return;

        end


        % Posicion horizontal del centro de Mario
        marioCentro = ...
            jugador.x + playerW/2;


        % Cada columna de postubos mide 32 pixeles
        anchoTubo = 2*tile;


        for j = 1:cantidadPlantas


            columna = columnasPlantas(j);


            % Posicion horizontal del centro del tubo
            tuboCentro = ...
                (columna - 0.5)*anchoTubo;


            % Distancia horizontal entre Mario y el tubo
            distancia = ...
                abs(marioCentro - tuboCentro);


            %% Logica de comportamiento

            if distancia > distanciaCerca && ...
                    distancia <= distanciaActivacion


                % Mario esta a una distancia media:
                % mostrar planta

                set(plantas(j), ...
                    'Visible','on');


            else


                % Mario esta demasiado cerca
                % o demasiado lejos:
                % esconder planta

                set(plantas(j), ...
                    'Visible','off');


            end

        end

    end


%% ================================================================
% COLISIONES
% ================================================================

    function ocupado = colisiona(x,y)


        c1 = max(1, ...
            floor(x/tile)+1);


        c2 = min(worldCols, ...
            floor((x+playerW-0.01)/tile)+1);


        r1 = max(1, ...
            floor(y/tile)+1);


        r2 = min(worldRows, ...
            floor((y+playerH-0.01)/tile)+1);


        if r1 > worldRows || ...
           r2 < 1 || ...
           c1 > worldCols || ...
           c2 < 1


            ocupado = false;

            return;

        end


        ocupado = any( ...
            solidMask(r1:r2,c1:c2), ...
            'all');

    end


%% ================================================================
% FILA SOLIDA MAS ARRIBA DENTRO DEL CUERPO DEL JUGADOR
% ================================================================
% playerH > tile, asi que al saltar la cabeza del jugador puede
% abarcar 2 filas de tiles. Devuelve la primera (mas alta, osea la
% de menor indice) que realmente este solida, para no confundirla
% con la fila vacia de encima.

    function fila = filaSolidaDesdeArriba(y,x)

        c1 = max(1,floor(x/tile)+1);

        c2 = min(worldCols,floor((x+playerW-0.01)/tile)+1);

        r1 = max(1,floor(y/tile)+1);

        r2 = min(worldRows,floor((y+playerH-0.01)/tile)+1);

        fila = r1;

        for rr = r1:r2

            if any(solidMask(rr,c1:c2))

                fila = rr;

                break;

            end

        end

    end


%% ================================================================
% GOLPEAR BLOQUES DESDE ABAJO
% ================================================================

    function golpearFila(fila,x)

        if fila < 1 || fila > worldRows

            return;

        end

        c1 = max(1,floor(x/tile)+1);

        c2 = min(worldCols,floor((x+playerW-0.01)/tile)+1);

        for col = c1:c2

            id = bloquesVivos(fila,col);

            switch id

                case 4

                    % Ladrillo normal: se rompe
                    romperBloque(fila,col);

                case 40

                    % Ladrillo con moneda: no se rompe
                    if ~tilesUsados(fila,col)

                        tilesUsados(fila,col) = true;

                        monedas = monedas + 1;

                        marcarUsado(fila,col);

                        crearPopup(fila,col,monedaImg,monedaAlpha);

                    end

                case 3

                    % Interrogante sin contenido especial
                    if ~tilesUsados(fila,col)

                        tilesUsados(fila,col) = true;

                        marcarUsado(fila,col);

                    end

                case 30

                    % Interrogante con flor (sin contador, solo visual)
                    if ~tilesUsados(fila,col)

                        tilesUsados(fila,col) = true;

                        marcarUsado(fila,col);

                        crearPopup(fila,col,florImg,florAlpha);

                    end

                case 31

                    % Interrogante con estrella (sin contador, solo visual)
                    if ~tilesUsados(fila,col)

                        tilesUsados(fila,col) = true;

                        marcarUsado(fila,col);

                        crearPopup(fila,col,estrellaImg,estrellaAlpha);

                    end

            end

        end

    end


%% ================================================================
% ROMPER UN BLOQUE DE LADRILLO
% ================================================================

    function romperBloque(fila,col)

        bloquesVivos(fila,col) = 1;

        solidMask(fila,col) = false;

        pintarTile(fila,col,zeros(tile,tile,3,'uint8'));

    end


%% ================================================================
% MARCAR UN BLOQUE COMO YA USADO (interrogante/moneda)
% ================================================================

    function marcarUsado(fila,col)

        pintarTile(fila,col,usadoImg);

    end


%% ================================================================
% PINTAR UN TILE DIRECTO SOBRE LA IMAGEN YA DIBUJADA
% ================================================================

    function pintarTile(fila,col,imgTile)

        filasPx = (fila-1)*tile+1 : fila*tile;

        columnasPx = (col-1)*tile+1 : col*tile;

        mundo(filasPx,columnasPx,:) = imgTile;

        set(imgHandle,'CData',mundo);

    end


%% ================================================================
% CREAR UN ITEM FLOTANTE (moneda/flor/estrella)
% ================================================================

    function crearPopup(fila,col,img,alpha)

        if isempty(img)

            return;

        end

        anchoItem = 12;

        altoItem = 12;

        cx = (col-0.5)*tile;

        yBase = (fila-1)*tile;

        h = image(ax, ...
            'CData',img, ...
            'XData',[cx-anchoItem/2,cx+anchoItem/2], ...
            'YData',[yBase-altoItem,yBase], ...
            'AlphaData',double(alpha)/255);

        nuevo.img = h;

        nuevo.vida = 0;

        nuevo.duracion = 24;

        nuevo.alphaBase = double(alpha)/255;

        nuevo.y0 = yBase;

        popups(end+1) = nuevo; %#ok<AGROW>

    end


%% ================================================================
% ACTUALIZAR ITEMS FLOTANTES (subir y desvanecer)
% ================================================================

    function actualizarPopups()

        activos = true(1,numel(popups));

        for k = 1:numel(popups)

            p = popups(k);

            p.vida = p.vida + 1;

            desplazamiento = 18*(p.vida/p.duracion);

            set(p.img, ...
                'YData',[p.y0-12-desplazamiento,p.y0-desplazamiento]);

            factor = max(0,1 - p.vida/p.duracion);

            set(p.img,'AlphaData',p.alphaBase*factor);

            if p.vida >= p.duracion

                delete(p.img);

                activos(k) = false;

            else

                popups(k) = p;

            end

        end

        popups = popups(activos);

    end


%% ================================================================
% CARGAR UN SPRITE DE ITEM (moneda/flor/estrella) SI EXISTE
% ================================================================

    function [rgbImg,alphaImg] = cargarItemSiExiste(ruta)

        rgbImg = [];

        alphaImg = [];

        if ~isfile(ruta)

            return;

        end

        try

            [rgbImg,alphaImg] = cargarSpriteTransparente(ruta);

        catch

            rgbImg = [];

            alphaImg = [];

        end

    end


%% ================================================================
% DIBUJAR MARIO Y CAMARA
% ================================================================

    function dibujar()


        camX = ...
            jugador.x + playerW/2 - viewW/2;


        camX = ...
            max(0,min(camX,worldW-viewW));


        xlim(ax, ...
            [camX,camX+viewW]);


        ylim(ax, ...
            [0,viewH]);


        %% Dibujar sprite de Mario

        if usarSprite


            if mirando >= 0

                xd = [ ...
                    jugador.x, ...
                    jugador.x+playerW];

            else

                xd = [ ...
                    jugador.x+playerW, ...
                    jugador.x];

            end


            set(spriteImg, ...
                'XData',xd, ...
                'YData',[ ...
                    jugador.y, ...
                    jugador.y+playerH]);


        else


            set(cuerpo, ...
                'Position',[ ...
                    jugador.x, ...
                    jugador.y+8, ...
                    playerW, ...
                    playerH-8]);


            set(gorra, ...
                'Position',[ ...
                    jugador.x-1, ...
                    jugador.y, ...
                    playerW+2, ...
                    8]);

        end


        %% Titulo

        if vivo

            set(tituloTxt, ...
                'String', ...
                sprintf( ...
                    'Mario jugable - muertes: %d', ...
                    muertes));

        end


        %% HUD de monedas (icono + numero, fijo en pantalla)

        set(textoMonedas,'String',sprintf('%d',monedas));


        drawnow limitrate;

    end


%% ================================================================
% TECLADO
% ================================================================

    function teclaPresionada(~,evt)


        switch evt.Key


            case 'leftarrow'

                teclas.izq = true;


            case 'rightarrow'

                teclas.der = true;


            case {'space','uparrow'}

                teclas.salto = true;


            case 'escape'

                close(fig);

        end

    end


    function teclaSoltada(~,evt)


        switch evt.Key


            case 'leftarrow'

                teclas.izq = false;


            case 'rightarrow'

                teclas.der = false;


            case {'space','uparrow'}

                teclas.salto = false;

        end

    end


%% ================================================================
% REINICIAR JUEGO
% ================================================================

    function reiniciarJuego(~,~)


        % Cierra la partida actual
        close(fig);


        % Genera un nuevo escenario
        jugarMario();

    end


%% ================================================================
% CERRAR
% ================================================================

    function cerrar(~,~)


        detener();


        delete(fig);

    end


%% ================================================================
% DETENER TIMER Y MUSICA
% ================================================================

    function detener()


        try %#ok<TRYNC>

            if isvalid(t) && ...
                    strcmp(t.Running,'on')

                stop(t);

            end


            delete(t);

        end


        try %#ok<TRYNC>

            if ~isempty(player) && ...
                    isvalid(player)


                % Evita que la musica vuelva a comenzar
                player.StopFcn = '';


                if isplaying(player)

                    stop(player);

                end

            end

        end

    end


end