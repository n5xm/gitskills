create or replace procedure DISTINCT_GRAIN as
  counterStatic number := 30000;

begin
  UPDATE_GRAIN(counterStatic);
  DELETE_GRAIN(counterStatic);
end DISTINCT_GRAIN;
/
