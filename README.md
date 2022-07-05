# doctors-office-db
Database project for doctor's office management application

## Project scope 
  - relational database design basing on requirements analysis and domain knowledge  
  - database structure implementation using **MySQL 8**
  - creating **views, triggers and stored procedures** corresponding to identified requirements 
  - mock data generation using **Mockaroo** 
  - database testing and SQL queries tuning 
  - data visualisation using **Power BI Desktop** 

## ERD 
![image](https://user-images.githubusercontent.com/39102075/177207012-1fc6604d-cfaa-476a-923f-be68918836cd.png)

## Sample Views 
**1/ Show offices timetable for today**
```
CREATE VIEW v_timetable_for_today AS
    SELECT 
        a.AppointmentTime AS 'TIME',
        CONCAT(d.FirstName, ' ', d.LastName) AS 'DOCTOR',
        CONCAT(r.RoomCode, ', ', r.RoomDescription) AS 'ROOM',
        CONCAT(p.FirstName, ' ', p.LastName) AS 'PATIENT'
    FROM
        appointment a
            INNER JOIN
        doctor d ON a.DoctorID = d.DoctorID
            INNER JOIN
        patient p ON p.PatientID = a.PatientID
            INNER JOIN
        room r ON r.RoomID = a.RoomID
    WHERE
        a.IsCancelled = 'N'
            AND a.AppointmentDate = CURDATE()
    ORDER BY a.AppointmentTime
```
Sample output: 

![image](https://user-images.githubusercontent.com/39102075/177209826-a2acae95-8c7f-4005-8bfc-6d9485818921.png)

**2/ Show top used drugs**
```
CREATE VIEW v_top_used_drugs AS
    SELECT 
        d.Name AS 'DRUG NAME',
        COUNT(pd.PrescriptionID) AS 'PRESCRIPTED'
    FROM
        prescription_drug pd
            INNER JOIN
        drug d ON pd.DrugID = d.DrugID
    GROUP BY pd.DrugID
    ORDER BY PRESCRIPTED DESC
```
Sample output: 

![image](https://user-images.githubusercontent.com/39102075/177210469-056c208c-7745-48a8-ba7b-d6b1de28d1d0.png)

## Sample Stored Procedures
**1/ Show specific doctor (user) timetable for defined period**
```
DELIMITER $$
CREATE PROCEDURE pr_show_timetable_for_doctor (start_date varchar(10), end_date varchar(10), mail varchar(255))
BEGIN
      SELECT date(a.AppointmentDate) AS 'DATE', a.AppointmentTime AS 'TIME', 
        concat(r.RoomCode,', ', r.RoomDescription) AS 'ROOM',
        concat(p.FirstName,' ', p.LastName) AS 'PATIENT' 
      FROM appointment a 
        INNER JOIN 
      doctor d ON a.DoctorID = d.DoctorID
        INNER JOIN 
      patient p ON p.PatientID = a.PatientID
        INNER JOIN 
      room r ON r.RoomID = a.RoomID
        INNER JOIN 
      user u ON u.UserID = d.UserID
      WHERE a.IsCancelled = 'N' AND (a.AppointmentDate BETWEEN cast(start_date AS DATE) 
      AND cast(end_date AS DATE)) 
      AND u.Email = mail
      ORDER BY a.AppointmentDate;
   END$$
DELIMITER ;
```
Sample use: 
```
CALL pr_show_timetable_for_doctor('2022-07-01', '2022-07-04', 'hcheetam1a@baidu.com');
```
Sample output: 

![image](https://user-images.githubusercontent.com/39102075/177212094-6369ec03-2b93-4550-9054-b6d360616901.png)

**2/ Cancel visit**
```
DELIMITER $$
CREATE PROCEDURE pr_cancel_visit(
	IN Appointment INT
)
BEGIN
	update appointment
    set IsCancelled = 'Y' 
    where AppointmentID = Appointment ;
END$$
DELIMITER ;
```
Sample use: 
```
CALL pr_cancel_visit_TEST(55);
```

## Sample Trigger 
**Record last modification date and time for each appointment**
```
CREATE 
    TRIGGER trg_lastmodified
 BEFORE UPDATE ON appointment FOR EACH ROW 
    SET new.lastmodified = CURRENT_TIMESTAMP()
```
## Data visualisation 
Data visualisation and BI using **MS Power BI Desktop** 
![image](https://user-images.githubusercontent.com/39102075/177213460-c753ba94-0a51-4221-8541-79c77c31a30d.png)
![image](https://user-images.githubusercontent.com/39102075/177213501-6a13e799-4af9-4558-be2d-af473d3c239b.png)
![image](https://user-images.githubusercontent.com/39102075/177213518-6e5fde13-c24f-4144-91d6-ac597cc8f10b.png)






  
    




