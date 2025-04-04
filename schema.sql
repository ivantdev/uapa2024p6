CREATE TABLE Campus (
    id_campus INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    location VARCHAR(100),
    UNIQUE (name)
);

CREATE TABLE Faculty (
    id_faculty INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    id_campus INT NOT NULL,
    FOREIGN KEY (id_campus) REFERENCES Campus(id_campus)
);

CREATE TABLE Department (
    id_department INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    id_faculty INT NOT NULL,
    FOREIGN KEY (id_faculty) REFERENCES Faculty(id_faculty)
);

CREATE TABLE Teacher (
    id_teacher INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    type_document ENUM('CC', 'CE', 'PASSPORT') NOT NULL,
    document_number VARCHAR(50) NOT NULL,
    username VARCHAR(50) NOT NULL,
    phone VARCHAR(50),
    address VARCHAR(50) NOT NULL,
    teacher_status ENUM('ACTIVE', 'INACTIVE') NOT NULL,
    id_department INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_department) REFERENCES Department(id_department),
    UNIQUE (document_number),
    UNIQUE (username)
);

CREATE TABLE AcademicPeriod (
    id_period INT AUTO_INCREMENT PRIMARY KEY,
    year INT NOT NULL,
    semester ENUM('1', '2') NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE (year, semester)
);

CREATE TABLE Course (
    id_course INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    code VARCHAR(50) NOT NULL,
    description TEXT NOT NULL,
    credits INT NOT NULL,
    id_department INT NOT NULL,
    FOREIGN KEY (id_department) REFERENCES Department(id_department),
    UNIQUE (code)
);

CREATE TABLE CourseOffer (
    id_course_offer INT AUTO_INCREMENT PRIMARY KEY,
    id_course INT NOT NULL,
    id_teacher INT NOT NULL,
    id_period INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_course) REFERENCES Course(id_course),
    FOREIGN KEY (id_teacher) REFERENCES Teacher(id_teacher),
    FOREIGN KEY (id_period) REFERENCES AcademicPeriod(id_period)
    -- UNIQUE (id_course, id_teacher, id_period) -- el docente puede dictar un mismo curso en el mismo periodo más de una vez? por ahora si
);

CREATE TABLE CourseSchedule (
    id_schedule INT AUTO_INCREMENT PRIMARY KEY,
    id_course_offer INT NOT NULL,
    day_of_week ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday') NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    classroom VARCHAR(50) NOT NULL,
    building VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_course_offer) REFERENCES CourseOffer(id_course_offer)
);

CREATE TABLE StudyPlan (
    id_plan INT AUTO_INCREMENT PRIMARY KEY,
    id_campus INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    code VARCHAR(50) NOT NULL UNIQUE,
    total_credits INT DEFAULT 0 NOT NULL,
    id_faculty INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_faculty) REFERENCES Faculty(id_faculty),
    FOREIGN KEY (id_campus) REFERENCES Campus(id_campus)
);

CREATE TABLE StudyPlanCourse (
    id_plan_course INT AUTO_INCREMENT PRIMARY KEY,
    id_plan INT NOT NULL,
    id_course INT NOT NULL,
    semester TINYINT,
    course_type ENUM('MANDATORY', 'ELECTIVE') NOT NULL DEFAULT 'MANDATORY',
    FOREIGN KEY (id_plan) REFERENCES StudyPlan(id_plan),
    FOREIGN KEY (id_course) REFERENCES Course(id_course),
    UNIQUE (id_plan, id_course)
);

CREATE TABLE BlockPlanReason (
    id_block_plan_reason INT AUTO_INCREMENT PRIMARY KEY,
    reason_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE Student (
    id_student INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    type_document ENUM('CC', 'CE', 'PASSPORT') NOT NULL,
    document_number VARCHAR(50) NOT NULL,
    username VARCHAR(50) NOT NULL,
    phone VARCHAR(50),
    address VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE (document_number),
    UNIQUE (username)
);

CREATE TABLE StudentPlan (
    id_student_plan INT AUTO_INCREMENT PRIMARY KEY,
    id_student INT NOT NULL,
    id_plan INT NOT NULL,
    total_used_credits INT DEFAULT 0 NOT NULL,
    total_available_credits INT DEFAULT 0 NOT NULL,
    admission_type ENUM('NEW', 'TRANSFER') NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    is_double_degree BOOLEAN NOT NULL DEFAULT FALSE,
    admission_date DATE NOT NULL,
    transfer_date DATE NULL,
    FOREIGN KEY (id_student) REFERENCES Student(id_student),
    FOREIGN KEY (id_plan) REFERENCES StudyPlan(id_plan),
    CHECK (
        (admission_type = 'NEW' AND transfer_date IS NULL) OR
        (admission_type = 'TRANSFER' AND transfer_date IS NOT NULL)
    )
);

CREATE TABLE StudentTransferLog (
    id_transfer INT AUTO_INCREMENT PRIMARY KEY,
    id_student INT NOT NULL,
    from_plan INT NOT NULL,
    to_plan INT NOT NULL,
    transfer_date DATE NOT NULL DEFAULT CURRENT_DATE,
    notes TEXT,
    FOREIGN KEY (id_student) REFERENCES Student(id_student),
    FOREIGN KEY (from_plan) REFERENCES StudyPlan(id_plan),
    FOREIGN KEY (to_plan) REFERENCES StudyPlan(id_plan)
);

CREATE TABLE StudentPlanBlock (
    id_block INT AUTO_INCREMENT PRIMARY KEY,
    id_student_plan INT NOT NULL,
    id_block_plan_reason INT NOT NULL,
    block_date DATE NOT NULL DEFAULT CURRENT_DATE,
    unblock_date DATE,
    is_active BOOLEAN DEFAULT TRUE,
    notes TEXT,
    FOREIGN KEY (id_student_plan) REFERENCES StudentPlan(id_student_plan),
    FOREIGN KEY (id_block_plan_reason) REFERENCES BlockPlanReason(id_block_plan_reason)
);

CREATE TABLE Enrollment (
    id_enrollment INT AUTO_INCREMENT PRIMARY KEY,
    id_student INT NOT NULL,
    id_course_offer INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_student) REFERENCES Student(id_student),
    FOREIGN KEY (id_course_offer) REFERENCES CourseOffer(id_course_offer),
    UNIQUE (id_student, id_course_offer)
);

CREATE TABLE StudentGrade (
    id_grade INT AUTO_INCREMENT PRIMARY KEY,
    id_enrollment INT NOT NULL,
    grade DECIMAL(3, 2) NOT NULL CHECK (grade >= 0 AND grade <= 5), -- por restricción de MariaDB se usa (3, 2) en lugar de (1, 2); DECIMAL(M, D) M > D
    grade_status ENUM('PASSED', 'FAILED') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_enrollment) REFERENCES Enrollment(id_enrollment),
    UNIQUE (id_enrollment)
);

CREATE TABLE TeacherEvaluation (
    id_evaluation INT AUTO_INCREMENT PRIMARY KEY,
    id_enrollment INT NOT NULL,
    score DECIMAL(3, 2) NOT NULL CHECK (score >= 0 AND score <= 5),
    feedback TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_enrollment) REFERENCES Enrollment(id_enrollment),
    UNIQUE (id_enrollment)
);

CREATE TABLE CourseHomologation (
    id_homologation INT AUTO_INCREMENT PRIMARY KEY,
    id_student INT NOT NULL,
    id_enrollment INT NOT NULL,
    id_course_target INT NOT NULL,
    id_old_plan INT NOT NULL,
    id_new_plan INT NOT NULL,
    homologation_date DATE NOT NULL DEFAULT CURRENT_DATE,
    notes TEXT,
    FOREIGN KEY (id_student) REFERENCES Student(id_student),
    FOREIGN KEY (id_enrollment) REFERENCES Enrollment(id_enrollment),
    FOREIGN KEY (id_course_target) REFERENCES Course(id_course),
    FOREIGN KEY (id_old_plan) REFERENCES StudyPlan(id_plan),
    FOREIGN KEY (id_new_plan) REFERENCES StudyPlan(id_plan)
);

-- Verificar que exista solo un único plan de estudios activo normal y uno como doble titulación
-- al momento de realizar una inserción
DELIMITER $$

CREATE TRIGGER check_unique_active_plans
BEFORE INSERT ON StudentPlan
FOR EACH ROW
BEGIN
    DECLARE active_plans_count INT;

    SELECT COUNT(*) INTO active_plans_count
    FROM StudentPlan
    WHERE id_student = NEW.id_student
      AND is_active = TRUE
      AND is_double_degree = NEW.is_double_degree;

    IF active_plans_count >= 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El estudiante ya tiene un plan activo de este tipo (normal o doble titulación).';
    END IF;
END$$

DELIMITER ;

-- Verificar que exista solo un único plan de estudios activo normal y uno como doble titulación
-- al momento de hacer una actualización en los planes de estudio de los estudiantes
DELIMITER $$

CREATE TRIGGER check_unique_active_plans_update
BEFORE UPDATE ON StudentPlan
FOR EACH ROW
BEGIN
    DECLARE active_plans_count INT;

    IF NEW.is_active = TRUE THEN
        SELECT COUNT(*) INTO active_plans_count
        FROM StudentPlan
        WHERE id_student = NEW.id_student
          AND is_active = TRUE
          AND is_double_degree = NEW.is_double_degree
          AND id_student_plan != NEW.id_student_plan;

        IF active_plans_count >= 1 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El estudiante ya tiene un plan activo de este tipo (normal o doble titulación).';
        END IF;
    END IF;
END$$

DELIMITER ;

-- Trigger para asignar los créditos disponibles del plan de estudios del estudiante, según StudyPlan
DELIMITER $$

CREATE TRIGGER set_available_credits_before_insert
BEFORE INSERT ON StudentPlan
FOR EACH ROW
BEGIN
    DECLARE plan_credits INT;

    SELECT total_credits INTO plan_credits
    FROM StudyPlan
    WHERE id_plan = NEW.id_plan;

    SET NEW.total_available_credits = plan_credits;
END$$

DELIMITER ;
