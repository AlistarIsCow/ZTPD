-- ZAD 1 

-- A

CREATE TABLE A6_LRS (Geom SDO_GEOMETRY);


-- B

SELECT sr.id, sdo_geom.sdo_length(sr.geom, 1, 'unit=km') distance
FROM STREETS_AND_RAILROADS sr, MAJOR_CITIES mj
WHERE sdo_relate(sr.geom, sdo_geom.sdo_buffer(mj.geom, 10, 1, 'unit=km'), 'MASK=ANYINTERACT') = 'TRUE'
AND mj.city_name = 'Koszalin';

INSERT INTO A6_LRS SELECT sr.geom FROM STREETS_AND_RAILROADS sr WHERE sr.id = 56;


-- C

SELECT sdo_geom.sdo_length(geom, 1, 'unit=km') distance, st_linestring(geom).st_numpoints() st_numpoionts FROM STREETS_AND_RAILROADS
WHERE id = 56;


-- D

UPDATE A6_LRS SET geom = sdo_lrs.convert_to_lrs_geom(geom, 0, 276.681);


-- E

INSERT INTO user_sdo_geom_metadata
values('A6_LRS', 'Geom', mdsys.sdo_dim_array(
                            mdsys.sdo_dim_element('X', 12.603676, 26.369824, 1),
                            mdsys.sdo_dim_element('Y', 45.8464, 58.0213, 1),
                            mdsys.sdo_dim_element('M', 0, 300, 1)), 8307);


-- F

CREATE INDEX A6_LRS_idx ON A6_LRS(Geom) indextype IS mdsys.spatial_index;


-- ZAD 2 

-- A

SELECT SDO_LRS.VALID_MEASURE(GEOM, 500) VALID_500
FROM A6_LRS;


-- B

SELECT SDO_LRS.GEOM_SEGMENT_END_PT(GEOM) END_PT
FROM A6_LRS;


-- C

SELECT sdo_lrs.locate_pt(geom, 150, 0) km_150
FROM A6_LRS;


-- D

SELECT sdo_lrs.clip_geom_segment(geom, 120, 160) seg_120_to_160
FROM A6_LRS;


-- E

SELECT sdo_lrs.get_next_shape_pt(A6.geom, mc.geom) a6_entry
FROM A6_LRS A6, major_cities mc
WHERE mc.city_name = 'Slupsk';


-- F

SELECT sdo_geom.sdo_length(sdo_lrs.offSET_geom_segment(A6.geom, m.diminfo, 50, 200, 50, 'unit=m arc_tolerance=1'), 1, 'unit=km') cost
FROM A6_LRS A6, user_sdo_geom_metadata msgm
WHERE m.table_name = 'A6_LRS'
AND m.column_name = 'GEOM';