-- =========================================
-- Proyecto SQL - Base de Datos Fitness 01 SCHEMA
-- =========================================

-- Eliminamos la base de datos si existe (para poder ejecutar desde cero)
DROP DATABASE IF EXISTS fitness_db;

-- Creamos la base de datos
CREATE DATABASE fitness_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_spanish_ci;

-- Usamos la base de datos
USE fitness_db;

-- =========================================
-- DIM: USUARIO
-- Describe las características del usuario
-- =========================================

CREATE TABLE IF NOT EXISTS usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    
    edad INT NOT NULL,
    
    sexo ENUM('M', 'F', 'Otro') NOT NULL,
    
    nivel ENUM('principiante', 'intermedio', 'avanzado') NOT NULL,
    
    objetivo ENUM('perder_grasa', 'ganar_musculo', 'mantenimiento') NOT NULL,
    
    tiene_gimnasio BOOLEAN NOT NULL DEFAULT 0

) COMMENT='Información demográfica y nivel de entrenamiento. El uso de ENUMs garantiza coherencia en valores categóricos como nivel y objetivo.';

-- =========================================
-- DIM: RUTINA
-- Describe las rutinas de entrenamiento
-- =========================================

CREATE TABLE IF NOT EXISTS rutina (
    id_rutina INT AUTO_INCREMENT PRIMARY KEY,
    
    nombre VARCHAR(100) NOT NULL,
    
    nivel ENUM('principiante', 'intermedio', 'avanzado') NOT NULL,
    
    objetivo ENUM('perder_grasa', 'ganar_musculo', 'mantenimiento') NOT NULL,
    
    duracion_estimada INT NOT NULL COMMENT 'Duración estimada en minutos',
    
    con_gimnasio BOOLEAN NOT NULL DEFAULT 0

) COMMENT='Dimensión rutina: define el tipo de entrenamiento según nivel y objetivo';

-- =========================================
-- DIM: EJERCICIO
-- Catálogo de ejercicios de entrenamiento
-- =========================================

CREATE TABLE IF NOT EXISTS ejercicio (
    id_ejercicio INT AUTO_INCREMENT PRIMARY KEY,
    
    nombre VARCHAR(100) NOT NULL,
    
    tipo ENUM('fuerza', 'cardio', 'movilidad', 'estiramiento') NOT NULL,
    
    grupo_muscular VARCHAR(50) NOT NULL,
    
    requiere_gimnasio BOOLEAN NOT NULL DEFAULT 0,
    
    dificultad ENUM('baja', 'media', 'alta') NOT NULL

) COMMENT='Dimensión ejercicio: catálogo de ejercicios y sus características';

-- =========================================
-- DIM: CALENDARIO
-- Dimensión temporal para análisis por fechas
-- =========================================

CREATE TABLE IF NOT EXISTS calendario (
    id_fecha INT AUTO_INCREMENT PRIMARY KEY,
    
    fecha DATE NOT NULL UNIQUE,
    
    dia INT NOT NULL,
    
    mes INT NOT NULL,
    
    anio INT NOT NULL,
    
    dia_semana VARCHAR(15) NOT NULL

) COMMENT='Dimensión calendario: permite análisis temporal de las sesiones de entrenamiento';

-- =========================================
-- TABLA INTERMEDIA: RUTINA_EJERCICIO
-- Relación muchos a muchos entre rutinas y ejercicios
-- =========================================

CREATE TABLE IF NOT EXISTS rutina_ejercicio (
    id_rutina INT NOT NULL,
    id_ejercicio INT NOT NULL,
    
    series INT NOT NULL,
    repeticiones INT NOT NULL,
    descanso_seg INT NOT NULL COMMENT 'Descanso entre series en segundos',
    
    PRIMARY KEY (id_rutina, id_ejercicio),
    
    CONSTRAINT fk_re_rutina
        FOREIGN KEY (id_rutina)
        REFERENCES rutina(id_rutina)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
        
    CONSTRAINT fk_re_ejercicio
        FOREIGN KEY (id_ejercicio)
        REFERENCES ejercicio(id_ejercicio)
        ON DELETE CASCADE
        ON UPDATE CASCADE

) COMMENT='Tabla intermedia que define los ejercicios que componen cada rutina';

-- =========================================
-- TABLA FACT: SESION_ENTRENAMIENTO
-- Registra cada sesión realizada por un usuario
-- =========================================

CREATE TABLE IF NOT EXISTS sesion_entrenamiento (
    id_sesion INT AUTO_INCREMENT PRIMARY KEY,
    
    id_usuario INT NOT NULL,
    id_rutina INT NOT NULL,
    id_fecha INT NOT NULL,
    
    duracion_min INT NOT NULL COMMENT 'Duración real de la sesión en minutos',
    
    esfuerzo INT NOT NULL COMMENT 'Esfuerzo percibido del 1 al 10',
    
    calorias_estimadas INT NOT NULL,
    
    completada BOOLEAN NOT NULL DEFAULT 1,
    
    -- Claves foráneas
    CONSTRAINT fk_sesion_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES usuario(id_usuario)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
        
    CONSTRAINT fk_sesion_rutina
        FOREIGN KEY (id_rutina)
        REFERENCES rutina(id_rutina)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
        
    CONSTRAINT fk_sesion_fecha
        FOREIGN KEY (id_fecha)
        REFERENCES calendario(id_fecha)
        ON DELETE RESTRICT
        ON UPDATE CASCADE

) COMMENT='Cada fila representa una sesión de entrenamiento realizada por un usuario en una fecha concreta. Contiene métricas agregables para análisis (duración, esfuerzo, calorías).';

-- Índice para optimizar consultas frecuentes por usuario en la tabla de hechos
-- Este índice mejora el rendimiento de las consultas analíticas que agrupan o filtran sesiones por usuario
CREATE INDEX idx_sesion_usuario
ON sesion_entrenamiento(id_usuario);

