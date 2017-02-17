The [Oregon Metro](http://www.oregonmetro.gov/) Multi-Criteria Evaluation (MCE) toolkit supports transportation planning alternatives analysis by estimating the quantitative “Social Return on Investment” of alternative transportation investment scenarios.

The MCE toolkit consists of three core tools:
  - Benefits calculator - calculates monetized benefits of transportation projects
  - Project costing workbook - calculates total project costs by type and Net Present Value
  - Visuals workbook - takes as input the benefits and costs, calculates B/C ratios, and summarizes and visualizes the results

Note that you need [Git LFS](https://git-lfs.github.com/) to download this repo due to the large OMX files.

# Benefits Calculator

## Travel Model Data Export
The scripts in this folder are used to export the required data from the R travel demand model and the EMME travel supply model for import into the benefits calculator.
  - Various R scripts - these demand model scripts were revised to output trip productions, destination choice logsums, and the HH CVAL array - HIAs by workers and car ownership for each TAZ - to CSV format. See the j.hbw_Generation.R script for the mf.cval column order.
  - convert_modechoice_pa_omx_part1.R and convert_modechoice_pa_omx_part2.R write the demand model mode choice PA trip matrices to OMX matrices.  These scripts required the [R OMX script](https://github.com/osPlanning/omx/tree/dev/api/r) which requires the [rhdf5](http://bioconductor.org/packages/release/bioc/html/rhdf5.html) package
  - parking_costs_to_omx.R converts the short term and long term parking cost by zone to an OMX matrix.  This script required the [R OMX script](https://github.com/osPlanning/omx/tree/dev/api/r) which requires the [rhdf5](http://bioconductor.org/packages/release/bioc/html/rhdf5.html) package
  - mce_reliability_prep.py codes freeway interchange nodes, upstream and downstream distances, and calculates the link reliability measure for skimming.  Run it after assignment and then skim the link @relvar attr.
  - bca_EMME_Export.bat exports the required matrices (mfs) and also calls ExportLinkResultsToCSV.py.  This script requires [EMXtoOMX.py](https://github.com/bstabler/EMXtoOMX)
  - ExportLinkResultsToCSV.py writes out EMME link assignment results to a CSV file.  The required link fields are listed below.

## Installation
The benefits calculator is an implementation of the [FHWA bca4abm](https://github.com/RSGInc/bca4abm) calculator, which also does aggregate (i.e. trip-based) model calculations.  To install bca4abm, follow the instructions [here](https://github.com/RSGInc/bca4abm/wiki/Installation).  Next, clone this repo (metro_mce) to your machine.

## Benefits Calculator File and Folder Setup
*root folder*
  - run_bca.py - run benefit calculator
  - configs folder - configuration settings
      - settings.yaml - overall settings such as constants for each processor, annualization factor, input file names, etc.
      - aggregate_demographics.csv - expressions for coding zonal-based communities of concerns 
      - aggregate_zone.csv - expressions for aggregate zonal calculations - auto ownership and destination choice logsums
      - aggregate_od.csv - expressions for aggregate OD-pair calculations - travel time, travel time reliability, physical activity
      - link_daily.csv - expressions for link calculations - safety, vehicle operating costs, emissions, water, noise 
  - base scenario folder
      - link
        - linksMD1.csv - link MD1 period assignment results with the following required fields.  Make sure to remove the list of vertices from the vertices field since the commas inside the [] causes problems
          - i - i node
          - j - j node
          - @zone - zone
          - @amrmp - ?
          - @cap - capacity
          - @divhwy - divided highway
          - @dwdist - ?
          - @fwcap - ?
          - @htkad - ?
          - @htvol - heavy truck volume
          - @hvol - hov volume
          - @lanes2 - is a 2 lane link
          - @lanes3 - is a 3 lane link
          - @lanes4 - is a 4 lane link
          - @losc - los c
          - @loscart - los c arterial
          - @losd - los d
          - @lose - los e
          - @losfh - los f high
          - @losfl - los f low
          - @losflart - los f low arterial
          - @mb - ?
          - @mdrmp - ?
          - @mpa - ?
          - @mtkad - ?
          - @mtvol - med truck volume
          - @noisef - noise benefit adjustment factor
          - @pmrmp - ?
          - @relvar - reliability variance 
          - @signal - to node is a signal
          - @spd35 - is 35mph 
          - @spd40 - is 40mph 
          - @spd45 - is 45mph 
          - @spd50 - is 50mph 
          - @spd50p - is 50mph 
          - @spd70 - is 70mph 
          - @speed - speed
          - @stop - to node is a stop
          - @svol - sov volume
          - @tknet - ? 
          - @tkpth - ?
          - @trkad - ?
          - @ul3 - ?
          - @updist - upstream ramp distance
          - @urbrur - urban or rural
          - @waterf - water benefit adjustment factor
          - @barrier - barrier 
          - additional_volume - ? 
          - auto_time - ?
          - auto_volume - total auto volume
          - data1 - ? 
          - data2 - ?
          - data3 - ?
          - length - link length
          - num_lanes - number of lanes
          - type - link type 
          - vertices - ?
          - volume_delay_func - vdf code
        - linksPM2.csv - link PM2 assignment results with the same fields
      - OD  
        - assign_mfs.omx - assignment bank matrices
        - skims_mfs.omx - skims bank matrices
        - mode_choice_pa_part1.omx - half of the mode choice production-attraction matrices
        - mode_choice_pa_part2.omx - half of the mode choice production-attraction matrices
        - mode_choice_pa_school_college.omx - mode choice production-attraction matrices for school and college trips
        - parking_cost.omx - parking costs at the destination
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
To run the benefits calculator, first change directory to the bc_setup folder and then activate the Anaconda environment you created for this project.  It may be named ```bca4abmtest``` based on the bca4abm install instructions, but it can be named something more relevant such as ```mce``` if desired.
  ```
  activate mce
  ```
Next, run the benefits calculator in the bc_setup folder with the following command:
  ```
  python run_bca.py
  ```

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

## Outputs 
The benefits calculator outputs the following files to the ```outputs``` folder:
  - Standard outputs with the setting ```dump``` set to True:
    - **aggregate_results.csv - overall results for each benefit calculated by COC, including everybody**
    - zone_demographics.csv - aggregate demographics processor results
    - aggregate_zone_benefits.csv - aggregate zone processor results
    - aggregate_od_benefits.csv - aggregate od processor results
    - link_daily_benefits.csv - link daily processor results
    - bca.log - logs the model steps run
    - bca_results.h5 - HDF5 file with the aggregate_results table inside
  - Trace outputs if a trace OD pair is defined in ```trace_od``` in the setting file:
    - aggregate_demographics.csv - all expression results for the traced ozone and all values for the traced dzone
    - aggregate_zone.csv - all expression results for the traced ozone and all values for the traced dzone
    - aggregate_od.csv - all expression results for the traced OD pair
    - link_daily_results_base.csv - all expression results for links with a @zone in the traced OD pair in the base scenario
    - link_daily_results_build.csv - all expression results for links with a @zone in the traced OD pair in the build scenario
    - hhtrace.log - log file for tracing model expressions

Additional useful documentation on how to setup and run the bca4abm tool is [here](https://github.com/RSGInc/bca4abm/wiki).

# Project Costing Workbook
The project cost workbook calculates total project costs by type and Net Present Value.  Instructions are on the first worksheet.

# Visuals Workbook
The visuals workbook takes as input the outputs of the benefits calculator and the project costing workbook, 
calculates BC ratios, and summaries the results in various forms.  Instructions are on the first worksheet.

# Running the Complete MCE Toolkit
The steps to run the complete toolkit from start to finish are:
  - Travel Model
    1. Code the base and build model scenarios
    2. Run the updated demand models with the revised R scripts in the data export folder
    3. Run the assignments
    4. Run the data export scripts for both the base and build scenarios.  The scripts need to be run in the following order:
        1. convert_modechoice_pa_omx_part1.R and convert_modechoice_pa_omx_part2.R
        2. parking_costs_to_omx.R
        3. mce_reliability_prep.py
        4. bca_EMME_Export.bat
  - Benefits Calculator
    1. Setup and run the benefits calculator.  Make sure to review and update the settings as needed.
    2. The results are in the aggregate_results.csv output file.
  - Project Costs
    1. Setup a project costing workbook for the base and build separately and code projects into the RTP+TIP tab.  Make sure to review and update the settings as needed, including setting the correct present value year for the net present value calculation.  
    2. The results are in the Present Value Sum table on the PV_Summary tab
  - Visuals Workbook
    1. Setup a visuals workbook.  Make sure to review and update the settings as needed, including setting the correct year for visualization/analysis.  
    2. Copy the aggregate_results.csv data to the Benefits tab and set the year of the scenario.  The DOLLARS field will be automatically calculated by the worksheet.
    3. Copy the Present Value Sum table data to the Costs tab and set the year of the scenario.  The DOLLARS field will be automatically calculated by the worksheet.
    4. Refresh all the pivot tables due to the data source changes
    5. If needed, refresh the average SCENPOLICYRANK fields:
      - on the BCRatio tab, in the third table, add `SCENPOLICYRANK` as the summation field and use `AVERAGE` as the summation operator.
      - on the BCRatioByPolicyRank tab, in the first table, add `SCENPOLICYRANK` as the summation field and use `AVERAGE` as the summation operator.
    6. Configure the visuals as needed and enjoy
