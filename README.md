The [Oregon Metro](http://www.oregonmetro.gov/) Multi-Criteria Evaluation (MCE) toolkit supports transportation planning alternatives analysis by estimating the quantitative “Social Return on Investment” of alternative transportation investment scenarios.  The MCE toolkit consists of three core tools described in more detail below:
  - [Benefits Calculator](#benefits-calculator) - calculates monetized benefits of transportation projects 
  - [Project Costing Workbook](#project-costing-workbook) - calculates total project costs by type and Net Present Value
  - [Visualizer](#visualization-dashboard) - web-based visualization of the results

# Running the Complete MCE Toolkit
In brief, the steps to run the complete toolkit from start to finish are:
  - Travel Model
    1. Code the base and build model scenarios
    2. Run the demand and supply models with the MCE export option
  - ITHIM
    1. Configure and run `mce_ithim.R` or `mce_ithim_coc.R` (for results by COC)
  - Benefits Calculator
    1. Setup and run the benefits calculator.  Make sure to review and update the settings as needed.
    2. The results are in the `final_aggregate_results.csv` output file.
    3. Make sure to add the ITHIM R results to the benefits calculator output file as well before running the script to create the visualizer data files.
  - Project Costs
    1. Setup a project costing workbook for the base and build separately and code projects into the RTP+TIP tab.  Make sure to review and update the settings as needed, including setting the correct present value year for the net present value calculation.  
    2. The results are in the Present Value Sum table on the PV_Summary tab
  - Visualization Dashboard (MCEVIZ)
    1. Run the `create_mce_visual_inputs.py` script to convert the data to the format expected by the visualizer.
    2. Run the `create_mce_visual_scen_comp_inputs.py` script to create the scenario comparison data expected by the visualizer.
    3. Commit the visualizer inputs to a local clone of the MCEVIZ git repository.
    5. Push the changes up to GitHub and check the online repository to ensure the files have been uploaded.
    6. On the website, create and then merge a Pull Request from the master branch into the gh-pages branch in order to publish the new data for the website.  
    7. Verify the updated data is displayed on the [website](http://metromodelingservices.github.io/MCEVIZ)
    
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
The workbook calculates total project costs by type and Net Present Value.  Instructions are on the first worksheet.

# Visualization Dashboard 
The visualization dashboard is online at https://github.com/MetroModelingServices/MCEVIZ.  

The `create_mce_visual_inputs.py` script in the data_export folder creates the MCE visualization dashboard input tables for one scenario based on the benefits calculator outputs.  An example command line call to run the script is below.  Instructions for running the script are in the script header.

```
python create_mce_visual_inputs.py final_aggregate_results.csv final_aggregate_zone_summary.csv cocs.csv final_aggregate_od_district_summary.csv dalys.csv final_zone_demographics.csv C:\projects\development\ActivityViz\data\portland\region.json I205
````

The input files for the script are:
  - benefits_file - final_aggregate_results.csv
  - zone_benefits_file - final_aggregate_zone_summary.csv
  - counties_and_cocs_file - cocs.csv
  - od_districts_benefits_file - final_aggregate_od_district_summary.csv
  - ithim_file - dalys.csv
  - ABMViz_Region.json_File_Local_Location - region.json
  - New_Scenario_Name - I205test

The `create_mce_visual_scen_comp_inputs.py` script in the data_export folder creates the MCE visualization dashboard scenario comparison input tables for two scenarios (scenario "a" and scenario "b").  An example command line call to run the script is below.  Instructions for running the script are in the script header.  This script operates on outputs from the `create_mce_visual_inputs.py` described above since it compares scenarios.

```
python create_mce_visual_scen_comp_inputs.py I205\BarChartData.csv DivisionBRT\BarChartData.csv 260000000 160000000 10 Scenarios
````

The input files for the script are:
  - benefits_a - I205\BarChartData.csv
  - benefits_b - DivisionBRT\BarChartData.csv
  - cost_a - 260000000
  - cost_b - 160000000
  - years_of_benefit - 10
  - New_Scenario_Name - Scenarios

After creating all the data inputs for the visualizer, the data files need to be uploaded to the online MCEVIZ GitHub repository since the website is hosted by [GitHub pages](https://pages.github.com/).  The steps to update/publish new scenarios with the visualizer require familiarity with git and GitHub.  The instructions below use [Git for Windows](https://git-scm.com/download/win) and [TortoiseGit](https://tortoisegit.org).  To post the data files online, do the following:

  - Clone the MCEVIZ repository to your local machine by Right Clicking in the desired destination Windows explorer folder and then selecting Git Clone and entering the project git address - https://github.com/MetroModelingServices/MCEVIZ.git
  - Copy the revised visualizer data inputs into the data \ portland \ new_scenario_if_needed folder.  
  - Configure the visualizer according to the visualizer [documentation](https://github.com/MetroModelingServices/MCEVIZ/blob/master/README.md)
  - Commit the visualizer setup revisions to the master (default) branch of your local clone of the MCEVIZ git repository via Right Click + Git Commit Master.
  - Push the changes up to GitHub via Right Click + Tortoise Git + Push and check the online repository master branch to ensure the files have been uploaded.
  - On the website, create a Pull Request from the master branch to the gh-pages branch in order to publish the new data for the website.  After creating the pull request, merge the pull request in order to finalize copying the data files from the master branch to the gh-pages branch.  The website displays the gh-pages branch files.  
  - Verify the updated data is displayed on the [website](http://metromodelingservices.github.io/MCEVIZ)
  
