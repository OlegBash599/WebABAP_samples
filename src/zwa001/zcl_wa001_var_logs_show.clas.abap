CLASS zcl_wa001_var_logs_show DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor.
    METHODS sh
      IMPORTING it_varlog TYPE ztwa001_varlog_tab.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA mt_var_log_db TYPE ztwa001_varlog_tab.

    METHODS show_alv_short.

ENDCLASS.



CLASS zcl_wa001_var_logs_show IMPLEMENTATION.
  METHOD constructor.

  ENDMETHOD.

  METHOD sh.
    IF it_varlog IS INITIAL.
      RETURN.
      MESSAGE s000(cl) WITH 'Nothing to show.'.
    ENDIF.


    CLEAR mt_var_log_db.


    SELECT * FROM ztwa001_varlog
        INTO TABLE mt_var_log_db
        FOR ALL ENTRIES IN it_varlog
        WHERE var_name EQ it_varlog-var_name.

    show_alv_short(  ).

  ENDMETHOD.

  METHOD show_alv_short.
    DATA lo_alv_short TYPE REF TO cl_salv_table.

    TRY.
        cl_salv_table=>factory(
            IMPORTING
                r_salv_table = lo_alv_short
            CHANGING t_table = mt_var_log_db ).

        lo_alv_short->display(  ).

      CATCH cx_salv_msg .

    ENDTRY.
  ENDMETHOD.

ENDCLASS.
