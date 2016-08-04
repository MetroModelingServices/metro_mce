# Metro MCE

# Data Export Scripts 
  - R scripts - revisions to the demand model in order to write out 
destination choice logsums and the CVAL array - HIAs by car ownership for each TAZ

```
mf.cval column order, by hia: c <# cars> w <# workers>
CVAL0 (mf.cval[,1:256]) = c0w0, c0w1, c0w2, c0w3
CVAL1 (mf.cval[,257:448]) = c1w2, c1w3, c2w3
CVAL2 (mf.cval[,449:640]) = c1w1, c2w2, c3w3 
CVAL3 (mf.cval[,641:1024])= c1w0, c2w0, c2w1, c3w0, c3w1, c3w2
```
  - ExportLinkResultsToCSV.py writes out EMME link assignment results to a CSV file
  - bca_EMME_Export.bat exports all the required full matrices and also calls 
ExportLinkResultsToCSV.py.  This script requires [EMXtoOMX.py](https://github.com/bstabler/EMXtoOMX)

# MCE Inputs Files 

The MCE tool file and folder setup is as follows:

root folder
  - run_bca.py - run benefit calculator
  - configs folder - configuration settings
      - settings.yaml
      - link_data_manifest.csv
      - aggregate_data_manifest.csv
      - aggregate_trips.csv
      - auto_ownership.csv
      - demographics.csv
      - link.csv
      - link_daily.csv
      - configs/person_trips.csv
      - physical_activity_person.csv
      - physical_activity_trip.csv
  - base scenario folder - such as 2040 No Build
      - assign_mfs.omx - assignment bank OMX matrices
      - linksMD1.csv - link MD1 assignment results
      - linksPM2.csv - link PM2 assignment results
      - ma.hbcdcls.csv - hbc destination choice logsums
      - ma.hbohdcls.csv - hbo high inc destination choice logsums
      - ma.hboldcls.csv - hbo low inc destination choice logsums
      - ma.hbomdcls.csv - hbo mid inc destination choice logsums
      - ma.hbrhdcls.csv - hbr high inc destination choice logsums
      - ma.hbrldcls.csv - hbr low inc destination choice logsums
      - ma.hbrmdcls.csv - hbr mid inc destination choice logsums
      - ma.hbshdcls.csv - hbs high inc destination choice logsums
      - ma.hbsldcls.csv - hbs low inc destination choice logsums
      - ma.hbsmdcls.csv - hbs mid inc destination choice logsums
      - ma.hbwhdcls.csv - hbw high inc destination choice logsums
      - ma.hbwldcls.csv - hbw low inc destination choice logsums
      - ma.hbwmdcls.csv - hbw mid inc destination choice logsums
      - ma.nhbnwdcls.csv - nhbnw destination choice logsums
      - ma.nhbwdcls.csv - nhbw destination choice logsums
      - ma.schdcls.csv - sch destination choice logsums
      - mf.cval.csv - CVAL array - HIAs by car ownership for each TAZ
      - skims_mfs.omx - skims bank OMX matrices
  - build scenario folder - such as 2040 Build
      - assign_mfs.omx - assignment bank OMX matrices
      - linksMD1.csv - link MD1 assignment results
      - linksPM2.csv - link PM2 assignment results
      - ma.hbcdcls.csv - hbc destination choice logsums
      - ma.hbohdcls.csv - hbo high inc destination choice logsums
      - ma.hboldcls.csv - hbo low inc destination choice logsums
      - ma.hbomdcls.csv - hbo mid inc destination choice logsums
      - ma.hbrhdcls.csv - hbr high inc destination choice logsums
      - ma.hbrldcls.csv - hbr low inc destination choice logsums
      - ma.hbrmdcls.csv - hbr mid inc destination choice logsums
      - ma.hbshdcls.csv - hbs high inc destination choice logsums
      - ma.hbsldcls.csv - hbs low inc destination choice logsums
      - ma.hbsmdcls.csv - hbs mid inc destination choice logsums
      - ma.hbwhdcls.csv - hbw high inc destination choice logsums
      - ma.hbwldcls.csv - hbw low inc destination choice logsums
      - ma.hbwmdcls.csv - hbw mid inc destination choice logsums
      - ma.nhbnwdcls.csv - nhbnw destination choice logsums
      - ma.nhbwdcls.csv - nhbw destination choice logsums
      - ma.schdcls.csv - sch destination choice logsums
      - mf.cval.csv - CVAL array - HIAs by car ownership for each TAZ
      - skims_mfs.omx - skims bank OMX matrices
