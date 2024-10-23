-- 创建数据库和使用
CREATE DATABASE IF NOT EXISTS UESTC_ST;
USE UESTC_ST;

-- 创建学生表
CREATE TABLE IF NOT EXISTS students (
    StudentID INT PRIMARY KEY,
    StudentName VARCHAR(20) NOT NULL,
    StudentTel VARCHAR(11) NOT NULL,
    Major VARCHAR(50)
);

-- 插入学生数据
INSERT INTO students (StudentID, StudentName, StudentTel, Major) VALUES
    (1, 'zhangsan', '6483906', 'Software'),
    (2, 'lisi', '6382973', 'Software'),
    (3, 'wangwu', '9372638', 'Math'),
    (4, 'wangyan', '3729478', 'Medicine'),
    (5, 'liyu', '7384901', 'Math'),
    (6, 'jiangli', '8293058', 'Math'),
    (7, 'xieyan', '5389027', 'Medicine')

-- 创建教师表
CREATE TABLE IF NOT EXISTS teachers (
    TeacherID INT PRIMARY KEY,
    TeacherName VARCHAR(20) NOT NULL,
    TeacherTel VARCHAR(11) NOT NULL,
    WorkingDate DATE NOT NULL,
    TeacherDepartment VARCHAR(60) NOT NULL
);

-- 插入教师数据
INSERT INTO teachers (TeacherID, TeacherName, TeacherTel, WorkingDate, TeacherDepartment) VALUES
    (1, 'huke', '9273840', '2002-10-06', 'Department1'),
    (2, 'gaoxi', '73992790', '2010-03-08', 'Department3'),
    (3, 'xieni', '7159207', '1998-05-09', 'Department2'),
    (4, 'wangyan', '9209567', '2009-09-01', 'Department2')

-- 创建授课表
CREATE TABLE IF NOT EXISTS teaching (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(20) NOT NULL,
    TeacherID INT NOT NULL,
    CourseType CHAR(2) NOT NULL CHECK (CourseType IN ('上午', '下午')),
    BeginDate DATE NOT NULL DEFAULT '2024-01-01',
    EndDate DATE NOT NULL DEFAULT '2024-01-01',
    Student_Number INT NOT NULL CHECK (Student_Number >= 0)
);

-- 插入授课数据
INSERT INTO teaching (CourseID, CourseName, TeacherID, CourseType, BeginDate, EndDate, Student_Number) VALUES
    ('0001', 'Software Engineering', 3, '下午', '2023-12-03', '2024-12-05', 169),
    ('0002', 'Math', 1, '上午', '2022-03-01', '2024-03-01', 289),
    ('0003', 'Medicine', 4, '上午', '2023-06-04', '2024-04-06', 109),
    ('0004', 'Art', 2, '上午', '2022-03-01', '2024-03-01', 301)

-- 创建课程表
CREATE TABLE IF NOT EXISTS course (
    RecordID INT PRIMARY KEY,
    StudentID1 INT NOT NULL,
    CourseID1 INT NOT NULL,
    EnrollmentDate DATE NOT NULL DEFAULT '2024-01-01',
    EnrollmentType CHAR(2) NOT NULL CHECK (EnrollmentType IN ('成功', '失败')),
    FOREIGN KEY (StudentID1) REFERENCES students(StudentID),
    FOREIGN KEY (CourseID1) REFERENCES teaching(CourseID)
);

-- 插入课程数据
INSERT INTO course (RecordID, StudentID1, CourseID1, EnrollmentDate, EnrollmentType) VALUES
    (1001, 1, '0001', '2023-02-06', '成功'),
    (1002, 1, '0002', '2023-02-05', '成功'),
    (1009, 3, '0002', '2024-01-01', '成功'),
    (1003, 2, '0001', '2023-03-01', '失败'),
    (1004, 2, '0002', '2023-03-01', '成功'),
    (1005, 2, '0003', '2023-03-01', '成功'),
    (1006, 3, '0004', '2024-01-01', '成功'),
    (1007, 3, '0001', '2024-01-01', '失败'),
    (1008, 4, '0003', '2023-12-05', '成功'),
    (1010, 1, '0004', '2023-02-06', '成功'),
    (1011, 1, '0003', '2023-02-05', '成功'),
    (1012, 3, '0003', '2024-01-01', '成功'),
    (1013, 2, '0004', '2023-03-01', '失败')


-- 查询选修上午课程成功的学生信息
SELECT StudentID, StudentName, StudentTel 
FROM course
JOIN teaching ON course.CourseID1 = teaching.CourseID
JOIN students ON course.StudentID1 = students.StudentID
WHERE CourseType = '上午' AND EnrollmentType = '成功'
GROUP BY StudentID
HAVING COUNT(course.CourseID1) > 2;

-- 统计教师授课的学生人数
SELECT TeacherName, SUM(Student_Number) AS TotalStudents 
FROM teachers 
JOIN teaching ON teachers.TeacherID = teaching.TeacherID
WHERE CourseType = '上午' AND BeginDate >= '2023-01-01'
GROUP BY TeacherName;

-- 查询下午课程信息
SELECT * FROM teaching
WHERE BeginDate > '2023-01-01' AND CourseType = '下午'
ORDER BY Student_Number DESC;

-- 创建学生选课视图
CREATE VIEW StudentEnrollment AS 
SELECT 
    students.StudentID,
    course.CourseID1,
    teaching.CourseName,
    teaching.CourseType,
    teachers.TeacherName,
    course.RecordID,
    course.EnrollmentType 
FROM course
JOIN teaching ON course.CourseID1 = teaching.CourseID
JOIN teachers ON teaching.TeacherID = teachers.TeacherID
JOIN students ON course.StudentID1 = students.StudentID;  