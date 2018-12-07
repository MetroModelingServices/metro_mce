The [Oregon Metro](http://www.oregonmetro.gov/) Multi-Criteria Evaluation (MCE) toolkit supports transportation planning alternatives analysis by estimating the quantitative “Social Return on Investment” of alternative transportation investment scenarios.  The MCE toolkit consists of three core tools:
  - [Benefits Calculator](#benefits-calculator) - calculates monetized benefits of transportation projects 
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
  - configs folder - configuration settings
      - settings.yaml - overall settings such as constants for each processor, annualization factor, input file names, etc.
      - aggregate_demographics.csv/yaml - expressions and settings for coding zonal-based communities of concerns 
      - aggregate_zone.csv/yaml - expressions and settingsfor aggregate zonal calculations - auto ownership and destination choice logsums
      - aggregate_od.csv/yaml - expressions and settingsfor aggregate OD-pair calculations - travel time, travel time reliability, physical activity
      - link_daily.csv/yaml - expressions and settingsfor link calculations - safety, vehicle operating costs, emissions, water, noise 
      - tables.yaml - input tables used by the various processors
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
    - final_aggregate_zone_summary.csv - aggregate zone processor results
    - final_aggregate_od_district_summary.csv - aggregate od processor results
    - bca.log - logs the model steps run
    - pipeline.h5 - HDF5 data pipeline file with all tables inside
  - Trace outputs if a trace OD pair is defined in ```trace_od``` in the setting file:
    - aggregate_demographics.csv - all expression results for the traced ozone and all values for the traced dzone
    - aggregate_zone.csv - all expression results for the traced ozone and all values for the traced dzone
    - aggregate_od.csv - all expression results for the traced OD pair
    - link_daily_results_base.csv - all expression results for links with a @zone in the traced OD pair in the base scenario
    - link_daily_results_build.csv - all expression results for links with a @zone in the traced OD pair in the build scenario

# ITHIM R
To run the ITHIM R active transportation benefit calculator:
  - Run the `mce_ithim.R` or `mce_ithim_coc.R` (for results by COC) script
  - Revise the following settings at the top of the script if needed:
    - projectDirectory_base = "data/base-data"
    - projectDirectory_build = "data/build-data"
    - projectDirectory_run = "data/ithimR"
    - GBDFileForITHIM = "data/ithimR/burden.portland.csv"
    - PopulationFileForITHIM = "data/ithimR/F.portland.csv"
    - WALK_SPEED = 3
    - BIKE_SPEED = 10
    - AVG_HH_SIZE = 2.4
    - DOLLARS_PER_DALY = 80000
  - Run the script from the `bc_setup` folder to produce the `dalys.csv` or `dalys_cocs.csv` output file with DALYs and dollars
  
# Project Costing Workbook
The project cost workbook calculates total project costs by type and Net Present Value.  Instructions are on the first worksheet.

# Visualization Dashboard 
The visualization dashboard is at https://github.com/MetroModelingServices/MCEVIZ.  The `create_mce_visual_inputs.py` script 
in the data_export folder creates the MCE visualization dashboard input tables based on the benefits calculator 
outputs. Instructions for running the script are in the script header. Before running the script, some of the inputs files should be modified by hand.  The input files are:
  - benefits_file - final_aggregate_results.csv - make sure to remove unwanted COCs and benefits (the target field), and to rename COCs and benefits for the visualizer.  A seperate benefits file for benefits per HH can be calculated by dividing the benefits by the HHs for the COC
  - zone_benefits_file - final_aggregate_zone_summary.csv
  - counties_and_cocs_file - cocs.csv
  - od_districts_benefits_file - final_aggregate_od_district_summary.csv
  - ithim_file - dalys.csv
  - ABMViz_Region.json_File_Local_Location - region.json
  - New_Scenario_Name - I205test

# Running the Complete MCE Toolkit
The steps to run the complete toolkit from start to finish are:
  - Travel Model
    1. Code the base and build model scenarios
    2. Run the demand and supply models with the MCE export option
  - ITHIMProcessor,Target,Description,coc_ext_minority,coc_ext_lowengpro,coc_ext_age18or65,coc_lowinc_ext,everybody
aggregate_demographics,hhs_for_the_coc,total hhs for each coc,222882.7195,42092.97561,637087.2221,229606.8432,1187017.822
aggregate_zone_benefits,travel_options_benefit,travel options benefit,3984553.192,690223.3457,14487780.09,4101208.492,26464943.03
aggregate_zone_benefits,veh_ownership_cost_benefit,vehicle ownership cost benefit,42423.32203,7297.519501,65077.62659,76432.79347,209216.0647
aggregate_od,travel_time_reliability_benefit,travel time reliability benefit,431999.0763,72609.44038,1416161.879,470330.629,2779973.528
aggregate_od,travel_time_benefit,travel time benefit,3561067.388,632461.4153,12362331.42,3834376.866,23301994.39
link_daily,veh_operating_cost_benefit,vehicle operating cost benefit,,,,,-15499198.37
link_daily,emissions_cost_benefit,emissions cost benefit,,,,,-4708070.842
link_daily,noise_pollution_cost_benefit,noise pollution cost benefit,,,,,-945067.5563
link_daily,surface_water_pollution_cost_benefit,surface water pollution cost benefit,,,,,-1103101.181
link_daily,safety_cost_benefit,roadway safety cost benefit,,,,,-1484723.26

    1. Configure and run `mce_ithim.R` or `mce_ithim_coc.R` (for results by COC)
  - Benefits Calculator
    1. Setup and run the benefits calculator.  Make sure to review and update the settings as needed.
    2. The results are in the `final_aggregate_results.csv` output file.
    3. Make sure to add the ITHIM R results to the benefits calculator output file as well.
  - Project Costs
    1. Setup a project costing workbook for the base and build separately and code projects into the RTP+TIP tab.  Make sure to review and update the settings as needed, including setting the correct present value year for the net present value calculation.  
    2. The results are in the Present Value Sum table on the PV_Summary tab
  - Visualization Dashboard
    1. Run the `create_mce_visual_inputs.py` script to convert the data to the format expected by the visualizer
    2. Add the visualizer inputs to your local MCEVIZ git repo and push the changes up to GitHub
    3. Go to https://github.com/metromodelingservices/mceviz and do a pull request from the master branch into the gh-pages branch to publish the new data
    4. The visualizer is running at http://metromodelingservices.github.io/MCEVIZ
