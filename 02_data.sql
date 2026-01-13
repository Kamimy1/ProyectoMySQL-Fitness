-- =========================================
-- Proyecto SQL - Base de Datos Fitness 02 DATA
-- =========================================

USE fitness_db;

/*
Este bloque permite reiniciar la base de datos para pruebas y recargas de datos.
Se utiliza DELETE en lugar de TRUNCATE para respetar las claves foráneas.
*/

/*DELETE FROM sesion_entrenamiento;
DELETE FROM rutina_ejercicio;
DELETE FROM ejercicio;
DELETE FROM rutina;
DELETE FROM calendario;
DELETE FROM usuario;


ALTER TABLE sesion_entrenamiento AUTO_INCREMENT = 1;
ALTER TABLE rutina_ejercicio AUTO_INCREMENT = 1; -- (si no tuviera PK compuesta)
ALTER TABLE ejercicio AUTO_INCREMENT = 1;
ALTER TABLE rutina AUTO_INCREMENT = 1;
ALTER TABLE calendario AUTO_INCREMENT = 1;
ALTER TABLE usuario AUTO_INCREMENT = 1;*/


-- =========================================
-- CARGA DE DATOS: DIM_USUARIO
-- =========================================

INSERT INTO usuario (edad, sexo, nivel, objetivo, tiene_gimnasio) VALUES
(22, 'F', 'principiante', 'perder_grasa', 0),
(28, 'M', 'principiante', 'ganar_musculo', 1),
(35, 'F', 'intermedio', 'mantenimiento', 0),
(31, 'M', 'intermedio', 'perder_grasa', 1),
(40, 'F', 'avanzado', 'ganar_musculo', 1),
(26, 'Otro', 'avanzado', 'mantenimiento', 0),
(24, 'F', 'principiante', 'mantenimiento', 0),
(33, 'M', 'intermedio', 'ganar_musculo', 1),
(38, 'F', 'intermedio', 'perder_grasa', 0),
(45, 'M', 'avanzado', 'ganar_musculo', 1);

SELECT * FROM usuario;

-- =========================================
-- CARGA DE DATOS: DIM_RUTINA
-- =========================================

INSERT INTO rutina (nombre, nivel, objetivo, duracion_estimada, con_gimnasio) VALUES
('Full Body Principiante', 'principiante', 'mantenimiento', 45, 0),
('Fuerza Tren Superior', 'intermedio', 'ganar_musculo', 60, 1),
('Cardio HIIT', 'intermedio', 'perder_grasa', 30, 0),
('Fuerza Avanzada', 'avanzado', 'ganar_musculo', 75, 1),
('Movilidad y Recuperación', 'principiante', 'mantenimiento', 30, 0);

SELECT * FROM rutina;

-- =========================================
-- CARGA DE DATOS: DIM_EJERCICIO
-- =========================================

INSERT INTO ejercicio (nombre, tipo, grupo_muscular, requiere_gimnasio, dificultad) VALUES
('Sentadillas', 'fuerza', 'piernas', 0, 'media'),
('Flexiones', 'fuerza', 'pecho', 0, 'media'),
('Press banca', 'fuerza', 'pecho', 1, 'alta'),
('Remo con barra', 'fuerza', 'espalda', 1, 'alta'),
('Plancha', 'movilidad', 'core', 0, 'baja'),
('Burpees', 'cardio', 'cuerpo completo', 0, 'alta'),
('Bicicleta estática', 'cardio', 'piernas', 1, 'media'),
('Zancadas', 'fuerza', 'piernas', 0, 'media'),
('Estiramientos generales', 'estiramiento', 'cuerpo completo', 0, 'baja');

SELECT * FROM ejercicio;

-- =========================================
-- CARGA DE DATOS: DIM_CALENDARIO
-- =========================================

INSERT INTO calendario (fecha, dia, mes, anio, dia_semana) VALUES
('2026-01-01', 1, 1, 2026, 'Jueves'),
('2026-01-02', 2, 1, 2026, 'Viernes'),
('2026-01-03', 3, 1, 2026, 'Sábado'),
('2026-01-04', 4, 1, 2026, 'Domingo'),
('2026-01-05', 5, 1, 2026, 'Lunes'),
('2026-01-06', 6, 1, 2026, 'Martes'),
('2026-01-07', 7, 1, 2026, 'Miércoles'),
('2026-01-08', 8, 1, 2026, 'Jueves'),
('2026-01-09', 9, 1, 2026, 'Viernes'),
('2026-01-10', 10, 1, 2026, 'Sábado'),
('2026-01-11', 11, 1, 2026, 'Domingo'),
('2026-01-12', 12, 1, 2026, 'Lunes'),
('2026-01-13', 13, 1, 2026, 'Martes'),
('2026-01-14', 14, 1, 2026, 'Miércoles'),
('2026-01-15', 15, 1, 2026, 'Jueves');

SELECT * FROM calendario;

-- =========================================
-- CARGA DE DATOS: DIM_RUTINA_EJERCICIO
-- =========================================

INSERT INTO rutina_ejercicio (id_rutina, id_ejercicio, series, repeticiones, descanso_seg) VALUES
-- Full Body Principiante
(1, 1, 3, 12, 60),
(1, 2, 3, 10, 60),
(1, 5, 3, 30, 45),

-- Fuerza Tren Superior
(2, 3, 4, 8, 90),
(2, 4, 4, 8, 90),
(2, 2, 3, 12, 60),

-- Cardio HIIT
(3, 6, 4, 15, 30),
(3, 5, 3, 30, 30),

-- Fuerza Avanzada
(4, 3, 5, 6, 120),
(4, 4, 5, 6, 120),
(4, 8, 4, 10, 90),

-- Movilidad y Recuperación
(5, 9, 3, 20, 30),
(5, 5, 3, 30, 30);

SELECT * FROM rutina_ejercicio;

-- =========================================
-- CARGA DE DATOS: FACT_SESION_ENTRENAMIENTO
-- =========================================

INSERT INTO sesion_entrenamiento
(id_usuario, id_rutina, id_fecha, duracion_min, esfuerzo, calorias_estimadas, completada)
VALUES
-- Usuario 1 (principiante, sin gimnasio)
(1, 1, 1, 45, 6, 250, 1),
(1, 3, 3, 30, 7, 220, 1),
(1, 1, 5, 40, 5, 210, 0),

-- Usuario 2 (principiante, con gimnasio)
(2, 1, 2, 45, 6, 260, 1),
(2, 2, 4, 60, 8, 420, 1),
(2, 2, 6, 55, 7, 400, 1),

-- Usuario 3 (intermedio, sin gimnasio)
(3, 3, 3, 30, 7, 230, 1),
(3, 1, 5, 45, 6, 260, 1),
(3, 3, 7, 35, 8, 250, 1),

-- Usuario 4 (intermedio, con gimnasio)
(4, 2, 2, 60, 8, 430, 1),
(4, 2, 4, 65, 9, 450, 1),
(4, 3, 6, 30, 7, 240, 0),

-- Usuario 5 (avanzado, con gimnasio)
(5, 4, 2, 75, 9, 550, 1),
(5, 4, 5, 80, 10, 580, 1),
(5, 2, 7, 60, 8, 420, 1),

-- Usuario 6 (avanzado, sin gimnasio)
(6, 3, 1, 35, 8, 260, 1),
(6, 1, 4, 45, 6, 250, 1),
(6, 5, 6, 30, 4, 180, 1),

-- Usuario 7 (principiante)
(7, 1, 11, 45, 6, 240, 1),
(7, 5, 12, 30, 4, 190, 1),
(7, 3, 13, 30, 7, 220, 0),

-- Usuario 8 (intermedio con gimnasio)
(8, 2, 11, 60, 8, 420, 1),
(8, 2, 12, 65, 9, 450, 1),
(8, 3, 13, 30, 7, 240, 1),

-- Usuario 9 (intermedio sin gimnasio)
(9, 3, 11, 35, 7, 230, 1),
(9, 1, 12, 45, 6, 260, 1),

-- Usuario 10 (avanzado con gimnasio)
(10, 4, 11, 75, 9, 560, 1),
(10, 4, 12, 80, 10, 600, 1);

SELECT * FROM sesion_entrenamiento;
