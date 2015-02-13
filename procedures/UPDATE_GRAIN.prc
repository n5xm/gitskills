create or replace procedure UPDATE_GRAIN(counterStatic in number) as
  counter             number := counterStatic;
  count_name          number;
  count_code          number;
  count_cangkuinit    integer := -1;
  count_crtongcang    integer := -1;
  count_LXYPJY        integer := -1;
  count_INSTORERECORD integer := -1;
  TYPE cursor_grain IS REF CURSOR;
  v_grain cursor_grain;
  v_code  yw_foodleibie.t_code%TYPE;
  --v_name          yw_foodleibie.foodname%TYPE;
  grain_id    number;
  count_grain integer := -1;
  -- resultStr   varchar2(8);
  --result_ok   varchar(8) := 'ok';
  grainNextval number;
  foodname     varchar2(100);
begin
  select count(distinct foodname) into count_name from yw_foodleibie;
  select count(distinct t_code) into count_code from yw_foodleibie;

  if count_code <= count_name then
    OPEN v_grain FOR
      SELECT distinct t_code FROM yw_foodleibie;
    LOOP
      FETCH v_grain
        INTO v_code;
      EXIT WHEN v_grain%NOTFOUND;
      dbms_output.put_line('t_code=' || v_code);
      counter := counter + 1;
      --yw_foodleibie start
      SELECT count(*)
        INTO count_grain
        FROM yw_foodleibie
       WHERE id = counter;
      if (count_grain is null or count_grain = 0) then
        select minid
          into grain_id
          from (select minid
                  from (select count(*) count_code, foodname, min(id) minid
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
        if (count_cangkuinit > 0 or count_crtongcang > 0 or
           count_LXYPJY > 0 or count_INSTORERECORD > 0) then
          --Drop_create_SEQUENCE('SEQ_FOODLEIBIE', counter - 1, resultStr);
          --if (resultStr = result_ok) then
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
          -- end if;
        else
          update yw_foodleibie set id = counter where id = grain_id;
          DBMS_OUTPUT.PUT_LINE('update yw_foodleibie' || counter);
        end if;
      
      else
        select foodname, minid
          into foodname, grain_id
          from (select foodname, minid
                  from (select count(*) count_code, foodname, min(id) minid
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
      --yw_foodleibie end
    
      SELECT count(*)
        INTO count_grain
        FROM yw_foodleibie
       WHERE id = counter;
      if (count_grain > 0) then
        --yw_cangkuinit start
        select count(*)
          into count_cangkuinit
          from yw_cangkuinit
         where FOODPINZHONG_ID <= counterStatic
           and FOODPINZHONG_ID in
               (select id from yw_foodleibie WHERE t_code = v_code);
        if (count_cangkuinit > 0) then
          update yw_cangkuinit
             set FOODPINZHONG_ID = counter
           where FOODPINZHONG_ID in
                 (select id from yw_foodleibie WHERE t_code = v_code);
          DBMS_OUTPUT.PUT_LINE('update yw_cangkuinit');
        end if;
        --yw_cangkuinit end
        --yw_crtongcang start
        select count(*)
          into count_cangkuinit
          from yw_crtongcang
         where FOODPZID <= counterStatic
           and FOODPZID in
               (select id from yw_foodleibie WHERE t_code = v_code);
        if (count_cangkuinit > 0) then
          update yw_crtongcang
             set FOODPZID = counter
           where FOODPZID in
                 (select id from yw_foodleibie WHERE t_code = v_code);
          DBMS_OUTPUT.PUT_LINE('update yw_crtongcang');
        end if;
        --yw_crtongcang end
        --YW_LXYPJY start
        select count(*)
          into count_cangkuinit
          from YW_LXYPJY
         where PZID <= counterStatic
           and PZID in (select id from yw_foodleibie WHERE t_code = v_code);
        if (count_cangkuinit > 0) then
          update YW_LXYPJY
             set PZID = counter
           where PZID in
                 (select id from yw_foodleibie WHERE t_code = v_code);
          DBMS_OUTPUT.PUT_LINE('update YW_LXYPJY');
        end if;
        --YW_LXYPJY end
        --YW_INSTORERECORD start
        select count(*)
          into count_cangkuinit
          from YW_INSTORERECORD
         where FOODPINZHONG_ID <= counterStatic
           and FOODPINZHONG_ID in
               (select id from yw_foodleibie WHERE t_code = v_code);
        if (count_cangkuinit > 0) then
          update YW_INSTORERECORD
             set FOODPINZHONG_ID = counter
           where FOODPINZHONG_ID in
                 (select id from yw_foodleibie WHERE t_code = v_code);
          DBMS_OUTPUT.PUT_LINE('update YW_INSTORERECORD');
        end if;
        --YW_INSTORERECORD end
      end if;
    END LOOP;
  
  else
    DBMS_OUTPUT.PUT_LINE('name');
  end if;

  commit;
end UPDATE_GRAIN;
/
