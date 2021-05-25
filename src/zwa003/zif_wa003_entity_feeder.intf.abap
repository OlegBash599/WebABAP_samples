INTERFACE zif_wa003_entity_feeder
  PUBLIC .

  DATA mo_odata_in TYPE REF TO zif_wa003_odata_in .

  METHODS set_odata_in
    IMPORTING
      !io_odata_in TYPE REF TO zif_wa003_odata_in .
  METHODS c
    EXPORTING
      !es TYPE any
    RAISING
      /iwbep/cx_mgw_busi_exception
      /iwbep/cx_mgw_tech_exception .
  METHODS r
    EXPORTING
      !es                  TYPE any
      !es_response_context TYPE /iwbep/if_mgw_appl_srv_runtime=>ty_s_mgw_response_entity_cntxt
    RAISING
      /iwbep/cx_mgw_busi_exception
      /iwbep/cx_mgw_tech_exception .
  METHODS u
    EXPORTING
      !es TYPE any
    RAISING
      /iwbep/cx_mgw_busi_exception
      /iwbep/cx_mgw_tech_exception .
  METHODS d
    RAISING
      /iwbep/cx_mgw_busi_exception
      /iwbep/cx_mgw_tech_exception .
  METHODS q
    EXPORTING
      !et_set              TYPE table
      !es_response_context TYPE /iwbep/if_mgw_appl_srv_runtime=>ty_s_mgw_response_context
    RAISING
      /iwbep/cx_mgw_busi_exception
      /iwbep/cx_mgw_tech_exception .
  METHODS set_batch_tab
    IMPORTING
      !itr TYPE REF TO data .
ENDINTERFACE.
