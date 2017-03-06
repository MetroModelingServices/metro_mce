rem # batch out required data from bank
rem # requires an active scenario defined in the project 
rem # requires EMXtoOMX.py, https://github.com/bstabler/EMXtoOMX

SET EMMEPY="C:\Program Files\INRO\Emme\Emme 4\Emme-4.2.5\Python27\python.exe"
SET SKIMS_EMP="C:\projects\metromce\testing\2040NB_Base\skims\new_project\new_project.emp"
SET ASSIGN_EMP="C:\projects\metromce\testing\2040NB_Base\model\peak\assign\new_project\new_project.emp"

rem # skims, trips, link results
%EMMEPY% EMXtoOMX.py %SKIMS_EMP% 4 C:\projects\skims_mfs.omx -e mf1 mf2 mf3 mf4 mf5 mf6 mf7 mf8 mf10 mf11 mf12 mf13 mf14 mf15 mf16 mf17 mf18 mf19 mf20 mf21 mf22 mf23 mf24 mf25 mf26 mf27 mf28 mf29 mf30 mf31 mf32 mf33 mf34 mf35 mf36 mf37 mf40 mf41 mf42 mf43 mf44 mf45 mf46 mf47 mf51 mf52 mf60 mf61 mf62 mf63
%EMMEPY% EMXtoOMX.py %ASSIGN_EMP% 4 C:\projects\assign_mfs.omx -e mf8 mf7 mf65 mf64 mf63 mf62 mf61 mf60 mf6 mf52 mf51 mf50 mf5 mf47 mf46 mf45 mf44 mf43 mf42 mf41 mf40 mf144 mf143 mf142 mf141 mf134 mf133 mf132 mf131 
%EMMEPY% ExportLinkResultsToCSV.py %ASSIGN_EMP% 4782 C:\projects\linksPM2.csv
%EMMEPY% ExportLinkResultsToCSV.py %ASSIGN_EMP% 4783 C:\projects\linksMD1.csv
