-- A.

CREATE TABLE FIGURY( id NUMBER, ksztalt mdsys.sdo_geometry);

-- B.

INSERT INTO FIGURY VALUES (1, mdsys.sdo_geometry(
                                2003, NULL, NULL,
                                mdsys.sdo_elem_info_array(1, 1003, 4),
                                mdsys.sdo_ordinate_array(5,7,  7,5,  3,5)
                                ));

INSERT INTO FIGURY VALUES (2, mdsys.sdo_geometry(
                                2003, NULL, NULL,
                                mdsys.sdo_elem_info_array(1, 1003, 3),
                                mdsys.sdo_ordinate_array(1,1,  5,5)
                                ));

INSERT INTO FIGURY VALUES (3, mdsys.sdo_geometry(
                                2002, NULL, NULL,
                                mdsys.sdo_elem_info_array(1,4,2,  1,2,1,  5,2,2),
                                mdsys.sdo_ordinate_array(3,2,  6,2,  7,3,  8,2,  7,1)
                                ));

DELETE FROM FIGURY WHERE id=3;

-- C.

INSERT INTO FIGURY VALUES (4, mdsys.sdo_geometry(
                                2003, NULL, NULL,
                                mdsys.sdo_elem_info_array(1, 1003, 4),
                                mdsys.sdo_ordinate_array(2,1,  3,1,  7,1)
                                ));

-- D.

SELECT id, sdo_geom.validate_geometry_with_context(ksztalt, 0.01) AS val FROM FIGURY;

-- E.

DELETE FROM FIGURY WHERE sdo_geom.validate_geometry_with_context(ksztalt, 0.01) <> 'TRUE';

SELECT * FROM FIGURY;

-- F.

COMMIT;
