% Incremental practice for Algebra & Discrete Mathematics
% 2022-23
% 
% Name of the student: Rafael Echevarría Aceña
% Milestone 1
% Briefly describe the steps taken to address this milestone:

% En este hito represento los arboles de una forma mas visual y especifica
% con los nombres de los investigadores. He añadido que los anchos sean
% proporcionales con el valor de los pesos y cambiado algunas opciones del
% diseño como el color y el estilo.

%% Representacion mas específica

%Primero itero sobre el archivo para selecionar los distintos arboles del
%cell.
for i = 1:length(arbol_max_generador)

    % Obtengo los pesos de las aristas del árbol
    pesos_aristas_arbol = arbol_max_generador{i}.Edges.Weight;

    % Normalizo los pesos de las aristas del árbol para que estén entre 0 y 1. 
    % Los pesos normalizados se utilizan para definir el grosor de las aristas más adelante.
    pesos_normalizados = (pesos_aristas_arbol - min(pesos_aristas_arbol)) ./ (max(pesos_aristas_arbol) - min(pesos_aristas_arbol)); %En esta linea me he inspirado en ejemplos sobre este tipo de procedimiento que h epodido encontrar en mathworks y en un foro sobre el programa.

    % Defino el tamaño de las aristas a partir de los pesos normalizados,
    % utilizando una escala de 5 para hacer más visible la variación en el grosor de las aristas.
    tamano_aristas = 5 .* pesos_normalizados;

    % Verifico si alguno de los valores de grosor de las aristas es cero. 
    % Si es así, se le asigna un valor mínimo positivo a la variable para evitar errores más adelante en el código.
    if any(tamano_aristas == 0)
       tamano_aristas(tamano_aristas == 0) = eps; % Este apartado le he añadido al recibir este problema cuando no tenía los pesos del grafo del todo bien, pero he preferido dejarlo.
    end

    
    % Finalmente defino las opciones de representación del árbol. 
    % Hago que las aristas sean de color rojo y de un grosor determinado.
    % Tambien he cambiado el estilo de linea para que sea rayado.
    plot_options = {'NodeLabel', arbol_max_generador{i}.Nodes.full_name, 'EdgeColor', 'r', 'LineWidth', tamano_aristas, 'LineStyle','--'};
    figure(i); % Creo una ventana para cada uno para una mejor visualización
    plot(arbol_max_generador{i}, plot_options{:}); % Hago el plot junto con las opciones previamente definidas
    
end





