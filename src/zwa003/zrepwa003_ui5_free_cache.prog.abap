*&---------------------------------------------------------------------*
*& Report ZREPWA003_UI5_FREE_CACHE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZREPWA003_UI5_FREE_CACHE.


CLASS lcl_clear_cache DEFINITION.

  PUBLIC SECTION.
    METHODS constructor.

    METHODS free_cache.

  PROTECTED SECTION.

  PRIVATE SECTION.
    METHODS delete_cache.
    METHODS invalidate_cache.
    METHODS cleanup_cache.
    METHODS call_smicm.
ENDCLASS.

CLASS lcl_clear_cache IMPLEMENTATION.
  METHOD constructor.

  ENDMETHOD.

  METHOD free_cache.

    delete_cache( ).
    invalidate_cache( ).
    cleanup_cache( ).
    call_smicm( ).

  ENDMETHOD.

  METHOD delete_cache.

    SUBMIT /ui2/delete_cache_after_imp
      AND RETURN.

  ENDMETHOD.

  METHOD invalidate_cache.

    SUBMIT /ui2/invalidate_client_caches
    AND RETURN.

  ENDMETHOD.

  METHOD cleanup_cache.
    DATA lt_range_model TYPE RANGE OF /iwfnd/med_mdl_identifier.

    lt_range_model = VALUE #(
    ( sign = 'I' option = 'CP' low = '*' )
    ).

    SUBMIT /iwfnd/r_med_cache_cleanup
    WITH modelid IN lt_range_model
    AND RETURN.

  ENDMETHOD.

  METHOD call_smicm.


    DATA bdcdata_tab TYPE TABLE OF bdcdata.

    DATA opt TYPE ctu_params.

    bdcdata_tab = VALUE #(
      ( program  = 'SAPMSSY0' dynpro   = '0120' dynbegin = 'X' )
      ( fnam = 'BDC_CURSOR'       fval = '12/03' )
      ( fnam = 'BDC_OKCODE'       fval = '=CACHE_INVG' )

      ( program  = 'SAPLSPO1' dynpro   = '0100' dynbegin = 'X' )
      ( fnam = 'BDC_OKCODE'       fval = '=YES' )

      ( program  = 'SAPMSSY0' dynpro   = '0120' dynbegin = 'X' )
      ( fnam = 'BDC_CURSOR'       fval = '12/03' )
      ( fnam = 'BDC_OKCODE'       fval = '=&F03' )
      ).

    opt-dismode = 'E'.
    opt-defsize = 'X'.

    TRY.
        CALL TRANSACTION 'SMICM' WITH AUTHORITY-CHECK
                                USING bdcdata_tab OPTIONS FROM opt.
      CATCH cx_sy_authorization_error ##NO_HANDLER.
    ENDTRY.

  ENDMETHOD.

ENDCLASS.


PARAMETERS p TYPE char4.


START-OF-SELECTION.
  DATA(free_cache) = NEW lcl_clear_cache( ).
  free_cache->free_cache( ).

END-OF-SELECTION.
