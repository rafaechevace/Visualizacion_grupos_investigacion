# Proyecto_Modelado_Epidemiológico

    Este proyecto es una implementación de modelos de simulación determinista para el análisis de sistemas dinámicos, en particular, la propagación de enfermedades. Se basa en álgebra y teoria de grafos, esta implementado en MatLab.
    
##Objetivo del Proyecto

    El objetivo principal de este proyecto es simular diferentes escenarios de propagación de enfermedades a través de modelos epidemiológicos básicos, permitiendo la observación de cómo evolucionan las poblaciones susceptibles y enfermas bajo distintas condiciones. Además, se exploran aspectos como el impacto de la incidencia constante, la tasa de contagio, y la recuperación y fallecimiento de la población.
    
##Modelos Implementados

A lo largo del proyecto se implementan y simulan varios modelos, cada uno con diferentes parámetros y escenarios:

    **Modelo de Incidencia Constante:** Simula la evolución de una enfermedad en una población bajo la hipótesis de que se diagnostican o notifican un número constante de nuevos casos en cada unidad de tiempo.

    **Modelo de Tasa de Incidencia Constante:** En este modelo, la incidencia depende de la cantidad de personas susceptibles, corrigiendo las limitaciones del modelo anterior.

    **Modelo de Tasa de Contagio Constante:** Aquí, la tasa de contagio es proporcional a la prevalencia de la enfermedad, reflejando una mayor probabilidad de infección cuando hay más personas enfermas en la población.

    **Modelo con Recuperación y Fallecimiento:** Extiende los modelos anteriores al incluir dinámicas de recuperación y mortalidad entre la población enferma, con la posibilidad de reinfección.
