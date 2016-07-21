rem # batch in required data from bank
rem # requires an active scenario defined in the project 
rem # requires EMXtoOMX.py, https://github.com/bstabler/EMXtoOMX

SET EMMEPY="C:\Program Files\INRO\Emme\Emme 4\Emme-4.2.5\Python27\python.exe"

%EMMEPY% EMXtoOMX.py C:\projects\metromce\testing\2040NB_Base\skims\new_project\new_project.emp 4 ..\..\model_hbw\mfs.omx -i mf100
%EMMEPY% EMXtoOMX.py C:\projects\metromce\testing\2040NB_Base\skims\new_project\new_project.emp 4 ..\..\model_hbw\mos.omx -i mo100 mo101 mo102 mo103 mo104 mo105 mo106 mo107 mo108 mo109 mo110 mo111 mo112 mo113 mo114 mo115
