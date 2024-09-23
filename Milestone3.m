% Incremental practice for Algebra & Discrete Mathematics
% 2022-23
% 
% Name of the student: Rafael Echevarría Aceña
% Milestone 1
% Briefly describe the steps taken to address this milestone:

% Represento el array de los grupos de investigacion de la UCLM en pestañas
% dsitintas con un ancho personalizado proporcional al peso, 
% este ha sido elegido a ojo en base a los pesos del propio grafo
% mediante la "normalizacion" de los pesos de cada arista.

%% Cargo los grupos de investigacion del hito 2

% En primer lugar, cargo el array con los grafos de los grupos de
% investigación.
load('prof_investigadores'); 

% No he modificado el nombre del array

%% Represento cada grupo de investigacion por separado

% Recorro el archivo e itero individualmente sobre los grafos mediante un bucle for
for i = 1:length(prof_investigadores)
    
    % Obtengo el grafo actual en la posición i para tratarlo de forma
    % individual.
    grupo_i = prof_investigadores{i};
    
    % Calculo el grosor máximo de los arcos del grafo para despues poder
    % operar con el.
    peso_max = max(grupo_i.Edges.Weight);
    
    % Represento el grafo en una nueva ventana para cada uno para una mejor
    % visualización.
    figure(i);

    % Aplico el valor de ancho en proporcion a los pesos segun la siguiente formula
    % matematica, que he ido modificando hasta que se adaptase bien
    % visualmente (x * grupo_i.Edges.Weight / max_pesos).

    % Hago el plot con la variable LineWidth para modificar el ancho.
    % También he cambiado el estilo de linea para que sea entrecortada.
    plot(grupo_i, 'LineWidth', 5 * grupo_i.Edges.Weight / peso_max, 'LineStyle','--');
    
    %Añado un titulo personalizado para cada ventana.
    title(sprintf('Research group %d', i));
end





