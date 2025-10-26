CREATE EXTENSION postgis;

create table nowe_budynki as
select t2019_kar_buildings.*
from t2019_kar_buildings
left join t2018_kar_buildings
on st_equals(t2019_kar_buildings.geom, t2018_kar_buildings.geom)
where t2018_kar_buildings.geom is null;

create table new_pois as
select t2019_kar_poi_table.*
from t2019_kar_poi_table
left join t2018_kar_poi_table
on st_equals(t2019_kar_poi_table.geom, t2018_kar_poi_table.geom)
where t2018_kar_poi_table.geom is null;

create table nowe_poi_w_promieniu500 as
select new_pois.*
from new_pois
join nowe_budynki
on st_dwithin(new_pois.geom, nowe_budynki.geom, 500);

select type, count(*) as liczba_poi
from nowe_poi_w_promieniu500
group by type
order by liczba_poi desc;

create table streets_reprojected as
select gid, st_name, st_transform(geom, 3068) as geom
from t2019_kar_streets;

create table input_points (id serial primary key, geom geometry(point, 4326));
insert into input_points (geom)
values
(st_setsrid(st_makepoint(8.36093, 49.03174), 4326)),
(st_setsrid(st_makepoint(8.39876, 49.00644), 4326));

alter table input_points
alter column geom type geometry(point, 3068)
using st_transform(geom, 3068);
select id, st_srid(geom), st_astext(geom)
from input_points;


create table skrzyzowania as
select n.*
from ( select st_makeline(geom order by id) as geom_line
	   from input_points) as l
	   join t2019_kar_street_node as n
	   on st_dwithin( st_transform(n.geom, 3068),
	   	  l.geom_line, 200);

select count(*) from skrzyzowania;


select count(*) as liczba_sklepow_sportowych
from t2019_kar_poi_table as poi
join t2019_kar_land_use_a as parks
on st_dwithin(
st_transform(poi.geom, 3068), st_transform(parks.geom, 3068), 300)
where poi.type = 'Sporting Goods Store';


create table t2019_kar_bridges as
select st_intersection(st_transform(r.geom,3068), st_transform(w.geom, 3068)) as geom
from t2019_kar_railways as r
join t2019_kar_water_lines as w
on st_intersects(st_transform(r.geom,3068), st_transform(w.geom, 3068))
where geometrytype(st_intersection(st_transform(r.geom,3068), st_transform(w.geom, 3068)))
in ('POINT', 'MULTIPOINT');
select st_astext(geom)
from t2019_kar_bridges
limit 10;
