INTERFACE zif_wa003_odata_in
  PUBLIC .

  CONSTANTS mc_n TYPE seoclsname VALUE 'ZIF_WA003_ODATA_IN' ##NO_TEXT.
  CONSTANTS imp_b TYPE seoclsname VALUE 'ZCL_WA003_ODATA_IN_B' ##NO_TEXT.
  DATA mv_entity_name               TYPE string READ-ONLY .
  DATA mv_entity_set_name           TYPE string READ-ONLY .
  DATA mv_source_name               TYPE string READ-ONLY .
  DATA mt_filter_select_options     TYPE /iwbep/t_mgw_select_option READ-ONLY .
  DATA ms_paging                    TYPE /iwbep/s_mgw_paging READ-ONLY .
  DATA mt_key_tab                   TYPE /iwbep/t_mgw_name_value_pair READ-ONLY .
  DATA mt_navigation_path           TYPE /iwbep/t_mgw_navigation_path READ-ONLY .
  DATA mt_order                     TYPE /iwbep/t_mgw_sorting_order READ-ONLY .
  DATA mv_filter_string             TYPE string READ-ONLY .
  DATA mv_search_string             TYPE string READ-ONLY .
  DATA mo_tech_context_q            TYPE REF TO /iwbep/if_mgw_req_entityset READ-ONLY .

  DATA mo_request_object TYPE REF TO /iwbep/if_mgw_req_entity READ-ONLY.
  DATA mo_tech_context_r TYPE REF TO /iwbep/if_mgw_req_entity READ-ONLY.

  DATA mo_tech_context_c TYPE REF TO /iwbep/if_mgw_req_entity_c READ-ONLY.
  DATA mo_data_provider        TYPE REF TO /iwbep/if_mgw_entry_provider READ-ONLY.

  DATA mo_context TYPE REF TO /iwbep/if_mgw_context.

  DATA mo_tech_context_u TYPE REF TO /iwbep/if_mgw_req_entity_u READ-ONLY.
  DATA mo_tech_context_d TYPE REF TO /iwbep/if_mgw_req_entity_d READ-ONLY.

  data mv_batch_changeset_mode type abap_bool READ-ONLY.

  METHODS set_from_q
    IMPORTING
      !iv_entity_name           TYPE string
      !iv_entity_set_name       TYPE string
      !iv_source_name           TYPE string
      !it_filter_select_options TYPE /iwbep/t_mgw_select_option
      !is_paging                TYPE /iwbep/s_mgw_paging
      !it_key_tab               TYPE /iwbep/t_mgw_name_value_pair
      !it_navigation_path       TYPE /iwbep/t_mgw_navigation_path
      !it_order                 TYPE /iwbep/t_mgw_sorting_order
      !iv_filter_string         TYPE string
      !iv_search_string         TYPE string
      !io_tech_request_context  TYPE REF TO /iwbep/if_mgw_req_entityset OPTIONAL
    .

  METHODS set_entity_name
    IMPORTING !iv_entity_name TYPE string.

  METHODS set_entity_set_name
    IMPORTING !iv_entity_set_name TYPE string.

  METHODS set_source_name
    IMPORTING !iv_source_name TYPE string.

  METHODS set_filter_select_options
    IMPORTING !it_filter_select_options TYPE /iwbep/t_mgw_select_option.

  METHODS set_paging
    IMPORTING !is_paging TYPE /iwbep/s_mgw_paging.

  METHODS set_key_tab
    IMPORTING !it_key_tab TYPE /iwbep/t_mgw_name_value_pair.

  METHODS set_navigation_path
    IMPORTING !it_navigation_path TYPE /iwbep/t_mgw_navigation_path.

  METHODS set_order
    IMPORTING !it_order TYPE /iwbep/t_mgw_sorting_order.

  METHODS set_filter_string
    IMPORTING !iv_filter_string TYPE string.

  METHODS set_search_string
    IMPORTING !iv_search_string TYPE string.

  METHODS set_tech_context_q
    IMPORTING !io_tech_request_context TYPE REF TO /iwbep/if_mgw_req_entityset .

  METHODS get_tech_context_q
    RETURNING VALUE(ro_obj) TYPE REF TO /iwbep/if_mgw_req_entityset .

  METHODS get_key_tab
    RETURNING VALUE(rt) TYPE /iwbep/t_mgw_name_value_pair.


  METHODS set_from_r
    IMPORTING
      !iv_entity_name          TYPE string
      !iv_entity_set_name      TYPE string
      !iv_source_name          TYPE string
      !it_key_tab              TYPE /iwbep/t_mgw_name_value_pair
      !io_request_object       TYPE REF TO /iwbep/if_mgw_req_entity OPTIONAL
      !io_tech_request_context TYPE REF TO /iwbep/if_mgw_req_entity OPTIONAL
      !it_navigation_path      TYPE /iwbep/t_mgw_navigation_path
    .

  METHODS set_request_object
    IMPORTING !io_request_object TYPE REF TO /iwbep/if_mgw_req_entity OPTIONAL.

  METHODS set_tech_context_r
    IMPORTING !io_tech_request_context TYPE REF TO /iwbep/if_mgw_req_entity OPTIONAL.

  METHODS set_from_c
    IMPORTING
      !iv_entity_name          TYPE string
      !iv_entity_set_name      TYPE string
      !iv_source_name          TYPE string
      !it_key_tab              TYPE /iwbep/t_mgw_name_value_pair
      !io_tech_request_context TYPE REF TO /iwbep/if_mgw_req_entity_c OPTIONAL
      !it_navigation_path      TYPE /iwbep/t_mgw_navigation_path
      !io_data_provider        TYPE REF TO /iwbep/if_mgw_entry_provider OPTIONAL
    .

  METHODS set_tech_context_c
    IMPORTING !io_tech_request_context TYPE REF TO /iwbep/if_mgw_req_entity_c OPTIONAL.

  METHODS set_data_provider
    IMPORTING !io_data_provider TYPE REF TO /iwbep/if_mgw_entry_provider OPTIONAL.

  METHODS get_data_provider
    RETURNING VALUE(ro_obj) TYPE REF TO /iwbep/if_mgw_entry_provider.

  METHODS set_context
    IMPORTING !io_context TYPE REF TO /iwbep/if_mgw_context.

  METHODS get_context
    RETURNING VALUE(ro_obj) TYPE REF TO /iwbep/if_mgw_context.

  METHODS set_from_u
    IMPORTING
      !iv_entity_name          TYPE string
      !iv_entity_set_name      TYPE string
      !iv_source_name          TYPE string
      !it_key_tab              TYPE /iwbep/t_mgw_name_value_pair
      !io_tech_request_context TYPE REF TO /iwbep/if_mgw_req_entity_u OPTIONAL
      !it_navigation_path      TYPE /iwbep/t_mgw_navigation_path
      !io_data_provider        TYPE REF TO /iwbep/if_mgw_entry_provider OPTIONAL.

  METHODS set_tech_context_u
    IMPORTING !io_tech_request_context TYPE REF TO /iwbep/if_mgw_req_entity_u OPTIONAL.

  METHODS set_from_d
    IMPORTING
      !iv_entity_name          TYPE string
      !iv_entity_set_name      TYPE string
      !iv_source_name          TYPE string
      !it_key_tab              TYPE /iwbep/t_mgw_name_value_pair
      !io_tech_request_context TYPE REF TO /iwbep/if_mgw_req_entity_d OPTIONAL
      !it_navigation_path      TYPE /iwbep/t_mgw_navigation_path.

  METHODS set_tech_context_d
    IMPORTING !io_tech_request_context TYPE REF TO /iwbep/if_mgw_req_entity_d OPTIONAL.

  METHODS set_batch_changeset_mode
    IMPORTING !iv TYPE abap_bool.
ENDINTERFACE.
