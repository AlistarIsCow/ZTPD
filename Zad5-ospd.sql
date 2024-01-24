-- ZAD 1 

-- A

INSERT INTO user_sdo_geom_metadata
VALUES('figury', 'ksztalt', mdsys.sdo_dim_array(
                                mdsys.sdo_dim_element('x', 0, 10, 0.01),
                                mdsys.sdo_dim_element('y', 0, 10, 0.01)
                            ), NULL);

SELECT * FROM user_sdo_geom_metadata;

-- B

SELECT sdo_tune.estimate_rtree_index_size(3000000, 8192, 10, 2, 0) FROM figury;

-- C

CREATE INDEX figury_spatial_idx ON figury(ksztalt) indextype is mdsys.spatial_index_v2;

-- D

SELECT id FROM figury WHERE sdo_filter(ksztalt, sdo_geometry(
                                                    2001, NULL, 
                                                    sdo_point_type(3, 3, NULL), 
                                                    NULL, NULL
                                                )) = 'TRUE';

-- E

SELECT id FROM figury WHERE sdo_relate(ksztalt, sdo_geometry(
                                                    2001, NULL, 
                                                    sdo_point_type(3, 3, NULL), 
                                                    NULL, NULL
                                                ), 'mask=anyinteract') = 'TRUE';

-- ZAD 2 

-- A

SELECT a.city_name miasto, sdo_nn_distance(1) distance FROM major_cities a, major_cities b
WHERE a.city_name <> 'Warsaw' 
AND b.city_name = 'Warsaw'
AND sdo_nn(a.geom, b.geom, 'sdo_num_res=10 unit=km', 1) = 'TRUE';


-- B

SELECT a.city_name miasto FROM major_cities a, major_cities b
WHERE a.city_name <> 'Warsaw' 
AND b.city_name = 'Warsaw'
AND sdo_within_distance(a.geom, b.geom, 'distance=100 unit=km') = 'TRUE';

-- C

SELECT a.cntry_name, b.city_name FROM country_boundaries a, major_cities b
WHERE sdo_relate(b.geom, a.geom, 'mask=INSIDE') = 'TRUE'
AND a.cntry_name = 'Slovakia';

-- D

SELECT b.cntry_name, sdo_geom.sdo_distance(a.geom, b.geom, 1, 'unit=km')
FROM country_boundaries a, country_boundaries b
WHERE a.cntry_name = 'Poland' 
AND sdo_relate(b.geom, a.geom, 'mask=ANYINTERACT'
) <> 'TRUE';

-- ZAD 3 

-- A

SELECT a.cntry_name, sdo_geom.sdo_length(sdo_geom.sdo_intersection(a.geom, b.geom, 1), 1, 'unit=km') len
FROM country_boundaries a,  country_boundaries b
WHERE b.cntry_name = 'Poland'
AND a.cntry_name <> 'Poland'
AND sdo_filter(a.geom, b.geom) = 'TRUE';

-- B

SELECT a.cntry_name
FROM country_boundaries a
WHERE sdo_geom.sdo_area(a.geom) = (
    SELECT MAX(sdo_geom.sdo_area(geom)) FROM country_boundaries
);

-- C

SELECT sdo_geom.sdo_area(sdo_geom.sdo_mbr(sdo_geom.sdo_union(a.geom, b.geom, 0.01)), 1, 'unit=SQ_KM') min_mbr_area
FROM major_cities a, major_cities b
WHERE a.city_name = 'Warsaw'
AND b.city_name = 'Lodz';

-- D

SELECT sdo_geom.sdo_union(a.geom, b.geom, 0.01).sdo_gtype geom_type
FROM major_cities a, country_boundaries b
WHERE a.city_name = 'Prague'
AND b.cntry_name = 'Poland';

-- E

SELECT a.city_name, b.cntry_name
FROM major_cities a,  country_boundaries b
WHERE sdo_geom.sdo_distance(sdo_geom.sdo_centroid(b.geom, 1), a.geom, 1, 'unit=km') = (SELECT MIN(
    sdo_geom.sdo_distance(sdo_geom.sdo_centroid(b.geom, 1), a.geom, 1, 'unit=km'))
    FROM major_cities a,  country_boundaries b);

-- F

SELECT c.name, SUM(c.len) AS sum_len
FROM(SELECT a.name, sdo_geom.sdo_length(sdo_geom.sdo_intersection(b.geom, a.geom, 1), 1, 'unit=km') AS len
    FROM rivers a, country_boundaries b
    WHERE b.cntry_name = 'Poland' 
    AND sdo_relate(a.geom, b.geom, 'mask=ANYINTERACT') = 'TRUE') c
GROUP BY c.name;

