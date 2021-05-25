CLASS zcl_wa001_var_logs_prepare DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor.

    METHODS sh
      IMPORTING it_varid  TYPE ztwa001_varid_tab OPTIONAL
                it_varval TYPE ztwa001_varval_tab OPTIONAL
      EXPORTING et_varlog TYPE ztwa001_varlog_tab .

  PROTECTED SECTION.
  PRIVATE SECTION.

    METHODS read_existed_varid
      IMPORTING it_varid4upd TYPE ztwa001_varid_tab
      EXPORTING et_varid_db  TYPE  ztwa001_varid_tab.

    METHODS read_existed_varval
      IMPORTING it_varval4upd TYPE ztwa001_varval_tab
      EXPORTING et_varval_db  TYPE  ztwa001_varval_tab.

    METHODS compare_varid4logs
      IMPORTING it_varid4upd  TYPE ztwa001_varid_tab
                it_varid_db   TYPE ztwa001_varid_tab
      EXPORTING et_varid_logs TYPE ztwa001_varlog_tab.


    METHODS compare_varval4logs
      IMPORTING it_varval4upd  TYPE ztwa001_varval_tab
                it_varval_db   TYPE ztwa001_varval_tab
      EXPORTING et_varval_logs TYPE ztwa001_varlog_tab.

    METHODS prepare4updation
                "IMPORTING is_upd  TYPE ztwa001_varid
      IMPORTING is_upd  TYPE any
                "is_db   TYPE ztwa001_varid
                is_db   TYPE any
      CHANGING  ct_logs TYPE ztwa001_varlog_tab.


    METHODS prepare4insert
                "IMPORTING is_ins  TYPE ztwa001_varid
      IMPORTING is_ins  TYPE any
      CHANGING  ct_logs TYPE ztwa001_varlog_tab.


    METHODS get_change_guid
      RETURNING VALUE(rv_val) TYPE char32.

ENDCLASS.



CLASS zcl_wa001_var_logs_prepare IMPLEMENTATION.
  METHOD constructor.

  ENDMETHOD.

  METHOD sh.
*      IMPORTING it_varid  TYPE ztwa001_varid_tab OPTIONAL
*                it_varval TYPE ztwa001_varval_tab OPTIONAL
*      EXPORTING et_varlog TYPE ztwa001_varlog_tab .

    DATA lt_varid_db TYPE ztwa001_varid_tab.
    DATA lt_varval_db TYPE ztwa001_varval_tab.

    DATA lt_varid_logs TYPE ztwa001_varlog_tab.
    DATA lt_varval_logs TYPE ztwa001_varlog_tab.

    read_existed_varid( EXPORTING it_varid4upd = it_varid
                        IMPORTING et_varid_db = lt_varid_db ).

    read_existed_varval( EXPORTING it_varval4upd = it_varval
                         IMPORTING et_varval_db = lt_varval_db ).

    compare_varid4logs( EXPORTING it_varid4upd = it_varid
                                  it_varid_db = lt_varid_db
                        IMPORTING et_varid_logs = lt_varid_logs ) .

    compare_varval4logs( EXPORTING it_varval4upd = it_varval
                                  it_varval_db = lt_varval_db
                        IMPORTING et_varval_logs = lt_varval_logs ) .

    APPEND LINES OF lt_varid_logs TO et_varlog.
    APPEND LINES OF lt_varval_logs TO et_varlog.

  ENDMETHOD.

  METHOD read_existed_varid.
*  ( EXPORTING it_varid4upd = it_varid
*                        IMPORTING it_varid_db = lt_varid_db ).

    IF it_varid4upd IS INITIAL.
      RETURN.
    ENDIF.

    SELECT * FROM ztwa001_varid
        INTO TABLE et_varid_db
        FOR ALL ENTRIES IN it_varid4upd
        WHERE var_name = it_varid4upd-var_name
        .

  ENDMETHOD.

  METHOD read_existed_varval.
*      IMPORTING it_varval4upd TYPE ztwa001_varval_tab
*      EXPORTING et_varval_db  TYPE  ztwa001_varval_tab.

    IF it_varval4upd IS INITIAL.
      RETURN.
    ENDIF.

    SELECT * FROM ztwa001_varval
        INTO TABLE et_varval_db
        FOR ALL ENTRIES IN it_varval4upd
        WHERE var_name EQ it_varval4upd-var_name
          AND var_numb EQ it_varval4upd-var_numb
          .

  ENDMETHOD.

  METHOD compare_varid4logs.
*        IMPORTING it_varid4upd TYPE ztwa001_varval_tab
*                  it_varid_db TYPE ztwa001_varid_tab
*        EXPORTING et_varid_logs TYPE ZTWA001_VARLOG_TAB.

    FIELD-SYMBOLS <fs_varid_upd> TYPE ztwa001_varid.
    FIELD-SYMBOLS <fs_varid_db> TYPE ztwa001_varid.


    LOOP AT it_varid4upd ASSIGNING <fs_varid_upd>.
      READ TABLE it_varid_db ASSIGNING <fs_varid_db> WITH KEY
              var_name = <fs_varid_upd>-var_name.
      IF sy-subrc EQ 0.
        IF <fs_varid_upd> EQ <fs_varid_db>.
          " nothing
        ELSE.
          " it is updation
          prepare4updation( EXPORTING is_upd = <fs_varid_upd>
                                      is_db = <fs_varid_db>
                            CHANGING ct_logs = et_varid_logs ).
        ENDIF.
      ELSE.
        " it is insertion
        prepare4insert( EXPORTING is_ins = <fs_varid_upd>
                        CHANGING ct_logs = et_varid_logs ).
      ENDIF.
    ENDLOOP.


  ENDMETHOD.

  METHOD compare_varval4logs.
*      IMPORTING it_varval4upd  TYPE ztwa001_varval_tab
*                it_varval_db   TYPE ztwa001_varval_tab
*      EXPORTING et_varval_logs TYPE ztwa001_varlog_tab.

    FIELD-SYMBOLS <fs_varval_upd> TYPE ztwa001_varval.
    FIELD-SYMBOLS <fs_varval_db> TYPE ztwa001_varval.

    LOOP AT it_varval4upd ASSIGNING <fs_varval_upd>.
      LOOP AT it_varval_db ASSIGNING <fs_varval_db>
          WHERE var_name = <fs_varval_upd>-var_name
            AND var_numb = <fs_varval_upd>-var_numb.
        IF <fs_varval_upd> EQ <fs_varval_db>.
          " nothing is changed
        ELSE.
          prepare4updation( EXPORTING is_upd = <fs_varval_upd>
                               is_db = <fs_varval_db>
                     CHANGING ct_logs = et_varval_logs ).
        ENDIF.

      ENDLOOP.
      IF sy-subrc NE 0.
        " it is insertion
        prepare4insert( EXPORTING is_ins = <fs_varval_upd>
                        CHANGING ct_logs = et_varval_logs ).
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD prepare4updation.
*EXPORTING is_upd = <fs_varid_upd>
*            is_db = <fs_varid_db>
*  CHANGING ct_logs = et_varid_logs ).
    DATA lo_struct_upd TYPE REF TO cl_abap_structdescr.
    DATA lo_struct_db TYPE REF TO cl_abap_structdescr.

    DATA lt_component_tab TYPE abap_component_tab.
    FIELD-SYMBOLS <fs_comp> TYPE abap_componentdescr.

    FIELD-SYMBOLS <fs_field_upd> TYPE any.
    FIELD-SYMBOLS <fs_field_db> TYPE any.
    FIELD-SYMBOLS <fs_field_var_name> TYPE any.
    FIELD-SYMBOLS <fs_field_var_numb> TYPE any.
    FIELD-SYMBOLS <fs_log_line> TYPE ztwa001_varlog.

    lo_struct_upd ?= cl_abap_structdescr=>describe_by_data( p_data = is_upd ).
    lo_struct_db ?= cl_abap_structdescr=>describe_by_data( p_data = is_db ).

    lt_component_tab = lo_struct_upd->get_components( ).

    LOOP AT lt_component_tab ASSIGNING <fs_comp>.

      " created and changed fields are excluded
      IF <fs_comp>-name CP 'CR+' OR <fs_comp>-name CP 'CH+'.
        CONTINUE.
      ENDIF.


      ASSIGN COMPONENT <fs_comp>-name OF STRUCTURE is_upd TO <fs_field_upd>.
      IF sy-subrc EQ 0.
        ASSIGN COMPONENT <fs_comp>-name OF STRUCTURE is_db TO <fs_field_db>.
        IF sy-subrc EQ 0.
          IF <fs_field_upd> EQ <fs_field_db>.
          ELSE.
            APPEND INITIAL LINE TO ct_logs ASSIGNING <fs_log_line>.
            <fs_log_line>-mandt = cl_abap_syst=>get_client( ).
            <fs_log_line>-change_guid = get_change_guid(  ).
*            <fs_log_line>-var_name = is_upd-var_name.
*            CLEAR <fs_log_line>-var_numb.
            ASSIGN COMPONENT 'VAR_NAME' OF STRUCTURE is_upd TO <fs_field_var_name>.
            IF sy-subrc EQ 0.
              <fs_log_line>-var_name = <fs_field_var_name>.
            ENDIF.
            ASSIGN COMPONENT 'VAR_NUMB' OF STRUCTURE is_upd TO <fs_field_var_numb>.
            IF sy-subrc EQ 0.
              <fs_log_line>-var_numb = <fs_field_var_numb>.
            ENDIF.
            <fs_log_line>-field_name = <fs_comp>-name.
            <fs_log_line>-field_val_old = <fs_field_db>.
            <fs_log_line>-field_val_new = <fs_field_upd>.
            <fs_log_line>-change_type = 'U'.
            GET TIME STAMP FIELD <fs_log_line>-chts.
            <fs_log_line>-chu = cl_abap_syst=>get_user_name( ).
            <fs_log_line>-chd = sy-datum.
            <fs_log_line>-cht = sy-uzeit.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD prepare4insert.
*    IMPORTING is_ins type ztwa001_varid
*    CHANGING ct_logs type ztwa001_varlog_tab.

    DATA lo_struct_ins TYPE REF TO cl_abap_structdescr.


    DATA lt_component_tab TYPE abap_component_tab.
    FIELD-SYMBOLS <fs_comp> TYPE abap_componentdescr.

    FIELD-SYMBOLS <fs_field_ins> TYPE any.
    FIELD-SYMBOLS <fs_log_line> TYPE ztwa001_varlog.

    FIELD-SYMBOLS <fs_field_var_name> TYPE any.
    FIELD-SYMBOLS <fs_field_var_numb> TYPE any.

    lo_struct_ins ?= cl_abap_structdescr=>describe_by_data( p_data = is_ins ).

    lt_component_tab = lo_struct_ins->get_components( ).

    LOOP AT lt_component_tab ASSIGNING <fs_comp>.
      ASSIGN COMPONENT <fs_comp>-name OF STRUCTURE is_ins TO <fs_field_ins>.
      IF sy-subrc EQ 0.
        IF <fs_field_ins> IS NOT INITIAL.
          APPEND INITIAL LINE TO ct_logs ASSIGNING <fs_log_line>.
          <fs_log_line>-mandt = cl_abap_syst=>get_client( ).
          <fs_log_line>-change_guid = get_change_guid(  ).

          ASSIGN COMPONENT 'VAR_NAME' OF STRUCTURE is_ins TO <fs_field_var_name>.
          IF sy-subrc EQ 0.
            <fs_log_line>-var_name = <fs_field_var_name>.
          ENDIF.
          ASSIGN COMPONENT 'VAR_NUMB' OF STRUCTURE is_ins TO <fs_field_var_numb>.
          IF sy-subrc EQ 0.
            <fs_log_line>-var_numb = <fs_field_var_numb>.
          ENDIF.

          <fs_log_line>-field_name = <fs_comp>-name.
          CLEAR <fs_log_line>-field_val_old.
          <fs_log_line>-field_val_new = <fs_field_ins>.
          <fs_log_line>-change_type = 'I'.
          GET TIME STAMP FIELD <fs_log_line>-chts.
          <fs_log_line>-chu = cl_abap_syst=>get_user_name( ).
          <fs_log_line>-chd = sy-datum.
          <fs_log_line>-cht = sy-uzeit.
        ENDIF.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD get_change_guid.
    "RETURNING VALUE(rv_val) TYPE char32.
    DATA lo_uuid TYPE REF TO cl_system_uuid.
    TRY.
        lo_uuid = NEW #(  ).
        rv_val = lo_uuid->if_system_uuid~create_uuid_c32(  ).
      CATCH cx_uuid_error.
        WAIT UP TO 1 SECONDS.
        rv_val = 'WA001_' && sy-datum && sy-uzeit.
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
