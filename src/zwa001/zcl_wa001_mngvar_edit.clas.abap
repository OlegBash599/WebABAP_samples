CLASS zcl_wa001_mngvar_edit DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING iv_var_name TYPE zewa001_var_name.
    METHODS sh
        EXPORTING ev_rc TYPE sysubrc.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA mv_var_name TYPE zewa001_var_name.

    METHODS get_var_n_range
      EXPORTING es_var_id_in TYPE ztwa001_varid
                et_range_in  TYPE zttwa001_varvalues_rng.

    METHODS save_var_n_range
      IMPORTING is_var_id_in TYPE ztwa001_varid
                it_range_in  TYPE zttwa001_varvalues_rng.

ENDCLASS.



CLASS zcl_wa001_mngvar_edit IMPLEMENTATION.
  METHOD constructor.
    mv_var_name = iv_var_name.
  ENDMETHOD.

  METHOD sh.
    DATA lv_screen_sysubrc TYPE  sysubrc.
    DATA ls_var_id_in TYPE ztwa001_varid.
    DATA lt_range_in TYPE zttwa001_varvalues_rng.


    get_var_n_range( IMPORTING es_var_id_in = ls_var_id_in
                               et_range_in = lt_range_in ).


    CALL FUNCTION 'Z_WA001_SEL_OPTIONS'
      CHANGING
        cs_var_head    = ls_var_id_in
        ct_range_char  = lt_range_in
        screen_sysubrc = lv_screen_sysubrc.

    IF lv_screen_sysubrc EQ 0.
      save_var_n_range( EXPORTING is_var_id_in = ls_var_id_in
                          it_range_in = lt_range_in ).
      ev_rc = 1. " updation is done
    ENDIF.
  ENDMETHOD.

  METHOD get_var_n_range.
*        EXPORTING es_var_id_in type ztwa001_varid
*                  et_range_in TYPE zttwa001_varvalues_rng.
    DATA lt_var_id TYPE ztwa001_varid_tab.
    DATA ls_var_id_in TYPE ztwa001_varid.
    DATA lt_var_val TYPE ztwa001_varval_tab.


    DATA lt_range_in TYPE zttwa001_varvalues_rng.
    FIELD-SYMBOLS <fs_range_line> TYPE zswa001_varvalues_rng.
    FIELD-SYMBOLS <fs_var_val> TYPE ztwa001_varval.


    SELECT * FROM ztwa001_varid
        INTO TABLE lt_var_id
        WHERE var_name = mv_var_name.

    ls_var_id_in = VALUE #( lt_var_id[ 1 ] OPTIONAL ).

    SELECT * FROM   ztwa001_varval
        INTO TABLE lt_var_val
        WHERE var_name = mv_var_name.


    CLEAR lt_range_in.
    LOOP AT lt_var_val ASSIGNING <fs_var_val>.
      APPEND INITIAL LINE TO lt_range_in ASSIGNING <fs_range_line>.
      <fs_range_line>-sign = <fs_var_val>-sign.
      <fs_range_line>-opti = <fs_var_val>-opti.
      <fs_range_line>-low = <fs_var_val>-low.
      <fs_range_line>-high = <fs_var_val>-high.
    ENDLOOP.

    es_var_id_in = ls_var_id_in.
    et_range_in = lt_range_in.

  ENDMETHOD.

  METHOD save_var_n_range.
*        IMPORTING is_var_id_in type ztwa001_varid
*                  it_range_in type zttwa001_varvalues_rng.
    DATA lt_var_id4db TYPE ztwa001_varid_tab.
    DATA lt_var_val4db TYPE ztwa001_varval_tab.

    DATA lv_range_line TYPE zewa001_var_numb.

    FIELD-SYMBOLS <fs_var_id> TYPE ztwa001_varid.
    FIELD-SYMBOLS <fs_var_val> TYPE ztwa001_varval.
    FIELD-SYMBOLS <fs_range_line> TYPE zswa001_varvalues_rng.

    CLEAR lt_var_id4db.
    GET TIME.
    APPEND INITIAL LINE TO lt_var_id4db ASSIGNING  <fs_var_id>.
    <fs_var_id>-mandt = cl_abap_syst=>get_client(  ).
    <fs_var_id>-var_name = is_var_id_in-var_name.
    <fs_var_id>-var_desc = is_var_id_in-var_desc.
    <fs_var_id>-var_type = is_var_id_in-var_type.
    <fs_var_id>-is_del = is_var_id_in-is_del.
    <fs_var_id>-is_debug_on = is_var_id_in-is_debug_on.
    <fs_var_id>-fast_val = is_var_id_in-fast_val.
    <fs_var_id>-cru = is_var_id_in-cru.
    IF <fs_var_id>-cru IS INITIAL.
      <fs_var_id>-cru = sy-uname.
    ENDIF.
    <fs_var_id>-crd = is_var_id_in-crd.
    IF <fs_var_id>-crd IS INITIAL.
      <fs_var_id>-crd = sy-datum.
    ENDIF.
    <fs_var_id>-crt = is_var_id_in-crt.
    IF <fs_var_id>-crt IS INITIAL.
      <fs_var_id>-crt = sy-uzeit.
    ENDIF.
    <fs_var_id>-chu = sy-uname.
    <fs_var_id>-chd = sy-datum.
    <fs_var_id>-cht = sy-uzeit.

    CLEAR lv_range_line.
    LOOP AT it_range_in ASSIGNING <fs_range_line>.
      lv_range_line = lv_range_line + 1.
      APPEND INITIAL LINE TO lt_var_val4db ASSIGNING <fs_var_val>.
      <fs_var_val>-mandt = cl_abap_syst=>get_client(  ).
      <fs_var_val>-var_name = is_var_id_in-var_name.
      <fs_var_val>-var_numb = lv_range_line.
      <fs_var_val>-sign = <fs_range_line>-sign.
      <fs_var_val>-opti = <fs_range_line>-opti.
      <fs_var_val>-low = <fs_range_line>-low.
      <fs_var_val>-high = <fs_range_line>-high.
    ENDLOOP.

    """"""""""""""""""""""""""""""""""""""""
    DATA lo_save_var_n_range TYPE REF TO zcl_wa001_save_var_n_rng.

    lo_save_var_n_range = NEW #(  ).

    lo_save_var_n_range->sh(  EXPORTING it_varid = lt_var_id4db
                                        it_varval = lt_var_val4db ).

  ENDMETHOD.
ENDCLASS.
