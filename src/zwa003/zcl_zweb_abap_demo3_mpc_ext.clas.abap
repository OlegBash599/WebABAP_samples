CLASS zcl_zweb_abap_demo3_mpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zcl_zweb_abap_demo3_mpc
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS define
        REDEFINITION .
  PROTECTED SECTION.
  PRIVATE SECTION.

    METHODS set_property_as_content_type
      RAISING /iwbep/cx_mgw_med_exception.

    METHODS correct_model4function_import
      RAISING /iwbep/cx_mgw_med_exception.

ENDCLASS.



CLASS zcl_zweb_abap_demo3_mpc_ext IMPLEMENTATION.


  METHOD define.
    super->define( ).

    correct_model4function_import(  ).

    set_property_as_content_type(  ).

  ENDMETHOD.

  METHOD correct_model4function_import.
    " https://blogs.sap.com/2017/12/14/implementing-optional-parameters-in-the-function-import/

    " Data Declarations
    DATA lo_entity_type TYPE REF TO /iwbep/if_mgw_odata_entity_typ.
    DATA lo_property    TYPE REF TO /iwbep/if_mgw_odata_property.
    DATA lo_action      TYPE REF TO /iwbep/if_mgw_odata_action.

    lo_action = model->get_action( iv_action_name = 'SwitchOnVarDebug' ).
    lo_property = lo_action->get_input_parameter( iv_name = 'OptionalPar' ).
    lo_property->set_nullable( iv_nullable = abap_true ).

  ENDMETHOD.

  METHOD set_property_as_content_type.
    DATA lo_entity_fs   TYPE REF TO /iwbep/if_mgw_odata_entity_typ.
    DATA lo_property_fs TYPE REF TO /iwbep/if_mgw_odata_property.

    lo_entity_fs = model->get_entity_type( iv_entity_name = 'VarFile' ).
    IF lo_entity_fs IS BOUND.
      lo_property_fs = lo_entity_fs->get_property( iv_property_name = 'FileContent' ).
      lo_property_fs->set_as_content_type( ).
    ENDIF.
  ENDMETHOD.

ENDCLASS.
