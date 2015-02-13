create or replace procedure DELETE_GRAINATTR(counterStatic in number) as
  count_grainattr  integer := -1;
  count_cangkuinit integer := -1;
  count_CRFANGAN   integer := -1;
  count_CANGKU     integer := -1;
begin
  --delete start
  select count(*)
    into count_grainattr
    from yw_lsxingzhi
   where id <= counterStatic;
  select count(*)
    into count_cangkuinit
    from yw_cangkuinit
   where xingzhi_id <= counterStatic;
  select count(*)
    into count_CRFANGAN
    from YW_CRFANGAN
   where LSXINGZHI <= counterStatic;
  select count(*)
    into count_CANGKU
    from YW_CANGKU
   where NOWXZID <= counterStatic;
  if count_grainattr > 0 then
    if (count_cangkuinit = 0) then
      delete yw_lsxingzhi where id <= counterStatic;
      DBMS_OUTPUT.PUT_LINE('delete yw_lsxingzhi');
      commit;
    else
      DBMS_OUTPUT.PUT_LINE('refid<=' || counterStatic);
    end if;
  end if;
  --delete end
end DELETE_GRAINATTR;
/
