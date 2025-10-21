create extension postgis;
select PostGIS_Version();


create table buildings (
id serial primary key,
geometry geometry,
name text
);

create table roads (
id serial primary key,
geometry geometry,
name text
);

create table poi (
id serial primary key,
geometry geometry,
name text
);

insert into buildings (name, geometry) values
('BuildingA', st_geomfromtext('polygon((8 1.5, 8 4, 10.5 4, 10.5 1.5, 8 1.5))')),
('BuildingB', st_geomfromtext('polygon((4 5, 4 7, 6 7, 6 5, 4 5))')),
('BuildingC', st_geomfromtext('polygon((3 6, 3 8, 5 8, 5 6, 3 6))')),
('BuildingD', st_geomfromtext('polygon((9 8, 9 9, 10 9, 10 8, 9 8))')),
('BuildingF', st_geomfromtext('polygon((1 1, 1 2, 2 2, 2 1, 1 1))'));

insert into roads (name, geometry) values
('RoadX', st_geomfromtext('linestring(0 4.5, 12 4.5)')),
('RoadY', st_geomfromtext('linestring(7.5 0, 7.5 10.5)'));

insert into poi (name, geometry) values
('G', st_geomfromtext('point(1 3.5)')),
('H', st_geomfromtext('point(5.5 1.5)')),
('I', st_geomfromtext('point(9.5 6)')),
('J', st_geomfromtext('point(6.5 6)')),
('K', st_geomfromtext('point(6 9.5)'));


select
sum(st_length(geometry)) as total_length
from roads;

select
st_astext(geometry) as wkt,
st_area(geometry) as pole_powierzchni,
st_perimeter(geometry) as obwod
from buildings
where name='BuildingA';

select name, st_area(geometry) as pole_powierzchni
from buildings
order by name;

select name, st_perimeter(geometry) as obwod
from buildings
order by st_area(geometry) desc
limit 2;

select st_distance(b.geometry, p.geometry) as distance
from buildings b, poi p
where b.name = 'BuildingC' and p.name = 'K';

select st_area(st_difference(bC.geometry, st_buffer(bB.geometry, 0.5))) as pole_powierzchni
from buildings bC, buildings bB
where bC.name = 'BuildingC' and bB.name = 'BuildingB';


select b.name
from buildings b, roads r
where r.name = 'RoadX'
and st_y(st_centroid(b.geometry)) > st_y(st_centroid(r.geometry));

with nowy_poligon as (select st_geomfromtext('polygon((4 7, 6 7, 6 8, 4 8, 4 7))') as poligon)
select st_area(st_symdifference(b.geometry, n.poligon)) as nie_wspolne
from buildings b, nowy_poligon n
where b.name = 'BuildingC';


