--3. Połącz te dane (wszystkie kafle) w mozaikę, a następnie wyeksportuj jako GeoTIFF
WITH mozaika AS (
SELECT ST_Union(rast) AS rast_union
FROM uk_250k
)
SELECT ST_AsGDALRaster(rast_union, 'GTiff')
FROM mozaika;
--6. Utwórz nową tabelę o nazwie uk_lake_district, do której zaimportujesz mapy rastrowe 
--z punktu 1., które zostaną przycięte do granic parku narodowego Lake District.
CREATE TABLE uk_late_district (
rid serial PRIMARY KEY,
rast raster
);
INSERT INTO uk_lake_district (rast)
SELECT ST_Clip(t.rast, g.wkb_geometry, TRUE)
FROM
	uk_250k AS t,
	granice_parkow AS g
WHERE g.id = 1
AND ST_Intersects(t.rast, g.wkb_geometry);
--7. Wyeksportuj wyniki do pliku GeoTIFF.
WITH mozaika AS (
SELECT ST_Union(rast) AS rast_union
FROM uk_lake_district
)
SELECT ST_AsGDALRaster(
rast_union,
'GTiff'
)
FROM mozaika;
--10. Policz indeks NDWI oraz przytnij wyniki do granic Lake District
SELECT
    ST_Clip(
        ST_MapAlgebra(
            b8.rast,
            b4.rast, 
            '([rast1.val - rast2.val]) / ([rast1.val + rast2.val])'
        ),
        g.wkb_geometry,
        TRUE 
    ) AS nd_clipped_rast3
INTO uk_lake_district_indeks3 
FROM
    s2_b8_2 b8, 
    s2_b4_2 b4,  
    granice_parkow g
WHERE
    g.id = 1 
    AND ST_Intersects(b8.rast, b4.rast)
    AND ST_Intersects(b8.rast, g.wkb_geometry);


SELECT ST_AsGDALRaster(
    ST_Union(nd_clipped_rast3),
    'GTiff'
) AS raster_output
FROM uk_lake_district_indeks3;


