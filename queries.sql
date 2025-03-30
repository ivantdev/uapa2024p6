-- 1. ¿Cuántos docentes activos hay en la Facultad de Ingeniería?

SELECT COUNT(*) AS active_teachers
FROM Teacher T
JOIN Department D ON T.id_department = D.id_department
JOIN Faculty F ON D.id_faculty = F.id_faculty
WHERE T.teacher_status = 'ACTIVE' AND F.name = 'Facultad de Ingeniería';



-- 2. ¿Cuáles son los cursos que se dictaron en un periodo dado?

SELECT C.code AS course_code, C.name AS course_name, P.year, P.semester, T.first_name, T.last_name
FROM CourseOffer AS CO
JOIN Course AS C ON CO.id_course = C.id_course
JOIN Period AS P ON CO.id_period = P.id_period
JOIN Teacher AS T ON CO.id_teacher = T.id_teacher
WHERE P.year = 2024 AND P.semester = '1'; -- Valores brutos (año y semestre)



-- 3. ¿Cuál es la lista de estudiantes para el periodo actual?

SELECT S.first_name, S.last_name, S.type_document, S.document_number, S.username, S.phone, S.address
FROM Student S
JOIN Enrollment E ON S.id_student = E.id_student
JOIN CourseOffer CO ON E.id_course_offer = CO.id_course_offer
JOIN Period P ON CO.id_period = P.id_period
WHERE P.year = YEAR(CURRENT_DATE())
    AND P.semester = CASE 
        WHEN MONTH(CURDATE()) BETWEEN 1 AND 6 THEN '1' 
        ELSE '2' 
    END; -- asumiendo semesetres normales



-- 4. ¿Cuál es el promedio de las calificaciones obtenidas en un curso los últimos 5 años?

SELECT C.name AS course_name, AVG(SG.grade) AS average_grade
FROM StudentGrade SG
JOIN Enrollment E ON SG.id_enrollment = E.id_enrollment
JOIN CourseOffer CO ON E.id_course_offer = CO.id_course_offer
JOIN Course C ON CO.id_course = C.id_course
JOIN Period P ON CO.id_period = P.id_period
WHERE P.year BETWEEN YEAR(CURRENT_DATE()) - 5 AND YEAR(CURRENT_DATE())
    AND C.name = 'Cálculo Diferencial'; -- Valores burtos (nombre del curso)



-- 5. ¿Cuál sería el procedimiento para crear un nuevo curso y asignarle un docente?

INSERT INTO Course (name, code, description, credits, id_department)
VALUES ('Cálculo Diferencial', '10000005', 'Curso de cálculo diferencial', 4, 1); -- Valores brutos

INSERT INTO CourseOffer (id_course, id_teacher, id_period)
VALUES (2, 1, 1); -- Valores brutos