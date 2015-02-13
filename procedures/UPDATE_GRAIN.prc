create or replace procedure UPDATE_GRAIN(counterStatic in number,
                                         counterLast   out number) as
  counter             number := counterStatic;
  count_name          number;
  count_code          number;
  count_cangkuinit    integer := -1;
  count_crtongcang    integer := -1;
  count_LXYPJY        integer := -1;
  count_INSTORERECORD integer := -1;
  count_CRFANGAN      integer := -1;
  TYPE cursor_grain IS REF CURSOR;
  v_grain cursor_grain;
  v_code  yw_foodleibie.t_code%TYPE;
  --v_name          yw_foodleibie.foodname%TYPE;
  grain_id     number;
  count_grain  integer := -1;
  resultStr    varchar2(8);
  result_ok    varchar(8) := 'ok';
  grainNextval number;
  foodname     varchar2(100);
begin
  select count(distinct foodname) into count_name from yw_foodleibie;
  select count(distinct t_code) into count_code from yw_foodleibie;

  if count_code <= count_name then
    OPEN v_grain FOR
      SELECT distinct t_code FROM yw_foodleibie order by t_code;
    LOOP
      FETCH v_grain
        INTO v_code;
      EXIT WHEN v_grain%NOTFOUND;
      dbms_output.put_line('t_code=' || v_code);
      counter := counter + 1;
      SELECT count(*)
        INTO count_grain
        FROM yw_foodleibie
       WHERE id = counter;
      if (count_grain is null or count_grain = 0) then
        select maxid
          into grain_id
          from (select maxid
                  from (select count(*) count_code, foodname, max(id) maxid
                          from yw_foodleibie
                         where t_code = v_code
                         group by foodname)
                 order by count_code desc)
         where rownum = 1;
        select count(*)
          into count_cangkuinit
          from yw_cangkuinit
         where FOODPINZHONG_ID <= counterStatic
           and FOODPINZHONG_ID = grain_id;
        select count(*)
          into count_crtongcang
          from yw_crtongcang
         where FOODPZID <= counterStatic
           and FOODPZID = grain_id;
        select count(*)
          into count_LXYPJY
          from yw_LXYPJY
         where PZID <= counterStatic
           and PZID = grain_id;
        select count(*)
          into count_INSTORERECORD
          from yw_INSTORERECORD
         where FOODPINZHONG_ID <= counterStatic
           and FOODPINZHONG_ID = grain_id;
        select count(*)
          into count_CRFANGAN
          from YW_CRFANGAN
         where LSPINZHONG <= counterStatic
           and LSPINZHONG = grain_id;
        if (count_cangkuinit > 0 or count_crtongcang > 0 or
           count_LXYPJY > 0 or count_INSTORERECORD > 0 or
           count_CRFANGAN > 0) then
          DROP_CREATE_SEQUENCE('SEQ_FOODLEIBIE', counter - 1, resultStr);
          if (resultStr = result_ok) then
            select SEQ_FOODLEIBIE.nextval into grainNextval from dual;
            insert into yw_foodleibie
              select grainNextval,
                     foodname,
                     describe,
                     flag,
                     state,
                     t_code,
                     suoshulei,
                     changetime,
                     cjtime,
                     oldid,
                     lktcode
                from yw_foodleibie
               where id = grain_id;
            commit;
            DBMS_OUTPUT.PUT_LINE('insert yw_foodleibie' || counter);
            update yw_foodleibie
               set id = counter
             where id = (grainNextval + 1);
            DBMS_OUTPUT.PUT_LINE('update yw_foodleibie' || counter);
          end if;
        else
          update yw_foodleibie set id = counter where id = grain_id;
          DBMS_OUTPUT.PUT_LINE('update yw_foodleibie' || counter);
        end if;
      
      else
        select foodname, maxid
          into foodname, grain_id
          from (select foodname, maxid
                  from (select count(*) count_code, foodname, max(id) maxid
                          from yw_foodleibie
                         where t_code = v_code
                         group by foodname)
                 order by count_code desc)
         where rownum = 1;
        if (counter != grain_id) then
          update yw_foodleibie set foodname = foodname where id = counter;
          DBMS_OUTPUT.PUT_LINE('update yw_foodleibie' || counter);
        end if;
        commit;
      end if;
    
      SELECT count(*)
        INTO count_grain
        FROM yw_foodleibie
       WHERE id = counter;
      if (count_grain > 0) then
        select count(*)
          into count_cangkuinit
          from yw_cangkuinit
         where FOODPINZHONG_ID in (select id
                                     from yw_foodleibie
                                    WHERE t_code = v_code
                                      and id <> counter);
        if (count_cangkuinit > 0) then
          update yw_cangkuinit
             set FOODPINZHONG_ID = counter
           where FOODPINZHONG_ID in
                 (select id
                    from yw_foodleibie
                   WHERE t_code = v_code
                     and id <> counter);
          DBMS_OUTPUT.PUT_LINE('update yw_cangkuinit');
        end if;
        select count(*)
          into count_crtongcang
          from yw_crtongcang
         where FOODPZID in (select id
                              from yw_foodleibie
                             WHERE t_code = v_code
                               and id <> counter);
        if (count_crtongcang > 0) then
          update yw_crtongcang
             set FOODPZID = counter
           where FOODPZID in (select id
                                from yw_foodleibie
                               WHERE t_code = v_code
                                 and id <> counter);
          DBMS_OUTPUT.PUT_LINE('update yw_crtongcang');
        end if;
        select count(*)
          into count_LXYPJY
          from YW_LXYPJY
         where PZID in (select id
                          from yw_foodleibie
                         WHERE t_code = v_code
                           and id <> counter);
        if (count_LXYPJY > 0) then
          update YW_LXYPJY
             set PZID = counter
           where PZID in (select id
                            from yw_foodleibie
                           WHERE t_code = v_code
                             and id <> counter);
          DBMS_OUTPUT.PUT_LINE('update YW_LXYPJY');
        end if;
        select count(*)
          into count_INSTORERECORD
          from YW_INSTORERECORD
         where FOODPINZHONG_ID in (select id
                                     from yw_foodleibie
                                    WHERE t_code = v_code
                                      and id <> counter);
        if (count_INSTORERECORD > 0) then
          update YW_INSTORERECORD
             set FOODPINZHONG_ID = counter
           where FOODPINZHONG_ID in
                 (select id
                    from yw_foodleibie
                   WHERE t_code = v_code
                     and id <> counter);
          DBMS_OUTPUT.PUT_LINE('update YW_INSTORERECORD');
        end if;
        select count(*)
          into count_CRFANGAN
          from YW_CRFANGAN
         where LSPINZHONG in (select id
                                from yw_foodleibie
                               WHERE t_code = v_code
                                 and id <> counter);
        if (count_CRFANGAN > 0) then
          update YW_CRFANGAN
             set LSPINZHONG = counter
           where LSPINZHONG in (select id
                                  from yw_foodleibie
                                 WHERE t_code = v_code
                                   and id <> counter);
          DBMS_OUTPUT.PUT_LINE('update YW_CRFANGAN');
        end if;
      end if;
    END LOOP;
  
  else
    DBMS_OUTPUT.PUT_LINE('name');
  end if;

  counterLast := counter;
  commit;
end UPDATE_GRAIN;
/
