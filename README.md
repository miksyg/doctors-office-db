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
      SELECT date(a.appointmentdate) AS 'DATE', a.appointmenttime AS 'TIME', 
        concat(r.roomcode,', ', r.roomdescription) AS 'ROOM',
        concat(p.firstname,' ', p.lastname) AS 'PATIENT' 
      FROM appointment a 
        INNER JOIN 
      doctor d ON a.doctorid = d.doctorid
        INNER JOIN 
      patient p ON p.patientid = a.patientid
        INNER JOIN 
      room r ON r.roomid = a.roomid 
        INNER JOIN 
      user u ON u.userid = d.userid
      WHERE a.iscancelled = 'N' AND (a.appointmentdate BETWEEN cast(start_date AS DATE) AND cast(end_date AS DATE)) 
      AND u.email = mail
      ORDER BY a.appointmentdate;
   END$$
DELIMITER ;
```
Sample use: 
```
CALL pr_show_timetable_for_doctor('2022-07-01', '2022-07-04', 'hcheetam1a@baidu.com');
```
Sample output: 

![image](https://user-images.githubusercontent.com/39102075/177212094-6369ec03-2b93-4550-9054-b6d360616901.png)


## Sample Trigger 
// to do // 

## Data visualisation 
// to do // 


  
    




