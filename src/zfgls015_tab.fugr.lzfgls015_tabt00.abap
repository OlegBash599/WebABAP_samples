*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 14.06.2020 at 12:42:59
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZTLS015_VARID...................................*
DATA:  BEGIN OF STATUS_ZTLS015_VARID                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTLS015_VARID                 .
CONTROLS: TCTRL_ZTLS015_VARID
            TYPE TABLEVIEW USING SCREEN '5000'.
*...processing: ZTLS015_VARVAL..................................*
DATA:  BEGIN OF STATUS_ZTLS015_VARVAL                .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTLS015_VARVAL                .
CONTROLS: TCTRL_ZTLS015_VARVAL
            TYPE TABLEVIEW USING SCREEN '5200'.
*.........table declarations:.................................*
TABLES: *ZTLS015_VARID                 .
TABLES: *ZTLS015_VARVAL                .
TABLES: ZTLS015_VARID                  .
TABLES: ZTLS015_VARVAL                 .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
