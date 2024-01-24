-- ZAD 1

CREATE TABLE cytaty AS SELECT * FROM ztpd.cytaty;


-- ZAD 2

SELECT autor, tekst FROM cytaty
WHERE lower(tekst) LIKE '%optymista%'
AND lower(tekst) LIKE '%pesymista%';


-- ZAD 3

CREATE INDEX cytaty_idx ON cytaty (tekst) INDEXTYPE IS ctxsys.context;
        

-- ZAD 4

SELECT autor, tekst FROM cytaty WHERE contains(tekst, 'optymista and pesymista') > 0;


-- ZAD 5

SELECT autor, tekst FROM cytaty WHERE contains(tekst, 'pesymista ~ optymista') > 0;


-- ZAD 6

SELECT autor, tekst FROM cytaty WHERE contains(tekst, 'near((optymista, pesymista), 3)') > 0;


-- ZAD 7

SELECT autor, tekst FROM cytaty WHERE contains(tekst, 'near((optymista, pesymista), 10)') > 0;
    

-- ZAD 8

SELECT autor, tekst FROM cytaty WHERE contains(tekst, 'życi%') > 0;


-- ZAD 9

SELECT autor, tekst, contains(tekst, 'życi%') score FROM cytaty WHERE contains(tekst, 'życi%') > 0;


-- ZAD 10

SELECT autor, tekst, contains(tekst, 'życi%') dopasowanie FROM cytaty WHERE contains(tekst, 'życi%') > 0 AND ROWNUM <= 1
ORDER BY dopasowanie DESC;


-- ZAD 11

SELECT autor, tekst FROM cytaty WHERE contains(tekst, 'fuzzy(‘problem’)') > 0;


-- ZAD 12

INSERT INTO cytaty VALUES(39, 'Bertrand Russell','To smutne, że głupcy są tacy pewni siebie, a ludzie rozsądni tacy pełni wątpliwości.');
COMMIT;


-- ZAD 13

SELECT autor, tekst FROM cytaty WHERE contains(tekst, 'głupcy') > 0;


-- ZAD 14

SELECT * FROM dr$cytaty_idx$i WHERE token_text = 'głupcy';


-- ZAD 15

DROP INDEX cytaty_idx;
CREATE INDEX cytaty_idx ON cytaty (tekst) INDEXTYPE IS ctxsys.context;


-- ZAD 16

SELECT autor, tekst FROM cytaty WHERE contains(tekst, 'głupcy') > 0;
    

-- ZAD 17

DROP INDEX cytaty_idx;
DROP TABLE cytaty;


-- ZAD 1

CREATE TABLE quotes AS SELECT * FROM ztpd.quotes;


-- ZAD 2

CREATE INDEX quotes_idx ON quotes (text) INDEXTYPE IS ctxsys.context;


-- ZAD 3

SELECT * FROM quotes WHERE contains(text, 'work') > 0;
SELECT * FROM quotes WHERE contains(text, '$work') > 0;
SELECT * FROM quotes WHERE contains(text, 'working') > 0;
SELECT * FROM quotes WHERE contains(text, '$working') > 0;


-- ZAD 4

SELECT * FROM quotes WHERE contains(text, 'it') > 0;
    

-- ZAD 5

SELECT * FROM ctx_stoplists;


-- ZAD 6

SELECT * FROM ctx_stopwords;
    

-- ZAD 7

DROP INDEX quotes_idx;
CREATE INDEX quotes_idx ON quotes(text) INDEXTYPE IS ctxsys.context PARAMETERS ( 'stoplist CTXSYS.EMPTY_STOPLIST' );


-- ZAD 8 

SELECT * FROM quotes WHERE contains(text, 'it') > 0; --Yes
    

-- ZAD 9

SELECT * FROM quotes WHERE contains(text, 'fool and humans') > 0;


-- ZAD 10

SELECT * FROM quotes WHERE contains(text, 'fool and computer') > 0;
    

-- ZAD 11

SELECT * FROM quotes WHERE contains(text, '(fool and humans) within sentence') > 0;
    

-- ZAD 12

DROP INDEX quotes_idx;


-- ZAD 13

BEGIN
    ctx_ddl.create_section_group('nullgroup', 'NULL_SECTION_GROUP');
    ctx_ddl.add_special_section('nullgroup', 'SENTENCE');
    ctx_ddl.add_special_section('nullgroup', 'PARAGRAPH');
END;


-- ZAD 14

CREATE INDEX quotes_idx ONquotes (text) INDEXTYPE IS ctxsys.context PARAMETERS ( 'section group nullgroup' );


-- ZAD 15

SELECT * FROM quotes WHERE contains(text, '(fool and humans) within sentence') > 0;
SELECT * FROM quotes WHERE contains(text, '(fool and computer) within sentence') > 0;
    

-- ZAD 16

SELECT * FROM quotes WHERE contains(text, 'humans') > 0;
    

-- ZAD 17

DROP INDEX quotes_idx;

BEGIN
    ctx_ddl.create_preference('lex_z_m', 'BASIC_LEXER');
    ctx_ddl.set_attribute('lex_z_m', 'printjoins', '_-');
    ctx_ddl.set_attribute('lex_z_m', 'index_text', 'YES');
END;

CREATE INDEX quotes_idx ON quotes (text) INDEXTYPE IS ctxsys.context PARAMETERS ( 'lexer lex_z_m' );
        

-- ZAD 18 

SELECT * FROM quotes WHERE contains(text, 'humans') > 0; --No



-- ZAD 19

SELECT * FROM quotes WHERE contains(text, 'non\-humans') > 0;


-- ZAD 20

DROP INDEX quotes_idx;
DROP TABLE quotes;