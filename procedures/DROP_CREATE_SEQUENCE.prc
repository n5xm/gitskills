create or replace procedure DROP_CREATE_SEQUENCE(procName  in varchar2,
                                                 startWith in number,
                                                 resultStr out varchar2) as
  --引用user_tables表中的tableName的类型;  
  sequenceName user_sequences.sequence_name%type;
  mycount      number(10);
  result_ok    varchar(8) := 'ok';
  result_error varchar(8) := 'error';
begin
  --把存储过程传过来的参数，赋值给tableName;  
  sequenceName := procName;
  SELECT COUNT(*)
    INTO mycount
    FROM user_sequences
   WHERE sequence_name = sequenceName;
  SAVEPOINT sp;
  if mycount > 0 then
    execute immediate 'DROP SEQUENCE ' || sequenceName;
    DBMS_OUTPUT.PUT_LINE('DROP SEQUENCE ' || sequenceName);
  end if;
  execute immediate 'create sequence ' || sequenceName ||
                    ' minvalue 1 maxvalue 999999999999999 start with ' ||
                    startWith || ' increment by 1 nocache cycle';
  DBMS_OUTPUT.PUT_LINE('CREATE SEQUENCE ' || sequenceName);
  resultStr := result_ok;
EXCEPTION
  WHEN OTHERS THEN
    resultStr := result_error;
    --ROLLBACK TO SAVEPOINT sp;
end;
/
