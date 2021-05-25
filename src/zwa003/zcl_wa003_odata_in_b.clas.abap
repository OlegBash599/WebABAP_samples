CLASS zcl_wa003_odata_in_b DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES zif_wa003_odata_in.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_wa003_odata_in_b IMPLEMENTATION.

  METHOD zif_wa003_odata_in~set_entity_name.
    "IMPORTING !iv_entity_name TYPE string.
    zif_wa003_odata_in~mv_entity_name = iv_entity_name.

  ENDMETHOD.

  METHOD zif_wa003_odata_in~set_entity_set_name.
    "IMPORTING !iv_entity_set_name TYPE string.
    zif_wa003_odata_in~mv_entity_set_name = iv_entity_set_name.

  ENDMETHOD.

  METHOD zif_wa003_odata_in~set_source_name.
    "IMPORTING !iv_source_name TYPE string.
    zif_wa003_odata_in~mv_source_name      = iv_source_name.

  ENDMETHOD.

  METHOD zif_wa003_odata_in~set_filter_select_options.
    "IMPORTING !it_filter_select_options TYPE /iwbep/t_mgw_select_option.
    zif_wa003_odata_in~mt_filter_select_options = it_filter_select_options.

  ENDMETHOD.

  METHOD zif_wa003_odata_in~set_paging.
    "IMPORTING !is_paging TYPE /iwbep/s_mgw_paging.
    zif_wa003_odata_in~ms_paging = is_paging.

  ENDMETHOD.

  METHOD zif_wa003_odata_in~set_key_tab.
    "IMPORTING !it_key_tab TYPE /iwbep/t_mgw_name_value_pair.
    zif_wa003_odata_in~mt_key_tab = it_key_tab.

  ENDMETHOD.

  METHOD zif_wa003_odata_in~set_navigation_path.
    "IMPORTING !it_navigation_path TYPE /iwbep/t_mgw_navigation_path.
    zif_wa003_odata_in~mt_navigation_path = it_navigation_path.

  ENDMETHOD.

  METHOD zif_wa003_odata_in~set_order.
    "IMPORTING !it_order TYPE /iwbep/t_mgw_sorting_order.
    zif_wa003_odata_in~mt_order = it_order.

  ENDMETHOD.

  METHOD zif_wa003_odata_in~set_filter_string.
    "IMPORTING !iv_filter_string TYPE string.
    zif_wa003_odata_in~mv_filter_string =  iv_filter_string.

  ENDMETHOD.

  METHOD zif_wa003_odata_in~set_search_string.
    "IMPORTING !iv_search_string TYPE string.
    zif_wa003_odata_in~mv_search_string = iv_search_string.

  ENDMETHOD.

  METHOD zif_wa003_odata_in~set_tech_context_q.
    "IMPORTING !io_tech_request_context TYPE REF TO /iwbep/if_mgw_req_entityset .
    zif_wa003_odata_in~mo_tech_context_q ?= io_tech_request_context.
  ENDMETHOD.

  METHOD zif_wa003_odata_in~get_tech_context_q.
    "IMPORTING !io_tech_request_context TYPE REF TO /iwbep/if_mgw_req_entityset .
    ro_obj ?= zif_wa003_odata_in~mo_tech_context_q.
  ENDMETHOD.

  METHOD zif_wa003_odata_in~set_from_q.
    me->zif_wa003_odata_in~set_entity_name( iv_entity_name ).
    me->zif_wa003_odata_in~set_entity_set_name( iv_entity_set_name ).
    me->zif_wa003_odata_in~set_source_name( iv_source_name ).
    me->zif_wa003_odata_in~set_filter_select_options( it_filter_select_options ).
    me->zif_wa003_odata_in~set_paging( is_paging ).
    me->zif_wa003_odata_in~set_key_tab( it_key_tab ).
    me->zif_wa003_odata_in~set_navigation_path( it_navigation_path ).
    me->zif_wa003_odata_in~set_order( it_order ).
    me->zif_wa003_odata_in~set_filter_string( iv_filter_string ).
    me->zif_wa003_odata_in~set_search_string( iv_search_string ).
    me->zif_wa003_odata_in~set_tech_context_q( io_tech_request_context ).
  ENDMETHOD.

  METHOD zif_wa003_odata_in~get_key_tab.
    "    RETURNING VALUE(rt)  TYPE /iwbep/t_mgw_name_value_pair.
    rt = zif_wa003_odata_in~mt_key_tab.
  ENDMETHOD.

  METHOD zif_wa003_odata_in~set_from_r.
*    IMPORTING
*      !IV_ENTITY_NAME type STRING
*      !IV_ENTITY_SET_NAME type STRING
*      !IV_SOURCE_NAME type STRING
*      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
*      !IO_REQUEST_OBJECT type ref to /IWBEP/IF_MGW_REQ_ENTITY optional
*      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY optional
*      !IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
*    .

    me->zif_wa003_odata_in~set_entity_name( iv_entity_name ).
    me->zif_wa003_odata_in~set_entity_set_name( iv_entity_set_name ).
    me->zif_wa003_odata_in~set_source_name( iv_source_name ).
    me->zif_wa003_odata_in~set_request_object( io_request_object ).
    me->zif_wa003_odata_in~set_key_tab( it_key_tab ).
    me->zif_wa003_odata_in~set_tech_context_r( io_tech_request_context ).
    me->zif_wa003_odata_in~set_navigation_path( it_navigation_path ).


  ENDMETHOD.

  METHOD zif_wa003_odata_in~set_request_object.
    zif_wa003_odata_in~mo_request_object ?= io_request_object.
  ENDMETHOD.

  METHOD zif_wa003_odata_in~set_tech_context_r.
    zif_wa003_odata_in~mo_tech_context_r ?= io_tech_request_context.
  ENDMETHOD.


  METHOD zif_wa003_odata_in~set_from_c.
*    IMPORTING
*      !iv_entity_name          TYPE string
*      !iv_entity_set_name      TYPE string
*      !iv_source_name          TYPE string
*      !it_key_tab              TYPE /iwbep/t_mgw_name_value_pair
*      !io_tech_request_context TYPE REF TO /iwbep/if_mgw_req_entity_c OPTIONAL
*      !it_navigation_path      TYPE /iwbep/t_mgw_navigation_path
*      !io_data_provider        TYPE REF TO /iwbep/if_mgw_entry_provider OPTIONAL


    me->zif_wa003_odata_in~set_entity_name( iv_entity_name ).
    me->zif_wa003_odata_in~set_entity_set_name( iv_entity_set_name ).
    me->zif_wa003_odata_in~set_source_name( iv_source_name ).
    me->zif_wa003_odata_in~set_key_tab( it_key_tab ).

    me->zif_wa003_odata_in~set_tech_context_c( io_tech_request_context ).
    me->zif_wa003_odata_in~set_navigation_path( it_navigation_path ).
    me->zif_wa003_odata_in~set_data_provider( io_data_provider ).

  ENDMETHOD.

  METHOD zif_wa003_odata_in~set_tech_context_c.
    "    IMPORTING !io_tech_request_context TYPE REF TO /iwbep/if_mgw_req_entity_c OPTIONAL.
    zif_wa003_odata_in~mo_tech_context_c ?= io_tech_request_context.
  ENDMETHOD.

  METHOD zif_wa003_odata_in~set_data_provider.
    "    IMPORTING !io_data_provider        TYPE REF TO /iwbep/if_mgw_entry_provider OPTIONAL.
    zif_wa003_odata_in~mo_data_provider ?= io_data_provider.
  ENDMETHOD.

  METHOD zif_wa003_odata_in~get_data_provider.
    "    RETURNING VALUE(ro_obj) TYPE REF TO /iwbep/if_mgw_entry_provider.
    ro_obj ?= zif_wa003_odata_in~mo_data_provider.
  ENDMETHOD.

  METHOD zif_wa003_odata_in~set_context.
    "  IMPORTING !io_context TYPE REF TO /iwbep/if_mgw_context.
    zif_wa003_odata_in~mo_context = io_context.
  ENDMETHOD.

  METHOD zif_wa003_odata_in~get_context.
    "    RETURNING VALUE(ro_obj) TYPE REF TO /iwbep/if_mgw_context.
    ro_obj ?= zif_wa003_odata_in~mo_context.
  ENDMETHOD.

  METHOD zif_wa003_odata_in~set_from_u.
*    importing
*      !IV_ENTITY_NAME type STRING
*      !IV_ENTITY_SET_NAME type STRING
*      !IV_SOURCE_NAME type STRING
*      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
*      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY_U optional
*      !IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
*      !IO_DATA_PROVIDER type ref to /IWBEP/IF_MGW_ENTRY_PROVIDER optional
    me->zif_wa003_odata_in~set_entity_name( iv_entity_name ).
    me->zif_wa003_odata_in~set_entity_set_name( iv_entity_set_name ).
    me->zif_wa003_odata_in~set_source_name( iv_source_name ).
    me->zif_wa003_odata_in~set_key_tab( it_key_tab ).

    me->zif_wa003_odata_in~set_tech_context_u( io_tech_request_context ).
    me->zif_wa003_odata_in~set_navigation_path( it_navigation_path ).
    me->zif_wa003_odata_in~set_data_provider( io_data_provider ).
  ENDMETHOD.

  METHOD zif_wa003_odata_in~set_tech_context_u.
    "     IMPORTING !io_tech_request_context TYPE REF TO /iwbep/if_mgw_req_entity_u OPTIONAL.
    zif_wa003_odata_in~mo_tech_context_u ?= io_tech_request_context.
  ENDMETHOD.

  METHOD zif_wa003_odata_in~set_from_d.
*    importing
*      !IV_ENTITY_NAME type STRING
*      !IV_ENTITY_SET_NAME type STRING
*      !IV_SOURCE_NAME type STRING
*      !IT_KEY_TAB type /IWBEP/T_MGW_NAME_VALUE_PAIR
*      !IO_TECH_REQUEST_CONTEXT type ref to /IWBEP/IF_MGW_REQ_ENTITY_D optional
*      !IT_NAVIGATION_PATH type /IWBEP/T_MGW_NAVIGATION_PATH
    me->zif_wa003_odata_in~set_entity_name( iv_entity_name ).
    me->zif_wa003_odata_in~set_entity_set_name( iv_entity_set_name ).
    me->zif_wa003_odata_in~set_source_name( iv_source_name ).
    me->zif_wa003_odata_in~set_key_tab( it_key_tab ).

    me->zif_wa003_odata_in~set_tech_context_d( io_tech_request_context ).
    me->zif_wa003_odata_in~set_navigation_path( it_navigation_path ).

  ENDMETHOD.

  METHOD zif_wa003_odata_in~set_tech_context_d.
    zif_wa003_odata_in~mo_tech_context_d ?= io_tech_request_context.
  ENDMETHOD.

  METHOD zif_wa003_odata_in~set_batch_changeset_mode.
    zif_wa003_odata_in~mv_batch_changeset_mode = iv.
  ENDMETHOD.

ENDCLASS.
