The [Oregon Metro](http://www.oregonmetro.gov/) Multi-Criteria Evaluation (MCE) toolkit supports transportation planning alternatives analysis by estimating the quantitative “Social Return on Investment” of alternative transportation investment scenarios.

The MCE toolkit consists of three core tools:
  - [Benefits Calculator](#benefits-calculator) - Calculates monetized benefits of transportation projects 
  - [Project Costing Workbook](#project-costing-workbook) - calculates total project costs by type and Net Present Value
  - [Visualizer](#visualization-dashboard) - web-based visualization of the results

# Benefits Calculator

## Travel Model Inputs
The travel demand and supply models are configured to output all required MCE inputs.  A set of model outputs is required for a base and build scenario for the benefits calculator.  The benefit calculator input specifications are at: 
https://github.com/MetroModelingServices/integrated_workflow, specifically:
  - [MCE Demand Inputs](https://github.com/MetroModelingServices/integrated_workflow/blob/master/mce_demand_inputs.md)
  - [MCE Supply Inputs](https://github.com/MetroModelingServices/integrated_workflow/blob/master/mce_supply_inputs.md)

## Installation
The benefits calculator is an implementation of the [FHWA bca4abm](https://github.com/RSGInc/bca4abm) calculator, which also does aggregate (i.e. trip-based) model calculations.  To install bca4abm, follow the instructions [here](http://rsginc.github.io/bca4abm/).

The Metro MCE configuration of the benefits calculator is in the [bc_setup](https://github.com/MetroModelingServices/metro_mce/tree/master/bc_setup) folder.  You can download the complete repository by clicking the 'clone or download' button on the [project home page](https://github.com/MetroModelingServices/metro_mce).

## Benefits Calculator
*root folder*
  - run_bca.py - run benefit calculator
  - create_park_cost_matrix.py - (for now) create the parking cost matrix input file by running this script before running run_bca.py
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
The benefits calculator outputs the following files to the ```output``` folder:
  - Standard outputs:
    - **final_aggregate_results.csv - overall results for each benefit calculated by COC, including everybody**
    - final_zone_demographics.csv - demographics processor results
    - final_aggregate_zone_benefits.csv - aggregate zone processor results
    - final_aggregate_od_benefits.csv - aggregate od processor results
    - bca.log - logs the model steps run
    - pipeline.h5 - HDF5 data pipeline file with all tables inside
  - Trace outputs if a trace OD pair is defined in ```trace_od``` in the setting file:
    - aggregate_demographics.csv - all expression results for the traced ozone and all values for the traced dzone
    - aggregate_zone.csv - all expression results for the traced ozone and all values for the traced dzone
    - aggregate_od.csv - all expression results for the traced OD pair
    - link_daily_results_base.csv - all expression results for links with a @zone in the traced OD pair in the base scenario
    - link_daily_results_build.csv - all expression results for links with a @zone in the traced OD pair in the build scenario

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

# Visualization Dashboard 
The visualization dashboard is at https://github.com/MetroModelingServices/MCEVIZ.  The `create_mce_visual_inputs.py` script in the data_export folder creates the MCE visualization dashboard input tables based on the benefits calculator outputs. File will now add the new data set to the MCE visualization dashboard config file. Instructions for running the script are in the script header.  The `createnewdatascenarion.bat` batch file in the data_export folder will run the  `create_mce_visual_inputs.py` script and using Git add, commit and push changes  up to the Github Repository. Batch file requires locations for files to be coded in before running. 

# Running the Complete MCE Toolkit
The steps to run the complete toolkit from start to finish are:
  - Travel Model
    1. Code the base and build model scenarios
    2. Run the demand and supply models with the MCE export option
  - ITHIM
    1. Run `mce_ithim.R` or `mce_ithim_coc.R`
  - Benefits Calculator
    1. Setup and run the benefits calculator.  Make sure to review and update the settings as needed.
    2. The results are in the `final_aggregate_results.csv` output file.
    3. Make sure to add the ITHIM R results to the benefits calculator output file as well.
  - Project Costs
    1. Setup a project costing workbook for the base and build separately and code projects into the RTP+TIP tab.  Make sure to review and update the settings as needed, including setting the correct present value year for the net present value calculation.  
    2. The results are in the Present Value Sum table on the PV_Summary tab
  - Visualization Dashboard
    1. Configure and run `createNewDataScenario.bat` to:
      - Run the `create_mce_visual_inputs.py` script to convert the data to the format expected by the visualizer
      - Add the visualizer inputs to your local mceviz git repo and pushes it to GitHub
    3. Go to https://github.com/metromodelingservices/mceviz and do a pull request from the master branch into the gh-pages branch to publish the new data
    4. The visualizer is running at http://metromodelingservices.github.io/MCEVIZ
