

-- 存储过程：统计各个课程中选课时间晚于 2023 年 1 月的学生人数
DELIMITER //

CREATE PROCEDURE CountStudentsAfterDate(IN input_date DATE)
BEGIN
    SELECT teaching.CourseID, teaching.CourseName, COUNT(course.StudentID1) AS StudentCount
    FROM teaching
    LEFT JOIN course ON teaching.CourseID = course.CourseID1
    WHERE course.EnrollmentDate > input_date
    GROUP BY teaching.CourseID, teaching.CourseName;
END //

DELIMITER ;

-- 游标：逐行遍历教师表并显示每位教师教授的课程信息和选课学生数量
DELIMITER //

CREATE PROCEDURE TeacherCourseInfo()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE tID INT;
    DECLARE tName VARCHAR(20);
    DECLARE cID INT;
    DECLARE cName VARCHAR(20);
    DECLARE sCount INT;

    DECLARE cur CURSOR FOR 
        SELECT TeacherID, TeacherName FROM teachers;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO tID, tName;
        IF done THEN
            LEAVE read_loop;
        END IF;

        SELECT teaching.CourseID, teaching.CourseName, COUNT(course.StudentID1) AS StudentCount
        INTO cID, cName, sCount
        FROM teaching
        LEFT JOIN course ON teaching.CourseID = course.CourseID1
        WHERE teaching.TeacherID = tID
        GROUP BY teaching.CourseID, teaching.CourseName;

        SELECT CONCAT('教师名称: ', tName, ', 课程: ', cName, ', 学生人数: ', IFNULL(sCount, 0)) AS CourseDetails;
    END LOOP;

    CLOSE cur;
END //

DELIMITER ;

DELIMITER //


-- 创建触发器，当在 course 表中插入新记录时，更新 teaching 表中的 Student_Number 字段。

CREATE TRIGGER after_insert_course
AFTER INSERT ON course
FOR EACH ROW
BEGIN
    UPDATE teaching
    SET Student_Number = Student_Number + 1
    WHERE CourseID = NEW.CourseID1;
END //

DELIMITER ;



-- 创建触发器，当从 course 表中删除记录时，更新 teaching 表中的 Student_Number 字段。
DELIMITER //

CREATE TRIGGER after_delete_course
AFTER DELETE ON course
FOR EACH ROW
BEGIN
    UPDATE teaching
    SET Student_Number = Student_Number - 1
    WHERE CourseID = OLD.CourseID1;
END //

DELIMITER ;
