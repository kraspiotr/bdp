DROP TABLE IF EXISTS wyniki;
CREATE TABLE wyniki AS 
SELECT ST_Union(rast) AS rast
FROM public."Exports";


SELECT count(*) FROM wyniki;
