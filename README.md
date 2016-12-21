The [Oregon Metro](http://www.oregonmetro.gov/) Multi-Criteria Evaluation (MCE) toolkit supports transportation planning alternatives analysis by estimating the quantitative “Social Return on Investment” of alternative transportation investment scenarios.

The MCE toolkit consists of three core tools:
  - Benefits calculator - calculates monetized benefits of transportation projects
  - Project costing workbook - calculates total project costs by type and Net Present Value
  - Visuals workbook - takes as input the benefits and costs, calculates B/C ratios, and summarizes and visualizes the results

# Benefits Calculator

## Travel Model Data Export
The scripts in this folder are used to export the required data from the R travel demand model and the EMME travel supply model for import into the benefits calculator.
  - Various R scripts - revisions to the demand model in order to write out trip productions, destination choice logsums, and the HH CVAL array - HIAs by workers and car ownership for each TAZ - to CSV format

```
mf.cval column order - A (age of head) flows first, I (income), H (size), W (workers), C (car ownership)
colnames = expand.grid(paste("a",seq(1:4),sep=""), paste("i",seq(1:4),sep=""), paste("h",seq(1:4),sep=""), paste("w",seq(1:4),sep=""), paste("c",seq(1:4),sep=""))
colnames = apply(colnames,1,function(x) paste(x, collapse=""))
```

  - ExportLinkResultsToCSV.py writes out EMME link assignment results to a CSV file
  - bca_EMME_Export.bat exports the required matrices (mfs) and also calls ExportLinkResultsToCSV.py.  This script requires [EMXtoOMX.py](https://github.com/bstabler/EMXtoOMX)
  - mce_reliability_prep.py codes freeway interchange nodes, upstream and downstream distances, and calculates the link reliability measure for skimming.  Run it after assignment and then skim the link @relvar attr.
  - convert_modechoice_pa_omx.R writes the demand model mode choice PA trip matrices to OMX matrices.  This script required the [R OMX script](https://github.com/osPlanning/omx/tree/dev/api/r) which requires the [rhdf5](http://bioconductor.org/packages/release/bioc/html/rhdf5.html) package
  
## Benefits Calculator File and Folder Setup
The benefits calculator is an implementation of the [FHWA bca4abm](https://github.com/RSGInc/bca4abm) calculator, which also does aggregate (i.e. trip-based) model calculations.  To install bca4abm, download the
repository and then run ```python setup.py install```.

*root folder*
  - run_bca.py - run benefit calculator
  - configs folder - configuration settings
      - settings.yaml - overall settings
      - aggregate_demographics.csv - expressions for coding zonal-based communities of concerns 
      - aggregate_zone.csv - expressions for aggregate zonal calculations, such as auto ownership and destination choice logsums
      - aggregate_od.csv - expressions for aggregate OD-pair calculations, such as travel time, travel time reliability, physical activity
      - link_daily.csv - expressions for link calculations - safety, vehicle operating costs, emissions, water, noise 
  - base scenario folder
      - link
        - linksMD1.csv - link MD1 assignment results
        - linksPM2.csv - link PM2 assignment results
      - OD  
        - assign_mfs.omx - assignment bank matrices
        - skims_mfs.omx - skims bank matrices
        - mode_choice_pa.omx - mode choice production-attraction matrices
      - Zone 
        - mf.cval.csv - see above
        - cocs.csv - externally defined COC share of households by zone
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
  - build scenario folder - same files as the base scenario folder
  - moves_2010_summer_running_rates.csv - MOVES emissions rate table

## Running the benefits calculator
The benefits calculator is currently run on the command line as follows: ```python run_bca.py```

The benefit calculator run steps are:
  - reads the settings and input data 
  - runs the aggregate_demographics_processor
    - each row in the processed data table is an origin zone
    - calculates communities of concern (COC)
    - ```orca.run(['aggregate_demographics_processor'])```
  - runs the aggregate zone processor
    - each row in the processed data table is an origin zone
    - calculates zonal level benefits
    - ```orca.run(['aggregate_zone_processor'])```
  - runs the aggregate_od_processor
    - each row in the processed data table is an OD pair
    - calculates trip level benefits
    - ```orca.run(['aggregate_od_processor'])```
  - runs the link processor
    - each row in the processed data table is a link 
    - daily is linkMD1 * scalingFactorMD1 + linkPM2 * scalingFactorPM2
    - calculates link level benefits
    - ```orca.run(['link_daily_processor'])```
  - writes results
    - ```orca.run(['write_four_step_results'])```
    - ```orca.run(['print_results'])```

# Project Costing Workbook
The project cost workbook calculates total project costs by type and Net Present Value.  Instructions are on the first worksheet.

# Visuals Workbook
The visuals workbook takes as input the outputs of the benefits calculator and the project costing workbook, 
calculates BC ratios, and summaries the results in various forms.  Instructions are on the first worksheet.
