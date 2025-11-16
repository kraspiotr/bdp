CREATE TABLE obiekty (
	id SERIAL PRIMARY KEY,
	nazwa VARCHAR(50),
	geom GEOMETRY
);

-- obiekt1
INSERT INTO obiekty (nazwa, geom)
VALUES (
    'obiekt1',
    ST_GeomFromText(
		'COMPOUNDCURVE(
			(0 1, 1 1), 
			CIRCULARSTRING(1 1, 2 0, 3 1), 
			CIRCULARSTRING(3 1, 4 2, 5 1),
			(5 1, 6 1))', 0)
);

-- obiekt2
INSERT INTO obiekty (nazwa, geom)
VALUES (
    'obiekt2',
    ST_Collect(
        ST_CurveToLine(
            ST_GeomFromText(
                'COMPOUNDCURVE(
                    (10 2, 10 6),
                    (10 6, 14 6),
                    CIRCULARSTRING(14 6, 16 4, 14 2),
                    CIRCULARSTRING(14 2, 12 0, 10 2)
                )',
                0
            )
        ),
        ST_ExteriorRing(
            ST_Buffer(ST_MakePoint(12, 2), 1)
        )
    )
);


-- obiekt3
INSERT INTO obiekty (nazwa, geom)
VALUES ('obiekt3',
    ST_GeomFromText('POLYGON((7 15, 10 17, 12 13, 7 15))', 0)
);

-- obiekt4
INSERT INTO obiekty (nazwa, geom)
VALUES (
    'obiekt4',
    ST_GeomFromText(
        'LINESTRING(20.5 19.5, 22 19, 26 21, 25 22, 27 24, 25 25, 20 20)',0)
);

-- obiekt5
INSERT INTO obiekty (nazwa, geom)
VALUES (
    'obiekt5',
    ST_GeomFromText('GEOMETRYCOLLECTIONZ(POINTZ(30 30 59), POINTZ(38 32 234))', 0)
);

-- obiekt6
INSERT INTO obiekty (nazwa, geom)
VALUES (
    'obiekt6',
    ST_GeomFromText('GEOMETRYCOLLECTION(LINESTRING(1 1, 3 2), POINT(4 2))', 0)
);

-- zadanie2
SELECT
	ST_Area(
		ST_Buffer(
			ST_ShortestLine(
				(SELECT geom FROM obiekty WHERE nazwa = 'obiekt3'),
				(SELECT geom FROM obiekty WHERE nazwa = 'obiekt4')
			),
			5
		)
	) AS pole_bufora_najkrotszej_linii

-- zadanie3
-- najpierw domykam geometrię dodając punkt początkowy na końcu
UPDATE obiekty
SET geom = ST_AddPoint(geom, ST_StartPoint(geom))
WHERE nazwa = 'obiekt4';
--zmieniam na poligon
UPDATE obiekty
SET geom = ST_MakePolygon(geom)
WHERE nazwa = 'obiekt4';

-- zadanie4
-- tworzę geometryczną sumę (ST_Union)
INSERT INTO obiekty (nazwa, geom)
VALUES (
	'obiekt7',
	ST_Union(
		(SELECT geom FROM obiekty WHERE nazwa = 'obiekt3'),
		(SELECT geom FROM obiekty WHERE nazwa = 'obiekt4')
	)
);

--zadanie5
SELECT
	SUM(ST_Area(ST_Buffer(geom, 5))) AS suma_pol_bez_lukow
FROM obiekty
WHERE ST_HasArc(geom) IS FALSE