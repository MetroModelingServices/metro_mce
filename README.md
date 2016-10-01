The Oregon Metro Multi-Criteria Evaluation (MCE) toolkit supports transportation planning alternatives analysis by estimating the “Social Return on Investment” of alternatives in a quantitative manner.

# Data Export
The following scripts are used to export all the required data from the R demand model and the EMME supply model.
  - R scripts - revisions to the demand model in order to write out 
trip productions, destination choice logsums, and the HH CVAL array - HIAs by workers and car ownership for each TAZ - to CSV format

```
mf.cval column order - A (age of head) flows first, I (income), H (size), W (workers), C (car ownership)
colnames = expand.grid(paste("a",seq(1:4),sep=""), paste("i",seq(1:4),sep=""), paste("h",seq(1:4),sep=""), paste("w",seq(1:4),sep=""), paste("c",seq(1:4),sep=""))
colnames = apply(colnames,1,function(x) paste(x, collapse=""))

```

  - ExportLinkResultsToCSV.py writes out EMME link assignment results to a CSV file
  - bca_EMME_Export.bat exports all the required full matrices and also calls ExportLinkResultsToCSV.py.  This script requires [EMXtoOMX.py](https://github.com/bstabler/EMXtoOMX)
  - mce_reliability_prep.py codes freeway interchange nodes, upstream and downstream distances, and calculates the link reliability measure for skimming.  Run it after assignment and then skim the link @relvar attr 

# Benefits calculator file and folder setup
The benefits calculator is implemented with the [FHWA bca4abm](https://github.com/RSGInc/bca4abm) calculator, which also does aggregate (i.e. trip-based) model calculations.

root folder
  - run_bca.py - run benefit calculator
  - configs folder - configuration settings
      - settings.yaml - overall settings
      - link
        - link_data_manifest.csv - list of link assignment result files by time period to process
        - link.csv - expressions for link assignment results by time period
        - link_daily.csv - expressions for daily link assignment results
      - zone
        - demographics_aggregate.csv - expressions for aggregate zonal level processor - i.e. coding of communities of concern / market 
        - zone_aggregate.csv - expressions for aggregate zonal level processor - i.e. auto ownership and destination choice logsums like FHWA segments
      - OD_aggregate
        - OD_aggregate_manifest.csv - list of OD aggregate tables and matrices to expose to the OD aggregate processor
        - OD_aggregate.csv - expressions for aggregate OD-pair level processor - i.e. trip measures
      - aggregate
        - aggregate_data_manifest.csv - list of aggregate market (i.e. trucks) matrices to expose to the aggregate market trip processor
        - aggregate_trips.csv - expressions for aggregate markets (i.e. trucks)
  - base scenario folder - such as 2040 No Build
      - link
        - linksMD1.csv - link MD1 assignment results
        - linksPM2.csv - link PM2 assignment results
      - OD  
        - assign_mfs.omx - assignment bank OMX matrices
        - skims_mfs.omx - skims bank OMX matrices
      - Zone 
        - mf.cval.csv - see above
        - Productions
          - ma.collpr.csv - hbc 
          - ma.hboprh.csv - hbo high inc 
          - ma.hboprl.csv - hbo low inc 
          - ma.hboprm.csv - hbo mid inc 
          - ma.hbrprh.csv - hbr high inc 
          - ma.hbrprl.csv - hbr low inc 
          - ma.hbrprm.csv - hbr mid inc 
          - ma.hbsprh.csv - hbs high inc 
          - ma.hbsprl.csv - hbs low inc 
          - ma.hbsprm.csv - hbs mid inc 
          - ma.hbwprh.csv - hbw high inc 
          - ma.hbwprl.csv - hbw low inc 
          - ma.hbwprm.csv - hbw mid inc 
          - ma.nhnwpr.csv - nhbnw 
          - ma.nhwpr.csv - nhbw 
          - ma.schdcls.csv - sch 
        - Destination choice logsums
          - ma.hbcdcls.csv - hbc 
          - ma.hbohdcls.csv - hbo high inc 
          - ma.hboldcls.csv - hbo low inc 
          - ma.hbomdcls.csv - hbo mid inc 
          - ma.hbrhdcls.csv - hbr high inc 
          - ma.hbrldcls.csv - hbr low inc 
          - ma.hbrmdcls.csv - hbr mid inc 
          - ma.hbshdcls.csv - hbs high inc 
          - ma.hbsldcls.csv - hbs low inc 
          - ma.hbsmdcls.csv - hbs mid inc 
          - ma.hbwhdcls.csv - hbw high inc 
          - ma.hbwldcls.csv - hbw low inc 
          - ma.hbwmdcls.csv - hbw mid inc 
          - ma.nhbnwdcls.csv - nhbnw 
          - ma.nhbwdcls.csv - nhbw 
          - ma.schdcls.csv - sch 
  - build scenario folder - such as 2040 Build
      - link
        - linksMD1.csv - link MD1 assignment results
        - linksPM2.csv - link PM2 assignment results
      - OD  
        - assign_mfs.omx - assignment bank OMX matrices
        - skims_mfs.omx - skims bank OMX matrices
      - Zone 
        - mf.cval.csv - see above
        - Productions
          - ma.collpr.csv - hbc 
          - ma.hboprh.csv - hbo high inc 
          - ma.hboprl.csv - hbo low inc 
          - ma.hboprm.csv - hbo mid inc 
          - ma.hbrprh.csv - hbr high inc 
          - ma.hbrprl.csv - hbr low inc 
          - ma.hbrprm.csv - hbr mid inc 
          - ma.hbsprh.csv - hbs high inc 
          - ma.hbsprl.csv - hbs low inc 
          - ma.hbsprm.csv - hbs mid inc 
          - ma.hbwprh.csv - hbw high inc 
          - ma.hbwprl.csv - hbw low inc 
          - ma.hbwprm.csv - hbw mid inc 
          - ma.nhnwpr.csv - nhbnw 
          - ma.nhwpr.csv - nhbw 
          - ma.schdcls.csv - sch 
        - Destination choice logsums
          - ma.hbcdcls.csv - hbc 
          - ma.hbohdcls.csv - hbo high inc 
          - ma.hboldcls.csv - hbo low inc 
          - ma.hbomdcls.csv - hbo mid inc 
          - ma.hbrhdcls.csv - hbr high inc 
          - ma.hbrldcls.csv - hbr low inc 
          - ma.hbrmdcls.csv - hbr mid inc 
          - ma.hbshdcls.csv - hbs high inc 
          - ma.hbsldcls.csv - hbs low inc 
          - ma.hbsmdcls.csv - hbs mid inc 
          - ma.hbwhdcls.csv - hbw high inc 
          - ma.hbwldcls.csv - hbw low inc 
          - ma.hbwmdcls.csv - hbw mid inc 
          - ma.nhbnwdcls.csv - nhbnw 
          - ma.nhbwdcls.csv - nhbw 
          - ma.schdcls.csv - sch 

# Running the benefits calculator
The benefits calculator is currently run on the command line as follows: ```python run_bca.py```

This program does the following:
  - reads the settings and input data 
  - runs the demographic aggregate processor
    - each row in the data table to solve is an origin zone and this processor calculates communities of concern (COC) / market segments based on zone data
    - ```orca.run(['demographics_aggregate_processor'])```
  - runs the zone aggregate processor
    - each row in the data table to solve is an origin zone and this processor calculates zonal auto ownership differences and destination choice logsums
    - ```orca.run(['zone_aggregate_processor'])```
  - runs the OD trips aggregate processor 
    - each row in the data table to solve is an OD pair and this processor calculates trip differences.  It requires access to input zone tables, the COC coding, trip matrices and skim matrices.  The new ```OD_aggregate_manifest.csv``` file tells this processor what data it can use and how to reference it.  The following input data tables are required: ```assign_mfs.omx```, ```skims_mfs.omx```, and the results of the zonal_aggregate_processor.  
    - ```orca.run(['OD_aggregate_processor'])```
  - runs the aggregate markets (i.e. trucks) processor
    - The ```aggregate_data_manifest.csv``` file tells this processor what data it can use and how to reference it.    
    - ```orca.run(['aggregate_trips_processor'])```
  - runs the time period and daily link processors
    - The ```link_data_manifest.csv``` file tells this processor what data it can use and how to reference it.    
    - daily will be linkMD1 * scalingFactorMD1 + linkPM2 * scalingFactorPM2
    - ```orca.run(['link_daily_processor'])```
    - ```orca.run(['link_processor'])```
  - writes results
    - ```orca.run(['write_results'])```
    - ```orca.run(['print_results'])```
