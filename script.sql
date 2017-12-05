CREATE DATABASE busCompany;

CREATE TABLE employee( employee_id int NOT NULL PRIMARY KEY,
	 										 fName varchar(255),
											 lName varchar(255),
											 hiredDate DATE,
			 							 	 phoneNumber int,
											 addressHouse varchar(255),
											 addressStreet varchar(255),
											 addressTown varchar(255),
										   IBAN varchar(255));

CREATE TABLE payslip_amount(id int,
														week int,
														amount int,
														PRIMARY KEY(id, week),
														FOREIGN KEY(id) REFERENCES employee(employee_id)
													);

CREATE SEQUENCE booking_seq
MINVALUE 1
START WITH 1
INCREMENT BY 1
CACHE 10;

CREATE TABLE route(route_id int NOT NULL PRIMARY KEY,
									 startLocation varchar(255),
								 	 endLocation varchar(255));



CREATE TABLE timetable(id int NOT NULL,
											 day varchar(7),
										 	 times varchar(5),
										 	 PRIMARY KEY (id, day, times),
										 	 CONSTRAINT daytype CHECK (day='weekday' OR day='weekend'),
											 FOREIGN KEY (id) REFERENCES route(route_id));


CREATE TABLE booking( booking_id int NOT NULL,
											booking_name varchar(255),
											employee int NOT NULL,
											FOREIGN KEY (employee) REFERENCES employee(employee_id),
											PRIMARY KEY (booking_id));

CREATE TABLE vehicle(year int NOT NULL,
										 county varchar(2) DEFAULT 'D',
										 plateNumber int NOT NULL,
										 available int,
										 seats int NOT NULL,
										 standing int DEFAULT 0,
										 booking int,
										 FOREIGN KEY (booking) REFERENCES booking(booking_id),
										 CONSTRAINT available CHECK ((available = 1 AND booking is NULL) OR (available = 0 AND booking is NOT NULL)),
										 PRIMARY KEY (year, county, plateNumber));

INSERT INTO employee values(1241, 'Sean', 'Byrne', '10-MAR-2015', 0835216368, '12', 'WoodPark Avenue', 'Castletown', 'BOIE3098CD1230');
INSERT INTO employee values(2310, 'Owen', 'O Byrne', '17-JAN-2014', 0862136729, '26', 'AshPlace', 'Newtown', 'AIB4034CD13405');
INSERT INTO employee values(6013, 'Killian', 'Costello', '01-FEB-2012', 0892348501, '01', 'Parkview Road', 'Springfield', 'BOIE3098CD1230');
INSERT INTO employee values(0149, 'Robert', 'Stephens', '28-APR-2016', 0854638103, '44', 'CLiffView Road', 'ParkVille', 'KBCIE6510CO032');
INSERT INTO employee values(3219, 'Michael', 'Freeman', '01-DEC-2015', 08695023441, '84', 'Sea Road', 'Oldtown', 'EBS10239329103');

INSERT INTO payslip_amount values(1241,  12, 430.50);
INSERT INTO payslip_amount values(2310,  13, 346.90);
INSERT INTO payslip_amount values(1241,  13, 690.50);
INSERT INTO payslip_amount values(6013,  15, 390.90);
INSERT INTO payslip_amount values(3219,  12, 500.00);

INSERT INTO booking values(booking_seq.nextval, '18th birthday party, Howth', 0149);
INSERT INTO booking values(booking_seq.nextval, 'School tour, Clontarf', 6013);
INSERT INTO booking values(booking_seq.nextval, '21st birthday, Sutton',  3219);
INSERT INTO booking values(booking_seq.nextval, 'Work function, Malahide', 1241);
INSERT INTO booking values(booking_seq.nextval, '18th party, Portmarnock', 1241);

INSERT INTO route values(13, 'Howth Dart Station', 'Talbot Street' );
INSERT INTO route values(51, 'Eden Quay', 'Sea Front' );
INSERT INTO route values(33, 'Aaron Quay', 'Phoenix Park' );
INSERT INTO route values(91, 'Coolock', 'Malahide Dart Station' );
INSERT INTO route values(03, 'Drimnagh', 'O Connell Street' );

INSERT INTO timetable values(13, 'weekend', '07:10');
INSERT INTO timetable values(13, 'weekday', '08:35');
INSERT INTO timetable values(51, 'weekend', '10:10');
INSERT INTO timetable values(91, 'weekday', '14:50');
INSERT INTO timetable values(13, 'weekend', '18:30');

INSERT INTO vehicle values(14, 'C', 82930, 0, 56, 10, 2);
INSERT INTO vehicle(year, plateNumber, available, seats, booking) values(15, 73201, 0, 65, 3);
INSERT INTO vehicle(year, county, plateNumber, available, seats) values(10, 'KK', 3210, 1, 80);
INSERT INTO vehicle values(09, 'D', 4210, 0, 30, 0, 4);
INSERT INTO vehicle values(17, 'G', 111, 1, 70, 0, NULL);

ALTER TABLE booking ADD bookingTime DATE;

CREATE TRIGGER updateBookingTime
BEFORE INSERT ON booking
FOR EACH ROW
WHEN(bookingTime is NULL)
DECLARE today_date DATE := SYSDATE;
BEGIN
NEW.bookingTime := today_date;
END;

INSERT INTO TABLE booking(booking_id, booking_name, employee) values(booking_seq.nextval, 'wedding transport, Swords', 0149);

CREATE VIEW vehicle_location AS
SELECT vehicle.year, vehicle.county, vehicle.plateNumber, booking.booking_name
FROM vehicle
INNER JOIN booking
ON vehicle.booking=booking.booking_id;

CREATE ROLE manager IDENTIFIED by theManager;
GRANT ALL ON employee, payslip_amount, vehicle, booking, route TO manager;

CREATE ROLE bus_driver IDENTIFIED by driver;
GRANT SELECT ON vehicle_location to bus_driver;

GRANT manager TO Michael;
GRANT bus_driver TO Sean;
