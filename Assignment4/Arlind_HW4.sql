-- Arlind Stafaj HW4
-- Use .read Arlind_HW4.sql to run file on command line 
-- 
-- 1. Use Excel formula to produce a table named CatSuppliers  = Catalog left-joins Suppliers, where Catalog and Suppliers are two tables shown below. 						
--     CatSuppliers table should include the following columns: sid, pid, City, cost						
--     CatSuppliers' upper left hand cell address for each of you is given in the table below (each of you has a different location to place it)						
-- 2. Use Excel formula to produce a table named CatSuppliersParts = CatSuppliers left-joins Parts. 						
--      CatSuppliersParts table should contain all the columns of CatSuppliers plus part_type and color						
--      CatSuppliersParts' upper left hand cell address for each of you is given in the table below (each of you has a different location to place it)						
-- 3. Use the pivot facility in Excel to create a pivot table for aggregation of the information in CatSuppliersParts (which is the joined final table in 2. above). 						
--       The row headings, column headings and the aggregation target are specified in the table below (each of you has a diffderent arrangement)						
--      For example, for JooMin, the row heading is color, and column heading is # of GB, and aggregation is for count, then the pivot table would look like this:						
--	4GB	8GB	16GB			
-- red	sum of cost	sum of cost	sum of cost			
-- green	sum of cost	sum of cost	sum of cost			
-- blue	sum of cost	sum of cost	sum of cost			
-- Note that before you invoke the insert of pivot, you need to create a computed column part size that is the same as part_type except that "usb " is stripped out, so only 4GB, 8GB, 16GB remain						
-- 4. Do the same pivot table as above except using array formula I showed in class with the files I sent (do not invoke the pivot table facility in Excel). 						
--        Check and see if it agrees with what you get in 3. above. If it does not agree and you cannot figure out why, indicate so. Otherwise, say the two tables agree						


-- TABLE FOR SUPPLIERS 
DROP TABLE Suppliers;
CREATE TABLE Suppliers
(
    sid CHAR,
    sname CHAR,
    City CHAR
);
INSERT INTO Suppliers
VALUES
    ('s1', 'BestBuy', 'Somers');
INSERT INTO Suppliers
VALUES
    ('s2', 'Walmart', 'Yorktown');
INSERT INTO Suppliers
VALUES
    ('s3', 'Officemax', 'Somers');
INSERT INTO Suppliers
VALUES
    ('s4', 'Target', 'Yorktown');
INSERT INTO Suppliers
VALUES
    ('s5', 'B&H', 'Scardsdale');
INSERT INTO Suppliers
VALUES
    ('s6', 'Macys', 'Somers');
INSERT INTO Suppliers
VALUES
    ('s8', 'BJ', 'Yorktown');

-- TABLE FOR PARTS
DROP TABLE Parts;
CREATE TABLE Parts
(
    pid CHAR,
    part_type CHAR,
    color CHAR
);
INSERT INTO Parts
VALUES
    ('pr1', 'usb 4GB', 'red');
INSERT INTO Parts
VALUES
    ('pr2', 'usb 16GB', 'red');
INSERT INTO Parts
VALUES
    ('pr3', 'usb 16GB', 'red');
INSERT INTO Parts
VALUES
    ('pg1', 'usb 4GB', 'green');
INSERT INTO Parts
VALUES
    ('pg2', 'usb 4GB', 'green');
INSERT INTO Parts
VALUES
    ('pb1', 'usb 8GB', 'blue');

-- TABLE FOR CATALOGS
DROP TABLE Catalogs;
CREATE TABLE Catalogs
(
    sid CHAR,
    pid CHAR,
    cost INTEGER
);
INSERT INTO Catalogs
VALUES
    ('s1', 'pr1', 1);
INSERT INTO Catalogs
VALUES
    ('s1', 'pr3', 5);
INSERT INTO Catalogs
VALUES
    ('s1', 'pg2', 3);
INSERT INTO Catalogs
VALUES
    ('s2', 'pr1', 6);
INSERT INTO Catalogs
VALUES
    ('s2', 'pr2', 2);
INSERT INTO Catalogs
VALUES
    ('s2', 'pr3', 4);
INSERT INTO Catalogs
VALUES
    ('s2', 'pg1', 2);
INSERT INTO Catalogs
VALUES
    ('s2', 'pg2', 2);
INSERT INTO Catalogs
VALUES
    ('s2', 'pb1', 1);
INSERT INTO Catalogs
VALUES
    ('s3', 'pg1', 6);
INSERT INTO Catalogs
VALUES
    ('s3', 'pr1', 5);
INSERT INTO Catalogs
VALUES
    ('s4', 'pg2', 3);
INSERT INTO Catalogs
VALUES
    ('s4', 'pr1', 1);
INSERT INTO Catalogs
VALUES
    ('s5', 'pr2', 1);
INSERT INTO Catalogs
VALUES
    ('s5', 'pr3', 2);
INSERT INTO Catalogs
VALUES
    ('s6', 'pb1', 1);
INSERT INTO Catalogs
VALUES
    ('s6', 'pr1', 3);
INSERT INTO Catalogs
VALUES
    ('s7', 'pr1', 2);
.mode column 
.header on 
.echo on


--------------------    DISPLAY TABLES    --------------------
--
-- 

SELECT *
FROM Suppliers;
SELECT *
FROM Parts;
SELECT *
FROM Catalogs;


-- CREATE CATSUPLIERS LEFT-JOINED TABLE
DROP VIEW CatSuppliers;
GO
CREATE VIEW CatSuppliers
AS
            SELECT C.sid, S.sname, S.City, C.pid, C.cost
        FROM Suppliers S, Catalogs C
        WHERE C.sid = S.sid
    UNION
        SELECT C1.sid, NULL, NULL, C1.pid, C1.cost
        FROM Catalogs C1
        WHERE C1.sid NOT IN (SELECT S1.sid
        FROM Suppliers S1);
GO

-- CREATE CATSUPPLIERSPARTS LEFT-JOIN TABLE
DROP VIEW CatSuppliersParts;
GO
CREATE VIEW CatSuppliersParts
AS
            SELECT C.sid, C.pid, S.sname, S.City, C.cost,
            substr(P.part_type, 4, 5) AS part_type, P.color
        FROM Catalogs C, Suppliers S, Parts P
        WHERE C.sid = S.sid AND C.pid = P.pid
    UNION
        SELECT C1.sid, C1.pid, NULL, NULL, C1.cost,
            substr(P1.part_type, 4, 5), P1.color
        FROM Catalogs C1, Parts P1
        WHERE C1.pid = P1.pid AND
            C1.sid NOT IN (SELECT S1.sid
            FROM Suppliers S1);
GO

--------------------    DISPLAY JOINED TABLES  --------------------
--
-- 

SELECT *
FROM CatSuppliers;
SELECT *
FROM CatSuppliersParts;

-------------------- PIVOT TABLE FOR ROWS = pid, COLUMNS = GB, COUNT --------------------
--
-- 

SELECT DISTINCT pid,
    COUNT(CASE WHEN part_type = ' 4GB' THEN '4GB' END) AS '4GB',
    COUNT(CASE WHEN part_type = ' 8GB' THEN '8GB' END) AS '8GB',
    COUNT (CASE WHEN part_type = ' 16GB' THEN '16GB' END) AS '16GB'
FROM CatSuppliersParts
GROUP BY pid;

-- 2. Find the names of suppliers that supply red and green parts. 
--    a. Use the method shown in page 19 of Nov 5's lecture slides (will be 
--          referred to as the lecture slides)
--    b. Use the method in page 29 of lecture slides in where statement, constrain 
--       red and green to be in the collection of such colors
--    c. Use the method I showed in Nov 5 class
--    d. Do the same but for red and green colors only (no other colors allowed) 
--       Use c but add the following: in where statement, constrain total number of  
--         colors found in expanded catalog to 2 with nested query,
--    e. Do the same but for any two colors and two only.
-----------------    2(a)    ------------------------
--
-- 

SELECT DISTINCT S.sname
FROM Suppliers S, Parts P, Catalogs C,
    Catalogs C2, Parts P2
WHERE S.sid = C.sid AND C.pid = P.pid
    AND S.sid = C2.sid AND C2.pid = P2.pid
    AND (P.color = 'red' AND P2.color = 'green');

-----------------    2(b)    ------------------------
--
-- 

SELECT DISTINCT S.sname
FROM Suppliers S, Catalogs C, Parts P
WHERE S.sid = C.sid AND C.pid = P.pid AND P.color = 'red'
    AND S.sname IN 
        (
        SELECT DISTINCT S2.sname
    FROM Suppliers S2,
        Catalogs C2, Parts P2
    WHERE S2.sid = C2.sid AND C2.pid = P2.pid
        AND P2.color = 'green'
        );

-----------------    2(c)    ------------------------
--
-- 

SELECT DISTINCT CSP.sname
FROM CatSuppliersParts CSP
WHERE 'red' IN  (
                SELECT DISTINCT CSP2.color
    FROM CatSuppliersParts CSP2
    WHERE CSP2.sid = CSP.sid
                )
    AND 'green' IN (
                                SELECT DISTINCT CSP3.color
    FROM CatSuppliersParts CSP3
    WHERE CSP3.sid = CSP.sid
                               );

-----------------    2(d)    ------------------------
--
-- 

SELECT DISTINCT CSP.sname
FROM CatSuppliersParts CSP
WHERE 2 = (
            SELECT COUNT(DISTINCT CSP2.color)
    FROM CatSuppliersParts CSP2
    WHERE CSP2.sid = CSP.sid
          )
    AND 'red' IN (
                SELECT DISTINCT CSP3.color
    FROM CatSuppliersParts CSP3
    WHERE CSP3.sid = CSP.sid
             )
    AND 'green' IN (
                SELECT DISTINCT CSP4.color
    FROM CatSuppliersParts CSP4
    WHERE CSP4.sid = CSP.sid
                );

-----------------    2(e)    ------------------------
--
-- 
SELECT DISTINCT CSP.sname
FROM CatSuppliersParts CSP
WHERE 2 = (
    SELECT COUNT(DISTINCT CSP2.color)
FROM CatSuppliersParts CSP2
WHERE CSP2.sid = CSP.sid
    );

-- 3. Repeat 2 but now for all colors (not just red and green).
-- If you can assume you don't know the names of the colors, 
-- and can't assume three only, do so. You are also required to
-- add the solution like the one shown in slide 32 of the lecture slides.
-----------------    3(a)    ------------------------
--
-- 
SELECT DISTINCT S.sname
FROM Suppliers S, Parts P, Catalogs C,
    Catalogs C2, Parts P2, Parts P3, Catalogs C3
WHERE S.sid = C.sid AND C.pid = P.pid
    AND S.sid = C2.sid AND C2.pid = P2.pid
    AND S.sid = C3.sid AND C3.pid = P3.pid
    AND (P.color = 'red' AND P2.color = 'green' AND P3.color = 'blue');

-----------------    3(b)    ------------------------
-- 
-- 
SELECT DISTINCT S.sname
FROM Suppliers S, Catalogs C, Parts P
WHERE S.sid = C.sid AND C.pid = P.pid AND P.color = 'red'
    AND S.sname IN 
        (SELECT DISTINCT S2.sname
    FROM Suppliers S2,
        Catalogs C2, Parts P2
    WHERE S2.sid = C2.sid AND C2.pid = P2.pid
        AND P2.color = 'green' AND S2.sname IN (
                                        SELECT DISTINCT S3.sname
        FROM Suppliers S3, Catalogs C3,
            Parts P3
        WHERE S3.sid = C3.sid
            AND C3.pid = P3.pid AND P3.color
                                        = 'blue'
                                        ));

-----------------    3(c)    ------------------------
-- 
-- 
SELECT DISTINCT CSP.sname
FROM CatSuppliersParts CSP
WHERE 'red' IN (SELECT DISTINCT CSP2.color
    FROM CatSuppliersParts CSP2
    WHERE CSP2.sid = CSP.sid)
    AND 'green' IN
                (
                SELECT DISTINCT CSP3.color
    FROM CatSuppliersParts CSP3
    WHERE CSP3.sid = CSP.sid AND 'blue' IN 
                (
                SELECT DISTINCT CSP4.color
        FROM CatSuppliersParts CSP4
        WHERE CSP4.sid = CSP.sid)
                );

-----------------    3(d)    ------------------------
-- 
-- 
SELECT DISTINCT CSP.sname
FROM CatSuppliersParts CSP
WHERE 3 = (
        SELECT COUNT(DISTINCT CSP2.color)
FROM CatSuppliersParts CSP2
WHERE CSP2.sid = CSP.sid
        );

-----------------    3(e)    ------------------------
-- 
-- 
SELECT DISTINCT CSP.sname
FROM CatSuppliersParts CSP
WHERE 3 = (
        SELECT COUNT(DISTINCT CSP2.color)
FROM CatSuppliersParts CSP2
WHERE CSP2.sid = CSP.sid
        );

-----------------    3(f)    ------------------------
-- 
-- 
SELECT S.sname
FROM Suppliers S
WHERE NOT EXISTS (
                SELECT P.pid
FROM Parts P
WHERE NOT EXISTS (SELECT C.pid
FROM Catalogs C
WHERE C.pid = P.pid AND C.sid = S.sid)
                );


-- 4. Find the lowest cost greater than or equal to 3 for each color 
-- that has at least 2 such items (see slide 48)
-----------------    4    ------------------------
-- 
-- 
SELECT color, MIN(cost)
FROM CatSuppliersParts
WHERE cost >= 3
GROUP BY color
HAVING COUNT(*)>1;

-- 5. Find the lowest cost greater than or equal to 3 for each color 
-- that has at least 2 items of any kind (see slide 52)
-----------------    5    ------------------------
-- 
-- 
SELECT color, MIN(cost)
FROM CatSuppliersParts
WHERE cost >= 3
GROUP BY color
HAVING 1 < (
            SELECT COUNT(*)
FROM CatSuppliersParts CSP
WHERE pid = CSP.pid
            );

-- 6. Find those cities for which the average price of items sold on 
-- the catelog is the minimum over all cities (see slide 56)
-----------------    6    ------------------------
-- 
-- 
WITH
    Temp
    AS
    (
        SELECT CSP.City, AVG(CSP.cost) AS avgcost
        FROM CatSuppliersParts CSP
        GROUP BY CSP.City
    )
SELECT Temp.City, Temp.avgcost
FROM Temp
WHERE Temp.avgcost = (
                    SELECT MIN(Temp.avgcost)
FROM Temp
                    );

-- 7. Find the part_type with the 2nd highest average cost.
-----------------    7    ------------------------
-- 
-- 
WITH
    Temp
    AS
    (
        SELECT CSP.part_type, AVG(CSP.cost) AS avgcost
        FROM CatSuppliersParts CSP
        GROUP BY CSP.City
    )
SELECT Temp.part_type
FROM Temp
WHERE Temp.avgcost < (
                    SELECT MAX(Temp.avgcost)
FROM Temp
                    )
ORDER BY avgcost ASC
LIMIT 1;