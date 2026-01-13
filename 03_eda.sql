-- =========================================
-- Proyecto SQL - Base de Datos Fitness 03 EDA
-- =========================================

USE fitness_db;

-- Parte 1: Se comprueban que los datos tienen sentidos antes de analizar.

-- Conteo básico para validar carga de datos.
SELECT 'usuario' AS tabla, COUNT(*) AS total FROM usuario
UNION ALL
SELECT 'rutina', COUNT(*) FROM rutina
UNION ALL
SELECT 'ejercicio', COUNT(*) FROM ejercicio
UNION ALL
SELECT 'calendario', COUNT(*) FROM calendario
UNION ALL
SELECT 'sesion_entrenamiento', COUNT(*) FROM sesion_entrenamiento;
/*
Insight:
El volumen de registros es suficiente en todas las tablas para realizar un análisis exploratorio, especialmente en la tabla de hechos,
que contiene múltiples sesiones por usuario.
*/

-- Adherencia básica al entrenamiento.
SELECT
  completada,
  COUNT(*) AS total_sesiones
FROM sesion_entrenamiento
GROUP BY completada;
/*
Insight:
Se observa la proporción de sesiones completadas frente a no completadas, lo que permite evaluar la adherencia general de los usuarios al sistema
y detectar posibles problemas de abandono.
*/

-- Rango de métricas clave
SELECT
  MIN(duracion_min) AS min_duracion,
  MAX(duracion_min) AS max_duracion,
  MIN(esfuerzo) AS min_esfuerzo,
  MAX(esfuerzo) AS max_esfuerzo
FROM sesion_entrenamiento;
/*
Insight:
Los valores mínimos y máximos de duración y esfuerzo se encuentran dentro de rangos razonables, lo que indica coherencia en los datos y ausencia
de valores atípicos extremos que puedan distorsionar el análisis.
*/

-- Parte 2: JOINs cruzando la tabla FACT con DIMs

-- INNER JOIN Sesiones con perfil del usuario
SELECT
  s.id_sesion,
  u.nivel,
  u.objetivo,
  s.duracion_min,
  s.esfuerzo
FROM sesion_entrenamiento s
INNER JOIN usuario u
  ON s.id_usuario = u.id_usuario;
/*
Insight:
Al cruzar las sesiones con el perfil del usuario se puede analizar la duración y el esfuerzo de los entrenamientos en función del nivel y objetivo personal,
permitiendo evaluar si la intensidad propuesta es coherente con cada perfil.
*/

-- INNER JOIN Sesiones por tipo de rutina
SELECT
  s.id_sesion,
  r.nombre AS rutina,
  r.nivel AS nivel_rutina,
  r.con_gimnasio,
  s.calorias_estimadas
FROM sesion_entrenamiento s
INNER JOIN rutina r
  ON s.id_rutina = r.id_rutina;
/*
Insight:
Este join permite comparar el gasto calórico y la exigencia de cada tipo de rutina, facilitando la identificación de entrenamientos más intensivos
o adecuados para determinados perfiles.
*/

-- LEFT JOIN para análisis temporal
SELECT
  c.fecha,
  c.dia_semana,
  COUNT(s.id_sesion) AS sesiones
FROM calendario c
LEFT JOIN sesion_entrenamiento s
  ON c.id_fecha = s.id_fecha
GROUP BY c.fecha, c.dia_semana
ORDER BY c.fecha;
/*
Insight:
El análisis temporal permite detectar patrones de entrenamiento a lo largo de los días, identificando posibles picos de actividad o días con menor
número de sesiones realizadas.
*/

-- Parte 3: Agregaciones: KPIs, metricas utiles de negocio

-- KPI: volumen de sesiones por nivel
SELECT
  u.nivel,
  COUNT(*) AS total_sesiones
FROM sesion_entrenamiento s
JOIN usuario u ON s.id_usuario = u.id_usuario
GROUP BY u.nivel;
/*
-- Insight:
El volumen de sesiones por nivel permite identificar qué tipo de usuario es más constante. Una mayor concentración en niveles intermedios puede
indicar una mayor estabilidad y adherencia en esta fase.
*/

-- KPI: intensidad media por rutina
SELECT
  r.nombre AS rutina,
  ROUND(AVG(s.esfuerzo), 2) AS esfuerzo_medio
FROM sesion_entrenamiento s
JOIN rutina r ON s.id_rutina = r.id_rutina
GROUP BY r.nombre
ORDER BY esfuerzo_medio DESC;
/*
Insight:
Las rutinas con mayor esfuerzo medio representan entrenamientos más exigentes, lo que permite evaluar si la intensidad propuesta es adecuada al nivel
objetivo de cada rutina.
*/

-- Comparativa de calorias medias con/sin gimnasio
SELECT
  r.con_gimnasio,
  ROUND(AVG(s.calorias_estimadas), 2) AS calorias_medias
FROM sesion_entrenamiento s
JOIN rutina r ON s.id_rutina = r.id_rutina
GROUP BY r.con_gimnasio;
/*
Insight:
Las rutinas realizadas con gimnasio presentan un mayor gasto calórico medio, lo que refuerza el impacto del equipamiento en entrenamientos orientados
a fuerza y ganancia muscular.
*/

-- Parte 4: CASE y logica condicional

-- Clasificación de sesiones por intensidad
SELECT
  s.id_sesion,
  s.esfuerzo,
  CASE
    WHEN s.esfuerzo <= 5 THEN 'Baja'
    WHEN s.esfuerzo BETWEEN 6 AND 7 THEN 'Media'
    ELSE 'Alta'
  END AS intensidad
FROM sesion_entrenamiento s;
/*
Insight:
La clasificación por intensidad facilita la segmentación de sesiones, permitiendo analizar si el sistema propone mayoritariamente entrenamientos
suaves, moderados o exigentes.
*/

-- Distribución de sesiones por intensidad
SELECT
  CASE
    WHEN esfuerzo <= 5 THEN 'Baja'
    WHEN esfuerzo BETWEEN 6 AND 7 THEN 'Media'
    ELSE 'Alta'
  END AS intensidad,
  COUNT(*) AS total_sesiones
FROM sesion_entrenamiento
GROUP BY intensidad;
/*
Insight:
La distribución de sesiones por intensidad permite evaluar el equilibrio del sistema de entrenamiento y detectar posibles sesgos hacia cargas
excesivas o demasiado conservadoras.
*/

-- Análisis de adherencia por nivel de usuario
SELECT
  u.nivel,
  SUM(CASE WHEN s.completada = 1 THEN 1 ELSE 0 END) AS sesiones_completadas,
  SUM(CASE WHEN s.completada = 0 THEN 1 ELSE 0 END) AS sesiones_no_completadas
FROM sesion_entrenamiento s
JOIN usuario u ON s.id_usuario = u.id_usuario
GROUP BY u.nivel;
/*
Insight:
Los niveles con mayor número de sesiones no completadas pueden requerir ajustes en la duración o intensidad de las rutinas para mejorar la adherencia,
especialmente en usuarios principiantes.
*/

-- Identificación de sesiones potencialmente problemáticas
SELECT
  s.id_sesion,
  s.duracion_min,
  s.esfuerzo,
  CASE
    WHEN s.duracion_min > 60 AND s.esfuerzo >= 9 THEN 'Riesgo alto'
    WHEN s.duracion_min > 45 AND s.esfuerzo >= 8 THEN 'Riesgo medio'
    ELSE 'Normal'
  END AS nivel_riesgo
FROM sesion_entrenamiento s;
/*
Insight:
La identificación de sesiones de riesgo permite detectar posibles casos de sobreentrenamiento, lo que resulta útil para diseñar estrategias de
prevención de lesiones y mejora del bienestar del usuario.
*/

-- Parte 5 CTEs (WITH)

-- CTE: cálculo del número de sesiones por usuario
WITH sesiones_por_usuario AS (
  SELECT
    s.id_usuario,
    COUNT(*) AS total_sesiones
  FROM sesion_entrenamiento s
  GROUP BY s.id_usuario
)
SELECT
  u.id_usuario,
  u.nivel,
  u.objetivo,
  spu.total_sesiones
FROM sesiones_por_usuario spu
JOIN usuario u ON spu.id_usuario = u.id_usuario
ORDER BY spu.total_sesiones DESC;
/*
Insight:
Este análisis permite identificar qué usuarios son más activos dentro del sistema.
Un mayor número de sesiones puede asociarse a una mayor adherencia y compromiso
con el entrenamiento.
*/

-- CTE encadenada: sesiones por usuario y ranking
WITH sesiones_por_usuario AS (
  SELECT
    id_usuario,
    COUNT(*) AS total_sesiones
  FROM sesion_entrenamiento
  GROUP BY id_usuario
),
ranking_usuarios AS (
  SELECT
    id_usuario,
    total_sesiones,
    RANK() OVER (ORDER BY total_sesiones DESC) AS ranking
  FROM sesiones_por_usuario
)
SELECT
  r.ranking,
  u.id_usuario,
  u.nivel,
  r.total_sesiones
FROM ranking_usuarios r
JOIN usuario u ON r.id_usuario = u.id_usuario
ORDER BY r.ranking;
/*
Insight:
El ranking permite comparar el nivel de actividad entre usuarios y detectar
perfiles altamente comprometidos frente a usuarios con menor constancia,
lo que puede ser útil para personalizar recomendaciones o planes de seguimiento.
*/

-- CTE: calorías totales acumuladas por usuario
WITH calorias_por_usuario AS (
  SELECT
    id_usuario,
    SUM(calorias_estimadas) AS calorias_totales
  FROM sesion_entrenamiento
  GROUP BY id_usuario
)
SELECT
  u.id_usuario,
  u.nivel,
  u.objetivo,
  c.calorias_totales
FROM calorias_por_usuario c
JOIN usuario u ON c.id_usuario = u.id_usuario
ORDER BY c.calorias_totales DESC;
/*
Insight:
Este indicador permite evaluar el volumen total de esfuerzo físico realizado
por cada usuario, siendo especialmente útil para comparar perfiles con objetivos
de pérdida de grasa o ganancia muscular.
*/

-- Parte 6 Funciones ventana

-- Esfuerzo medio por nivel de usuario
SELECT
  s.id_sesion,
  u.nivel,
  s.esfuerzo,
  ROUND(AVG(s.esfuerzo) OVER (PARTITION BY u.nivel), 2) AS esfuerzo_medio_nivel
FROM sesion_entrenamiento s
JOIN usuario u ON s.id_usuario = u.id_usuario;
/*
Insight:
Esta comparación permite identificar sesiones que están por encima o por debajo
del esfuerzo medio esperado para cada nivel, ayudando a detectar posibles
desajustes en la intensidad de los entrenamientos.
*/

-- Calorías medias por rutina
SELECT
  s.id_sesion,
  r.nombre AS rutina,
  s.calorias_estimadas,
  ROUND(AVG(s.calorias_estimadas) OVER (PARTITION BY r.nombre), 2) AS calorias_medias_rutina
FROM sesion_entrenamiento s
JOIN rutina r ON s.id_rutina = r.id_rutina;
/*
Insight:
Permite evaluar la consistencia de las rutinas y detectar sesiones atípicas
con un gasto calórico significativamente superior o inferior al habitual.
*/

-- Ranking de sesiones según gasto calórico
SELECT
  s.id_sesion,
  s.id_usuario,
  s.calorias_estimadas,
  RANK() OVER (ORDER BY s.calorias_estimadas DESC) AS ranking_calorias
FROM sesion_entrenamiento s;
/*
Insight:
Las sesiones con mayor gasto calórico representan los entrenamientos más exigentes,
lo que puede ser útil para identificar rutinas intensivas o analizar el rendimiento
de usuarios avanzados.
*/

-- Parte 7: WIEW que resume el número de sesiones y métricas clave por usuario y rutina

CREATE OR REPLACE VIEW resumen_sesiones_usuario AS
SELECT
  u.id_usuario,
  u.nivel,
  u.objetivo,
  r.nombre AS rutina,
  COUNT(s.id_sesion) AS total_sesiones,
  ROUND(AVG(s.esfuerzo), 2) AS esfuerzo_medio,
  ROUND(AVG(s.calorias_estimadas), 2) AS calorias_medias
FROM sesion_entrenamiento s
JOIN usuario u ON s.id_usuario = u.id_usuario
JOIN rutina r ON s.id_rutina = r.id_rutina
GROUP BY
  u.id_usuario,
  u.nivel,
  u.objetivo,
  r.nombre;

SELECT * FROM resumen_sesiones_usuario;

/*
Insight:
Esta vista facilita el análisis agregado y permite identificar qué rutinas
funcionan mejor para cada nivel de usuario, siendo especialmente útil
para reporting y toma de decisiones de negocio.
*/

-- Parte 8: FUNCTION que devuelve el total de calorías consumidas por un usuario

DELIMITER $$

CREATE FUNCTION total_calorias_usuario(p_id_usuario INT)
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE total_calorias INT;

  SELECT SUM(calorias_estimadas)
  INTO total_calorias
  FROM sesion_entrenamiento
  WHERE id_usuario = p_id_usuario;

  RETURN total_calorias;
END$$

DELIMITER ;

SELECT
  id_usuario,
  total_calorias_usuario(id_usuario) AS calorias_totales
FROM usuario;

/*
Insight:
El uso de una función permite reutilizar esta lógica en múltiples consultas
y facilita el análisis individualizado del esfuerzo acumulado de cada usuario.
*/

-- Parte 9: Resumen

-- Análisis por nivel de usuario
SELECT
  nivel,
  COUNT(DISTINCT id_usuario) AS usuarios,
  SUM(total_sesiones) AS sesiones_totales
FROM resumen_sesiones_usuario
GROUP BY nivel;

/*
Insight:
Los usuarios intermedios concentran el mayor volumen de sesiones, lo que sugiere
una mayor adherencia y estabilidad en este perfil frente a principiantes
o usuarios avanzados.
*/