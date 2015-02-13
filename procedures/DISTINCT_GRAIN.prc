create or replace procedure DISTINCT_GRAIN as
  counterStatic number := 30000;
  counterLast   number;
begin
  UPDATE_GRAIN(counterStatic, counterLast);
  DELETE_GRAIN(counterStatic, counterLast);
end DISTINCT_GRAIN;
/
