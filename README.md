# Proyecto SQL – Diseño de Base de Datos Relacional y EDA

## 1. Objetivo del proyecto
El objetivo de este proyecto es diseñar, implementar y analizar una base de datos
relacional orientada a un dominio de fitness, aplicando buenas prácticas de modelado
relacional y análisis exploratorio de datos (EDA) mediante SQL.

El proyecto permite extraer insights relevantes a partir de los datos y simular
un entorno realista de análisis de sesiones de entrenamiento.

---

## 2. Dominio y alcance
La base de datos representa un sistema de seguimiento de entrenamientos físicos,
donde los usuarios realizan sesiones asociadas a rutinas y ejercicios en fechas
concretas.

### Incluye:
- Información de usuarios (nivel, objetivo, disponibilidad de gimnasio).
- Rutinas y ejercicios de entrenamiento.
- Sesiones realizadas con métricas de duración, esfuerzo y calorías.
- Dimensión temporal para análisis por fechas.

---

## 3. Modelo de datos
El modelo sigue un enfoque de **modelo estrella**, con:
- Una **tabla de hechos** (`sesion_entrenamiento`) que almacena las métricas principales.
- Varias **tablas de dimensiones** (`usuario`, `rutina`, `ejercicio`, `calendario`).
- Una tabla intermedia para resolver relaciones muchos a muchos (`rutina_ejercicio`).

Este diseño facilita la integridad de los datos y el análisis analítico posterior.

---

## 4. Implementación
La implementación se divide en tres archivos principales:

- `01_schema.sql`: creación del esquema, tablas, claves primarias y foráneas,
  constraints, índices y comentarios explicativos.
- `02_data.sql`: carga de datos simulados mediante sentencias INSERT,
  incluyendo ejemplos de limpieza y control de transacciones.
- `03_eda.sql`: análisis exploratorio de datos, considerado el núcleo del proyecto,
  donde se aplican JOINs, agregaciones, CASE, CTEs, funciones ventana, vistas y funciones.

---

## 5. Análisis Exploratorio (EDA)
El EDA permite analizar:
- Adherencia de los usuarios al entrenamiento.
- Intensidad y esfuerzo de las sesiones.
- Comparativas entre rutinas con y sin gimnasio.
- Patrones temporales de actividad.
- Identificación de sesiones de riesgo por sobreentrenamiento.

Cada consulta incluye comentarios con los insights obtenidos y su relevancia
para la toma de decisiones.

---

## 6. Resultados y conclusiones
El análisis muestra diferencias claras en el comportamiento de los usuarios según
su nivel y el tipo de rutina realizada. Los usuarios intermedios presentan mayor
adherencia, mientras que los principiantes requieren rutinas más progresivas.

Estos resultados permiten orientar decisiones de personalización de entrenamientos
y mejora de la experiencia del usuario.

