create or replace procedure DISTINCT_GRAINATTR as
  counterStatic number := 30000;

begin
  UPDATE_GRAINATTR(counterStatic);
  DELETE_GRAINATTR(counterStatic);
end DISTINCT_GRAINATTR;
/
