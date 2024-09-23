% Incremental practice for Algebra & Discrete Mathematics
% 2022-23
% 
% Name of the student: Rafael Echevarria Aceña
% Milestone 4
% Briefly describe the steps taken to address this milestone:

% Calculo el indice de productividad de los grupos de investigacion y
% genero un arbol generador de maximo coste para cada grupo por separado.
% Después resalto las aristas conectadas a los nodos de mayor IPccon color rojo a demás de otras modificaciones extra. 
% Por ultimo se guardan dichos arboles en un archivo . mat


%% Obtener los investigadores con mayor indice de productividad (IP)
%En este apartado calculo los investigadores con un mayor indice de
%productividad, estos son aquellos cuya suma de pesos de las aristas incidentes
%con dicho nodo sea mas grande. Es decir, los nodos con mayor peso.

% En primer lugar es necesario obtener la lista de nodos de cada subgrafo
% individualmente.

nodos_subgrafo = cell(11, 1); %Inicializo el vector con el tamaño del cell de grafos original.
for i = 1:length(nodos_subgrafo)
    nodos_subgrafo{i} = prof_investigadores{i}.Nodes.Name; % Guardo los nodos desde los grupos de profesores
end

% Inicializo el vector de indices de productividad mediante una matriz de
% ceros cuyo tamaño sea igual al vector anterior.
indice_productividad = zeros(length(nodos_subgrafo{1}), 11);

% Luego, itero sobre los grafos de investigacion para conseguir los pesos
% de las aristas 
for i = 1:length(indice_productividad)

    % Obtengo los pesos de la arista de forma individual.
    pesos = prof_investigadores{i}.Edges.Weight;
    
    % Itero sobre los nodos para sumar los pesos de las aristas
    for j = 1:length(nodos_subgrafo{i})

        nodo = nodos_subgrafo{i}{j}; % Obtengo el nodo de forma individual 

        indice_nodo = findnode(prof_investigadores{i}, nodo); % Obtengo el índice de fila correspondiente al nodo
        
        indice_nodo = indice_nodo(1); % Convierto nodo_idx a un número entero ya que sin realizar este paso me devolvía un error en el siguiente paso.
        
        % Esta linea es bastante compleja, he tenido que juntar varias cosas en una ya que por separado me daba múltiples errores. Busco aquellas aristas que están conectadas directamente con el nodo en cuestión.
        % Para ello utilizo la función "find" junto con la función "strcmp" para buscar en las columnas 1 y 2 de la matriz las aristas de cada grafo
        % individual (prof_investigadores{i}.Edges.EndNodes) aquellas filas donde se encuentre el nombre del nodo actual, indicado por la variable "nodo". 
        % Luego, selecciono solo las filas que cumplan esta condición y se guardan en la variable aristas. 
        
        aristas = prof_investigadores{i}.Edges(find(strcmp(prof_investigadores{i}.Edges.EndNodes(:,1), nodos_subgrafo{i}{j}) | strcmp(prof_investigadores{i}.Edges.EndNodes(:,2), nodos_subgrafo{i}{j})), :);
        
        % Finalmente, la variable pesos_nodo será igual a los pesos de las aristas guardadas en la variable aristas.
        pesos_nodo = table2array(aristas(:, 'Weight'));
        
        % Guardo la suma de los pesos del nodo en su correspondiente vector
        % de los indices de productividad.
        indice_productividad(j, i) = sum(pesos_nodo);
    end

end

%% Mostrar los resultados de la suma para cada nodo de cada subgrafo
for i = 1:length(prof_investigadores)

    % Imprimo por consola los respectivos incides de profuctividad de
    % cada grupo 
    for j = 1:length(nodos_subgrafo{i})
        disp(['El indice de productividad de  ' nodos_subgrafo{i}{j} ' del equipo de investigacion ' num2str(i) ' es: ' num2str(indice_productividad(j, i))]);
    end

    % Encuentro el nodo con la suma máxima para cada iteración
    [max_suma, max_idx] = max(indice_productividad(:,i));
    nodo_max = nodos_subgrafo{i}{max_idx};
    IPs{i}=nodo_max;
    % Imprimo el resultado por consola aunque queda muy largo.
    fprintf('En el subgrafo %d, el nodo con la suma máxima es %s, con una suma de %f.\n', i, nodo_max, max_suma);
end


%% Crear los arboles mediante el algortimo de Prim

%En este apartado creo el arbol generador utilizando el algoritmo de prim
%mediante la funcion minspantree a traves de un add-on.

% Primero, creo un cell array vacío para almacenar los árboles generados
arbol_max_generador = cell(11, 1);

% Itero sobre los 11 grupos de investigación
for i = 1:length(prof_investigadores)
    
    % Obtengo el grafo correspondiente al grupo de investigación actual
    grupo_i = prof_investigadores{i};
    
    % Obtengo el índice del nodo IP mediante la funcion find
    indice_ip = find(ismember(grupo_i.Nodes.Name,IPs(i))); %La funcion ismember es un boolean que responde positivamente si pertenece a ese conjunto.
    
    % Obtengo los pesos de las aristas en cuestión, según mathworks para
    % utilizar la funcion minspantree deben ser negativos.
    neg_pesos = -grupo_i.Edges.Weight;
    grupo_i.Edges.Weight=neg_pesos;

    % Obtengo el árbol generador de máximo coste usando el algoritmo de Prim
    arbol_gener = minspantree(grupo_i,'Root',indice_ip); % En mathworks recomiendan el uso de Root.
    
    % Devuelvo el signo original a los pesos de las aristas una vez ya he
    % creado los arboles.
    arbol_gener.Edges.Weight = -arbol_gener.Edges.Weight;
    
    % Añado el árbol generado al array
    arbol_max_generador{i} = arbol_gener;

    % Obtengo los nodos IP para su representación en rojo
    IP_nodes(i) = grupo_i.Nodes.Name(indice_ip);
   

end

%% Representacion de los arboles, con los nodos IP en rojo
for i=1:length(arbol_max_generador)

    %Resalto las aristas conectadas a los nodos IP en rojo
    figure(i); % Represento cada una en una ventana distinta para que se vea mejor.
    h=plot(arbol_max_generador{i});

    %He modificado el color del nodo ip a rojo, con forma de diamante y
    %aumentado su tamayo para una mejor diferenciación.
    highlight(h,IP_nodes(i),'NodeColor','r','Marker','diamond','MarkerSize',10);
    
end

% Guard0 el array en un fichero .mat
save('arbol_max_generador.mat',"arbol_max_generador");





