1. Retrieve names of students enrolled in any society.

Select distinct(studentName) as studentName_enrolled_in_society from student

Join enrollment as e on e.rollNo = student.rollNo

Join society as sc on sc.socID = e.socID;

◼ 2. Retrieve all society names.

Select socName from society;

◼ 3. Retrieve students’ names starting with letter ‘A’.

Select studentName from student

Where studentName like ‘A%’ ;

◼ 4. Retrieve students’ details studying in courses ‘computer science’ or
‘chemistry’.

Select * from student

Where course = ‘CS’ or course = ‘Chemistry’;

◼ 5. Retrieve students’ names whose roll no either starts with ‘X’ or ‘Z’ and
ends with ‘9’

--not used in our dataset as our roll number is like this ‘100001’

Select studentName from student

Where rollNo like ‘X%’ or rollNo like ‘Z%’ and rollNo like ‘%9’;

◼ 6. Find society details with more than N TotalSeats where N is to be input by
the user

SET @num=5; --run this first then run next line

Select * from society where totalSeats >@num;

◼ 7. Update society table for mentor name of a specific society

Update society

Set mentorName=’Mr.himanshi’

Where socName=’NSS’;

◼ 8. Find society names in which more than five students have enrolled

Select socName from society

Join enrollment as e on e.socID = society.socID

Group by socName

Having count(socName)>3; --having more than 3 students. I have less data
therefore i used 3 instead of 5.

◼ 9. Find the name of youngest student enrolled in society ‘NSS’

Select studentName from student

Join enrollment as e on e.rollNo = student.rollNo

Join society as s on s.socID = e.socID

Where socName = ‘NSS’

Order by (DOB) DESC

Limit 1;

◼ 10. Find the name of most popular society (on the basis of enrolled students)

Select socName from society

Join enrollment as e on e.socID = society.socID

Join student as st on st.rollNo = e.rollNo

Group by socName

Order by COUNT(socName) desc

Limit 1;

◼ 11. Find the name of two least popular societies (on the basis of enrolled
students)

Select socName from society

Join enrollment as e on e.socID = society.socID

Join student as st on st.rollNo = e.rollNo

Group by socName

Order by COUNT(socName) asc

Limit 2;

◼ 12. Find the student names who are not enrolled in any society

Select studentName from student

Left join enrollment e on e.rollNo=student.rollNo

Where e.rollNo is null;

--alternate query

Select studentName from student

Where studentName not in (select studentName from student,enrollment where
student.rollNo=enrollment.rollNo);

◼ 13. Find the student names enrolled in at least two societies

Select studentName from student,enrollment

Where enrollment.rollNo = student.rollNo

Group by studentName

Having count(studentName)>3;

◼ 14. Find society names in which maximum students are enrolled

Select socName from society

Join enrollment e on socID=socID

Group by socName

Order by(count(socName)) DESC;

◼ 15. Find names of all students who have enrolled in any society and society
names in which at least one student has enrolled

--first all students names

SELECT distinct(studentName) from student

JOIN enrollment e on e.rollNo=student.rollNo;

--society names in which at least a studetn is enrollwd

SELECT DISTINCT(socName) from society

JOIN enrollment e on e.socID=society.socID;

◼ 16. Find names of students who are enrolled in any of the three societies
‘Debating(Blitz)’, ‘Dancing(Advaita)’ and ‘Sashakt(Founders)’.

SELECT DISTINCT(studentName) from student,enrollment as e,society

WHERE student.rollNo=e.rollNo AND e.socID=society.socID AND
(socName=”Blitz” or socName=”Advaita” or socName=”Founders”);

◼ 17. Find society names such that its mentor has a name with ‘Gupta’ in it.

SELECT socName from society

Where mentorName like ‘%Gupta%’;

◼ 18. Find the society names in which the number of enrolled students is only
10% of its capacity.

Select society.socName from society

Join ( select socName, count(enrollment.rollNo) as enrolled from society join
enrollment on enrollment.socID=society.socID group by socName) as new on
new.socName=society.socName

Where new.enrolled >= (0.1)*totalSeats;

◼ 19. Display the vacant seats for each society.

Select society.socName,(society.totalSeats – new.enrolled) as vacant_seats
from society

Join ( select socName, count(enrollment.rollNo) as enrolled from society join
enrollment on enrollment.socID=society.socID group by socName) as new on
new.socName=society.socName;

◼ 20. Increment Total Seats of each society by 10%

Update society set totalSeats=totalSeats + 0.1*totalSeats;

◼ 21. Add the enrollment fees paid (‘yes’/’No’) field in the enrollment table.

ALTER TABLE enrollment ADD COLUMN enrollment_fess_paid VARCHAR(3);

◼ 22. Update date of enrollment of society id ‘s1’ to ‘2018-01-15’, ‘s2’ to
current date and ‘s3’ to ‘2018-01-02’.

Set @currDate = CURRENT_DATE();--SETTING A VARIBALE TO STORE CURRENT
DATE

Update enrollment

Set DOE =

Case socID

WHEN “S00001” THEN “2018-01-15”

WHEN “S00002” THEN @currDate

WHEN “S00003” THEN “2018-01-02”

END

WHERE socID IN (“S00001”,”S00002”,”S00003”);

◼ 23. Create a view to keep track of society names with the total number of
students enrolled in it.

Create view IF NOT EXISTS no_of_enrollments_in_society as

Select society.socName,count(enrollment.rollNo) as enrolled_students from
society

Natural join enrollment

Group by socName;

◼ 24. Find student names enrolled in all the societies.

SET @no_of_societies= (SELECT COUNT(*) FROM society); --run this first to find
no. Of societies in our Database

Select studentName from

(select *,count(enrollment.socID) as societies_enrolled from student Natural
join enrollment group by studentName) as enrolled

Where societies_enrolled=@no_of_societies;

◼ 25. Count the number of societies with more than 5 students enrolled in it

Select count(*) from

(select count(enrollment.rollNo) as enrolled from society Natural Join enrollment
group by society.socName) as new

Where enrolled>5;

◼ 26. Add column Mobile number in student table with default value
‘9999999999’

ALTER TABLE student ADD COLUMN mobileNumber INT DEFAULT ‘999999999’;

◼ 27. Find the total number of students whose age is > 20 years.

Select count(*) from

(select timestampdiff(year,DOB,current_date()) as age from student) as new

Where age>20

◼ 28. Find names of students who are born in 2001 and are enrolled in at least
one society.

Select studentName from student,enrollment

Where student.rollNo = enrollment.rollNo and DOB like “%2001%”;

◼ 29. Count all societies whose name starts with ‘S’ and ends with ‘t’ and at
least 5 students are enrolled in the society.

Select count(socName) from

(select socName,count(enrollment.rollNo) as enrolled_student_count from
society,enrollment

Where society.socID=enrollment.socID

Group by socName) as new

Where enrolled_student_count>5 and socName like “S%t”;

◼ 30. Display the following information: Society name Mentor name Total
Capacity Total Enrolled Unfilled Seats

Select socName,mentorName,totalSeats,enrolled,(totalSeats-enrolled)

From (select *,count(enrollment.rollNo) as enrolled from society

Natural Join enrollment group by socName) as new_enrolled;
