CLASS zcl_wa001_manage_varid DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS constructor.

    METHODS set_dto
      IMPORTING io_scr TYPE REF TO zcl_wa001_mngvar_scr_dto.

    METHODS sh.



  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS mc_output_alv TYPE tabname VALUE 'ZSWA001_VARIABLE_ALV' ##NO_TEXT.

    DATA mo_handler TYPE REF TO zcl_wa001_manage_varid_hndl.

    DATA mo_dto_scr TYPE REF TO zcl_wa001_mngvar_scr_dto.
    DATA mo_alv_on_dto TYPE REF TO zif_c8a001_alvtab_on_dto.

    DATA mt_var_list TYPE zttwa001_variable_alv.

    METHODS fill_var_list.
    METHODS show_in_alv_list.

    METHODS get_alv_dto
      RETURNING
        VALUE(ro_obj) TYPE REF TO zif_c8a001_alv_dto .

    METHODS refresh_after_update FOR EVENT updation_done
        OF zcl_wa001_manage_varid_hndl.
ENDCLASS.



CLASS zcl_wa001_manage_varid IMPLEMENTATION.
  METHOD constructor.
    mo_handler = NEW #(  ).

    SET HANDLER refresh_after_update FOR mo_handler ACTIVATION abap_true.

  ENDMETHOD.

  METHOD set_dto.
    mo_dto_scr ?= io_scr.
  ENDMETHOD.


  METHOD sh.

    fill_var_list(  ).

    show_in_alv_list(  ).

  ENDMETHOD.

  METHOD fill_var_list.
    DATA lt_var_id TYPE ztwa001_varid_tab.
    DATA lt_var_val TYPE ztwa001_varval_tab.
    DATA lt_var_file TYPE ztwa001_varfile_tab.

    FIELD-SYMBOLS <fs_var_id> TYPE ztwa001_varid.
    FIELD-SYMBOLS <fs_var_list> TYPE zswa001_variable_alv.

    SELECT * FROM ztwa001_varid
        INTO TABLE lt_var_id
        WHERE var_name IN mo_dto_scr->mt_var_name_rng
        .

    IF lt_var_id IS NOT INITIAL.
      SELECT * FROM ztwa001_varval
         INTO TABLE lt_var_val
         FOR ALL ENTRIES IN lt_var_id
         WHERE  var_name EQ lt_var_id-var_name
         .

      SELECT * FROM ztwa001_varfile
        INTO TABLE lt_var_file
        FOR ALL ENTRIES IN lt_var_id
         WHERE  var_name EQ lt_var_id-var_name
         .
    ENDIF.


    CLEAR mt_var_list.

    LOOP AT lt_var_id ASSIGNING <fs_var_id>.
      APPEND INITIAL LINE TO mt_var_list ASSIGNING <fs_var_list>.
      MOVE-CORRESPONDING <fs_var_id> TO <fs_var_list>.

      <fs_var_list>-name = <fs_var_id>-var_name.
      <fs_var_list>-description = <fs_var_id>-var_desc.
      <fs_var_list>-var_type = <fs_var_id>-var_type.

      <fs_var_list>-is_del = <fs_var_id>-is_del.
      <fs_var_list>-debug_is_on = <fs_var_id>-is_debug_on.
      <fs_var_list>-fast_val = <fs_var_id>-fast_val.
      <fs_var_list>-cru = <fs_var_id>-cru.
      <fs_var_list>-crd = <fs_var_id>-crd.
      <fs_var_list>-crt = <fs_var_id>-crt.
      <fs_var_list>-chu = <fs_var_id>-chu.
      <fs_var_list>-chd = <fs_var_id>-chd.
      <fs_var_list>-cht = <fs_var_id>-cht.

      <fs_var_list>-num_of_values = REDUCE i( INIT vals_in_var = 0
                                              FOR ls_var_val IN lt_var_val WHERE ( var_name = <fs_var_id>-var_name )
                                              NEXT vals_in_var = vals_in_var + 1 ).

      <fs_var_list>-num_of_files = REDUCE i( INIT files_in_var = 0
                                              FOR ls_var_file IN lt_var_file WHERE ( var_name = <fs_var_id>-var_name )
                                              NEXT files_in_var = files_in_var + 1 ).
    ENDLOOP.

  ENDMETHOD.


  METHOD show_in_alv_list.

    DATA lo_alv_dto TYPE REF TO zif_c8a001_alv_dto.



    lo_alv_dto ?= get_alv_dto( ).

    mo_alv_on_dto ?= zcl_c8a001_alv_factory=>get_ins(
      )->alv_on_dto( lo_alv_dto ).
    mo_alv_on_dto->show( CHANGING ct_tab = mt_var_list ).

    zcl_c8a001_alv_factory=>get_ins( )->alv_on_dto_free( ).
  ENDMETHOD.

  METHOD get_alv_dto.

    ro_obj ?= zcl_c8a001_alv_factory=>get_ins( )->get_dto4alv( ).
    ro_obj->set_structure( iv_struct = mc_output_alv ).
    ro_obj->set_double_click_handler( mo_handler ).


    """"""""""""""""""""""""""""""""""""""""""""""""""""""'
    " alv - buttons - user command
    DATA ls_but TYPE zsc8a001_alv_button_handler.
    DATA lt_but TYPE zttc8a001_alv_button_handler.

    ls_but-function = 'ZOPEN_VAL'.
    ls_but-icon = icon_display.
    ls_but-quickinfo  = 'Values for Variable'.
    ls_but-text  = 'Values for Variable'.
    ls_but-obj2handl ?= mo_handler.
    APPEND ls_but TO lt_but .


    CLEAR ls_but.
    ls_but-function = 'ZSEP01'.
    ls_but-butn_type = '3'.
    APPEND ls_but TO lt_but .

    CLEAR ls_but.
    ls_but-function = 'ZSHOW_LOGS'.
    ls_but-icon = icon_history.
    ls_but-quickinfo  = 'Show Logs'.
    ls_but-text  = 'Show Logs'.
    ls_but-obj2handl ?= mo_handler.
    APPEND ls_but TO lt_but .


    CLEAR ls_but.
    ls_but-function = 'ZSEP02'.
    ls_but-butn_type = '3'.
    APPEND ls_but TO lt_but .

    CLEAR ls_but.
    ls_but-function = 'ZDOC_UPLOAD'.
    ls_but-icon = icon_display_more.
    ls_but-quickinfo  = 'Upload HelpDoc'.
    ls_but-text  = 'Upload HelpDoc'.
    ls_but-obj2handl ?= mo_handler.
    APPEND ls_but TO lt_but .


    CLEAR ls_but.
    ls_but-function = 'ZSEP03'.
    ls_but-butn_type = '3'.
    APPEND ls_but TO lt_but .

    CLEAR ls_but.
    ls_but-function = 'ZDOC_DOWNLOAD'.
    ls_but-icon = icon_system_undo.
    ls_but-quickinfo  = 'Download HelpDoc'.
    ls_but-text  = 'Download HelpDoc (if exists)'.
    ls_but-obj2handl ?= mo_handler.
    APPEND ls_but TO lt_but .

    ro_obj->set_toolbar_process( it_button = lt_but ).
    ro_obj->set_layout_hndl( mo_handler ).
    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""'
    " variant management for selection screen and alv inside
    "  ro_obj->set_variant( is_variant = io_dto_scr->ms_disvariant ).
    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""'

  ENDMETHOD.

  METHOD refresh_after_update.
    fill_var_list(  ).
    mo_alv_on_dto->refresh_scr(  ).
  ENDMETHOD.

ENDCLASS.
