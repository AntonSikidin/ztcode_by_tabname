*&---------------------------------------------------------------------*
*& Report  ZTCODE_BY_TABNAME                                        *
*&                                                                     *
*&---------------------------------------------------------------------*
*&    Autor Sikidin A.P.                                                                  *
*&                                                                     *
*&---------------------------------------------------------------------*

report  ztcode_by_tabname                                        .


parameters
  : tabname type tabname obligatory
  .

data
      : lv_tcode type tcode
      , lt_dd26s type table of dd26s
      , lv_vclname  type vcl_name
      .

field-symbols
               : <fs_dd26s> type dd26s
               .

start-of-selection.

  write : / 'Table maintenance'.
  uline.

  perform get_tcode_by_tabname using tabname.

  write : /' '.
  write : /' '.
  write : /' '.

  uline.
  write : / 'View maintenance'.
  uline.
  select distinct viewname  as viewname
    into corresponding fields of table lt_dd26s
    from dd26s
    where tabname = tabname
    .


  loop at lt_dd26s assigning <fs_dd26s>.
    write : / 'View ', <fs_dd26s>-viewname.
    perform get_tcode_by_tabname using <fs_dd26s>-viewname.
  endloop.

  write : /' '.
  write : /' '.
  write : /' '.
  uline.
  write : / 'Cluster  maintenance'.
  uline.

  select vclname into lv_vclname
    from vclstruc
    where object  = tabname.

    write : / 'Cluster ', lv_vclname.
    perform get_tcode_by_tabname using lv_vclname.
  endselect.

  loop at lt_dd26s assigning <fs_dd26s>.
    select vclname into lv_vclname
      from vclstruc
      where object  = <fs_dd26s>-viewname.

      write : / 'Cluster ', lv_vclname.
      perform get_tcode_by_tabname using lv_vclname.
    endselect.
  endloop.
  uline.

*&---------------------------------------------------------------------*
*&      Form  get_tcode_by_tabname
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->TABNAME    text
*      -->TCODE      text
*----------------------------------------------------------------------*
form get_tcode_by_tabname using tabname
                          .

  data
        : lv_tcode type tcode
        , lv_text type ttext_stct
        , lv_param  type tcdparam
        .

  concatenate '%' tabname '%' into lv_param .




  select
        tstcp~tcode
        tstct~ttext
  into (lv_tcode, lv_text)
  from
  tstcp inner join tstct on
             tstcp~tcode = tstct~tcode
  where
         tstcp~param like lv_param
  .

    write : / lv_tcode, lv_text.
  endselect.
endform.                    "get_tcode_by_tabname
