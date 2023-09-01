class ZCL_ZWEB_ABAP_DEMO3_UN_MPC definition
  public
  inheriting from /IWBEP/CL_MGW_PUSH_ABS_MODEL
  create public .

public section.

  methods DEFINE
    redefinition .
  methods GET_LAST_MODIFIED
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ZWEB_ABAP_DEMO3_UN_MPC IMPLEMENTATION.


  method DEFINE.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS         &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL  &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                   &*
*&                                                                     &*
*&---------------------------------------------------------------------*

model->set_schema_namespace( 'ZWEB_ABAP_DEMO3_UNI_SRV' ).

*&~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~&*
*&   Include the model ZWEB_ABAP_DEMO1_MDL from service ZWEB_ABAP_DEMO1_SRV         &*
*&~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~&*
  model->include_model_by_name(
                          iv_service_external_name    = 'ZWEB_ABAP_DEMO1_SRV'                    "#EC NOTEXT
                          iv_service_version          = '0001'                     "#EC NOTEXT
                          iv_model_tech_name          = 'ZWEB_ABAP_DEMO1_MDL'                          "#EC NOTEXT
                          iv_model_version            = '0001' ).                    "#EC NOTEXT
*&~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~&*
*&   Include the model ZWEB_ABAP_DEMO3_MDL from service ZWEB_ABAP_DEMO3_SRV         &*
*&~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~&*
  model->include_model_by_name(
                          iv_service_external_name    = 'ZWEB_ABAP_DEMO3_SRV'                    "#EC NOTEXT
                          iv_service_version          = '0001'                     "#EC NOTEXT
                          iv_model_tech_name          = 'ZWEB_ABAP_DEMO3_MDL'                          "#EC NOTEXT
                          iv_model_version            = '0001' ).                    "#EC NOTEXT
  endmethod.


  method GET_LAST_MODIFIED.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS         &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL  &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                   &*
*&                                                                     &*
*&---------------------------------------------------------------------*


  CONSTANTS: lc_gen_date_time TYPE timestamp VALUE '20210526072018'.                  "#EC NOTEXT
  rv_last_modified = super->get_last_modified( ).
  IF rv_last_modified LT lc_gen_date_time.
    rv_last_modified = lc_gen_date_time.
  ENDIF.
  endmethod.
ENDCLASS.
