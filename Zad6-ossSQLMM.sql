-- ZAD 1 

-- A

select lpad('-',2*(level-1),'|-') || t.owner||'.'||t.type_name||' (FINAL:'||t.final||
', INSTANTIABLE:'||t.instantiable||', ATTRIBUTES:'||t.attributes||', METHODS:'||t.methods||')'
from all_types t
start with t.type_name = 'ST_GEOMETRY'
connect by prior t.type_name = t.supertype_name
and prior t.owner = t.owner;


-- B 

SELECT DISTINCT m.method_name FROM all_type_methods m
WHERE m.type_name LIKE 'ST_POLYGON'
AND m.owner = 'MDSYS' ORDER BY 1;


-- C

CREATE TABLE myst_major_cities(fips_cntry VARCHAR(2), city_name VARCHAR2(40), stgeom st_point);


-- D

INSERT INTO myst_major_cities(fips_cntry, city_name, stgeom)
SELECT mc.FIPS_CNTRY, mc.CITY_NAME, st_point(mc.GEOM) FROM major_cities mc;


-- ZAD 2 

INSERT INTO myst_major_cities VALUES('PL', 'Szczyrk', st_point(19.036107, 49.718655, 8307));

-- ZAD 3 

-- A

CREATE TABLE MYST_COUNTRY_BOUNDARIES (FIPS_CNTRY VARCHAR2(2), CNTRY_NAME VARCHAR2(40), STGEOM ST_MULTIPOLYGON);


-- B

INSERT INTO MYST_COUNTRY_BOUNDARIES(FIPS_CNTRY, CNTRY_NAME, STGEOM)
SELECT cb.FIPS_CNTRY, cb.CNTRY_NAME, ST_MULTIPOLYGON(cb.GEOM) FROM COUNTRY_BOUNDARIES cb;


-- C

SELECT B.STGEOM.ST_GEOMETRYTYPE() STGTYPE, COUNT(*) AS count FROM MYST_COUNTRY_BOUNDARIES B
GROUP BY B.STGEOM.ST_GEOMETRYTYPE();


-- D

SELECT B.STGEOM.ST_GEOMETRYTYPE() STGTYPE, B.STGEOM.ST_ISSIMPLE() IS_SIMPLE FROM MYST_COUNTRY_BOUNDARIES B;


-- ZAD 4 

-- A

SELECT cb.cntry_name, COUNT(*) AS count FROM myst_major_cities mc, myst_country_boundaries cb
WHERE cb.stgeom.st_contains(mc.stgeom) = 1
GROUP BY cb.cntry_name;


-- B

SELECT  cb1.cntry_name, cb2.cntry_name FROM myst_country_boundaries cb1, myst_country_boundaries cb2
WHERE b1.stgeom.st_touches(cb2.stgeom) = 1
AND cb1.cntry_name = 'Czech Republic';


-- C

SELECT DISTINCT cb.cntry_name, r.name FROM myst_country_boundaries cb, rivers r
WHERE cb.stgeom.st_intersects(st_linestring(r.geom)) = 1
AND cb.cntry_name = 'Czech Republic';


-- D

SELECT ROUND(treat(cb1.stgeom.st_union(cb2.stgeom) AS st_polygon).st_area()) AS czechoslovakia_area FROM myst_country_boundaries cb1, myst_country_boundaries cb2
WHERE cb1.cntry_name = 'Czech Republic'
AND cb2.cntry_name = 'Slovakia';

-- E

SELECT  cb.stgeom AS hungary, 
        cb.stgeom.st_geometrytype() AS hungary_geomtype,
        cb.stgeom.st_difference(st_geometry(wb.geom)) AS hungary_without_balaton,
        cb.stgeom.st_difference(st_geometry(wb.GEOM)).st_geometrytype() AS hungary_without_balaton_geomtype FROM    myst_country_boundaries cb, water_bodies wb
WHERE   cb.cntry_name = 'Hungary'
AND     wb.name = 'Balaton';


-- ZAD 5 

-- A

explain plan FOR
SELECT cb.cntry_name, COUNT(*) count_cities FROM myst_country_boundaries cb, myst_major_cities mc
WHERE cb.cntry_name = 'Poland'
AND sdo_within_distance(cb.stgeom, mc.stgeom, 'distance=100 unit=km') = 'TRUE'
GROUP BY cb.cntry_name;


-- B

SELECT * FROM all_sdo_geom_metadata;

INSERT INTO user_sdo_geom_metadata
SELECT 'myst_major_cities', 'stgeom', T.diminfo, T.srid FROM all_sdo_geom_metadata T
WHERE table_name = 'MAJOR_CITIES';



-- C

CREATE INDEX myst_major_cities_idx ON myst_major_cities(stgeom) indextype IS mdsys.spatial_index;

-- D

explain plan FOR
SELECT cb.cntry_name, count(*) count_cities
FROM myst_country_boundaries cb, myst_major_cities mc
WHERE cb.cntry_name = 'Poland'
AND sdo_within_distance(cb.stgeom, mc.stgeom, 'distance=100 unit=km') = 'TRUE'
GROUP BY cb.cntry_name;

SELECT plan_table_output FROM TABLE(dbms_xplan.display);