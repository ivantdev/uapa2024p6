CREATE TABLE Faculty (
    id_faculty INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
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

CREATE TABLE Period (
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
    FOREIGN KEY (id_department) REFERENCES Department(id_department)
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
    FOREIGN KEY (id_period) REFERENCES Period(id_period)
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

CREATE TABLE Student (
    id_student INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    type_document ENUM('CC', 'CE', 'PASSPORT') NOT NULL,
    student_status ENUM('ACTIVE', 'INACTIVE') NOT NULL,
    document_number VARCHAR(50) NOT NULL,
    username VARCHAR(50) NOT NULL,
    phone VARCHAR(50),
    address VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE (document_number),
    UNIQUE (username)
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
