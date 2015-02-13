create or replace procedure TEST_SEQUN is
  resultStr    varchar2(8);
  sql_SEQUENCE varchar2(4000) := 'CREATE SEQUENCE SZLA.';
begin
  sql_SEQUENCE := sql_SEQUENCE || 'SEQ_FOODLEIBIE' ||
                  'START WITH 10001 MAXVALUE 999999999999999999999999999 MINVALUE 1 NOCYCLE CACHE 20 NOORDER';
  execute immediate sql_SEQUENCE;
  --Drop_create_SEQUENCE('SEQ_FOODLEIBIE', 10000, resultStr);
  --if (resultStr = result_ok)
end TEST_SEQUN;
/
