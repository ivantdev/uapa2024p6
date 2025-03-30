-- Poblar la base de datos con datos de prueba para la Universidad Nacional de Colombia

-- 1. Facultades
INSERT INTO Faculty (name) VALUES
('Facultad de Ciencias'),
('Facultad de Ingeniería'),
('Facultad de Medicina'),
('Facultad de Ciencias Humanas'),
('Facultad de Artes');

-- 2. Departamentos
INSERT INTO Department (name, id_faculty) VALUES
('Departamento de Biología', 1),
('Departamento de Física', 1),
('Departamento de Matemáticas', 1),
('Departamento de Ingeniería de Sistemas', 2),
('Departamento de Ingeniería Civil', 2),
('Departamento de Medicina Interna', 3),
('Departamento de Psicología', 4),
('Departamento de Filosofía', 4),
('Departamento de Música', 5),
('Departamento de Artes Plásticas', 5);

-- 3. Docentes
INSERT INTO Teacher (first_name, last_name, type_document, document_number, username, address, teacher_status, id_department) VALUES
('Ana', 'García', 'CC', '1234567890', 'agarcia', 'Calle 1 # 2-3', 'ACTIVE', 1),
('Carlos', 'Martínez', 'CC', '2345678901', 'cmartinez', 'Calle 4 # 5-6', 'ACTIVE', 4),
('Laura', 'López', 'CC', '3456789012', 'llopez', 'Calle 7 # 8-9', 'ACTIVE', 7),
('Miguel', 'Rodríguez', 'CC', '4567890123', 'mrodriguez', 'Calle 10 # 11-12', 'ACTIVE', 9),
('Sofía', 'Fernández', 'CC', '5678901234', 'sfernandez', 'Calle 13 # 14-15', 'INACTIVE', 3);

-- 4. Periodos Académicos
INSERT INTO Period (year, semester, start_date, end_date) VALUES
(2024, '1', '2024-01-15', '2024-06-15'),
(2024, '2', '2024-07-15', '2024-12-15'),
(2025, '1', '2025-01-15', '2025-06-15'),
(2025, '2', '2025-07-15', '2025-12-15');

-- 5. Cursos
INSERT INTO Course (name, code, description, credits, id_department) VALUES
('Biología General', 'BIO101', 'Introducción a los principios básicos de la biología.', 3, 1),
('Programación Básica', 'SIS101', 'Fundamentos de programación en lenguajes de alto nivel.', 4, 4),
('Psicología del Desarrollo', 'PSI201', 'Estudio del desarrollo humano a lo largo de la vida.', 3, 7),
('Historia del Arte', 'ART301', 'Análisis de las principales corrientes artísticas.', 3, 10),
('Física I', 'FIS101', 'Estudio de los principios fundamentales de la física.', 4, 2);

-- 6. Ofertas de Cursos
INSERT INTO CourseOffer (id_course, id_teacher, id_period) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 4),
(5, 5, 4);

-- 7. Horarios de Cursos
INSERT INTO CourseSchedule (id_course_offer, day_of_week, start_time, end_time, classroom, building) VALUES
(1, 'Monday', '08:00:00', '10:00:00', '101', 'Edificio A'),
(2, 'Tuesday', '10:00:00', '12:00:00', '202', 'Edificio B'),
(3, 'Wednesday', '14:00:00', '16:00:00', '303', 'Edificio C'),
(4, 'Thursday', '16:00:00', '18:00:00', '404', 'Edificio D'),
(5, 'Friday', '08:00:00', '10:00:00', '505', 'Edificio E');

-- 8. Estudiantes
INSERT INTO Student (first_name, last_name, type_document, student_status, document_number, username, address) VALUES
('Juan', 'Pérez', 'CC', 'ACTIVE', '6789012345', 'jperez', 'Calle 16 # 17-18'),
('María', 'Gómez', 'CC', 'ACTIVE', '7890123456', 'mgomez', 'Calle 19 # 20-21'),
('Luis', 'Torres', 'CC', 'ACTIVE', '8901234567', 'ltorres', 'Calle 22 # 23-24'),
('Elena', 'Morales', 'CC', 'ACTIVE', '9012345678', 'emorales', 'Calle 25 # 26-27'),
('Diego', 'Hernández', 'CC', 'ACTIVE', '0123456789', 'dhernandez', 'Calle 28 # 29-30');

-- 9. Inscripciones
INSERT INTO Enrollment (id_student, id_course_offer) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

-- 10. Calificaciones de Estudiantes
INSERT INTO StudentGrade (id_enrollment, grade) VALUES
(1, 4.5),
(2, 3.8),
(3, 4.2),
(4, 3.9),
(5, 4.7);

-- 11. Evaluaciones de Docentes
INSERT INTO TeacherEvaluation (id_enrollment, score, feedback) VALUES
(1, 4.8, 'Excelente docente, explica claramente los conceptos.'),
(2, 4.0, 'Buena metodología de enseñanza.'),
(3, 4.5, 'Muy atento a las dudas de los estudiantes.'),
(4, 3.9, 'Las clases podrían ser más dinámicas.'),
(5, 4.7, 'Excelente manejo del tema.');
