SET SERVEROUTPUT ON SIZE 30000;

-- ZAD 1

CREATE TABLE dokumenty (id NUMBER PRIMARY KEY, dokument clob);



-- ZAD 2

DECLARE
    counter NUMBER := 10000;
    text_str VARCHAR(20) := 'Oto tekst. ';
    text_final clob;
BEGIN
    FOR i IN 1..counter
    LOOP
        text_final := concat(text_final, text_str);
    END LOOP;
    INSERT INTO dokumenty 
    VALUES (1, text_final);
END;


-- ZAD 3

SELECT * FROM dokumenty;

SELECT id, UPPER(dokument) FROM dokumenty;

SELECT id, LENGTH(dokument) AS doc_len FROM dokumenty;

SELECT id, dbms_lob.getlength(dokument) AS doc_len FROM dokumenty;

SELECT id, substr(dokument, 5, 1000) AS doc_substr FROM dokumenty;

SELECT id, dbms_lob.substr(dokument, 1000, 5) AS doc_substr FROM dokumenty;


-- ZAD 4

INSERT INTO dokumenty VALUES(2, empty_clob());


-- ZAD 5

INSERT INTO dokumenty VALUES(3, null);


-- ZAD 6

SELECT * FROM dokumenty;

SELECT id, UPPER(dokument) FROM dokumenty;

SELECT id, LENGTH(dokument) AS doc_len FROM dokumenty;

SELECT id, dbms_lob.getlength(dokument) AS doc_len FROM dokumenty;

SELECT id, substr(dokument, 5, 1000) AS doc_substr FROM dokumenty;

SELECT id, dbms_lob.substr(dokument, 1000, 5) AS doc_substr FROM dokumenty; 


-- ZAD 7.

DECLARE
    clo clob;
    bf bfile := bfilename('TPD_DIR', 'dokument.txt');
    dest_offset INTEGER := 1;
    src_offset INTEGER := 1;
    bfile_csid NUMBER := 0;
    lang_ctx INTEGER := 0;
    warn INTEGER := null;
BEGIN
    SELECT dokument 
    INTO clo 
    FROM dokumenty
    WHERE id = 2
    FOR UPDATE;
    
    dbms_lob.fileopen(bf, dbms_lob.file_readonly);
    dbms_lob.loadclobfromfile(clo, bf, dbms_lob.lobmaxsize, dest_offset, src_offset, bfile_csid, lang_ctx, warn);
    dbms_lob.fileclose(bf);
    COMMIT;
    
    dbms_output.put_line('Status operacji ' || warn);
END;


-- ZAD 8

UPDATE dokumenty SET dokument = to_clob(bfilename('TPD_DIR', 'dokument.txt')) WHERE id = 3;


-- ZAD 9

SELECT * FROM dokumenty;


-- ZAD 10

SELECT id, dbms_lob.getlength(dokument) AS doc_len FROM dokumenty;


-- ZAD 11

DROP TABLE dokumenty;


-- ZAD 12

CREATE OR REPLACE PROCEDURE clob_censor(cl IN OUT clob, to_replace VARCHAR2)
IS
    dots VARCHAR(255);
    to_replace_size INTEGER := LENGTH(to_replace);
    position INTEGER := 10000;
    nth_occurence INTEGER := 1;
BEGIN
    FOR i IN 1..to_replace_size
    LOOP
        dots := concat(dots, '.');
    END LOOP;

    LOOP
        position := dbms_lob.instr(cl, to_replace, 1, nth_occurence);
        
        exit when position = 0;
        
        dbms_lob.write(cl, to_replace_size, position, dots);
        nth_occurence := nth_occurence + 1;
    END LOOP;
END clob_censor;


-- ZAD 13

CREATE TABLE biographies AS SELECT * FROM ztpd.biographies;

SELECT * FROM biographies;

DECLARE
    cl clob;
BEGIN
    SELECT bio
    INTO cl
    FROM biographies
    WHERE id = 1
    FOR UPDATE;

    clob_censor(cl, 'Cimrman');
    
    COMMIT;
END;


-- ZAD 14

DROP TABLE biographies;