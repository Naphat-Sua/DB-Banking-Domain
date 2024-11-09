CREATE DATABASE KBank;
USE KBank;

-- Create the Customer table
CREATE TABLE Customer 
(
Citizen_ID VARCHAR(13) not null primary key,
T_FirstName NVARCHAR(50) not null,
T_LastName NVARCHAR(50) not null,
E_FirstName NVARCHAR(50) not null,
E_Lastname NVARCHAR(50) not null,
Salary DECIMAL(19, 2) not null,
Occupation VARCHAR(20) not null,
Phone_Number VARCHAR(10),
Paddr_Country VARCHAR(20),
Paddr_Province VARCHAR(20),
Paddr_City VARCHAR(20),
Occupation_Group VARCHAR(20) not null,
Signature LONGBLOB,
Email_Address VARCHAR(50),
Financial_Credits INT not null,
Laddr_Country VARCHAR(20) not null,
Laddr_Province VARCHAR(20) not null,
Laddr_Postal_code VARCHAR(20) not null,
Laddr_City VARCHAR(20) not null,
National VARCHAR(20) not null,
Branch VARCHAR(20) not null,
BD_Date DATE not null
);

-- Create the Account_Book table
CREATE TABLE Account_Book
(
Account_Number VARCHAR(20) not null primary key,
Book_Number VARCHAR(20) not null,
DW_DateandTime DATETIME not null,
DD_DateandTime DATETIME not null,
Amount DECIMAL(19, 2) not null,
Teller_Number VARCHAR(15) not null,
Branch VARCHAR(25) not null,
Branch_Number VARCHAR(15) not null,
Bank_Opener VARCHAR(50) not null,
Old_Book_Number VARCHAR(20),
Account_Type VARCHAR(30) not null
);

-- Create the Designated_Bank_Account table
CREATE TABLE Designated_Bank_Account
(
Senders_Account_Number VARCHAR(15) not null,
Receivers_Account_Number VARCHAR(15) not null,
Senders_Bank_Name VARCHAR(15) not null,
Receivers_Bank_Name VARCHAR(15) not null,
CONSTRAINT pk_SRaccount primary key (Senders_Account_Number, Receivers_Account_Number)
);

-- Create the Card table
CREATE TABLE Card
(
CardID VARCHAR(16) not null primary key,
EXP_Date DATE not null,
E_FirstName VARCHAR(50) not null,
E_Lastname VARCHAR(50) not null,
Card_Number VARCHAR(16) not null,
CVV VARCHAR(3) not null,
Citizen_ID VARCHAR(13) not null,
CONSTRAINT fk_citizenID foreign key (Citizen_ID) REFERENCES
Customer (Citizen_ID) 
);

-- Create the Debit_Card table
CREATE TABLE Debit_Card
(	
CardID VARCHAR(16) not null primary key,
T_Date DATE not null,
PIN VARCHAR(16) not null,
User_Location VARCHAR(50) not null,
Status VARCHAR(10) not null,
Registration_Channel VARCHAR(20) not null,
Card_Issuer VARCHAR(50) not null,
A_Date DATE not null,
Account_Number VARCHAR(20) not null,
CONSTRAINT fk_cardID foreign key (CardID) references 
Card (CardID),
CONSTRAINT fk_Account_Number foreign key (Account_Number)
REFERENCES Account_Book (Account_Number)
);

-- Create the Withdrawal table
CREATE TABLE Withdrawal
(
Withdrawal_Number VARCHAR(20) not null primary key,
Withdrawal_Amount DECIMAL(10, 2) not null,
Date_and_Time_of_Withdrawal DATETIME not null,
CardID VARCHAR(16) not null,
CONSTRAINT fk_WcardID foreign key (CardID)
REFERENCES Debit_Card (CardID)
);

-- Create the Deposit table
CREATE TABLE Deposit
(
Deposit_Number VARCHAR(20) not null primary key,
Deposit_Amount DECIMAL(10, 2) not null,
Account_Type VARCHAR(15) not null,
CardID VARCHAR(16) not null,
CONSTRAINT fk_DcardID foreign key (CardID)
REFERENCES Debit_Card (CardID)
);

-- Create the Closure table
CREATE TABLE Closure
(
Citizen_ID VARCHAR(13) not null primary key,
Closure_Date DATE not null,
Current_Balance DECIMAL(10, 2) not null,
Branch VARCHAR(25) not null,
CONSTRAINT fk_Ccitizen_ID foreign key (Citizen_ID) REFERENCES
Customer (Citizen_ID)
);

-- Create the Transfer table
CREATE TABLE Transfer
(
CardID VARCHAR(16) not null,
Senders_Account_Number VARCHAR(15) not null,
Receivers_Account_Number VARCHAR(15) not null,
CONSTRAINT pk_CSRtranfer primary key (CardID, 
Senders_Account_Number, Receivers_Account_Number),
CONSTRAINT fk_TcardID foreign key (CardID)
references Debit_Card (CardID),
CONSTRAINT fk_TAccount FOREIGN KEY (Senders_Account_Number, 
Receivers_Account_Number)
REFERENCES Designated_Bank_Account (Senders_Account_Number, 
Receivers_Account_Number)
);

-- Create the C_Have_A table
CREATE TABLE C_Have_A
(
Account_Number VARCHAR(20) not null,
Citizen_ID VARCHAR(13) not null,
CONSTRAINT pk_CHA primary key (Account_Number, Citizen_ID),
CONSTRAINT fk_CHA_AccNo foreign key (Account_Number)
REFERENCES Account_Book (Account_Number),
CONSTRAINT fk_CHA_CitID foreign key (Citizen_ID) REFERENCES
Customer (Citizen_ID)
);

-- Create the AccB_Currency table
CREATE TABLE AccB_Currency
(
Currency VARCHAR(10) not null,
Account_Number VARCHAR(20) NOT NULL,
CONSTRAINT pk_AccB primary key (Currency, Account_Number),
CONSTRAINT fk_AccB foreign key (Account_Number)
REFERENCES Account_Book (Account_Number)
);

-- Create the Transaction table
CREATE TABLE Transaction
(
Reference_Transaction_Number VARCHAR(20) not null primary key,
Date_and_Time DATETIME not null,
Deposit_Number VARCHAR(20),
Withdrawal_Number VARCHAR(20),
CONSTRAINT fk_TraDpo foreign key (Deposit_Number)
REFERENCES Deposit (Deposit_Number),
CONSTRAINT fk_TraWitdra foreign key (Withdrawal_Number)
REFERENCES Withdrawal (Withdrawal_Number)
);

-- Create the T_ATM table
CREATE TABLE T_ATM
(
Reference_Transaction_Number VARCHAR(20) not null,
Bank_Name VARCHAR(20) not null,
ATM_ID VARCHAR(20) not null,
Transaction_Limit DECIMAL(10, 2) not null,
CONSTRAINT pk_ATM PRIMARY KEY (Reference_Transaction_Number, ATM_ID),
CONSTRAINT fk_ATM_Refe FOREIGN KEY (Reference_Transaction_Number)
REFERENCES Transaction (Reference_Transaction_Number)
);

-- Create the T_Counter table
CREATE TABLE T_Counter
(
Reference_Transaction_Number VARCHAR(20) not null,
Branch_ID VARCHAR(20) not null,
TC_Cash DECIMAL(10,2),
TC_Cheque DECIMAL(10,2),
Reference_Number VARCHAR(20) not null,
CONSTRAINT pk_Counter primary key 
(Reference_Transaction_Number, Branch_ID),
CONSTRAINT fk_CRefo foreign key (Reference_Transaction_Number)
REFERENCES Transaction (Reference_Transaction_Number)
);

-- Create the Transfer_Order table
CREATE TABLE Transfer_Order
(
Transaction_Reference_Number VARCHAR(20) not null primary key,
Payment_Type VARCHAR(20) not null,
Amount_Transfer DECIMAL(10,2) not null,
Transfer_Date_and_Time DATETIME not null,
CardID VARCHAR(16) not null,
Account_Number VARCHAR(20) not null,
CONSTRAINT fk_TOAC foreign key (Account_Number)
REFERENCES Account_Book (Account_Number)
);

-- Create the Transfer_order_type_Application table
CREATE TABLE Transfer_order_type_Application
(
Transaction_Reference_Number VARCHAR(20) not null,
IMEI_Number VARCHAR(20) not null,
CONSTRAINT pk_TOTA primary key (Transaction_Reference_Number,
IMEI_Number),
CONSTRAINT fk_TRN foreign key (Transaction_Reference_Number)
REFERENCES Transfer_Order (Transaction_Reference_Number)
);

-- Create the Transfer_order_type_ATM table
CREATE TABLE Transfer_order_type_ATM
(
Transaction_Reference_Number VARCHAR(20) not null,
ATM_ID VARCHAR(20) not null,
Bank_owner VARCHAR(50) not null,
Transaction_Limit DECIMAL(10,2) not null,
CONSTRAINT pk_TOTAt primary key (Transaction_Reference_Number,
ATM_ID),
CONSTRAINT fk_TRNATM foreign key (Transaction_Reference_Number)
REFERENCES Transfer_Order (Transaction_Reference_Number)
);

-- Create the Tranfer_order_type_Counter_Service table
CREATE TABLE Tranfer_order_type_Counter_Service
(
Transaction_Reference_Number VARCHAR(20) not null,
BranchID VARCHAR(20) not null, 
CONSTRAINT pk_TOTAcs primary key (Transaction_Reference_Number,
BranchID),
CONSTRAINT fk_TRNcs foreign key (Transaction_Reference_Number)
REFERENCES Transfer_Order (Transaction_Reference_Number)
);

Use KBank;

INSERT INTO customer (Citizen_ID,T_FirstName,T_Lastname,E_FirstName,E_LastName,Salary,
 Occupation,Phone_Number, Paddr_Country,Paddr_Province,Paddr_City,
 Occupation_Group,
 Signature,
 Email_Address,Financial_Credits,Laddr_Country,
 Laddr_Province,Laddr_Postal_Code,Laddr_City,National,Branch,BD_Date) Values 
('4100101245299', 'เดวิด', 'แซ่เม้ง', 'David', 'Saemeng', 85000, 'Engineer', '819854652', 'Thailand', 'Bangkok', 'Khlongsan', 'Engineer', null, 'davidlnwza@gmail.com', 50000, 'Thailand', 'Bangkok', '10110', 'Watthana', 'Thai', 'Siamparagon', '2004-04-20'),
('1967638494589', 'อลิส', 'สมิท', 'Alice', 'Smith', 30000, 'Teacher', '0881121528', 'Thailand', 'Bangkok', 'Bangphlat', 'Government official', null, 'helloha@gmail.com', 15000, 'Thailand', 'Bangkok', '10700', 'Bangphlat', 'Thai', 'Bang Phlat', '1999-05-11'),
('4758301119349', 'บอบ', 'จอนสัน', 'Bob', 'Johnson', 40000, 'Sale', '0865940279', 'Thailand', 'Bangkok', 'Dindaeng', 'Office', null, 'wearewhoweare@gmail.com', 30000, 'Thailand', 'Bangkok', '10400', 'Dindaeng', 'Thai', 'Asok', '1997-06-11'),
('4127107046827', 'ชาลี', 'วิลเลียม', 'Charlie', 'Williams', 120000, 'Farmer', null, 'Thailand', 'Bangkok', 'Ratchada', 'Farmer', null, 'susuka@gmail.com', 100000, 'Thailand', 'Bangkok', '10900', 'Ratchada', 'Thai', 'Ratchadapisek 15', '1999-07-06'),
('1079560825451', 'อีฟ', 'โจนส์', 'Eve', 'Jones', 300000, 'Engineer', '0828749674', 'Thailand', 'Bangkok', 'Sukhumwit', 'Owned Business', null, 'evesurjones@gmail.com', 450000, 'Thailand', 'Bangkok', '10120', 'Yannawa', 'Thai', 'Yan Nawa', '1979-07-01'),
('1228381953513', 'เฟย์', 'บราวน์', 'Fay', 'Brown', 50000, 'Engineer', '0880004272', null, null, null, 'Accountant', null, 'sirfayofbrownfamily@gmai.com', 30000, 'Thailand', 'Bangkok', '10310', 'Huai Khwang', 'Thai', 'Huai Khwang', '1999-09-21'),
('192365831976', 'เกรซ', 'เดวิส', 'Grace', 'Davis', 21000, 'Engineer', null, null, null, null, 'Government Official', null, 'grace.davis@gmail.com', 25000, 'Thailand', 'Bangkok', '10500', 'Bang Rak', 'Thai', 'Bang Rak', '1990-10-11'),
('1701458210085', 'แฮงค์', 'มิลเลอร์', 'Hank', 'Miller', 18000, 'Engineer', '0817219818', 'Thailand', 'Pathumtani', 'Khlongluang', 'Farmer', null, 'iamthefarmeroftheyear@gmail.com', 10000, 'Thailand', 'Pathumtani', '12120', 'Khlongluang', 'Thai', 'Future park', '1999-09-18'),
('4518464885577', 'ไอวี่', 'วิลสัน', 'Ivy', 'Wilson', 10000, 'Engineer', '0865763294', 'Thailand', 'Phuket', 'Muang', 'Student', null, 'lvywilson@gmail.com', 0, 'Thailand', 'Phuket', '13130', 'Muang', 'Thai', 'Central Phuket', '2004-12-11'),
('1809274552308', 'แจค', 'มอร์', 'Jack', 'Moore', 150000, 'Engineer', '0806468519', 'Thailand', 'Nakronsrithammarat', 'Muang', 'Engineer', null, 'tootierdtotype@gmail.com', 100000, 'Thailand', 'Nakronsrithammarat', '80000', 'Muang', 'Thai', 'Robinson Nakornsri', '1997-03-27');

INSERT INTO Account_book (Account_Number, Book_Number, DW_DateandTime, DD_DateandTime, Amount, Teller_Number, Branch, Branch_Number, Bank_Opener, Old_Book_Number, Account_Type) 
values
(302225354, 125648597, '2015-10-21', '2015-10-10', 5000, '07806A', 'Siamparagon', 738, 'Athit Siwakorn', 121558967,'Saving'),
(133507922, 401250007, '2024-06-26', '2024-09-03', 20, '0888B8', 'Bang Phlat', 563, 'Meesuk Somwang', 401250006,'Saving Account'),
(190576761, 928313789, '2024-10-09', '2024-07-06', 200, '953AB3', 'Asok', 123, 'Swwatdee Mechai', 928313788,'Fixed Deposit Account'),
(950921447, 398855175, '2024-05-02', '2024-11-16', 32, '11B211', 'Ratchadapisek 15', 456, 'Arun Aram', 398855174,'Basic Banking Account'),
(349177630, 942676236, '2024-09-21', '2024-03-22', 179, '02B123', 'Yan Nawa', 789, 'Wandee Tongtea', '-','E-Saving'),
(363915962, 478988980, '2024-03-19', '2024-07-24', 801, '0888B8', 'Huai Khwang', 432, 'Chinchutha Chalerm', 478988979,'Saving Account'),
(914694468, 652721456, '2024-11-07', '2024-10-18', 700, '0888B8', 'Bang Rak', 112, 'Mesuk Mechai', 652721455,'Saving Account'),
(790992301, 149995915, '2024-10-12', '2024-07-02', 50, '07806A', 'Future Park', 901, 'Natnid Seateaw', '-','E-Saving'),
(695336522, 325158918, '2024-04-25', '2024-12-12', 12, '07806A', 'Central Phuket', 503, 'Bunmee Lontub', 325158917,'Saving Account'),
(859028769, 512282526, '2024-02-05', '2024-04-18', 30000, '07806A', 'Robinson Nakornsri', 446, 'Jatai Leaw', 512282525,'Saving Account');

INSERT INTO Designated_Bank_Account (Senders_Account_Number, Receivers_Account_Number, Senders_Bank_Name, Receivers_Bank_Name) values
(133507922, 302225354, 'Kasikorn', 'Kasikorn'),
(190576761, 586235874, 'Kasikorn', 'Krugsri'),
(950921447, 251485236, 'Kasikorn', 'SCB'),
(133507922, 541283253, 'Kasikorn', 'Aomsin'),
(190576761, 253621452, 'Kasikorn', 'Krungthai'),
(950921447, 586325632, 'Kasikorn', 'Bangkok'),
(133507922, 142585632, 'Kasikorn', 'Krungthai'),
(190576761, 147525236, 'Kasikorn', 'SCB'),
(950921447, 120586396, 'Kasikorn', 'Kasikorn'),
(133507922, 135805263, 'Kasikorn', 'Kasikorn');

INSERT INTO card (CardID, EXP_Date, E_FirstName, E_Lastname, Card_Number, CVV, Citizen_ID) values
('2457845695621453', '2026-02-28', 'David', 'Saemeng', '2457845695621453', 303, '4100101245299'),
('1392976090548670', '2026-03-31', 'Alice', 'Smith', '1392976090548670', 412, '1967638494589'),
('3201821108935821', '2025-01-31', 'Bob', 'Johnson', '3201821108935821', 683, '4758301119349'),
('2491466402444990', '2026-07-31', 'Charlie', 'Williams', '2491466402444990', 721, '4127107046827'),
('6283747376517743', '2028-07-31', 'Eve', 'Jones', '6283747376517743', 898, '1079560825451'),
('6736078766613815', '2025-05-31', 'Fay', 'Brown', '6736078766613815', 405, '1228381953513'),
('9043275910535717', '2028-11-30', 'Grace', 'Davis', '9043275910535717', 254, '192365831976'),
('8888741357818332', '2027-06-30', 'Hank', 'Miller', '8888741357818332', 382, '1701458210085'),
('4295741582290866', '2027-07-31', 'Ivy', 'Wilson', '4295741582290866', 127, '4518464885577'),
('2469535772926542', '2028-03-31', 'Jack', 'Moore', '2469535772926542', 567, '1809274552308'),
('8190562477211093', '2027-05-31', 'Alice', 'Smith', '8190562477211093', 399, '1967638494589'),
('8961775636649040', '2032-04-30', 'Bob', 'Johnson', '8961775636649040', 143, '4758301119349'),
('5092144338412485', '2033-01-31', 'Charlie', 'Williams', '5092144338412485', 966, '4127107046827'),
('3238711642691094', '2027-11-30', 'Eve', 'Jones', '3238711642691094', 923, '1079560825451'),
('3267186189975749', '2034-10-31', 'Eve', 'Jones', '3267186189975749', 906, '1079560825451'),
('8684413143937008', '2027-05-31', 'Ivy', 'Wilson', '8684413143937008', 772, '4518464885577'),
('7680464556596835', '2027-07-31', 'Jack', 'Moore', '7680464556596835', 123, '1809274552308'),
('3138695264842062', '2028-03-31', 'Alice', 'Smith', '3138695264842062', 436, '1967638494589'),
('2982588099646685', '2027-05-31', 'Jack', 'Moore', '2982588099646685', 635, '1809274552308'),
('1526371094836955', '2031-04-30', 'Alice', 'Smith', '1526371094836955', 948, '1967638494589'),
('5106818877969545', '2027-11-30', 'Charlie', 'Williams', '5106818877969545', 678, '4127107046827'),
('3919527650476338', '2032-10-31', 'Eve', 'Jones', '3919527650476338', 967, '1079560825451'),
('6742784646059623', '2027-05-31', 'Fay', 'Brown', '6742784646059623', 183, '1228381953513'),
('1671096523496893', '2032-05-31', 'Grace', 'Davis', '1671096523496893', 385, '192365831976'),
('3254603039861522', '2028-03-31', 'Charlie', 'Williams', '3254603039861522', 836, '4127107046827'),
('7320575070540327', '2026-02-28', 'Eve', 'Jones', '7320575070540327', 305, '1079560825451'),
('1361706522061323', '2030-09-30', 'Fay', 'Brown', '1361706522061323', 586, '1228381953513'),
('4187703675499394', '2028-12-31', 'Grace', 'Davis', '4187703675499394', 294, '192365831976'),
('1269535792805772', '2026-11-30', 'Eve', 'Jones', '1269535792805772', 305, '1079560825451'),
('8352034905576864', '2024-11-30', 'Fay', 'Brown', '8352034905576864', 950, '1228381953513');

INSERT INTO Debit_Card (CardID, T_Date, PIN, User_Location, Status, Registration_Channel, Card_Issuer, A_Date, Account_Number) values
('2457845695621453', '2023-12-12', '807060', 'Saphankwai', 'Suspended', 'Online', 'Kasikorn', '2021-05-10', '302225354'),
('1392976090548670', '2024-02-29', '852364', 'Phayathai', 'Active', 'Online', 'Kasikorn', '2024-01-17', '133507922'),
('3201821108935821', '2024-04-24', '147264', 'Khongsan', 'Active', 'Online', 'Kasikorn', '2022-03-24', '190576761'),
('2491466402444990', '2024-04-16', '205068', 'Ratchada', 'Active', 'Online', 'Kasikorn', '2024-09-16', '950921447'),
('6283747376517743', '2024-02-02', '174263', 'Huai Khwang', 'Suspended', 'Online', 'Kasikorn', '2017-09-30', '349177630'),
('6736078766613815', '2024-10-07', '265983', 'Yanawa', 'Suspended', 'Online', 'Kasikorn', '2023-08-10', '363915962'),
('9043275910535717', '2024-02-14', '985621', 'Bangkok noi', 'Active', 'Online', 'Kasikorn', '2017-08-14', '914694468'),
('8888741357818332', '2024-03-06', '125487', 'Rangsit', 'Active', 'Online', 'Kasikorn', '2024-02-21', '790992301'),
('4295741582290866', '2024-12-09', '366352', 'Patong', 'Active', 'Online', 'Kasikorn', '2022-03-01', '695336522'),
('2469535772926542', '2024-01-28', '965328', 'Muang', 'Active', 'Online', 'Kasikorn', '2020-10-31', '859028769'),
('8190562477211093', '2024-12-17', '958583', 'Phayathai', 'Active', 'Online', 'Kasikorn', '2015-09-18', '133507922'),
('8961775636649040', '2024-05-25', '372611', 'Khongsan', 'Active', 'Counter Service', 'Kasikorn', '2019-12-15', '190576761'),
('5092144338412485', '2024-11-08', '113696', 'Ratchada', 'Active', 'Online', 'Kasikorn', '2021-08-01', '950921447'),
('3238711642691094', '2024-06-16', '685793', 'Huai Khwang', 'Suspended', 'Online', 'Kasikorn', '2019-11-29', '349177630'),
('3267186189975749', '2024-12-01', '684906', 'Huai Khwang', 'Suspended', 'Counter Service', 'Kasikorn', '2022-03-07', '349177630'),
('8684413143937008', '2024-04-12', '907342', 'Patong', 'Active', 'Online', 'Kasikorn', '2023-08-17', '695336522'),
('7680464556596835', '2024-10-05', '810694', 'Muang', 'Active', 'Online', 'Kasikorn', '2022-01-14', '859028769'),
('3138695264842062', '2024-12-24', '348021', 'Phayathai', 'Suspended', 'Online', 'Kasikorn', '2020-08-26', '133507922'),
('2982588099646685', '2024-10-10', '897484', 'Muang', 'Active', 'Online', 'Kasikorn', '2022-06-30', '859028769'),
('1526371094836955', '2024-05-15', '939343', 'Phayathai', 'Active', 'Counter Service', 'Kasikorn', '2022-03-14', '133507922'),
('5106818877969545', '2024-02-26', '191374', 'Ratchada', 'Active', 'Online', 'Kasikorn', '2016-12-15', '950921447'),
('3919527650476338', '2024-10-16', '395301', 'Huai Khwang', 'Active', 'Online', 'Kasikorn', '2018-09-30', '349177630'),
('6742784646059623', '2024-12-16', '746640', 'Yanawa', 'Active', 'Counter Service', 'Kasikorn', '2020-02-14', '363915962'),
('1671096523496893', '2024-12-26', '948221', 'Bangkok noi', 'Suspended', 'Online', 'Kasikorn', '2020-07-19', '914694468'),
('3254603039861522', '2024-01-06', '656847', 'Ratchada', 'Active', 'Online', 'Kasikorn', '2022-10-17', '950921447'),
('7320575070540327', '2024-01-18', '546077', 'Huai Khwang', 'Active', 'Online', 'Kasikorn', '2024-08-24', '349177630'),
('1361706522061323', '2024-07-22', '587871', 'Yanawa', 'Active', 'Counter Service', 'Kasikorn', '2023-09-03', '363915962'),
('4187703675499394', '2024-08-27', '152233', 'Bangkok noi', 'Active', 'Online', 'Kasikorn', '2017-05-19', '363915962'),
('1269535792805772', '2024-10-23', '570022', 'Huai Khwang', 'Suspended', 'Online', 'Kasikorn', '2022-07-07', '349177630'),
('8352034905576864', '2024-03-02', '488979', 'Yanawa', 'Active', 'Online', 'Kasikorn', '2015-10-02', '363915962');

INSERT INTO withdrawal(Withdrawal_Number, Withdrawal_Amount, Date_and_Time_of_Withdrawal, CardID) values
('017541203640BBC45485', 4500, '2023-06-24 14:35:00', '2457845695621453'),
('928769299040MSB77007', 3200, '2024-10-20 06:38:00', '2491466402444990'),
('520138025239QCF32744', 1000, '2024-11-25 05:23:00', '6283747376517743'),
('366476846433QTX76001', 2500, '2024-11-19 21:13:00', '6736078766613815'),
('887010154808NPP40991', 5000, '2024-08-17 22:19:00', '2491466402444990'),
('887025414874VOB30529', 8000, '2024-11-30 04:48:00', '6283747376517743'),
('515963754882WIB17872', 4000, '2024-08-25 05:14:00', '6736078766613815'),
('942411389549PWM69322', 6500, '2024-09-06 16:10:00', '4295741582290866'),
('889106390753NWQ42983', 7000, '2024-02-25 06:30:00', '2469535772926542'),
('526997165846BLF78209', 5500, '2024-06-15 23:20:00', '8190562477211093'),
('890130734400PHY97483', 50, '2024-03-12 05:52:00', '4295741582290866'),
('239072729198HJO96617', 12, '2024-05-05 08:28:00', '2469535772926542'),
('875611432342AYW55831', 57, '2024-04-14 15:17:00', '8190562477211093'),
('337006784115KMR13520', 123, '2024-05-13 18:14:00', '6283747376517743'),
('190433767728HXE89245', 437, '2024-05-10 13:06:00', '6736078766613815'),
('561250752890YNO71487', 8880, '2024-07-01 14:29:00', '9043275910535717'),
('973201941803ZPF18810', 653, '2024-05-03 09:31:00', '6283747376517743'),
('804320970298YLN77833', 679, '2024-08-08 05:33:00', '6736078766613815'),
('438480069260UIL56381', 1864, '2024-01-10 18:33:00', '9043275910535717'),
('997890418170YSB33108', 5666, '2024-03-24 16:59:00', '3919527650476338'),
('686720012977WIM37859', 980, '2024-01-16 09:23:00', '6742784646059623'),
('491565669395MJV68687', 750, '2024-03-20 05:14:00', '1671096523496893'),
('893703317783LQB17865', 12, '2024-09-12 20:59:00', '6742784646059623'),
('150951845261SMQ13904', 7, '2024-07-19 17:36:00', '1671096523496893'),
('864993675603CDA41151', 754, '2024-11-10 11:55:00', '3254603039861522'),
('448905547816HDK50755', 400, '2024-03-03 08:16:00', '9043275910535717'),
('849242709748BXN70175', 38, '2024-06-16 19:15:00', '3919527650476338'),
('280096065737ISR39038', 9, '2024-07-12 18:15:00', '6742784646059623'),
('428797369548YOW40731', 13000, '2024-11-18 14:24:00', '1671096523496893'),
('453326154111CVU34432', 12, '2024-06-12 20:42:00', '6742784646059623');

INSERT INTO deposit(Deposit_Number, Deposit_Amount, Account_Type, CardID) values
('017548693640ABG11475', 15000, 'Saving', '2457845695621453'),
('123734372167RUP34899', 2500, 'Saving', '6283747376517743'),
('482247842062ARO91080', 9500, 'Saving', '6736078766613815'),
('199401351218VWL27085', 50000, 'Saving', '9043275910535717'),
('838201273096FTQ61837', 60000, 'Saving', '8888741357818332'),
('244300647225EUW56976', 7500, 'Saving', '4295741582290866'),
('629961916867CMG34557', 6500, 'Saving', '3201821108935821'),
('866000405143IBE87845', 5000, 'Saving', '2491466402444990'),
('227833692606VBQ38909', 5000, 'Saving', '6283747376517743'),
('195657337122OZT76647', 20000, 'Saving', '7680464556596835'),
('455255169616GEF40282', 5000, 'Saving', '3138695264842062'),
('253494208067YRM68260', 30000, 'Saving', '2982588099646685'),
('540302872563ZGW68872', 3700, 'Saving', '1526371094836955'),
('171192881526QZK91612', 30000, 'Saving', '5106818877969545'),
('510466451945BUY35211', 100000, 'Saving', '3919527650476338'),
('471488828775IPG49600', 27000, 'Saving', '3238711642691094'),
('697438325580TKC25191', 2000, 'Saving', '3267186189975749'),
('674444024799ISP71925', 2500, 'Saving', '8684413143937008'),
('231958921327YDD33661', 240, 'Saving', '7680464556596835'),
('669380854033FSS98119', 30000, 'Saving', '3267186189975749'),
('300125732148AFB64645', 10000, 'Saving', '8684413143937008'),
('774502458430QQB29379', 4500, 'Saving', '7680464556596835'),
('641106621861SAA78014', 250, 'Saving', '5106818877969545'),
('208927921913WFM43428', 179, 'Saving', '3919527650476338'),
('740352149998AGJ86531', 49, 'Saving', '6742784646059623'),
('197978809679OVS86533', 2000, 'Saving', '1671096523496893'),
('284415672845GKB58797', 1000, 'Saving', '3254603039861522'),
('223097846969IQP48846', 1500, 'Saving', '7320575070540327'),
('419710967677NYA50058', 37000, 'Saving', '1361706522061323'),
('243403894655LNZ34661', 40000, 'Saving', '8352034905576864');

INSERT INTO closure(Citizen_ID, Closure_Date, Current_Balance, Branch) values
('4100101245299', '2024-11-12', 8670453, 'Siam paragon'),
('1967638494589', '2024-12-12', 9, 'Central Phuket'),
('4758301119349', '2024-12-13', 1029, 'bang phalt'),
('4127107046827', '2024-12-14', 33300, 'Lotus Wongsawang'),
('1079560825451', '2024-12-15', 0, 'Central World'),
('1228381953513', '2024-12-16', 10, 'Lotus Wongsawang'),
('192365831976', '2024-12-17', 930, 'Central World'),
('1701458210085', '2024-12-18', 4000000, 'Siam Paragon'),
('4518464885577', '2024-12-19', 304000, 'Central rama9'),
('1809274552308', '2024-12-20', 54534, 'Cantral Westville');

INSERT INTO transfer (CardID, Senders_Account_Number, Receivers_Account_Number) VALUES
('2457845695621453', '133507922', '302225354'),
('1392976090548670', '190576761', '586235874'),
('3201821108935821', '950921447', '251485236'),
('2491466402444990', '133507922', '541283253'),
('6283747376517743', '190576761', '253621452'),
('6736078766613815', '950921447', '586325632'),
('9043275910535717', '133507922', '142585632'),
('8888741357818332', '190576761', '147525236'),
('4295741582290866', '950921447', '120586396'),
('2469535772926542', '133507922', '135805263'),
('8190562477211093', '133507922', '302225354'),
('8961775636649040', '190576761', '586235874'),
('5092144338412485', '950921447', '251485236'),
('3238711642691094', '133507922', '541283253'),
('3267186189975749', '190576761', '253621452'),
('8684413143937008', '950921447', '586325632'),
('7680464556596835', '133507922', '142585632'),
('3138695264842062', '190576761', '147525236'),
('2982588099646685', '950921447', '120586396'),
('1526371094836955', '133507922', '135805263'),
('5106818877969545', '133507922', '302225354'),
('3919527650476338', '190576761', '586235874'),
('6742784646059623', '950921447', '251485236'),
('1671096523496893', '133507922', '541283253'),
('3254603039861522', '190576761', '253621452'),
('7320575070540327', '950921447', '586325632'),
('1361706522061323', '133507922', '142585632'),
('4187703675499394', '190576761', '147525236'),
('1269535792805772', '950921447', '120586396'),
('8352034905576864', '133507922', '135805263');

INSERT INTO C_HAVE_A (Account_number, citizen_ID) VALUES
('302225354', '4100101245299'),
('133507922', '1967638494589'),
('190576761', '4758301119349'),
('950921447', '4127107046827'),
('349177630', '1079560825451'),
('363915962', '1228381953513'),
('914694468', '192365831976'),
('790992301', '1701458210085'),
('695336522', '4518464885577'),
('859028769', '1809274552308');

INSERT INTO AccB_Currency (Currency, Account_Number) VALUES
('THB', '302225354'),
('THB', '133507922'),
('THB', '190576761'),
('THB', '950921447'),
('THB', '349177630'),
('THB', '363915962'),
('THB', '914694468'),
('THB', '790992301'),
('THB', '695336522'),
('THB', '859028769'),
('USD', '302225354'),
('USD', '133507922'),
('USD', '190576761'),
('USD', '950921447'),
('USD', '349177630'),
('USD', '363915962'),
('USD', '914694468'),
('USD', '790992301'),
('USD', '695336522'),
('USD', '859028769'),
('CNY', '302225354'),
('CNY', '133507922'),
('CNY', '190576761'),
('CNY', '950921447'),
('CNY', '349177630'),
('CNY', '363915962'),
('CNY', '914694468'),
('CNY', '790992301'),
('CNY', '695336522'),
('CNY', '859028769');

INSERT INTO Transaction (Reference_Transaction_Number, Date_and_Time, Deposit_Number, Withdrawal_Number) VALUES
('014459685230BNK11776', '2023-06-24 14:35', '017548693640ABG11475', NULL),
('014459685230BNK11777', '2024-10-20 06:38', '123734372167RUP34899', NULL),
('014459685230BNK11778', '2024-11-25 05:23', '482247842062ARO91080', NULL),
('014459685230BNK11779', '2014-11-19 21:13', '199401351218VWL27085', NULL),
('014459685230BNK11780', '2024-08-17 22:19', '838201273096FTQ61837', NULL),
('014459685230BNK11781', '2024-11-30 04:48', '244300647225EUW56976', NULL),
('014459685230BNK11782', '2024-08-25 05:14', '629961916867CMG34557', NULL),
('014459685230BNK11783', '2024-06-09 16:10', '866000405143IBE87845', NULL),
('014459685230BNK11784', '2024-02-25 06:30', '227833692606VBQ38909', NULL),
('014459685230BNK11785', '2024-06-15 23:20', NULL, '526997165846BLF78209'),
('014459685230BNK11786', '2024-12-03 05:52', NULL, '890130734400PHY97483'),
('014459685230BNK11787', '2024-05-05 08:28', NULL, '239072729198HJO96617'),
('014459685230BNK11788', '2024-04-14 15:17', NULL, '875611432342AYW55831'),
('014459685230BNK11789', '2024-05-13 18:14', NULL, '337006784115KMR13520'),
('014459685230BNK11790', '2024-10-05 13:06', NULL, '190433767728HXE89245'),
('014459685230BNK11791', '2024-01-07 14:29', NULL, '561250752890YNO71487'),
('014459685230BNK11792', '2024-03-05 09:31', NULL, '973201941803ZPF18810'),
('014459685230BNK11793', '2024-08-08 05:33', '674444024799ISP71925', NULL),
('014459685230BNK11794', '2024-10-01 18:33', '231958921327YDD33661', NULL),
('014459685230BNK11795', '2024-03-24 16:59', '669380854033FSS98119', NULL),
('014459685230BNK11796', '2024-01-16 09:23', '300125732148AFB64645', NULL),
('014459685230BNK11797', '2024-03-20 05:14', '774502458430QQB29379', NULL),
('014459685230BNK11798', '2024-12-09 20:59', '641106621861SAA78014', NULL),
('014459685230BNK11799', '2024-07-19 17:36', '208927921913WFM43428', NULL),
('014459685230BNK11800', '2024-10-11 11:55', NULL, '864993675603CDA41151'),
('014459685230BNK11801', '2024-03-03 08:16', NULL, '448905547816HDK50755'),
('014459685230BNK11802', '2024-06-16 19:15', NULL, '849242709748BXN70175'),
('014459685230BNK11803', '2024-12-07 18:15', NULL, '280096065737ISR39038'),
('014459685230BNK11804', '2024-11-18 14:24', NULL, '428797369548YOW40731'),
('014459685230BNK11805', '2024-12-06 20:42', NULL, '453326154111CVU34432');

INSERT INTO T_ATM (Reference_Transaction_Number,Bank_Name, ATM_ID, Transaction_Limit)VALUES

('014459685230BNK11776', 'Kasikorn', 'S1B2426', 100000),
('014459685230BNK11777', 'Kasikorn', 'S1B2427', 50000),
('014459685230BNK11778', 'Kasikorn', 'S1B2428', 50000),
('014459685230BNK11779', 'Kasikorn', 'S1B2429', 50000),
('014459685230BNK11780', 'Kasikorn', 'S1B2430', 50000),
('014459685230BNK11781', 'Kasikorn', 'S1B2431', 50000),
('014459685230BNK11782', 'Kasikorn', 'S1B2432', 50000),
('014459685230BNK11783', 'Kroungthep', 'S1B2433', 50000),
('014459685230BNK11784', 'Kasikorn', 'S1B2434', 20000),
('014459685230BNK11785', 'Aomsin', 'S1B2435', 50000),
('014459685230BNK11796', 'Aomsin', 'S1B2436', 50000),
('014459685230BNK11797', 'Aomsin', 'S1B2437', 50000),
('014459685230BNK11798', 'Aomsin', 'S1B2438', 50000),
('014459685230BNK11799', 'Aomsin', 'S1B2439', 50000),
('014459685230BNK11800', 'Aomsin', 'S1B2440', 50000);

INSERT INTO T_Counter (Reference_Transaction_Number, Branch_ID, TC_Cash, TC_Cheque, Reference_Number) VALUES
('014459685230BNK11786', 738, NULL, 800000, '075462891780CCR11462'),
('014459685230BNK11787', 563, 10000, NULL, '075462891780CCR11463'),
('014459685230BNK11788', 123, 34000, NULL, '075462891780CCR11464'),
('014459685230BNK11789', 456, 20, NULL, '075462891780CCR11465'),
('014459685230BNK11790', 789, 10000, NULL, '075462891780CCR11466'),
('014459685230BNK11791', 432, 43000, NULL, '075462891780CCR11467'),
('014459685230BNK11792', 112, 1200, NULL, '075462891780CCR11468'),
('014459685230BNK11793', 901, 9000, NULL, '075462891780CCR11469'),
('014459685230BNK11794', 503, 1400000, NULL, '075462891780CCR11470'),
('014459685230BNK11795', 446, 3940, NULL, '075462891780CCR11471'),
('014459685230BNK11801', 133, 120, NULL, '075462891780CCR11472'),
('014459685230BNK11802', 453, 350, NULL, '075462891780CCR11473'),
('014459685230BNK11803', 395, 33, NULL, '075462891780CCR11474'),
('014459685230BNK11804', 979, NULL, 30400, '075462891780CCR11475'),
('014459685230BNK11805', 569, 3400, NULL, '075462891780CCR11476');

INSERT INTO Transfer_Order (Transaction_Reference_Number, Payment_Type, Amount_Transfer, Transfer_Date_and_Time, CardID, Account_Number) VALUES
('014375891640CQK11758', 'Application', 20000, '2023-06-18 14:58:00', '457845695621453', 302225354),
('4521H970075538B3M59S', 'Application', 10000, '2024-11-25 05:23:00', '1392976090548670', 133507922),
('86R94224HX1L1401Q1X7', 'Application', 34000, '2024-11-19 21:13:00', '3201821108935821', 190576761),
('767T8382959T42209B80', 'Application', 20, '2024-08-17 22:19:00', '2491466402444990', 950921447),
('3ZDP8L59U53112345P06', 'Application', 10000, '2024-11-30 04:48:00', '6283747376517743', 349177630),
('21U169843897388Y4739', 'Application', 8000, '2024-08-25 05:14:00', '6736078766613815', 363915962),
('41ZS93137852GRJ805O1', 'Application', 4000, '2023-09-25 05:15:00', '9043275910535717', 914694468),
('31X1Y8Y7517971498722', 'Application', 6500, '2020-08-25 05:16:00', '8888741357818332', 790992301),
('39973339J7730M584E03', 'Application', 7000, '2024-08-17 22:19:00', '4295741582290866', 695336522),
('NO891041S40J5675385T', 'Application', 5500, '2024-11-30 04:48:00', '2469535772926542', 859028769),
('6304Z303338R47M', 'ATM', 40, '2024-01-31 22:37:00', '2457845695621453', 302225354),
('7018U669507S26Q', 'ATM', 2804, '2024-05-01 18:32:00', '1392976090548670', 133507922),
('9753B139974S08L', 'ATM', 80590, '2024-01-31 14:36:00', '3201821108935821', 190576761),
('6313V021847E45T', 'ATM', 980, '2024-10-24 22:54:00', '2491466402444990', 950921447),
('7116H313637J83T', 'ATM', 9847, '2024-10-18 02:34:00', '6283747376517743', 349177630),
('1412N536342A32B', 'ATM', 329, '2024-04-10 04:58:00', '6736078766613815', 363915962),
('2638X865396U86E', 'ATM', 87, '2024-12-04 00:25:00', '9043275910535717', 914694468),
('9766E148180A54B', 'ATM', 32949, '2024-08-01 05:03:00', '8888741357818332', 790992301),
('0709Q769502J13D', 'ATM', 88880, '2024-05-14 12:51:00', '4295741582290866', 695336522),
('8294K915525X33I', 'ATM', 1830, '2024-09-21 10:14:00', '2469535772926542', 859028769),
('6741O767372O87G', 'Application', 8940, '2024-06-29 01:50:00', '2457845695621453', 302225354),
('9170E669978R65R', 'Application', 7, '2024-08-22 07:52:00', '1392976090548670', 133507922),
('9324A874684Z18A', 'Application', 3930, '2024-05-24 20:40:00', '3201821108935821', 190576761),
('6866S790589O58Q', 'Application', 9302, '2024-07-14 10:39:00', '2491466402444990', 950921447),
('9610F450680O09T', 'Application', 19220, '2024-03-31 09:31:00', '6283747376517743', 349177630),
('1642T763816S66X', 'Application', 930, '2024-01-20 23:28:00', '6736078766613815', 363915962),
('2330P313613K13X', 'Application', 30480, '2024-12-18 23:51:00', '9043275910535717', 914694468),
('7111O300458M93Y', 'Application', 100, '2024-10-07 16:14:00', '8888741357818332', 790992301),
('6158D807157O69C', 'Application', 2000, '2024-08-19 14:56:00', '4295741582290866', 695336522),
('6761S527970W90U', 'Application', 3000, '2024-05-17 11:31:00', '2469535772926542', 859028769);

INSERT INTO Transfer_order_type_Application (Transaction_Reference_Number, IMEI_Number) VALUES
('014375891640CQK11758', '359144772478981'),
('4521H970075538B3M59S', '359144772478981'),
('86R94224HX1L1401Q1X7', '359144772478982'),
('767T8382959T42209B80', '4526890806546'),
('3ZDP8L59U53112345P06', '44308564060808'),
('21U169843897388Y4739', '405850943684509'),
('41ZS93137852GRJ805O1', '54960806904568990'),
('31X1Y8Y7517971498722', '450809235803900'),
('39973339J7730M584E03', '45048352045840950349'),
('NO891041S40J5675385T', '568096098035922');

INSERT INTO Transfer_order_type_ATM (Transaction_Reference_Number, ATM_ID, Bank_owner, Transaction_Limit) VALUES
('6304Z303338R47M', 'S1B2426', 'Kasikorn', 20000),
('7018U669507S26Q', 'S1B2427', 'Kasikorn', 20000),
('9753B139974S08L', 'S1B2428', 'Kasikorn', 20000),
('6313V021847E45T', 'S1B2429', 'Kasikorn', 20000),
('7116H313637J83T', 'S1B2430', 'Kasikorn', 100000),
('1412N536342A32B', 'S1B2431', 'Kasikorn', 50000),
('2638X865396U86E', 'S1B2432', 'Kasikorn', 50000),
('9766E148180A54B', 'S1B2433', 'Kasikorn', 50000),
('0709Q769502J13D', 'S1B2434', 'Kasikorn', 20000),
('8294K915525X33I', 'S1B2435', 'Kasikorn', 50000);

INSERT INTO tranfer_order_type_Counter_Service (Transaction_Reference_Number, BranchID) VALUES
('6741O767372O87G', 738),
('9170E669978R65R', 563),
('9324A874684Z18A', 123),
('6866S790589O58Q', 456),
('9610F450680O09T', 789),
('1642T763816S66X', 432),
('2330P313613K13X', 112),
('7111O300458M93Y', 901),
('6158D807157O69C', 503),
('6761S527970W90U', 446);

SELECT * FROM Debit_Card;



