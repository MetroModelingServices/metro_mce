SET BENEFITS_FILE=aggregate_results.csv
SET ZONE_BENEFITS_FILE=kate_aggregate_zone_benefits.csv
SET COUNTIES_COC_FILE=cocs.csv
SET REGION_FILE_LOC=C:\MCEVIZ\data\portland\region.json
SET NEW_DATA_NAME=I205Test
SET GITHUB_ABMVIZ_LOC=C:\MCEVIZ

CALL python create_mce_visual_inputs.py %BENEFITS_FILE% %ZONE_BENEFITS_FILE% %COUNTIES_COC_FILE% %REGION_FILE_LOC% %NEW_DATA_NAME%

CD %GITHUB_ABMVIZ_LOC%
CALL git add  --all
CALL git commit -m 'Added new data set'
CALL git push
