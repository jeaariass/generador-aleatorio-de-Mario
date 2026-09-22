function iniciarProyecto()
% INICIARPROYECTO Agrega al path de MATLAB todas las carpetas del
% proyecto (src, actividades, recursos, extra), sin importar cual sea la
% carpeta actual dentro del repositorio.
%
% Ejecutar UNA VEZ al abrir el proyecto (en MATLAB Desktop u Online):
%
%   iniciarProyecto
%
% Despues ya se puede llamar cualquier funcion/script del proyecto por
% su nombre, por ejemplo:
%
%   ejecutarActividad1
%   jugarMario

    raiz = fileparts(mfilename('fullpath'));
    addpath(genpath(raiz));
    fprintf('Proyecto listo. Carpetas agregadas al path desde:\n  %s\n', raiz);
    fprintf('Prueba: ejecutarActividad1   (o)   jugarMario\n');
end
