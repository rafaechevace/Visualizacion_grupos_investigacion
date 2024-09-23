% Incremental practice for Algebra & Discrete Mathematics
% 2022-23
% 
% Name of the student: Rafael Echevarría Aceña
% Milestone 2
% Briefly describe the steps taken to address this milestone:

% Busco de forma iterativa los distintos grupos de investigacion, para
% ello, elimino las aristas con peso menor que cinco y menor que el umbral alpha.
% Encuentro el valor de alpha mas adecuado para que se cumpla n(α∗) = n(α∗+0.3)
% Los grafos generados se añaden a un cell y se muestran por pantalla de
% forma individual.

%% Obtener las componentes conexas y crear los subgrafos correspondientes 

% Copiar el grafo original para trabajar con él en cada iteración manteniendo los valores originales
grafo_copia = Grafo_Colaboraciones;

% Inicializar variables
alpha = 0; % valor inicial del umbral 
incremento_alpha = 0.3; % Incremento de alpha en cada iteración
max_nodos_conexos = 0; % Esta es la variable para almacenar el número máximo de nodos en una componente conexa
grupo = 0; % Contador para identificar los grupos de investigación
grupos_investigacion = {}; % Creo el array para almacenar los grupos de investigación

% Iteración para buscar los grupos de investigación que estamos buscando.
while true
    
    % Eliminar las aristas con peso menor al valor actual de alpha
    aristas_a_eliminar = find(grafo_copia.Edges.Weight < alpha); % Primero guardo en una variable los indices de las aristas menores que alpha.
    grafo_copia = rmedge(grafo_copia, aristas_a_eliminar); % Luego elimino esas aristas mediante rmedge con sus indices.

    % Calculo las componentes conexas en el grafo resultante
    [nodos_conexos, tamanno_conexos] = conncomp(grafo_copia); %La funcion conncomp se encarga de buscar las componentes conexas directamente

    % Encuentro el tamaño de la componente conexa más grande
    comp_conexa_max = max(tamanno_conexos); %La funcion max busca el valor mas grande 

    % Encuentro las componentes conexas con tamaño igual al máximo
    grupos_actuales = find(tamanno_conexos == comp_conexa_max); % La funcion find encuentra indices de una variable, 
    % en este caso es un poco distinto pero se basa en el mismo funcionamiento, encontrando la que tenga el mismo valor.


 % Si el tamaño de la componente conexa más grande no ha cambiado, detener
 % la iteración. 
    if comp_conexa_max == max_nodos_conexos
        break;
    else
        % Si no se ha dado el caso intercambiar los valores para la
        %siguiente iteración.
        max_nodos_conexos = comp_conexa_max;
    end

    % Al acabar incremento alpha en 0.3 mediante una variable en vez de
    % hacerlo directamente.
    alpha=alpha+incremento_alpha;
end

%% Encontrar las nuevas componentes concexas y crear los subgrafos respecto a estas.

% Comienzo encontrando las componentes conexas en grafo umbral una vez se
% han realizado todos los cambios y se ha obtenido el valor de alpha
% adecuado, en este caso 6.
componentes_conexas = conncomp(grafo_copia);
prof_investigadores = {}; % Inicializo el array para almacenar los subgrafos

%En este apartado un poco mas complejo he realizado una iteracion sobre las
%componentes conexas ¡, encontrando sus id y creando un subgrafo con ellas.
%Solo se añadiran al grupo de investigación aquellos subgrafos que tengan
%mas de cinco nodos.

for i = 1:max(componentes_conexas)
    nodos_grupo = find(componentes_conexas == i);
    %con la opcion subgraph lo que hago es crear un subgrafo cogiendo los
    %valores de grafo_nuevo pero solo con aquellos que he guardado en nodos
    %grupo.
    subgrafo = subgraph(grafo_copia, nodos_grupo);
    if numnodes(subgrafo) >= 5 %Solo se introducen si tienen mas de cinco nodos.
        prof_investigadores{end+1} = subgrafo; 
    end
end

%% Visualización individual de los subgrafos.

% He seguido el mismo procedimiento que en hitos anteriores mediante figure
% y plot. 
for i = 1:length(prof_investigadores)
    figure;
    plot(prof_investigadores{i});
    title(sprintf('Subgrafo %d', i)); % En este caso he añadido titulo a la ventana.
end

