CLASS zcl_wa001_mngvar_file DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING iv_var_name TYPE zewa001_var_name.
    METHODS sh
      EXPORTING ev_rc TYPE sysubrc.

    METHODS upload_file
      EXPORTING ev_rc TYPE sysubrc.

    METHODS download_file.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA mv_var_name TYPE zewa001_var_name.

    METHODS ask4path_file
      RETURNING VALUE(rv_val) TYPE string.

    METHODS get_pc_file_bin_data
      IMPORTING iv_file_path  TYPE string
      RETURNING VALUE(rv_val) TYPE xstring.

    METHODS get_file_name
      IMPORTING iv_file_path  TYPE string
      RETURNING VALUE(rv_val) TYPE string.

    METHODS save_file2var
      IMPORTING iv_file_name    TYPE string
                iv_file_xstring TYPE xstring.

    METHODS get_guid
      RETURNING VALUE(rv_val) TYPE char32.

    METHODS fill_file_data
      EXPORTING et_file_data_xtab TYPE solix_tab
                ev_file_disk_name TYPE string
                ev_file_size      TYPE syindex.

    METHODS ask4path_save_file
      RETURNING VALUE(rv_val) TYPE string.

    METHODS get_separator_os
      RETURNING VALUE(rv_val) TYPE string.

    METHODS save_file2pc
      CHANGING ct_file_data_xtab TYPE solix_tab
               cv_file_name      TYPE string
               cv_file_size      TYPE syindex.

ENDCLASS.



CLASS zcl_wa001_mngvar_file IMPLEMENTATION.
  METHOD constructor.
    mv_var_name = iv_var_name.
  ENDMETHOD.

  METHOD sh.

  ENDMETHOD.

  METHOD upload_file.

    DATA lv_path2file TYPE string.
    DATA lv_file_xstring TYPE xstring.
    DATA lv_file_name TYPE string.

    lv_path2file = ask4path_file(  ).

    IF lv_path2file IS INITIAL.
      ev_rc = 0.
      RETURN.
    ELSE.
      lv_file_name =
      get_file_name( iv_file_path = lv_path2file ).
    ENDIF.

    lv_file_xstring = get_pc_file_bin_data( lv_path2file ).
    IF lv_file_xstring IS INITIAL.
      ev_rc = 0.
      RETURN.
    ENDIF.

    save_file2var( EXPORTING iv_file_name = lv_file_name
                             iv_file_xstring = lv_file_xstring ).

    MESSAGE s000(cl) WITH 'File has been uploaded'.

    ev_rc = 1.
  ENDMETHOD.

  METHOD download_file.
    DATA lv_path2file TYPE string.
    DATA lt_file_data_xtab TYPE solix_tab.
    DATA lv_file_name_on_disk TYPE string.
    DATA lv_separator TYPE string.
    DATA lv_file_size TYPE sytabix.

    fill_file_data( IMPORTING et_file_data_xtab = lt_file_data_xtab
                              ev_file_disk_name = lv_file_name_on_disk
                              ev_file_size = lv_file_size ).

    IF lt_file_data_xtab IS NOT INITIAL.
      lv_path2file = ask4path_save_file(  ).
      "lv_separator = get_separator_os(  ).
      "lv_path2file = lv_path2file && lv_separator && lv_file_name_on_disk.
      lv_path2file = lv_path2file && lv_file_name_on_disk.
      save_file2pc( CHANGING ct_file_data_xtab = lt_file_data_xtab
                             cv_file_name      = lv_path2file
                             cv_file_size = lv_file_size ).

    ENDIF.

  ENDMETHOD.

  METHOD get_separator_os.
    DATA lv_separator TYPE char1.

    NEW cl_gui_frontend_services( )->get_file_separator( CHANGING file_separator = lv_separator ).
    rv_val = lv_separator.
  ENDMETHOD.

  METHOD save_file2pc.
    DATA lv_filelength TYPE syindex.

    NEW cl_gui_frontend_services( )->gui_download(
        EXPORTING bin_filesize = cv_file_size
                  filename = cv_file_name
                  filetype = 'BIN'
        IMPORTING filelength = lv_filelength
        CHANGING data_tab = ct_file_data_xtab
        EXCEPTIONS OTHERS = 99
    ).
  ENDMETHOD.

  METHOD fill_file_data.
    "EXPORTING et_file_data_tab TYPE soli_tab.
    DATA lt_var_file TYPE ztwa001_varfile_tab.
    DATA lv_file_xstring TYPE xstring.

    FIELD-SYMBOLS <fs_var_file> TYPE ztwa001_varfile.

    SELECT * FROM ztwa001_varfile
        INTO TABLE lt_var_file
        WHERE var_name = mv_var_name.

    LOOP AT lt_var_file ASSIGNING <fs_var_file>.
      ev_file_disk_name = <fs_var_file>-parh2file.
      OPEN DATASET <fs_var_file>-parh2file FOR INPUT IN BINARY MODE.
      IF sy-subrc EQ 0.
        READ DATASET <fs_var_file>-parh2file INTO lv_file_xstring.
        CLOSE DATASET <fs_var_file>-parh2file.
      ENDIF.
      EXIT.
    ENDLOOP.

    IF lv_file_xstring IS NOT INITIAL.
      ev_file_size = xstrlen( lv_file_xstring ).
      cl_bcs_convert=>xstring_to_xtab( EXPORTING iv_xstring = lv_file_xstring
                                       IMPORTING et_xtab = et_file_data_xtab ).
    ENDIF.

  ENDMETHOD.

  METHOD ask4path_save_file.
    "        RETURNING VALUE(rv_val) TYPE string.
    DATA lv_filename TYPE string.
    DATA lv_path TYPE string.
    DATA lv_fullpath TYPE string.
    DATA lo_frontend_services TYPE REF TO cl_gui_frontend_services.
    lo_frontend_services = NEW #(  ).

    lo_frontend_services->file_save_dialog(
    CHANGING
        filename = lv_filename
        path = lv_path
        fullpath = lv_fullpath
    EXCEPTIONS OTHERS = 99
    ).

    rv_val = lv_path.

  ENDMETHOD.

  METHOD save_file2var.
*        IMPORTING iv_file_name TYPE string
*                  iv_file_xstring TYPE xstring.
    DATA lv_disk_filename TYPE string.
    DATA lv_ts TYPE timestamp.
    DATA lv_ts_str TYPE string.

    DATA lt_varfile TYPE ztwa001_varfile_tab.
    FIELD-SYMBOLS <fs_varfile> TYPE ztwa001_varfile.

    DATA ls_return TYPE bapiret2.

    GET TIME STAMP FIELD lv_ts.
    lv_ts_str = lv_ts.
    lv_disk_filename = |FILE_VAR_{ mv_var_name }_{ lv_ts_str }_{ iv_file_name }|.
    CONDENSE lv_disk_filename NO-GAPS.

    OPEN DATASET lv_disk_filename IN BINARY MODE FOR OUTPUT.
    IF sy-subrc EQ 0.
      TRANSFER iv_file_xstring TO lv_disk_filename.
      CLOSE DATASET lv_disk_filename.
    ENDIF.

    SELECT * FROM ztwa001_varfile
        INTO TABLE lt_varfile
        WHERE var_name = mv_var_name.
    IF sy-subrc EQ 0.
      READ TABLE lt_varfile ASSIGNING <fs_varfile> INDEX 1.
    ELSE.
      APPEND INITIAL LINE TO lt_varfile ASSIGNING <fs_varfile>.
      <fs_varfile>-mandt = cl_abap_syst=>get_client(  ).
      <fs_varfile>-file_guid = get_guid(  ).
      <fs_varfile>-var_name = mv_var_name.
    ENDIF.

    <fs_varfile>-parh2file = lv_disk_filename.
    GET TIME STAMP FIELD <fs_varfile>-chts.
    <fs_varfile>-chu = sy-uname.
    <fs_varfile>-chd = sy-datum.
    <fs_varfile>-cht = sy-uzeit.

    CALL FUNCTION 'Z_WA001_VAR_FILE_UPD'
      IN UPDATE TASK
      EXPORTING
        it_var_file = lt_varfile.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait   = abap_true
      IMPORTING
        return = ls_return.


  ENDMETHOD.

  METHOD get_file_name.
    "        RETURNING VALUE(rv_val) TYPE string.
    DATA lt_tab_str TYPE STANDARD TABLE OF string.
    DATA lv_file TYPE string.

    SPLIT iv_file_path AT '\' INTO TABLE lt_tab_str.

    READ TABLE lt_tab_str INTO lv_file INDEX lines( lt_tab_str ).
    CONDENSE lv_file NO-GAPS.
    rv_val = lv_file.


  ENDMETHOD.

  METHOD ask4path_file.
    "RETURNING VALUE(rv_val) TYPE string.
    DATA lt_file_table TYPE filetable.
    DATA lv_rc TYPE syindex.
    DATA lv_title TYPE string VALUE 'Choose file for upload'.

    FIELD-SYMBOLS <fs_file_name> TYPE file_table.

    CALL METHOD cl_gui_frontend_services=>file_open_dialog
      EXPORTING
        window_title = lv_title
      CHANGING
        file_table   = lt_file_table
        rc           = lv_rc
      EXCEPTIONS
        OTHERS       = 99.

    READ TABLE lt_file_table ASSIGNING <fs_file_name> INDEX 1.
    IF sy-subrc EQ 0.
      rv_val = <fs_file_name>-filename.
    ENDIF.

  ENDMETHOD.

  METHOD get_pc_file_bin_data.
*       IMPORTING iv_file_path TYPE string
*       RETURNING VALUE(rv_val) TYPE xstring.
    DATA lo_frontend_serv TYPE REF TO cl_gui_frontend_services.
    DATA lv_file_length TYPE syindex.
    DATA lv_xheader TYPE xstring.
    DATA lt_soli_tab TYPE soli_tab.
    DATA lt_solix_tab TYPE solix_tab.

    lo_frontend_serv = NEW #(  ).

    lo_frontend_serv->gui_upload(
        EXPORTING filename = iv_file_path
                  filetype = 'BIN'
        IMPORTING filelength = lv_file_length
                  header = lv_xheader
        CHANGING data_tab = lt_solix_tab
        EXCEPTIONS OTHERS = 99
    ).

    IF lt_solix_tab IS INITIAL.
      CLEAR rv_val.
      RETURN.
    ENDIF.

    TRY.
        rv_val =
    "    cl_bcs_convert=>raw_to_xstring( it_soli = lt_solix_tab ).
        cl_bcs_convert=>xtab_to_xstring( it_xtab = lt_solix_tab ).
      CATCH cx_bcs.
    ENDTRY.
  ENDMETHOD.

  METHOD get_guid.
    "        RETURNING VALUE(rv_val) TYPE char32.
    DATA lo_uuid TYPE REF TO cl_system_uuid.
    TRY.
        lo_uuid = NEW #(  ).
        rv_val = lo_uuid->if_system_uuid~create_uuid_c32(  ).
      CATCH cx_uuid_error.
        WAIT UP TO 1 SECONDS.
        rv_val = 'WAFG001_' && sy-datum && sy-uzeit.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
