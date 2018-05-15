set BENEFITS_FILE=aggregate_results.csv
set ZONE_BENEFITS_FILE=kate_aggregate_zone_benefits.csv
set COUNTIES_COC_FILE=cocs.csv
set REGION_FILE_LOC=C:\SVN\ABMVIZ\data\portland\region.json
set NEW_DATA_NAME=I205Test
set GITHUB_ABMVIZ_LOC=C:\SVN\ABMVIZ
call python create_mce_visual_inputs.py %BENEFITS_FILE% %ZONE_BENEFITS_FILE% %COUNTIES_COC_FILE% %REGION_FILE_LOC% %NEW_DATA_NAME%
cd %GITHUB_ABMVIZ_LOC%
call git add  --all
call git commit -m 'Added new data set'
call git push
