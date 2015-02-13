create or replace procedure DELETE_GRAIN(counterStatic in number,
                                         counterLast   in number) as
  count_grain         integer := -1;
  count_cangkuinit    integer := -1;
  count_crtongcang    integer := -1;
  count_LXYPJY        integer := -1;
  count_INSTORERECORD integer := -1;
  count_CRFANGAN      integer := -1;
begin
  select count(*)
    into count_grain
    from yw_foodleibie
   where id <= counterStatic
      or id > counterLast;
  select count(*)
    into count_cangkuinit
    from yw_cangkuinit
   where FOODPINZHONG_ID <= counterStatic
      or FOODPINZHONG_ID > counterLast;
  select count(*)
    into count_crtongcang
    from yw_crtongcang
   where FOODPZID <= counterStatic
      or FOODPZID > counterLast;
  select count(*)
    into count_LXYPJY
    from yw_LXYPJY
   where PZID <= counterStatic
      or PZID > counterLast;
  select count(*)
    into count_INSTORERECORD
    from yw_INSTORERECORD
   where FOODPINZHONG_ID <= counterStatic
      or FOODPINZHONG_ID > counterLast;
  select count(*)
    into count_CRFANGAN
    from YW_CRFANGAN
   where LSPINZHONG <= counterStatic
      or LSPINZHONG > counterLast;
  if count_grain > 0 then
    if (count_cangkuinit = 0 and count_crtongcang = 0 and
       count_INSTORERECORD = 0 and count_LXYPJY = 0 and count_CRFANGAN = 0) then
      delete yw_foodleibie
       where id <= counterStatic
          or id > counterLast;
      DBMS_OUTPUT.PUT_LINE('delete yw_foodleibie');
      commit;
    else
      DBMS_OUTPUT.PUT_LINE('refid<=' || counterStatic ||
                           ' or counterLast>' || counterLast);
    end if;
  end if;
end DELETE_GRAIN;
/
