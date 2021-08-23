DROP TABLE Suppliers;
CREATE TABLE Suppliers
(
    sid CHAR,
    sname CHAR,
    address CHAR,
    City CHAR
);
INSERT INTO Suppliers
VALUES
    ('s1', 'BestBuy', '52 Granite St', 'Somers');
INSERT INTO Suppliers
VALUES
    ('s2', 'Walmart', '14 Evergreen St', 'Yorktown');
INSERT INTO Suppliers
VALUES
    ('s3', 'Officemax', '221 Jackson St', 'Somers');
INSERT INTO Suppliers
VALUES
    ('s4', 'Target', '55 Evergreen St', 'Yorktown');
INSERT INTO Suppliers
VALUES
    ('s5', 'B&H', '33 Parker Ave', 'Scardsdale');
INSERT INTO Suppliers VALUES 
    ('s6',"Macy's",'21 Granite St','Somers');
INSERT INTO Suppliers VALUES 
    ('s8','BJ','41 Evergreen St','Peekskill');

DROP TABLE Parts;
CREATE TABLE Parts
(
    pid CHAR,
    pname CHAR,
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
    ('pr3', '16GB usb', 'red');
INSERT INTO Parts
VALUES
    ('pg1', 'usb 4GB', 'green');
INSERT INTO Parts
VALUES
    ('pg2', '4GB usb', 'green');
INSERT INTO Parts
VALUES
    ('pb1', '32GB usb', 'blue');
    
DROP TABLE Catalog;
CREATE TABLE Catalog (sid CHAR, pid CHAR, cost INT);
INSERT INTO Catalog VALUES ('s1','pr1',1);
INSERT INTO Catalog VALUES ('s1','pr3',5);
INSERT INTO Catalog VALUES ('s1','pg2',3);
INSERT INTO Catalog VALUES ('s2','pr1',6);
INSERT INTO Catalog VALUES ('s2','pr2',2);
INSERT INTO Catalog VALUES ('s2','pr3',4);
INSERT INTO Catalog VALUES ('s2','pg1',2);
INSERT INTO Catalog VALUES ('s2','pg2',2);
INSERT INTO Catalog VALUES ('s2','pb1',1);
INSERT INTO Catalog VALUES ('s3','pg1',6);
INSERT INTO Catalog VALUES ('s3','pr1',5);
INSERT INTO Catalog VALUES ('s4','pg2',3);
INSERT INTO Catalog VALUES ('s4','pr1',1);
INSERT INTO Catalog VALUES ('s5','pr2',1);
INSERT INTO Catalog VALUES ('s5','pr3',2);
INSERT INTO Catalog VALUES ('s6','pb1',1);
INSERT INTO Catalog VALUES ('s6','pr1',3);
INSERT INTO Catalog VALUES ('s8','pr1',2);

.mode column 
.header on 

SELECT DISTINCT S.City, 
    COUNT (CASE WHEN substr(P.pname, instr(P.pname,'GB')-1,3) = '4GB' AND P.color = 'red' THEN '4GB' END) AS '4GB - red',
    COUNT (CASE WHEN substr(P.pname, instr(P.pname,'GB')-1,3) = '4GB' AND P.color = 'green' THEN '4GB' END) AS '4GB - green',
    COUNT (CASE WHEN substr(P.pname, instr(P.pname,'GB')-1,3) = '4GB' AND P.color = 'blue' THEN '4GB' END) AS '4GB - blue',
    COUNT (CASE WHEN substr(P.pname, instr(P.pname,'GB')-2,4) = '16GB' AND P.color = 'red' THEN '16GB' END) AS '16GB - red',
    COUNT (CASE WHEN substr(P.pname, instr(P.pname,'GB')-2,4) = '16GB' AND P.color = 'green' THEN '16GB' END) AS '16GB - green',
    COUNT (CASE WHEN substr(P.pname, instr(P.pname,'GB')-2,4) = '16GB' AND P.color = 'blue' THEN '16GB' END) AS '16GB - blue',
    COUNT (CASE WHEN substr(P.pname, instr(P.pname,'GB')-2,4) = '32GB' AND P.color = 'red' THEN '32GB' END) AS '32GB - red',
    COUNT (CASE WHEN substr(P.pname, instr(P.pname,'GB')-2,4) = '32GB' AND P.color = 'green' THEN '32GB' END) AS '32GB - green',
    COUNT (CASE WHEN substr(P.pname, instr(P.pname,'GB')-2,4)= '32GB' AND P.color = 'blue' THEN '32GB' END) AS '32GB - blue'
FROM Suppliers S, Parts P, Catalog C
WHERE S.sid = C.sid AND C.pid = P.pid
GROUP BY S.City;

DROP VIEW CSP;
GO
CREATE VIEW CSP AS
SELECT * FROM Catalog C
LEFT JOIN Suppliers S
ON C.sid = S.sid
LEFT JOIN Parts P 
ON C.pid = P.pid;
GO

SELECT DISTINCT A.City FROM CSP A, CSP B, CSP C, CSP D 
WHERE A.City = B.City AND B.color = 'red' AND A.City = C.City AND C.color = 'green'
AND A.City = D.City AND D.color = 'blue';

SELECT DISTINCT S.City
FROM Suppliers S, Parts P, Catalog C
WHERE S.sid = C.sid AND P.pid=C.pid AND P.color = 'red'
    AND S.City IN (
SELECT S2.sid
    FROM Suppliers S2, Parts P2, Catalog C2
    WHERE S2.sid = C2.sid AND P2.pid=C2.pid AND P2.color = 'green'
)
    AND S.City IN (
SELECT S3.sid
    FROM Suppliers S3, Parts P3, Catalog C3
    WHERE S3.sid = C3.sid AND P3.pid=C3.pid AND P3.color = 'blue'
);

SELECT DISTINCT C.City
FROM CSP C
WHERE (SELECT COUNT(DISTINCT(p1.color)) 
FROM parts p1) = (SELECT COUNT(DISTINCT(C2.color))
FROM CSP C2
WHERE C2.City=C.City);

WITH
    CP
    AS
    (
        SELECT c1.sid, p1.color, S.City
        FROM catalog c1, parts p1, Suppliers S
        WHERE c1.pid=p1.pid
    )
SELECT DISTINCT S.City
FROM Suppliers S
WHERE NOT EXISTS (SELECT P.color
FROM Parts P
WHERE NOT EXISTS (SELECT C.color
FROM CP C
WHERE C.color = P.color AND C.City = S.City AND C.sid = S.sid));

