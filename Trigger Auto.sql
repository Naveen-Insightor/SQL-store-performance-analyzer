USE PRACTISE;

#Inserting of working hours cannot be negative

create table empX (Ename varchar(30), Working_hrs Int);
insert into empX values ("Navuu",-20); -- It is taking negative value
select * from empX;
-- create a before insert trigger that will convert it into positive RCtab>>Alter Table>>Trigg>>Before INSERT
insert into empX values("Raj",-30); -- It converted into positive due to trigger
select * from empX;

#Insert the inserted / updated / deleted time into actitivity table whenever its done

create table users( id INT AUTO_INCREMENT PRIMARY KEY,name VARCHAR(100),email VARCHAR(100));
desc users; -- name , email

create table activity (id INT AUTO_INCREMENT PRIMARY KEY,name varchar(100),
  action_type VARCHAR(20), 
  action_time DATETIME);
desc activity; -- action type , action time

-- We want to set up trigger that will catch all INSERT UPDATE AND DELETE ACTIVITIES WITH TIME
-- Trigger Created for AFTER -  INSERT/UPDATE/DELETE
Insert into users (name,email) values ("aos","lala@gmail.com"),("am","Rara@gamil.com");
select * from users;
select * from activity;

update users set name = "Vietnam" where name = "Laos";
select * from users;
select * from activity;

delete from users 
where email = "lala@gmail.com";
SELECT *FROM users;
select * from activity;




