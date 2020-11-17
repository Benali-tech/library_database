-------------LIBRARY--PROJECT----------


------------------DROP_TABLES----------------------
DROP TABLE card CASCADE CONSTRAINTS ;
DROP TABLE customer CASCADE CONSTRAINTS;
DROP TABLE employee CASCADE CONSTRAINTS;
DROP TABLE branch CASCADE CONSTRAINTS;
DROP TABLE location CASCADE CONSTRAINTS;
DROP TABLE book CASCADE CONSTRAINTS;
DROP TABLE cds CASCADE CONSTRAINTS;
DROP TABLE rent CASCADE CONSTRAINTS;
----------------CREATE_TABLES----------------------

CREATE TABLE card(                         
       cardID NUMBER
      ,status VARCHAR2(1) CHECK ((status = 'A') OR (status = 'B'))
      ,fines NUMBER
      ,CONSTRAINT card_pk PRIMARY KEY (cardID) );
  
CREATE TABLE customer(
     customerID NUMBER
     ,name VARCHAR2(25)
     ,customerAddress VARCHAR2(50)
     ,phone NUMBER(13)
     ,password VARCHAR2(20)
     ,user_name VARCHAR2(15)
     ,dateSign_up DATE
     ,cardNumber NUMBER
     ,CONSTRAINT customer_pk PRIMARY KEY (customerID));
     
CREATE TABLE employee(
      employeeID NUMBER
     ,name VARCHAR2(25)
     ,employeeAddress VARCHAR2(50)
     ,phone NUMBER(13)
     ,password VARCHAR2(20)
     ,user_name VARCHAR2(15)
     ,paychek NUMBER(8,2)
     ,branchName VARCHAR2(40)
     ,cardNumber NUMBER
     ,CONSTRAINT employees_pk PRIMARY KEY (employeeID));     

CREATE TABLE branch(
      name VARCHAR2(40)
     ,address VARCHAR2(50)
     ,phone NUMBER(13)
     ,CONSTRAINT branch_pk PRIMARY KEY (name));   

CREATE TABLE location(
     address VARCHAR2(50)
    ,CONSTRAINT location_pk PRIMARY KEY (address));     

CREATE TABLE rent(
     cardID NUMBER
    ,itemID VARCHAR2(8)
    ,appDate DATE 
    ,returnDate DATE 
    ,CONSTRAINT rent_pk PRIMARY KEY (cardID,itemID));   

CREATE TABLE book(
    ISBN VARCHAR2(4)
   ,bookID VARCHAR2(8)
   ,state VARCHAR2(10)
   ,avalab VARCHAR2(1) CHECK ((avalab = 'A')OR(avalab = 'B'))
   ,debyCost NUMBER(10,2)
   ,lostCost NUMBER(10,2)
   ,address VARCHAR2(40)
   ,CONSTRAINT book_pk PRIMARY KEY (ISBN,bookID));    

CREATE TABLE cds(
    titel VARCHAR2(50)
   ,year INT
   ,cdID VARCHAR2(6)
   ,state VARCHAR2(6)
   ,avalab VARCHAR2(1) CHECK ((avalab = 'A')OR(avalab = 'o'))
   ,debyCost NUMBER(10,2)
   ,lostCost NUMBER(10,2)
   ,address VARCHAR2(40)
   ,CONSTRAINT cds_pk PRIMARY KEY (titel,year,cdID));  
   
-----------------FOREIGN_KEY---------------------   
ALTER TABLE customer 
    ADD CONSTRAINT customer_fk 
    FOREIGN KEY (cardNumber) 
    REFERENCES card (cardID);

ALTER TABLE employee
    ADD CONSTRAINT employee_fk_card 
    FOREIGN KEY (cardNumber)
    REFERENCES card (cardID);

ALTER TABLE employee
    ADD CONSTRAINT employee_fk_branch
    FOREIGN KEY (branchName)
    REFERENCES branch (name);
    
ALTER TABLE branch
    ADD CONSTRAINT branch_fk
    FOREIGN KEY (address)
    REFERENCES location(address);
    
ALTER TABLE book
    ADD CONSTRAINT book_fk
    FOREIGN KEY (address)
    REFERENCES location(address);

ALTER TABLE cds 
    ADD CONSTRAINT cds_fk 
    FOREIGN KEY (address)
    REFERENCES location (address);

ALTER TABLE rent
    ADD CONSTRAINT rent_fk_card
    FOREIGN KEY (cardID)
    REFERENCES card (cardID);

ALTER TABLE rent
    ADD CONSTRAINT rent_fk_book
    FOREIGN KEY (itemID)
    REFERENCES book (bookID);
    
ALTER TABLE rent 
    ADD CONSTRAINT rent_fk_cds
    FOREIGN KEY (itemID)
    REFERENCES cds (cdID);

-------------PACKAGE_FOR_ALL_TABLES---------------

CREATE SEQUENCE ins_card   /* create sequence for inserting 'CARD_TABLE'*/
    START WITH 100
    INCREMENT BY 1;
CREATE SEQUENCE ins_customer/* create sequence for table customer*/
    START WITH 1
    INCREMENT BY 1;
CREATE SEQUENCE ins_employee  /*create sequence for table employee*/ 
    START WITH 200
    INCREMENT BY 1 ;
    
/*CREATE package specification*/    
CREATE OR REPLACE PACKAGE all_tables
IS 
      PROCEDURE insert_card
            (p_table VARCHAR2,status VARCHAR2 ,fines NUMBER);
      PROCEDURE insert_branch
            (v_table VARCHAR2,v_name VARCHAR2,address VARCHAR2,phone NUMBER);
      PROCEDURE insert_customer
            (v_table VARCHAR2,customerID NUMBER,name VARCHAR2, customerAddress VARCHAR2,
             phone NUMBER, password VARCHAR2,user_name VARCHAR2, dateSign_up DATE
             ,cardNumber NUMBER);
       PROCEDURE insert_employee
             (v_table VARCHAR2, employeeID NUMBER,employeeAddress VARCHAR2,phone NUMBER,
              password VARCHAR2, user_name VARCHAR2, paycheck NUMBER,branchName VARCHAR2,
               cardNumber NUMBER);
END all_tables;
/
/*create package body */
CREATE OR REPLACE PACKAGE BODY all_tables
IS 
PROCEDURE insert_card 
       (p_table VARCHAR2,status VARCHAR2 ,fines NUMBER)
IS 
        /*inserting values in table_card with seq ins_card*/
        v_sql VARCHAR2(100);
BEGIN
         v_sql := ' INSERT INTO '||p_table||' VALUES (:cardID,:status,:fines)';
         EXECUTE IMMEDIATE v_sql USING ins_card.NEXTVAL, status,fines; 
END insert_card;

/*procedure inserting for table branch*/
PROCEDURE insert_branch
         (v_table VARCHAR2,v_name VARCHAR2,address VARCHAR2,phone NUMBER)
 IS 
          v_sql VARCHAR2(1000):= ' INSERT INTO '||v_table ||' VALUES (:v_name,:address,:phone)';
 BEGIN
           EXECUTE IMMEDIATE v_sql USING v_name,address,phone;
 END insert_branch;
-------------------------------------------------------------------------------------------------------------- 
 /*Inserting into table customer with seq ins_customer*/   
PROCEDURE insert_customer
       (v_table VARCHAR2,name VARCHAR2, customerAddress VARCHAR2,
        phone NUMBER, password VARCHAR2,user_name VARCHAR2, dateSign_up DATE
        ,cardNumber NUMBER)
IS
         v_sql VARCHAR2(100):= ' INSERT INTO '||v_table||' VALUES (:1,:2,:3,:4,:5,:6,:7)';
BEGIN
         EXECUTE IMMEDIATE v_sql USING INS_CUSTOMER.nextval,name,customeraddress,phone,password,user_name,datesign_up,cardNumber;
END insert_customer;
----------------------------------------------------------------------------------------------------------------

PROCEDURE insert_employee
           (v_table VARCHAR2,employeeAddress VARCHAR2,phone NUMBER,
            password VARCHAR2, user_name VARCHAR2, paycheck NUMBER,branchName VARCHAR2,
            cardNumber NUMBER)
IS 
   v_sql VARCHAR2(1000);
BEGIN
   v_sql :=' INSERT INTO '||v_table||' VALUES (:employeeID,:employeeAddress,:phone,:password
                                               ,:user_name,:paycheck,:branchName,:cardNumber)';
   EXECUTE IMMEDIATE v_sql USING ins_employee.NEXTVAL,employeeAddress,phone,password,user_name,
                                paycheck,branchname,cardNumber;
END insert_employee;
---------------------------------------------------------------------------------------------------------------------------
  
END all_tables;
/

------------------CREATE_FUNCTIONS----------------------

/*Create function for login Customer */
CREATE OR REPLACE PROCEDURE loginCustomer_library (user IN VARCHAR2,pass IN VARCHAR2)
IS
  passAux customer.password%TYPE;
BEGIN
          SELECT password INTO passAux 
          FROM customer 
          WHERE user_name LIKE user;
      
      IF passaux LIKE pass THEN 
           DBMS_OUTPUT.PUT_LINE(' User '|| user || ' loging succesfull');
      ELSE 
            DBMS_OUTPUT.PUT_LINE('Password incorrect');
      END IF;
      
      EXCEPTION WHEN no_data_found THEN 
            DBMS_OUTPUT.PUT_LINE('User incorrect');
END loginCustomer_library;

DECLARE /*Tesitin user and password Customer */
         user customer.user_name%type;
         pass customer.password%TYPE;
BEGIN
         user :='&User_name' ;
         pass :='&Password';
         logincustomer_library(user,pass);
END;
/*create function for login employees */
CREATE OR REPLACE PROCEDURE loginEmployee_library
                   (user VARCHAR2,pass VARCHAR2)
IS 
       passAux employee.password%TYPE;
BEGIN
       SELECT password INTO passAux 
       FROM employee 
       WHERE user_name LIKE user;
       
       IF passAux LIKE pass THEN
            DBMS_OUTPUT.PUT_LINE('User : '||user ||' Login succesfull');
       ELSE 
            DBMS_OUTPUT.PUT_LINE('Password incorrect');
       END IF;
       
      EXCEPTION WHEN no_data_found THEN
          DBMS_OUTPUT.PUT_LINE('User Incorrect');
END loginEmployee_library;

DECLARE /*Tesitin user and password employee */
    user employee.user_name%type;
    pass employee.password%type;
BEGIN
  user :='&User_name';
  pass :='&Password';
  loginEmployee_library(user,pass);
END;

/*create function for View Items*/
CREATE OR REPLACE PROCEDURE viewItem_library
                       (auxItemID VARCHAR2)
IS 
       n_book number;
       n_cd number;
       vb_rec book%ROWTYPE;   
       vc_rec cds%ROWTYPE;
BEGIN
       SELECT COUNT(*) INTO n_book
       FROM book
       WHERE bookID = auxItemID;
       
       SELECT COUNT(*) INTO n_cd
       FROM cds
       WHERE cdID LIKE auxItemID;
   
   IF n_book > 0 THEN 
     SELECT *
     INTO vb_rec FROM book
     WHERE bookID = auxItemID;
     DBMS_OUTPUT.PUT_LINE('BOOK ' || auxItemID || 'INFO' );
     DBMS_OUTPUT.PUT_LINE('-------------------------------');
     DBMS_OUTPUT.PUT_LINE('ISBN ' ||vb_rec.isbn);
     DBMS_OUTPUT.PUT_LINE('STATE  ' ||vb_rec.state);
     DBMS_OUTPUT.PUT_LINE('AVALAB ' ||vb_rec.avalab);
     DBMS_OUTPUT.PUT_LINE('DEBYCOST ' ||vb_rec.debycost);
     DBMS_OUTPUT.PUT_LINE('LOSTCOST ' ||vb_rec.lostcost);
     DBMS_OUTPUT.PUT_LINE('address ' ||vb_rec.address);
     DBMS_OUTPUT.PUT_LINE('-------------------------------');
   
   ELSIF n_cd >0 THEN
     SELECT *
     INTO vc_rec FROM cds
     WHERE cdID LIKE auxItemID;
     DBMS_OUTPUT.PUT_LINE('CDS ' || auxItemID || 'INFO' );
     DBMS_OUTPUT.PUT_LINE('-------------------------------');
     DBMS_OUTPUT.PUT_LINE('TITLE ' ||vc_rec.titel);
     DBMS_OUTPUT.PUT_LINE('YEAR  ' ||vc_rec.year);
     DBMS_OUTPUT.PUT_LINE('AVALAB ' ||vc_rec.avalab);
     DBMS_OUTPUT.PUT_LINE('DEBYCOST ' ||vc_rec.debycost);
     DBMS_OUTPUT.PUT_LINE('LOSTCOST ' ||vc_rec.lostcost);
     DBMS_OUTPUT.PUT_LINE('address ' ||vc_rec.address);
     DBMS_OUTPUT.PUT_LINE('-------------------------------');
   
   END IF;  
END viewItem_library;
/
/*Testing Item for BOOK AND CDS */
DECLARE
  auxItemID VARCHAR2(10);
BEGIN
  auxItemID :='&Item_ID';
  viewItem_library(auxItemID);
END;

/*RENT For Customer And Testing*/
CREATE OR REPLACE PROCEDURE customerAccount_library
                    (custoID_IN customer.customerid%type)
IS 
     auxCard NUMBER;
     rented NUMBER:=0;
     auxItem VARCHAR2(6);
     auxFines NUMBER;
BEGIN
       SELECT cardNumber INTO auxCard 
       FROM customer 
       WHERE customerid LIKE custoID_IN;
       
       SELECT COUNT(*) INTO rented 
       FROM rent 
       WHERE rent.cardid = auxCard;
       DBMS_OUTPUT.PUT_LINE('USER CARD IS : ' || auxcard);
       
       IF rented > 0 THEN 
         SELECT rent.itemid INTO auxItem 
         FROM rent,card
         WHERE rent.cardid = card.cardid
         AND card.cardid LIKE auxCard;
         
         DBMS_OUTPUT.PUT_LINE('The customer has  : ' || auxItem || ' Rented');
       ELSE
         DBMS_OUTPUT.PUT_LINE('The customer has no rents');
       END IF;   
       
       SELECT fines INTO auxFines 
       FROM card 
       WHERE cardid LIKE auxCard;
       
       DBMS_OUTPUT.PUT_LINE('The Customer fines are : ' ||auxFines);
       
       EXCEPTION WHEN no_data_found THEN
       DBMS_OUTPUT.PUT_LINE('NO DATA FOUND');      
END customerAccount_library;

DECLARE
  custoID_IN customer.customerid%type;
BEGIN
  custoid_in :=&Customer_ID ;
  customerAccount_library(custoID_IN);
END;
/*employee  And Testing*/
CREATE OR REPLACE PROCEDURE employeeAccount_library 
                         (emploID_IN employee.employeeid%type)
IS 
    auxCard NUMBER;
    rented NUMBER:=0;
    auxItem VARCHAR2(6);
    auxFines NUMBER;
BEGIN
   SELECT cardNumber INTO auxCard 
   FROM employee 
   WHERE employeeID LIKE emploID_IN;
   
   SELECT COUNT(*) INTO rented 
   FROM rent
   WHERE rent.cardID LIKE auxcard;
   
   DBMS_OUTPUT.PUT_LINE('The employee card is : ' || auxcard);
   
   IF rented > 0 THEN 
    SELECT rent.itemid INTO auxItem
    FROM rent,card
    WHERE card.cardID = rent.cardID
    AND card.cardID LIKE auxCard;
    
        DBMS_OUTPUT.PUT_LINE('The employee has' || auxItem|| 'Rented ');
    ELSE 
       DBMS_OUTPUT.PUT_LINE('The employee has no rented');
    END IF;
    
    SELECT fines INTO auxFines 
    FROM card
    WHERE cardID LIKE auxcard;
      DBMS_OUTPUT.PUT_LINE('The employee fines are :' ||auxfines);
  
  EXCEPTION WHEN no_data_found THEN
     DBMS_OUTPUT.PUT_LINE('NO DATA FOUND');
END employeeAccount_library;

DECLARE
   emploID_IN employee.employeeid%type;
BEGIN
   emploID_IN:=&Employee_id;
   employeeAccount_library(emploID_IN);
END;

-------PROCEDURE_RENT_ITEM_LIBRARY-------------------
CREATE OR REPLACE PROCEDURE rentItem_library (auxCard_in NUMBER,auxItem_in VARCHAR2,
                                      itemType_in VARCHAR2,auxDate_in DATE)
IS
     auxStats VARCHAR2(1);
     itemStats VARCHAR2(1);
BEGIN
    SELECT status INTO auxStats
    FROM card
    WHERE cardid LIKE auxcard_in;
    
    IF auxStats LIKE 'A' THEN 
       IF itemType_in LIKE 'book' THEN 
       
        SELECT avalab INTO itemStats
        FROM book
        WHERE bookid LIKE auxitem_in;
        
             IF itemStats LIKE 'A' THEN 
               UPDATE book SET avalab = 'B'
               WHERE bookid LIKE auxitem_in;
               
               INSERT INTO rent 
               VALUES(auxCard_in,auxItem_in,SYSDATE,auxDate_in);
               DBMS_OUTPUT.PUT_LINE('Item ' ||auxItem_in|| 'Rented ');
               
            ELSE
              DBMS_OUTPUT.PUT_LINE('The book is alerdy rented');
            END IF;
            
     ELSIF itemType_in LIKE 'cds' THEN    
        
        SELECT avalab INTO itemStats
        FROM cds 
        WHERE cdID LIKE auxitem_in;
        
        IF itemStats LIKE 'A' THEN 
          
          UPDATE cds SET avalab = 'B'
          WHERE cdID LIKE auxitem_in;
          
          INSERT INTO rent 
          VALUES (auxCard_in,auxItem_in,SYSDATE,auxDate_in);
          DBMS_OUTPUT.PUT_LINE('Item ' ||auxItem_in|| 'Rented ');
          
       ELSE 
          DBMS_OUTPUT.PUT_LINE('is alerdy rented ');
       END IF;
  
  
  ELSE 
          DBMS_OUTPUT.PUT_LINE('Is Blocked ');
  END IF;
END IF;
END rentItem_library;
/*Testing rent*/
DECLARE
      auxCard_in NUMBER;
      auxItem_in VARCHAR2(10);
      itemType_in VARCHAR2(20);
      auxDate_in DATE;
BEGIN
   auxCard_in := &CARD_ID;
   auxItem_in :='&Item_book_OR_CD';
   itemType_in :='&Id_tem';
   auxDate_in := '&return_date';
   rentItem_library(auxCard_in,auxItem_in,itemType_in,auxDate_in);
END;

--------PROCEDURE_PAY_FINES_LIBRARY-------------
CREATE OR REPLACE PROCEDURE payFines_library 
                   (auxCard_in card.cardid%type, money_in NUMBER)
IS 
   finesAmount NUMBER;
   total NUMBER;
BEGIN
    SELECT fines INTO finesAmount
    FROM card 
    WHERE cardid = auxCard_in;
    
    IF finesAmount < money_in THEN
        total := money_in - finesAmount ; 
        DBMS_OUTPUT.PUT_LINE('You pay all fines and you have ' || total || 'Money back');
        
        UPDATE card 
        SET status = 'A' , fines = 0
        WHERE cardid = auxCard_in;
    
   ELSIF finesAmount = money_in THEN
       total := money_in - finesAmount;
       DBMS_OUTPUT.PUT_LINE('You pay all your fines');
       
       UPDATE card 
       SET status = 'A',fines = 0
       WHERE cardid = auxCard_in;
       
   ELSE 
     total := finesAmount - money_in ;
     DBMS_OUTPUT.PUT_LINE('You will need to Pay ' || total || 'More to Unlock your card');
     
     UPDATE card 
     SET fines = total
     WHERE cardid = auxCard_in;
  
  END IF;    
END payFines_library;

DECLARE
    auxCard_in card.cardid%type;
    money_in NUMBER;
BEGIN
   auxcard_in :=&Card_id;
   money_in :=&Money_to_pay;
   payFines_library(auxcard_in,money_in);
END;
----PROCEDURE_FOR_UPDATE_INFO_CUSTOMERS------

