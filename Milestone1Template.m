% Incremental practice for Algebra & Discrete Mathematics
% 2022-23
% 
% Name of the student: Rafael Echevarría Aceña
% Milestone 1
% Briefly describe the steps taken to address this milestone:

% He cargado información de autores, publicaciones y colaboraciones desde archivos CSV y lo he utilizado para construir un grafo de colaboraciones entre autores.
% Luego, he calculado los pesos de las aristas del grafo basados en la
% cantidad de autores que han colaborado en cada publicación, y finalmente
% incluyo su representación gráfica.

clear all
clc;

% En primer lugar, cambiando el data_dir a la carpeta donde se encuentran
% los archivos.

%% Variable definition
data_dir = 'C:\Users\rafae\OneDrive - Universidad de Castilla-La Mancha\Escritorio\Rafa\Uni\2 Cuatrimestre\Álgebra y Matematica Discreta\Practica incremental'; 

%% Load graph data

% Primer archivo: autores. Contiene el id de los autores junto con su
% informacion mas detallada como el id de scopus, el nombre completo y la
% afiliacion. Los tres parametros los declaro como String.
opciones = detectImportOptions(strcat(data_dir,'1_authors.csv'));
opciones = setvartype(opciones, {'ID_author','AU_ID_scopus','full_name','affiliation'}, {'string','string','string','string'});
authors_data = readtable(strcat(data_dir,'1_authors.csv'), opciones); % Archivo que guardara toda la informacion relativa a los autores como tabla. El objetivo de esta tabla sera obetener la informacion de los nodos.


% Segundo archivo: publicaciones. Contiene el id de scopus de la
% publicacion asi como el tipo de documento, doi, titulo, fecha de
% publicacion, citaciones... No es necesario para la práctica.
opciones2 = detectImportOptions(strcat(data_dir,'2_publications.csv'));
opciones2 = setvartype(opciones2, {'scopus_id','document_type','doi','source_type', 'source_title', 'document_type', 'publication_date', 'citations'}, {'int64','string','string','string','string', 'string','string','int64'});
publications_data = readtable(strcat(data_dir,'2_publications.csv'), opciones2); 


% Tercer archivo: colaboradores. Contiene el id del autor uno y el id del
% autor dos que introduzco como enteros, junto con el id de la colaboracion de scopus que defino como string. 
opciones3 = detectImportOptions(strcat(data_dir,'3_collaborations.csv'));
opciones3 = setvartype(opciones3, {'ID_author_1','ID_author_2','scopus_id_collaborations'}, {'int64','int64','string'});
collaborations_data = readtable(strcat(data_dir,'3_collaborations.csv'), opciones3); %Archivo que guardara toda la informacion de las colaboraciones como tabla. De aqui se pueden sacar los nodos de origen y los de destino.

%% Construct the graph

%Segun el enunciado, para el correcto funcionamiento del grafo es necesario
%que el id del autor se llame Name.
authors_data = renamevars(authors_data, 'ID_author', 'Name');

%Para crear el grafo, he utilizado el formato graph(s,t) donde todavia no
%se especifican los pesos unicamento los nodos origen y destino. Hay que
%tener en cuenta que no es un grafo dirigido.


%% Calculate edge weights

%Para crear los pesos de las aristas he realizado este procedimiento: En
%primer lugar, he creado dos tablas una con todos los scopus ids y otra
%sacando los scopus ids sin repeticiones, es decir, los originales. Despues
%he iterado sobre la primera tabla con todos los ids para contar cuantas
%veces aparece y ese será su peso. Pero como bien dice el enunciado, hay
%que tener en cuenta que no es lo mismo un valor con tres autores que con
%seis por lo que divido el peso entre uno.

%Creo una tabla para no cambiar la tabla original.
scopus_id=collaborations_data.scopus_id_collaborations;
scopus_split=[]; %Inicializo el vector al que añadire los ids
weights=[]; %Inicializo el vector de pesos en el que introducire los pesos finales.

%Uso un bucle for para introducir los datos, como cada columna tiene un
%numero distinto de ids me daba error al introducirlos en el vector asi que
%he utilizado un vector auxiliar y temporal para corregir ese error.
for i=1:height(collaborations_data)
    temp_split = split(scopus_id(i),','); %Vector auxiliar
    scopus_split = [scopus_split; temp_split];% Vector final con todos los ids por separado.
end

% Obtengo los ids únicos en la matriz scopus_split.
unique_vals = unique(scopus_split);
%Inicializo el vector en el que guardare cuantas veces aparece cada id de
%los valores unicos en la tabla de los valores generales.
pesos_scopus=zeros(length(unique_vals),1);

%Itero mediante un for para recorrer el vector, he utilizado la funcion
%contains para mayor eficacia, sumando la cantidad de veces que aparece un
%valor de la tabla de unicos en la general. Todo ello entre uno como indica
%el enunciado.
for i=1:length(unique_vals)
    pesos_scopus(i) = 1/sum(contains(scopus_split, unique_vals(i))); %La funcion contains es una forma mas sencilla y eficaz de comparar dos vectores, 
    % devuelve un valor positivo si encuentra ese valor, es decir un uno.
end

%Hasta este momento se ha conseguido un vector con el numero de veces que
%aparece cada id, pero no se ha tenido en cuenta que las columnas de la
%tabla original contienen varios ids por lo que falta sumar los pesos que
%hemos conseguido dentro de una misma columna. Para ello hay que
%intercambiar los ids de la tabla original por los pesos que hemos
%encontrado, es decir, asociarlos. 
unique_vals=string(unique_vals);
% Para implementar esto he encontrado en MathWorks una utilizacion similar a un diccionario en el que se asocia una cadena a un valor numerico, que es precisamente lo que necesitamos.
dicc = containers.Map(unique_vals,pesos_scopus); %Defino el diccionario, mediante la siguiente sintaxis (cadena , valor numerico asociado)

for j=1:height(collaborations_data)
% Convertimos el string de una columna en concreto en una matriz de celdas
cellIds = strsplit(collaborations_data.scopus_id_collaborations(j), ',');

% Inicializamos la suma en cero
suma = 0;

% Bucle para recorrer cada elemento de la matriz
for i = 1:numel(cellIds)
    % Obtenemos el valor numérico correspondiente a cada id dentro de la
    % cadena de esa columna concreta
    valor = dicc(cellIds{i});
    
    % Sumamos el valor asociado a ese id actual a la suma total de esa columna
    suma = suma + valor;
end

    %Añado esa suma a un vector de pesos que después introducire
    %directamente al grafo.
    weights(j,1)=suma;

end



%% Visualize the graph

%He construido el grafo aqui debido a un error previo, al construir el
%grafo anteriormente se desordenaban las aristas alterando tambien los
%pesos a la hora de añadirlos, lo hacian de forma erronea.
Grafo_Colaboraciones=graph(collaborations_data.ID_author_1,collaborations_data.ID_author_2,weights,authors_data);

figure(1); %Pongo una ventana aunque no seria del todo necesario.
% Visualizo el grafo poniendo el diseño force y cambiando el color de los
% nodos a rojo para una mejor visualizacion.
plot(Grafo_Colaboraciones, "Layout","force","NodeColor",'r');

save("Grafo_Colaboraciones.mat")

%De esta forma ya tendriamos el grafo con la suma de todos los pesos 

