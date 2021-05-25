CLASS zcl_zweb_abap_demo11_dpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zcl_zweb_abap_demo11_dpc
  CREATE PUBLIC .

  PUBLIC SECTION.
  PROTECTED SECTION.

    METHODS varheadset_get_entityset
        REDEFINITION .

    METHODS varheadset_get_entity REDEFINITION .
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_zweb_abap_demo11_dpc_ext IMPLEMENTATION.


  METHOD varheadset_get_entityset.
**TRY.
*CALL METHOD SUPER->VARHEADSET_GET_ENTITYSET
*  EXPORTING
*    IV_ENTITY_NAME           =
*    IV_ENTITY_SET_NAME       =
*    IV_SOURCE_NAME           =
*    IT_FILTER_SELECT_OPTIONS =
*    IS_PAGING                =
*    IT_KEY_TAB               =
*    IT_NAVIGATION_PATH       =
*    IT_ORDER                 =
*    IV_FILTER_STRING         =
*    IV_SEARCH_STRING         =
**    io_tech_request_context  =
**  IMPORTING
**    et_entityset             =
**    es_response_context      =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.

    DATA lt_varid TYPE STANDARD TABLE OF ztwa001_varid.

    DATA lt_set_out TYPE zcl_zweb_abap_demo11_mpc=>tt_varhead.


    SELECT * FROM ztwa001_varid
        INTO TABLE lt_varid
      UP TO 10000 ROWS.


    cl_abap_corresponding=>create(
  source            = lt_varid
  destination       = lt_set_out
  mapping           = VALUE cl_abap_corresponding=>mapping_table(
   ( level = 0 kind = 1 srcname = 'VAR_NAME' dstname = 'NAME' )
   ( level = 0 kind = 1 srcname = 'VAR_DESC' dstname = 'DESCRIPTION' )
   "( level = 0 kind = 1 srcname = 'VAR_TYPE' dstname = 'VAR_TYPE' )
   ( level = 0 kind = 1 srcname = 'IS_DEBUG_ON' dstname = 'DEBUG_IS_ON' ) )
  )->execute( EXPORTING source      = lt_varid
              CHANGING  destination = lt_set_out ).



    et_entityset[] = lt_set_out[].

  ENDMETHOD.

  METHOD varheadset_get_entity.
*        importing
*      !IV_ENTITY_NAME type STRING
*      !IV_ENTITY_SET_NAME type STRING
*      !IV_SOURCE_NAME type STRING
*      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
*      !IO_REQUEST_OBJECT type ref to /IWBEP/IF_MGW_REQ_ENTITY optional
*      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY optional
*      !IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
*    exporting
*      !ER_ENTITY type ZCL_ZWEB_ABAP_DEMO11_MPC=>TS_VARHEAD
*      !ES_RESPONSE_CONTEXT type /IWBEP/IF_MGW_APPL_SRV_RUNTIME=>TY_S_MGW_RESPONSE_ENTITY_CNTXT
*    raising
*      /IWBEP/CX_MGW_BUSI_EXCEPTION
*      /IWBEP/CX_MGW_TECH_EXCEPTION .
*

    data ls_entry_in TYPE ZCL_ZWEB_ABAP_DEMO11_MPC=>TS_VARHEAD.

    DATA lr_name_value_line TYPE REF TO /iwbep/s_mgw_name_value_pair.


    LOOP AT it_key_tab REFERENCE INTO lr_name_value_line.

        case lr_name_value_line->name.
           when 'Name'.
            ls_entry_in-name = lr_name_value_line->value.
           WHEN OTHERS.
        ENDCASE.
    ENDLOOP.


    DATA lt_varid TYPE STANDARD TABLE OF ztwa001_varid.
    data ls_varid_db TYPE ztwa001_varid.
    SELECT * FROM ztwa001_varid
        INTO TABLE lt_varid
      WHERE var_name =  ls_entry_in-name .

     MOVE-CORRESPONDING value #( lt_varid[ 1 ] optional ) to ls_varid_db.
     MOVE-CORRESPONDING ls_varid_db to ER_ENTITY.
     ER_ENTITY-name = ls_varid_db-var_name.
     ER_ENTITY-description = ls_varid_db-var_desc.

  ENDMETHOD.

ENDCLASS.
