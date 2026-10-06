function [rgb,alpha] = cargarSpriteTransparente(ruta,umbral)
% CARGARSPRITETRANSPARENTE Carga un PNG/JPG y devuelve su RGB y su
% mascara alfa, recortados al contenido real (sin el margen de fondo).
%
% Si el archivo ya trae transparencia real (PNG con canal alfa), se usa
% esa transparencia. Si no, se aplica chroma-key: todo pixel casi
% blanco/gris claro (por encima de UMBRAL en los 3 canales) se vuelve
% transparente. Luego se recorta a la caja que contiene los pixeles
% visibles, para que el sujeto no quede perdido dentro de un lienzo
% mucho mas grande al reescalar.
%
% [rgb,alpha] = CARGARSPRITETRANSPARENTE(ruta)
% [rgb,alpha] = CARGARSPRITETRANSPARENTE(ruta,umbral)

    if nargin < 2
        umbral = 220;
    end

    [img,mapa,alphaNativa] = imread(ruta);

    if ~isempty(mapa) && ismatrix(img)
        img = im2uint8(ind2rgb(img,mapa));
    elseif ndims(img) == 2
        img = repmat(img,[1 1 3]);
    end

    if ~isempty(alphaNativa)
        alpha = alphaNativa;
    else
        fondo = all(img >= umbral,3);
        alpha = uint8(255*(~fondo));
    end

    % Recortar a la caja que contiene el contenido visible
    [filas,cols] = find(alpha > 0);

    if ~isempty(filas)
        r1 = min(filas); r2 = max(filas);
        c1 = min(cols); c2 = max(cols);
        img = img(r1:r2,c1:c2,:);
        alpha = alpha(r1:r2,c1:c2);
    end

    rgb = img;
end
