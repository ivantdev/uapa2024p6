-- Diseñe una base de datos relacional (de preferencia en MySQL o MariaDB) para la Facultad de Ingeniería, la cual permita dar respuesta a las siguientes preguntas:

-- Para ejecutar directamente el código SQL:
-- reemplazar ? con los datos reales

-- 1. ¿Cuántos estudiantes activos hay en la Facultad de Ingeniería?
SELECT COUNT(*) AS active_students_at_the_faculty_of_engineering
FROM StudentPlan StP
JOIN StudyPlan SP ON StP.id_plan = SP.id_plan
JOIN Faculty F ON SP.id_faculty = F.id_faculty
WHERE StP.is_active AND F.name = "Facultad de Ingeniería"; -- asegurese de coincidir con el registro en la db

-- 2. ¿Cuáles son los cursos que cursaron en un periodo dado?
-- asumiendo que un curso es considerado cursado si cuenta con mínimo un estudiante inscrito.
SELECT C.*
FROM Enrollment E
JOIN CourseOffer CO ON CO.id_course_offer = E.id_course_offer
JOIN Course C ON CO.id_course = C.id_course
JOIN AcademicPeriod P ON CO.id_period = P.id_period
WHERE P.year = ? AND P.semester = ?; -- reemplazar `?` para hacer una consutla directa con SQL

-- 3. ¿Cuál es el promedio de las calificaciones obtenidas en un curso los últimos 5 años?
-- Se usa `... - 4` porque el rango quedaría en 6 años, incluyendo el acutal.
SELECT C.name AS course_name, AVG(SG.grade) AS average_grade
FROM StudentGrade SG
JOIN Enrollment E ON E.id_enrollment = SG.id_enrollment
JOIN CourseOffer CO ON CO.id_course_offer = E.id_course_offer
JOIN Course C ON C.id_course = CO.id_course
JOIN AcademicPeriod P ON P.id_period = CO.id_period
WHERE P.year BETWEEN YEAR(CURRENT_DATE()) - 4 AND YEAR(CURRENT_DATE())
    AND C.code = ?; -- reemplazar `?` para hacer una consutla directa con SQL

-- 4. ¿Cuáles son las asignaturas de mayor reprobación?
SELECT C.code AS course_code, C.name AS course_name, COUNT(*) as total_failures
FROM StudentGrade SG
JOIN Enrollment E ON E.id_enrollment = SG.id_enrollment
JOIN CourseOffer CO ON CO.id_course_offer = E.id_course_offer
JOIN Course C ON C.id_course = CO.id_course
WHERE SG.grade_status = "FAILED"
GROUP BY course_code, course_name
ORDER BY total_failures DESC;

-- haciendolo por porcentaje:
SELECT 
    C.code AS course_code,
    C.name AS course_name,
    SUM(SG.grade_status = 'FAILED') AS total_failures,
    COUNT(*) AS total_enrollments,
    ROUND(SUM(SG.grade_status = 'FAILED') / COUNT(*) * 100, 2) AS failure_rate
FROM StudentGrade SG
JOIN Enrollment E ON E.id_enrollment = SG.id_enrollment
JOIN CourseOffer CO ON CO.id_course_offer = E.id_course_offer
JOIN Course C ON C.id_course = CO.id_course
GROUP BY course_code, course_name
ORDER BY failure_rate DESC;

-- 5. ¿Cuál sería el procedimiento para ingresar los estudiantes de primera matrícula o de traslado?
-- 5.1 Registrar al estudiante:
INSERT INTO Student(first_name, last_name, type_document, document_number, username, phone, address)
VALUES(?, ?, ?, ?, ?, ?, ?); -- reemplazar `?` para hacer una consutla directa con SQL

-- 5.2a Registrar plan de estudios de primera matrícula
INSERT INTO StudentPlan(id_student, id_plan, admission_type, admission_date)
VALUES (?, ?, "NEW", ?); -- reemplazar `?` para hacer una consutla directa con SQL

-- 5.2b0 Traslado de un estudiante. Si su plan de estudios anterior esta activo, este debe ser bloqueado.
--       Considerando que cada sede (campus) tiene su propia autonomía, considero que la mejor forma es
--       blquear cada plan de estudios manualmente, en lugar de hacer todo en una sentecia SQL con Triggers.

-- 5.2b1 Obtener el plan actual activo (normal o doble titulación, según el caso)
SELECT id_student_plan
FROM StudentPlan
WHERE id_student = ? -- reemplazar `?` para hacer una consutla directa con SQL
    AND is_active = TRUE
    AND is_double_degree = FALSE;

-- 5.2b2 Bloquear el plan de estudio y registrar la razón de bloqueo
UPDATE StudentPlan SET is_active = FALSE WHERE id_student_plan = ?; -- reemplazar `?` para hacer una consutla directa con SQL

INSERT INTO StudentPlanBlock(id_student_plan, id_block_plan_reason, notes)
VALUES (?, ?, 'Bloqueo por traslado de sede'); -- reemplazar `?` para hacer una consutla directa con SQL

-- 5.2b3 Registrar el plan de estudio al que se traslada el estudiante
INSERT INTO StudentPlan(id_student, id_plan, admission_type, admission_date, transfer_date)
VALUES (?, ?, 'TRANSFER', ?, ?); -- reemplazar `?` para hacer una consutla directa con SQL

-- opcional: registrar el log del traslado
INSERT INTO StudentTransferLog(id_student, from_plan, to_plan, transfer_date, notes)
VALUES (?, ?, ?, ?, 'Traslado aprobado por consejo académica'); -- reemplazar `?` para hacer una consutla directa con SQL

-- 5.2b4 Homologación de cursos

-- Recuperar los cursos aprobados por el estudiante
SELECT E.id_enrollment, C.name AS course_name, SG.grade, SG.grade_status
FROM Enrollment E
JOIN CourseOffer CO ON e.id_course_offer = CO.id_course_offer
JOIN Course C ON CO.id_course = c.id_course
JOIN StudentGrade SG ON SG.id_enrollment = e.id_enrollment
WHERE e.id_student = ? -- reemplazar `?` para hacer una consutla directa con SQL
    AND SG.grade_status = 'PASSED';

-- Por cada curos aprobado hacer la respectiva homologación (si es posible)
INSERT INTO CourseHomologation(
    id_student,
    id_enrollment,        -- del curso anterior
    id_course_target,     -- del curso en el nuevo plan
    id_old_plan,
    id_new_plan,
    homologation_date,
    notes
) VALUES (?, ?, ?, ?, ?, CURRENT_DATE, 'Homologación validada por el consejo académico'); -- reemplazar `?` para hacer una consutla directa con SQL