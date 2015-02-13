create or replace procedure DELETE_GRAIN(counterStatic in number) as
  count_grain         integer := -1;
  count_cangkuinit    integer := -1;
  count_crtongcang    integer := -1;
  count_LXYPJY        integer := -1;
  count_INSTORERECORD integer := -1;

begin
  --delete start
  select count(*)
    into count_grain
    from yw_foodleibie
   where id <= counterStatic;
  select count(*)
    into count_cangkuinit
    from yw_cangkuinit
   where FOODPINZHONG_ID <= counterStatic;
  select count(*)
    into count_crtongcang
    from yw_crtongcang
   where FOODPZID <= counterStatic;
  select count(*)
    into count_LXYPJY
    from yw_LXYPJY
   where PZID <= counterStatic;
  select count(*)
    into count_INSTORERECORD
    from yw_INSTORERECORD
   where FOODPINZHONG_ID <= counterStatic;
  if count_grain > 0 then
    if (count_cangkuinit = 0 and count_crtongcang = 0 and
       count_INSTORERECORD = 0 and count_LXYPJY = 0) then
      delete yw_foodleibie where id <= counterStatic;
      commit;
    else
      DBMS_OUTPUT.PUT_LINE('refid<=' || counterStatic);
    end if;
  end if;
  --delete end  
end DELETE_GRAIN;
/
