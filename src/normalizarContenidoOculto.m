function bloques = normalizarContenidoOculto(bloques)
% NORMALIZARCONTENIDOOCULTO Convierte los ids de contenido oculto que
% agrega actividad6 (30/31 = interrogante con flor/estrella, 40 =
% ladrillo con moneda) de vuelta a su tipo base (3 = interrogante,
% 4 = ladrillo).
%
% actividad3 y actividad4 solo reconocen los tipos base; esta funcion
% se llama antes de que lean el par anterior, para no tener que
% modificar esos archivos.

    bloques(bloques == 30 | bloques == 31) = 3;
    bloques(bloques == 40) = 4;

end
