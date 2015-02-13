create or replace procedure COUNT_GRAIN_REF(counterStatic       in number,
                                            count_cangkuinit    out integer,
                                            count_crtongcang    out integer,
                                            count_LXYPJY        out integer,
                                            count_INSTORERECORD out integer) is
begin
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
end COUNT_GRAIN_REF;
/
