create or replace procedure UPDATE_GRAINATTR(counterStatic in number) as
  counter             number := counterStatic;
  count_name          number;
  count_code          number;
  count_cangkuinit    integer := -1;
  count_CRFANGAN      integer := -1;
  count_CANGKU        integer := -1;
  count_INSTORERECORD integer := -1;
  /*
  defaultStr       varchar2(8) := 'zero';
  grainattr_ids VARCHAR2(10000);
  count_namecode   number;
  TYPE array_grainattr IS TABLE OF varchar2(256) INDEX BY PLS_INTEGER;
  array_name    array_grainattr;
  array_code    array_grainattr;
  name VARCHAR2(256);
  */
  TYPE cursor_grainattr IS REF CURSOR;
  v_grainattr     cursor_grainattr;
  v_code          yw_lsxingzhi.t_code%TYPE;
  v_name          yw_lsxingzhi.name%TYPE;
  grainattr_id    number;
  count_grainattr integer := -1;
  grainattr_name  varchar2(100);
begin
  /*
  select count(*)
    into count_namecode
    from (select t_code from yw_lsxingzhi group by name, t_code);
    */
  select count(distinct name) into count_name from yw_lsxingzhi;
  select count(distinct t_code) into count_code from yw_lsxingzhi;

  if count_code <= count_name then
    OPEN v_grainattr FOR
      SELECT distinct t_code FROM yw_lsxingzhi order by t_code;
    LOOP
      FETCH v_grainattr
        INTO v_code;
      EXIT WHEN v_grainattr%NOTFOUND;
      dbms_output.put_line('t_code=' || v_code);
      /*
            SELECT (case
                     when count(*) > 0 then
                      wm_concat(id)
                     else
                      defaultStr
                   end)
              INTO grainattr_ids
              FROM (select distinct t_code, id
                      from yw_lsxingzhi
                     WHERE t_code = v_code);
      DBMS_OUTPUT.PUT_LINE(grainattr_ids);
      if grainattr_ids <> defaultStr then 
      end if;              
                     */
      counter := counter + 1;
      DBMS_OUTPUT.PUT_LINE(counter);
      select count(*)
        into count_cangkuinit
        from yw_cangkuinit t
       where t.xingzhi_id <= counterStatic
         and t.xingzhi_id in
             (select id from yw_lsxingzhi WHERE t_code = v_code);
      if count_cangkuinit > 0 then
        update yw_cangkuinit t
           set t.xingzhi_id = counter
         where t.xingzhi_id in
               (select id from yw_lsxingzhi WHERE t_code = v_code);
        DBMS_OUTPUT.PUT_LINE('update yw_cangkuinit');
      end if;
      select count(*)
        into count_CRFANGAN
        from YW_CRFANGAN
       where LSXINGZHI <= counterStatic
         and LSXINGZHI in
             (select id from yw_lsxingzhi WHERE t_code = v_code);
      if (count_CRFANGAN > 0) then
        update YW_CRFANGAN
           set LSXINGZHI = counter
         where LSXINGZHI in
               (select id from yw_lsxingzhi WHERE t_code = v_code);
        DBMS_OUTPUT.PUT_LINE('update YW_CRFANGAN');
      end if;
      select count(*)
        into count_CANGKU
        from YW_CANGKU
       where NOWXZID <= counterStatic
         and NOWXZID in (select id from yw_lsxingzhi WHERE t_code = v_code);
      if (count_CANGKU > 0) then
        update YW_CANGKU
           set NOWXZID = counter
         where NOWXZID in
               (select id from yw_lsxingzhi WHERE t_code = v_code);
        DBMS_OUTPUT.PUT_LINE('update YW_CANGKU');
      end if;
      select count(*)
        into count_INSTORERECORD
        from YW_INSTORERECORD
       where DISTRICT <= counterStatic
         and DISTRICT in
             (select id from yw_lsxingzhi WHERE t_code = v_code);
      if (count_CANGKU > 0) then
        update YW_INSTORERECORD
           set DISTRICT = counter
         where DISTRICT in
               (select id from yw_lsxingzhi WHERE t_code = v_code);
        DBMS_OUTPUT.PUT_LINE('update YW_INSTORERECORD');
      end if;
      SELECT count(*)
        INTO count_grainattr
        FROM yw_lsxingzhi
       WHERE id = counter;
      if count_grainattr is null or count_grainattr = 0 then
        select minid
          into grainattr_id
          from (select minid
                  from (select count(*) count_code, name, min(id) minid
                          from yw_lsxingzhi
                         where t_code = v_code
                         group by name)
                 order by count_code desc)
         where rownum = 1;
        update yw_lsxingzhi set id = counter where id = grainattr_id;
        DBMS_OUTPUT.PUT_LINE('update yw_lsxingzhi');
      
      else
        select name, minid
          into grainattr_name, grainattr_id
          from (select name, minid
                  from (select count(*) count_code, name, min(id) minid
                          from yw_lsxingzhi
                         where t_code = v_code
                         group by name)
                 order by count_code desc)
         where rownum = 1;
        if (counter != grainattr_id) then
          update yw_lsxingzhi set name = grainattr_name where id = counter;
          DBMS_OUTPUT.PUT_LINE('update yw_lsxingzhi' || counter);
        end if;
      end if;
    END LOOP;
  
  else
    OPEN v_grainattr FOR
      SELECT distinct name FROM yw_lsxingzhi;
    LOOP
      FETCH v_grainattr
        INTO v_name;
      EXIT WHEN v_grainattr%NOTFOUND;
      dbms_output.put_line('name=' || v_name);
      counter := counter + 1;
      DBMS_OUTPUT.PUT_LINE(counter);
      select count(*)
        into count_cangkuinit
        from yw_cangkuinit t
       where t.xingzhi_id <= counterStatic
         and t.xingzhi_id in
             (select id from yw_lsxingzhi WHERE name = v_name);
      if count_cangkuinit > 0 then
        update yw_cangkuinit t
           set t.xingzhi_id = counter
         where t.xingzhi_id in
               (select id from yw_lsxingzhi WHERE name = v_name);
        DBMS_OUTPUT.PUT_LINE('update yw_cangkuinit');
      end if;
      /*
      SELECT count(*)
        INTO count_grainattr
        FROM yw_lsxingzhi
       WHERE id = counter;
      if count_grainattr is null or count_grainattr = 0 then
        select minid
          into grainattr_id
          from (select minid
                  from (select count(*) count_code, name, min(id) minid
                          from yw_lsxingzhi
                         where t_code = v_code
                         group by name)
                 order by count_code desc)
         where rownum = 1;
        update yw_lsxingzhi set id = counter where id = grainattr_id;
        DBMS_OUTPUT.PUT_LINE('update yw_lsxingzhi');
      else
        select name, minid
          into grainattr_name, grainattr_id
          from (select name, minid
                  from (select count(*) count_code, name, min(id) minid
                          from yw_lsxingzhi
                         where t_code = v_code
                         group by name)
                 order by count_code desc)
         where rownum = 1;
        if (counter != grainattr_id) then
          update yw_lsxingzhi set name = grainattr_name where id = counter;
          DBMS_OUTPUT.PUT_LINE('update yw_lsxingzhi' || counter);
        end if;
      end if;
      */
    END LOOP;
  end if;

  commit;
  --rollback;
  CLOSE v_grainattr;
end UPDATE_GRAINATTR;
/
