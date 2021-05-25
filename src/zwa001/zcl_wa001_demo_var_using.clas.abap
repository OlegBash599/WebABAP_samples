CLASS zcl_wa001_demo_var_using DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor.

    METHODS set_scrn
      IMPORTING it_rng_var_name TYPE ANY TABLE.

    METHODS start_of_sel.
    METHODS end_of_sel.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA mt_range_var TYPE RANGE OF zewa001_var_name.
    DATA mt_output_txt TYPE tline_tab.

    DATA mo_var TYPE REF TO zcl_wa001_var_read.

    METHODS check4switch1.
    METHODS check4switch2.

    METHODS check_for_sep_value1.
    METHODS check_for_sep_value2.

    METHODS check_if_val_in_range1.
    METHODS check_if_val_in_range2.

    METHODS check4switch
      IMPORTING iv_var_name TYPE zewa001_var_name.


    METHODS check_for_sep_value
      IMPORTING iv_var_name TYPE zewa001_var_name.

    METHODS check_if_val_in_range
      IMPORTING iv_var_name TYPE zewa001_var_name.
ENDCLASS.



CLASS zcl_wa001_demo_var_using IMPLEMENTATION.
  METHOD constructor.
    mo_var = NEW #(  ).
  ENDMETHOD.

  METHOD set_scrn.
    "IMPORTING it_rng_var_name TYPE any TABLE.
    MOVE-CORRESPONDING it_rng_var_name[] TO  mt_range_var[].
  ENDMETHOD.

  METHOD start_of_sel.


    CLEAR mt_output_txt.

    check4switch1(  ).

    check4switch2(  ).

    check_for_sep_value1(  ).

    check_for_sep_value2(  ).


    check_if_val_in_range1(  ).

    check_if_val_in_range1(  ).


  ENDMETHOD.

  METHOD end_of_sel.
    DATA lo_alv_short TYPE REF TO cl_salv_table.

    TRY.
        cl_salv_table=>factory(
            IMPORTING
                r_salv_table = lo_alv_short
            CHANGING t_table = mt_output_txt ).

        lo_alv_short->display(  ).

      CATCH cx_salv_msg .

    ENDTRY.
  ENDMETHOD.

  METHOD check4switch1.

    DATA lv_var_name_switch TYPE zewa001_var_name VALUE 'ZCO_N41'.

    check4switch( lv_var_name_switch ).
  ENDMETHOD.

  METHOD check4switch2.
    DATA lv_var_name_switch TYPE zewa001_var_name VALUE 'ZDMS_N21'.

    check4switch( lv_var_name_switch ).
  ENDMETHOD.

  METHOD check4switch.
    "        IMPORTING iv_var_name TYPE zewa001_var_name.

    FIELD-SYMBOLS <fs_output_line> TYPE tline.

    APPEND INITIAL LINE TO mt_output_txt ASSIGNING <fs_output_line>.
    <fs_output_line>-tdline = |****~~~~~****~~~~~****~~~~~****~~~~~|.
    APPEND INITIAL LINE TO mt_output_txt ASSIGNING <fs_output_line>.
    <fs_output_line>-tdline = |...Check if switch { iv_var_name } is on|.

    IF mo_var->if_switch( iv_var_name ) EQ abap_true.

      APPEND INITIAL LINE TO mt_output_txt ASSIGNING <fs_output_line>.
      <fs_output_line>-tdline = |switch { iv_var_name } is +++ON+++|.

    ELSE.

      APPEND INITIAL LINE TO mt_output_txt ASSIGNING <fs_output_line>.
      <fs_output_line>-tdline = |switch { iv_var_name } is ---OFF---|.
    ENDIF.

  ENDMETHOD.

  METHOD check_for_sep_value.
    "      IMPORTING iv_var_name TYPE zewa001_var_name.
    DATA lv_val_char20 TYPE char20.
    FIELD-SYMBOLS <fs_output_line> TYPE tline.

    APPEND INITIAL LINE TO mt_output_txt ASSIGNING <fs_output_line>.
    <fs_output_line>-tdline = |+++++++////////+++++++////////+++++++////////|.
    APPEND INITIAL LINE TO mt_output_txt ASSIGNING <fs_output_line>.
    <fs_output_line>-tdline = |...reading value for { iv_var_name }|.

    mo_var->v( EXPORTING iv_var = iv_var_name
               IMPORTING ev = lv_val_char20 ).

    APPEND INITIAL LINE TO mt_output_txt ASSIGNING <fs_output_line>.
    <fs_output_line>-tdline = |...value:   { lv_val_char20 }|.
  ENDMETHOD.
  METHOD check_for_sep_value1.
    DATA lv_var_name_sep_val TYPE zewa001_var_name VALUE 'ZDMS_N12'.

    check_for_sep_value( lv_var_name_sep_val ).
  ENDMETHOD.

  METHOD check_for_sep_value2.
    DATA lv_var_name_sep_val TYPE zewa001_var_name VALUE 'ZCO_N41'.

    check_for_sep_value( lv_var_name_sep_val ).
  ENDMETHOD.

  METHOD check_if_val_in_range1.
    DATA lv_var_name_rng TYPE zewa001_var_name VALUE 'ZAPO_N15'.

    check_if_val_in_range( lv_var_name_rng ).
  ENDMETHOD.

  METHOD check_if_val_in_range2.
    DATA lv_var_name_rng TYPE zewa001_var_name VALUE 'ZAPO_N24'.
    check_if_val_in_range( lv_var_name_rng ).
  ENDMETHOD.

  METHOD check_if_val_in_range.
    "IMPORTING iv_var_name TYPE zewa001_var_name.
    DATA lv_line_str TYPE string.
    DATA lt_range TYPE RANGE OF char20.
    DATA lv_tot_records_in_range TYPE char18.
    FIELD-SYMBOLS <fs_rng_line> LIKE LINE OF lt_range.

    DATA lv_val_char20 TYPE char20.
    FIELD-SYMBOLS <fs_output_line> TYPE tline.

    APPEND INITIAL LINE TO mt_output_txt ASSIGNING <fs_output_line>.
    <fs_output_line>-tdline = |+++++++////////+++++++////////+++++++////////|.
    APPEND INITIAL LINE TO mt_output_txt ASSIGNING <fs_output_line>.
    <fs_output_line>-tdline = |...reading RANGE for { iv_var_name }|.

    mo_var->r( EXPORTING iv_var = iv_var_name
               IMPORTING et = lt_range ).

    lv_tot_records_in_range = lines( lt_range ).
    APPEND INITIAL LINE TO mt_output_txt ASSIGNING <fs_output_line>.
    <fs_output_line>-tdline = |.total number of records in range is { lv_tot_records_in_range }|.

    APPEND INITIAL LINE TO mt_output_txt ASSIGNING <fs_output_line>.
    <fs_output_line>-tdline = |... outputing one by one ....|.
    LOOP AT lt_range ASSIGNING <fs_rng_line>.
      APPEND INITIAL LINE TO mt_output_txt ASSIGNING <fs_output_line>.

      lv_line_str =
      |......sign: { <fs_rng_line>-sign } // option: { <fs_rng_line>-option } // low: { <fs_rng_line>-low } // HIGH: { <fs_rng_line>-high }|.
      CONDENSE lv_line_str.
      <fs_output_line>-tdline = lv_line_str.
    ENDLOOP.


  ENDMETHOD.
ENDCLASS.
