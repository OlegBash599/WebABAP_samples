CLASS zcl_wa001_var_read DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING iv_var_mask TYPE zewa001_var_name OPTIONAL.
    METHODS v
      IMPORTING iv_var TYPE zewa001_var_name
      EXPORTING ev     TYPE any.

    METHODS if_switch
      IMPORTING iv_var        TYPE zewa001_var_name
      RETURNING VALUE(rv_val) TYPE abap_bool.

    METHODS r
      IMPORTING iv_var    TYPE zewa001_var_name
                iv_strict TYPE abap_bool DEFAULT abap_false
      EXPORTING et        TYPE STANDARD TABLE.

  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS: BEGIN OF mc_var_type
                    , separate_value TYPE zewa001_var_type VALUE '1'
                    , switch_val TYPE zewa001_var_type VALUE '2'
                    , range_val TYPE zewa001_var_type VALUE '3'
             , END OF mc_var_type
             .

    DATA mt_var_id TYPE ztwa001_varid_tab.
    DATA mt_var_val TYPE ztwa001_varval_tab.

    METHODS fill_var_val
      IMPORTING is_varid TYPE ztwa001_varid
      EXPORTING ev       TYPE any.

    METHODS add_from_db_by_var
      IMPORTING iv_var   TYPE zewa001_var_name
      EXPORTING es_varid TYPE ztwa001_varid.


    METHODS fill_var_rng
      IMPORTING is_varid TYPE ztwa001_varid
      EXPORTING et       TYPE STANDARD TABLE.
ENDCLASS.



CLASS zcl_wa001_var_read IMPLEMENTATION.
  METHOD constructor.

    IF iv_var_mask IS NOT INITIAL.
      SELECT * FROM ztwa001_varid
          INTO TABLE mt_var_id
          WHERE var_name LIKE iv_var_mask
          ORDER BY PRIMARY KEY.


      IF mt_var_id IS NOT INITIAL.
        SELECT * FROM ztwa001_varval
            INTO TABLE mt_var_val
            FOR ALL ENTRIES IN  mt_var_id
            WHERE var_name EQ mt_var_id-var_name
            ORDER BY PRIMARY KEY.

      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD v.

    DATA ls_varid TYPE ztwa001_varid.

    READ TABLE mt_var_id INTO ls_varid
        WITH KEY var_name = iv_var BINARY SEARCH.
    IF sy-subrc EQ 0.
      fill_var_val( EXPORTING is_varid = ls_varid
                    IMPORTING ev = ev ).
    ELSE.
      add_from_db_by_var( EXPORTING iv_var = iv_var
                          IMPORTING es_varid = ls_varid ).
      fill_var_val( EXPORTING is_varid = ls_varid
                    IMPORTING ev = ev ).
    ENDIF.

  ENDMETHOD.

  METHOD if_switch.
*      IMPORTING iv_var TYPE zewa001_var_name
*      RETURNING VALUE(rv_val) TYPE abap_bool.
    DATA lv_switch_val TYPE char1.

    rv_val = abap_false.
    me->v( EXPORTING iv_var = iv_var
           IMPORTING ev = lv_switch_val ).

    IF lv_switch_val IS NOT INITIAL.
      rv_val = abap_true.
      RETURN.
    ENDIF.

  ENDMETHOD.

  METHOD add_from_db_by_var.
*        IMPORTING iv_var TYPE zewa001_var_name
*        EXPORTING es_varid TYPE ztwa001_varid.
    DATA lt_var_id TYPE ztwa001_varid_tab.
    DATA lt_var_val TYPE ztwa001_varval_tab.

    SELECT * FROM ztwa001_varid
    APPENDING TABLE lt_var_id
    WHERE var_name EQ iv_var
    ORDER BY PRIMARY KEY.

    IF lt_var_id IS NOT INITIAL.
      SELECT * FROM ztwa001_varval
      APPENDING TABLE lt_var_val
      FOR ALL ENTRIES IN lt_var_id
      WHERE var_name EQ lt_var_id-var_name
      ORDER BY PRIMARY KEY
      .
    ENDIF.

    es_varid = VALUE #( lt_var_id[ 1 ] OPTIONAL ).
    APPEND LINES OF lt_var_id TO mt_var_id.
    APPEND LINES OF lt_var_val TO mt_var_val.

  ENDMETHOD.

  METHOD fill_var_val.
*        IMPORTING is_varid TYPE ztwa001_varid
*        EXPORTING ev TYPE any.
    FIELD-SYMBOLS <fs_varval> TYPE ztwa001_varval.

    IF is_varid IS INITIAL.
      CLEAR ev.
      RETURN.
    ENDIF.

    IF is_varid-is_del EQ abap_true.
      CLEAR ev.
      RETURN.
    ENDIF.

    IF is_varid-is_debug_on EQ abap_true.
      BREAK-POINT.
    ENDIF.

    IF is_varid-var_type EQ mc_var_type-switch_val.
      IF is_varid-fast_val IS NOT INITIAL.
        ev = abap_true.
      ELSE.
        ev = abap_false.
      ENDIF.
      RETURN.
    ENDIF.

    IF is_varid-var_type EQ mc_var_type-separate_value.
      ev = is_varid-fast_val.
      RETURN.
    ENDIF.

    IF is_varid-var_type EQ mc_var_type-range_val.
      LOOP AT mt_var_val ASSIGNING <fs_varval> WHERE var_name EQ is_varid-var_name.
        IF <fs_varval>-sign NE 'I'.
          CONTINUE.
        ENDIF.

        IF <fs_varval>-opti NE 'EQ' OR  <fs_varval>-opti NE 'BT'.
          CONTINUE.
        ENDIF.

        ev = <fs_varval>-low.
        EXIT.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

  METHOD r.
*      IMPORTING iv_var TYPE zewa001_var_name
*      EXPORTING et     TYPE any TABLE.
    DATA ls_varid TYPE ztwa001_varid.

    READ TABLE mt_var_id INTO ls_varid
        WITH KEY var_name = iv_var BINARY SEARCH.
    IF sy-subrc EQ 0.
      fill_var_rng( EXPORTING is_varid = ls_varid
                    IMPORTING et = et ).
    ELSE.
      add_from_db_by_var( EXPORTING iv_var = iv_var
                          IMPORTING es_varid = ls_varid ).
      fill_var_rng( EXPORTING is_varid = ls_varid
                    IMPORTING et = et ).
    ENDIF.
  ENDMETHOD.

  METHOD fill_var_rng.
*      IMPORTING is_varid TYPE ztwa001_varid
*      EXPORTING et       TYPE any TABLE.
    FIELD-SYMBOLS <fs_varval> TYPE ztwa001_varval.
    FIELD-SYMBOLS <fs_range> TYPE any.
    FIELD-SYMBOLS <fs_field> TYPE any.

    IF is_varid IS INITIAL.
      CLEAR et.
      RETURN.
    ENDIF.

    IF is_varid-is_del EQ abap_true.
      CLEAR et.
      RETURN.
    ENDIF.

    IF is_varid-is_debug_on EQ abap_true.
      BREAK-POINT.
    ENDIF.

    IF is_varid-var_type EQ mc_var_type-range_val.
      LOOP AT mt_var_val ASSIGNING <fs_varval> WHERE var_name EQ is_varid-var_name.

        APPEND INITIAL LINE TO et ASSIGNING <fs_range>.
        ASSIGN COMPONENT 'SIGN' OF STRUCTURE <fs_range> TO <fs_field>.
        IF sy-subrc EQ 0.
          <fs_field> = <fs_varval>-sign.
        ENDIF.

        ASSIGN COMPONENT 'OPTION' OF STRUCTURE <fs_range> TO <fs_field>.
        IF sy-subrc EQ 0.
          <fs_field> = <fs_varval>-opti.
        ENDIF.

        ASSIGN COMPONENT 'LOW' OF STRUCTURE <fs_range> TO <fs_field>.
        IF sy-subrc EQ 0.
          <fs_field> = <fs_varval>-low.
        ENDIF.

        ASSIGN COMPONENT 'HIGH' OF STRUCTURE <fs_range> TO <fs_field>.
        IF sy-subrc EQ 0.
          <fs_field> = <fs_varval>-low.
        ENDIF.

      ENDLOOP.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
