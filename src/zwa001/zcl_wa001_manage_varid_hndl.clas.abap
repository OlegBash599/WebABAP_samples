CLASS zcl_wa001_manage_varid_hndl DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS double_click
      IMPORTING
        !e_row            TYPE lvc_s_row
        !e_column         TYPE lvc_s_col
        !es_row_no        TYPE lvc_s_roid
        !io_grid          TYPE REF TO cl_gui_alv_grid
        !isr_line_clicked TYPE REF TO data .
    METHODS user_command
      IMPORTING
        !iv_ucomm    TYPE syucomm
        !io_grid     TYPE REF TO cl_gui_alv_grid
      CHANGING
        !ir_stan_tab TYPE STANDARD TABLE .


    METHODS build_layout
      CHANGING ct_fieldcat TYPE lvc_t_fcat.

    EVENTS updation_done.

  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES ts_line TYPE zswa001_variable_alv .
    TYPES tt_line TYPE STANDARD TABLE OF zswa001_variable_alv WITH DEFAULT KEY.

    METHODS open_var_values
      IMPORTING is_line TYPE ts_line.

    METHODS upload_doc2var
      IMPORTING is_line TYPE ts_line.

    METHODS download_doc2var
      IMPORTING is_line TYPE ts_line.

    METHODS show_logs
      IMPORTING it_sel_lines TYPE tt_line.

ENDCLASS.



CLASS zcl_wa001_manage_varid_hndl IMPLEMENTATION.
  METHOD double_click.
    FIELD-SYMBOLS <fs_line> TYPE ts_line.
    ASSIGN isr_line_clicked->* TO <fs_line>.

    IF <fs_line> IS ASSIGNED.
      open_var_values( <fs_line> ).
    ENDIF.

  ENDMETHOD.

  METHOD user_command.
*      IMPORTING
*        !iv_ucomm    TYPE syucomm
*        !io_grid     TYPE REF TO cl_gui_alv_grid
*        !ir_stan_tab TYPE STANDARD TABLE .


    DATA lt_index_rows  TYPE lvc_t_row.
    DATA lt_sel_tab_lines TYPE tt_line.
    FIELD-SYMBOLS <fs_row> TYPE lvc_s_row.
    FIELD-SYMBOLS <fs_line> TYPE ts_line.

    io_grid->get_selected_rows(
         IMPORTING
           et_index_rows = lt_index_rows    " Indexes of Selected Rows
*          et_row_no     =     " Numeric IDs of Selected Rows
       ).

    CASE iv_ucomm.
      WHEN 'ZOPEN_VAL'.
        LOOP AT lt_index_rows ASSIGNING <fs_row>.
          READ TABLE ir_stan_tab ASSIGNING <fs_line> INDEX <fs_row>-index.
          IF sy-subrc EQ 0.
            open_var_values( <fs_line> ).
          ENDIF.
          EXIT.
        ENDLOOP.

      WHEN 'ZSHOW_LOGS'.
        CLEAR lt_sel_tab_lines.
        LOOP AT lt_index_rows ASSIGNING <fs_row>.
          READ TABLE ir_stan_tab ASSIGNING <fs_line> INDEX <fs_row>-index.
          IF sy-subrc EQ 0.
            APPEND <fs_line> TO lt_sel_tab_lines.
          ENDIF.
        ENDLOOP.

        show_logs( EXPORTING it_sel_lines = lt_sel_tab_lines ).

      WHEN 'ZDOC_UPLOAD'.
        LOOP AT lt_index_rows ASSIGNING <fs_row>.
          READ TABLE ir_stan_tab ASSIGNING <fs_line> INDEX <fs_row>-index.
          IF sy-subrc EQ 0.
            upload_doc2var( <fs_line> ).
          ENDIF.
          EXIT.
        ENDLOOP.

      WHEN 'ZDOC_DOWNLOAD'.

        LOOP AT lt_index_rows ASSIGNING <fs_row>.
          READ TABLE ir_stan_tab ASSIGNING <fs_line> INDEX <fs_row>-index.
          IF sy-subrc EQ 0.
            download_doc2var( <fs_line> ).
          ENDIF.
          EXIT.
        ENDLOOP.

      WHEN OTHERS.
    ENDCASE.

  ENDMETHOD.

  METHOD open_var_values.

    DATA lo_mngvar_edit TYPE REF TO zcl_wa001_mngvar_edit.

    DATA lv_rc TYPE sysubrc.


    lo_mngvar_edit = NEW #( is_line-name ).
    lo_mngvar_edit->sh( IMPORTING ev_rc = lv_rc ).

    IF lv_rc EQ 1.
      RAISE EVENT updation_done.
    ENDIF.

  ENDMETHOD.

  METHOD show_logs.
    "EXPORTING it_sel_lines TYPE tt_line.
    DATA lt_varlog TYPE ztwa001_varlog_tab.
    FIELD-SYMBOLS <fs_varlog> TYPE ztwa001_varlog.
    FIELD-SYMBOLS <fs_sel_line> TYPE ts_line.

    LOOP AT it_sel_lines ASSIGNING <fs_sel_line>.
      APPEND INITIAL LINE TO lt_varlog ASSIGNING <fs_varlog>.
      <fs_varlog>-var_name = <fs_sel_line>-name.
    ENDLOOP.

    DELETE lt_varlog WHERE var_name IS INITIAL.
    SORT lt_varlog.
    DELETE ADJACENT DUPLICATES FROM lt_varlog.



    DATA lo_logs_show TYPE REF TO zcl_wa001_var_logs_show.
    lo_logs_show = NEW #(  ).

    lo_logs_show->sh( EXPORTING it_varlog = lt_varlog ).

  ENDMETHOD.

  METHOD build_layout.
    "        changing CT_FIELDCAT    TYPE LVC_T_FCAT.
    FIELD-SYMBOLS: <fs_fcat> TYPE lvc_s_fcat.

    LOOP AT ct_fieldcat ASSIGNING <fs_fcat>.
      CASE <fs_fcat>-fieldname.
        WHEN 'FAST_VAL'.
          <fs_fcat>-outputlen = 10.

        WHEN 'NAME'.
          <fs_fcat>-outputlen = 10.

        WHEN 'DESCRIPTION'.
          <fs_fcat>-outputlen = 20.

        WHEN 'IS_DEBUG_ON'.
          <fs_fcat>-checkbox  = abap_true.

        WHEN OTHERS.

      ENDCASE.
    ENDLOOP.
  ENDMETHOD.

  METHOD upload_doc2var.
    "        IMPORTING is_line TYPE ts_line.

    DATA lo_mngvar_file TYPE REF TO zcl_wa001_mngvar_file.

    DATA lv_rc TYPE sysubrc.


    lo_mngvar_file = NEW #( is_line-name ).
    lo_mngvar_file->upload_file( IMPORTING ev_rc = lv_rc ).

    IF lv_rc EQ 1.
      RAISE EVENT updation_done.
    ENDIF.

  ENDMETHOD.

  METHOD download_doc2var.
    "        IMPORTING is_line TYPE ts_line.
    DATA lo_mngvar_file TYPE REF TO zcl_wa001_mngvar_file.

    DATA lv_rc TYPE sysubrc.


    lo_mngvar_file = NEW #( is_line-name ).
    lo_mngvar_file->download_file( ).
  ENDMETHOD.
ENDCLASS.
