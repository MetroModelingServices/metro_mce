The [Oregon Metro](http://www.oregonmetro.gov/) Multi-Criteria Evaluation (MCE) toolkit supports transportation planning alternatives analysis by estimating the quantitative “Social Return on Investment” of alternative transportation investment scenarios.

The MCE toolkit consists of three core tools:
  - Benefits calculator - calculates monetized benefits of transportation projects 
  - Project costing workbook - calculates total project costs by type and Net Present Value
  - Visualizer - visualizes the results

# Benefits Calculator

## Travel Model Inputs
The travel demand and supply models are configured to output all required MCE inputs.  A set of model outputs is required for a base and build scenario for the benefits calculator.  The benefit calculator input specifications are at: 
https://github.com/MetroModelingServices/integrated_workflow, specifically:
  - [MCE Demand Inputs](https://github.com/MetroModelingServices/integrated_workflow/blob/master/mce_demand_inputs.md)
  - [MCE Supply Inputs](https://github.com/MetroModelingServices/integrated_workflow/blob/master/mce_supply_inputs.md)

## Installation
The benefits calculator is an implementation of the [FHWA bca4abm](https://github.com/RSGInc/bca4abm) calculator, which also does aggregate (i.e. trip-based) model calculations.  To install bca4abm, follow the instructions [here](http://rsginc.github.io/bca4abm/).

The Metro MCE configuration of the benefits calculator is in the [bc_setup](https://github.com/MetroModelingServices/metro_mce/tree/master/bc_setup) folder.  You can download the complete repository by clicking the 'clone or download' button on the [project home page](https://github.com/MetroModelingServices/metro_mce).

## Benefits Calculator File and Folder Setup
*root folder*
  - run_bca.py - run benefit calculator
  - create_park_cost_matrix.py - create the parking cost matrix input file
  - configs folder - configuration settings
      - settings.yaml - overall settings such as constants for each processor, annualization factor, input file names, etc.
      - aggregate_demographics.csv/yaml - expressions and settings for coding zonal-based communities of concerns 
      - aggregate_zone.csv/yaml - expressions and settingsfor aggregate zonal calculations - auto ownership and destination choice logsums
      - aggregate_od.csv/yaml - expressions and settingsfor aggregate OD-pair calculations - travel time, travel time reliability, physical activity
      - link_daily.csv/yaml - expressions and settingsfor link calculations - safety, vehicle operating costs, emissions, water, noise 
  - data folder
    - base scenario folder - all the MCE demand and supply inputs noted above for the base scenario
      - cocs.csv - communities of concerns specification file
    - build scenario folder - same files as the base scenario folder but for the build scenario
    - moves_2010_summer_running_rates.csv - MOVES emissions rate table
    - zone_districts.csv - zone districts for aggregate OD processor reporting

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

# ITHIM R
To run the ITHIM R active transportation benefit calculator, configure the following settings at the top of the script:
  - projectDirectory_base = "data/base-data"
  - projectDirectory_build = "data/build-data"
  - projectDirectory_run = "data/run/ithimR"
  - GBDFileForITHIM = "burden.portland.csv"
  - PopulationFileForITHIM = "F.portland.csv"
  - WALK_SPEED = 3
  - BIKE_SPEED = 10
  - AVG_HH_SIZE = 2.4
  - DOLLARS_PER_DALY = 80000

The script will write out the dalys.csv output file with three columns - coc, dalys, and dollars.

# Project Costing Workbook
The project cost workbook calculates total project costs by type and Net Present Value.  Instructions are on the first worksheet.

# Visualization Dashboard inputs creation script
The `create_mce_visual_inputs.py` script in the data_export folder creates the MCE visualization dashboard input 
tables based on the benefits calculator outputs. File will now add the new data set to the MCE visualization dashboard config file.
 Instructions for running the script are in the script header.

# Visualization Dashboard inputs creation batch file
The `createnewdatascenarion.bat` batch file in the data_export folder will run the  `create_mce_visual_inputs.py` script  
and using Git add, commit and push changes  up to the Github Repository. Batch file requires locations for files to be coded in before running. 

# Running the Complete MCE Toolkit
The steps to run the complete toolkit from start to finish are:
  - Travel Model
    1. Code the base and build model scenarios
    2. Run the updated demand models with the revised R scripts in the data export folder
    3. Run the assignments
    4. Run the data export scripts for both the base and build scenarios.  The scripts need to be run in the following order:
        1. base|build_convert_modechoice_pa_omx_purpose.R
        2. parking_costs_to_omx.R
        3. mce_reliability_prep.py
        4. bca_EMME_Export.bat
        5. mce_ithim.R or mce_ithim_coc.R
  - Benefits Calculator
    1. Setup and run the benefits calculator.  Make sure to review and update the settings as needed.
    2. The results are in the aggregate_results.csv output file.
    3. Make sure to add the ITHIM R results to the benefits calculator output file as well.
  - Project Costs
    1. Setup a project costing workbook for the base and build separately and code projects into the RTP+TIP tab.  Make sure to review and update the settings as needed, including setting the correct present value year for the net present value calculation.  
    2. The results are in the Present Value Sum table on the PV_Summary tab
  - Visuals Workbook
    1. Setup a visuals workbook.  Make sure to review and update the settings as needed, including setting the correct year for visualization/analysis.  
    2. Copy the aggregate_results.csv data to the Benefits tab and set the year of the scenario.  The DOLLARS and KEY fields are automatically calculated by the worksheet.
    3. Copy the Present Value Sum table data to the Costs tab and set the year of the scenario.  The DOLLARS and KEY fields  are automatically calculated by the worksheet.
  - Visualization Dashboard
    1. In createNewDataScenario.bat, set the following parameters:
      - BENEFITS_FILE - such as `aggregate_results.csv`
      - ZONE_BENEFITS_FILE - such as `kate_aggregate_zone_benefits.csv`
      - COUNTIES_COC_FILE - such as `cocs.csv`
      - REGION_FILE_LOC - such as `C:\MCEVIZ\data\portland\region.json`
      - NEW_DATA_NAME - such as `I205Test`
      - GITHUB_ABMVIZ_LOC - such as `C:\MCEVIZ`
    2. Run createNewDataScenario.bat to:
      - Run the `create_mce_visual_inputs.py` script to convert the data to the format expected by the visualizer
      - Add the visualizer inputs to your local mceviz git repo and pushes it to GitHub
    3. Go to https://github.com/metromodelingservices/mceviz and do a pull request from the master branch into the gh-pages branch to publish the new data
    4. The visualizer is running at http://metromodelingservices.github.io/MCEVIZ
