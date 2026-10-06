function [mundo,imgHandle] = mariomundo(posbloques,postubos)

    %% BLOQUES ------------------------------------------------------

    % 1 = vacio
    a{1} = uint8(zeros(16,16,3));

    % 2 = baldosa
    a{2} = imread('baldosa.png');

    % 3 = interrogante
    a{3} = imread('interrogante.png');

    % 4 = ladrillo
    a{4} = imread('ladrillo.png');


    %% LAKITU -------------------------------------------------------
    % lakitu.png ya viene del tamano exacto de un tile (16x16) y con
    % transparencia real: se usa tal cual, sin recortar ni reescalar
    % (recortar/reescalar estirara el dibujo y lo dejaria disperso).

    [lakitu,mapLakitu,alphaLakitu] = imread('lakitu.png');

    if ~isempty(mapLakitu)
        lakitu = im2uint8(ind2rgb(lakitu,mapLakitu));
    elseif ndims(lakitu) == 2
        lakitu = repmat(lakitu,[1 1 3]);
    end

    if ~isempty(alphaLakitu)
        lakitu(repmat(alphaLakitu == 0,[1 1 3])) = 0;
    end

    a{20} = lakitu;


    %% NUBE DE LAKITU -------------------------------------------------
    % Se achica el lienzo completo a 16x16 tal cual viene en el
    % archivo, sin quitarle el fondo (sin chroma-key).

    [nube,mapNube] = imread('lakitu_cloud.png');

    if ~isempty(mapNube)
        nube = im2uint8(ind2rgb(nube,mapNube));
    elseif ndims(nube) == 2
        nube = repmat(nube,[1 1 3]);
    end

    nube = imresize(nube,[16,16],'bilinear');

    a{21} = nube;


    %% CONTENIDO OCULTO DE BLOQUES (actividad 6) ---------------------
    % Mismo sprite visible que el bloque base: el contenido
    % (flor/estrella/moneda) esta oculto hasta romper el bloque en
    % el juego, por eso en el mapa estatico se ven identicos.

    % 30 = interrogante con flor, 31 = interrogante con estrella
    a{30} = a{3};
    a{31} = a{3};

    % 40 = ladrillo con moneda
    a{40} = a{4};


    %% TUBOS Y PLANTA -----------------------------------------------

    % 1 = vacio
    b{1} = uint8(zeros(32,32,3));

    % 2 = tubo
    b{2} = imread('tubo.png');


    %% PLANTA -------------------------------------------------------

    % Planta original de 32x16
    planta = imread('planta.png');

    % Crear espacio de 32x32
    planta32 = uint8(zeros(32,32,3));

    % Centrar la planta de 16 pixeles dentro de los 32
    planta32(:,9:24,:) = planta;

    % 3 = planta
    b{3} = planta32;


    %% MASCARAS -----------------------------------------------------

    c{1} = uint8(ones(32,32,3));
    c{2} = uint8(zeros(32,32,3));
    c{3} = uint8(zeros(32,32,3));


    %% CONSTRUIR BLOQUES --------------------------------------------

    bloques = cell2mat(a(posbloques));


    %% CONSTRUIR TUBOS Y PLANTAS -----------------------------------

    if size(postubos,2) == 1

        tubos = cell2mat(b(postubos)');
        mascara = cell2mat(c(postubos)');

    else

        tubos = cell2mat(b(postubos));
        mascara = cell2mat(c(postubos));

    end


    %% CONSTRUIR MUNDO ---------------------------------------------

    mundo = mascara.*bloques + tubos;


    %% MOSTRAR MUNDO -----------------------------------------------

    h = imshow(mundo);

    if nargout > 1
        imgHandle = h;
    end

end