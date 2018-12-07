# Create MCE Visualization Dashboard Input Tables
# Mike Dailey, Ben Stabler, RSG, 02/02/18
# python create_mce_visual_inputs.py benefits_file zone_benefits_file counties_and_cocs_file od_districts_benefits_file ithim_file ABMViz_Region.json_File_Local_Location New_Scenario_Name
# python create_mce_visual_inputs.py final_aggregate_results.csv final_aggregate_zone_summary.csv cocs.csv final_aggregate_od_district_summary.csv dalys.csv C:\SVN\ABMVIZ\data\portland\region.json I205test
# Outputs 3DAnimatedMapData.csv, BarChartAndMapData.csv, BarChartData.csv, ChordData.csv

import os, sys
import shutil
from shutil import copyfile
from collections import OrderedDict
import pandas as pd
import csv
import numpy as np
import json
sys.path.append(os.getcwd())
sys.path.append(os.path.join(os.getcwd(),"inputs"))

def buildBarChartFile(fileName,ithim_file,regionfileloc,datasetname):
    directory = regionfileloc.replace('region.json', '')
    
    BENEFIT_GROUPS = {'travel_options_benefit': 'Social Goods',
                      'physical_activity_benefit': 'Social Goods',
                      'safety_cost_benefit': 'Social Goods', 
                      'hhs_for_the_coc': 'Social Goods',
                      'veh_ownership_cost_benefit': 'Economic Vitality', 
                      'travel_time_reliability_benefit': 'Economic Vitality', 
                      'travel_time_benefit': 'Economic Vitality',
                      'trk_travel_time_benefit': 'Economic Vitality', 
                      'dtransit_travel_time_benefit': 'Economic Vitality', 
                      'sch_travel_time_benefit': 'Economic Vitality',
                      'hbc_travel_time_benefit': 'Economic Vitality',
                      'hbr_travel_time_benefit': 'Economic Vitality',
                      'hbs_travel_time_benefit': 'Economic Vitality',
                      'hbo_travel_time_benefit': 'Economic Vitality',
                      'nhbnw_travel_time_benefit': 'Economic Vitality',
                      'nhbw_travel_time_benefit': 'Economic Vitality',
                      'hbw_travel_time_benefit': 'Economic Vitality',
                      'veh_operating_cost_benefit': 'Economic Vitality',
                      'emissions_cost_benefit': 'Environmental Stewardship', 
                      'noise_pollution_cost_benefit': 'Environmental Stewardship',
                      'surface_water_pollution_cost_benefit': 'Environmental Stewardship'
                     }
                      
    RENAME_BENEFITS = ['sch_travel_time_benefit',
                       'hbc_travel_time_benefit', 
                       'hbr_travel_time_benefit',
                       'hbs_travel_time_benefit',
                       'hbo_travel_time_benefit', 
                       'nhbnw_travel_time_benefit',
                       'nhbw_travel_time_benefit',
                       'hbw_travel_time_benefit'
                      ]
    
    ithim_benefit = pd.read_csv(ithim_file)['dollars'][0]
    ithim_rec = pd.DataFrame({"BENEFIT":"active trans", "BENEFIT GROUP":"Everyone", "":ithim_benefit, "CHART":"Benefits"}, index=[0])
    
    with open(fileName,'r') as sourcefile:
        benefits = pd.read_csv(sourcefile)
        benefits.pop('Processor')
        benefits.pop('Description')
        mask = benefits['Target'].isin(RENAME_BENEFITS)
        benefits = benefits[~mask]
        benefits['BENEFIT GROUP'] = benefits.apply(lambda x: BENEFIT_GROUPS.get(x[0]),axis=1)
        df = pd.melt(benefits, id_vars=["Target","BENEFIT GROUP"],value_name="VALUE", var_name="CHART")

        cols = df.columns.tolist()
        cols = cols[:2] + [cols[-1]] + [cols[2]]
        df = df[cols]
        df = df.fillna(0)
        df.columns.values[0] = 'BENEFIT'
        ithim_rec.columns = df.columns
        df = df.append(ithim_rec)
        df.to_csv(directory+datasetname+"\BarChartData.csv", encoding='utf-8', index=False)

def animatedMapData(fileName,regionfileloc,datasetname):
    directory = regionfileloc.replace('region.json', '')
    
    BENEFIT_COLUMNS = {'travel_options_benefit': 'ALL PURPOSES',
                       'access_benefit_hbc': 'HBC',
                       'access_benefit_hbo': 'HBO',
                       'access_benefit_hbr': 'HBR',
                       'access_benefit_hbs': 'HBS',
                       'access_benefit_hbw': 'HBW',
                       'access_benefit_nhbnw': 'NHBNW',
                       'access_benefit_nhbw': 'NHBW',
                       'access_benefit_sch': 'SCH'
                      }

    with open(fileName, 'r') as sourcefile:
        animated = pd.read_csv(sourcefile, usecols=list(BENEFIT_COLUMNS))
        tempdf = pd.DataFrame(columns=['ZONE','PER','TRAVEL OPTIONS BENEFIT'])
        animated = animated.fillna(0)
        animated = animated.loc[~(animated == 0).all(axis=1)]

        masterFrame =pd.DataFrame(columns=['ZONE','PER','TRAVEL OPTIONS BENEFIT'])
        for key, value in BENEFIT_COLUMNS.items():
            tempdf['ZONE'] = range(1,len(animated))
            tempdf['PER'] = value
            tempdf['TRAVEL OPTIONS BENEFIT'] = animated.loc[:,[key]]
            masterFrame = masterFrame.append(tempdf,ignore_index=True)
        masterFrame = masterFrame.fillna(0)
        masterFrame.to_csv(directory+datasetname+"\\3DAnimatedMapData.csv", encoding='utf-8', index=False)

def barchartMap(fileName, countyFile,regionfileloc,datasetname):
    directory = regionfileloc.replace('region.json', '')
    
    BENEFIT_COLUMNS = {'access_benefit_hbc':'HBC',
                       'access_benefit_hbo':'HBO',
                       'access_benefit_hbr':'HBR',
                       'access_benefit_hbs':'HBS',
                       'access_benefit_hbw':'HBW',
                       'access_benefit_nhbnw':'NHBNW',
                       'access_benefit_nhbw':'NHBW',
                       'access_benefit_sch':'SCH'
                      }
    
    countys = []
    with open (countyFile,'r') as cntyFile:
        getcntys = pd.read_csv(cntyFile, usecols=['County'])
        countys = getcntys.dropna()

    totaldf = pd.DataFrame(['Total'],[countys.shape[0]],columns=['County'])

    countys = countys.append(totaldf)

    with open(fileName, 'r') as sourcefile:
        animated = pd.read_csv(sourcefile, usecols=list(BENEFIT_COLUMNS))
        tempdf = pd.DataFrame(columns=['ZONE','QUANTITY','TRAVEL OPTIONS BENEFIT','COUNTY'])
        masterFrame =pd.DataFrame(columns=['ZONE','COUNTY','TRAVEL OPTIONS BENEFIT','QUANTITY'])
        for key, value in BENEFIT_COLUMNS.items():
            tempdf['ZONE'] = range(1,len(animated))
            tempdf['TRAVEL OPTIONS BENEFIT'] = value
            tempdf['QUANTITY'] = animated.loc[:,[key]]
            tempdf['COUNTY'] = countys

            tempdf.loc[tempdf.index[tempdf['COUNTY']=='Total'].tolist(),'QUANTITY'] = tempdf['QUANTITY'].sum()
            masterFrame = masterFrame.append(tempdf,ignore_index=True)
        condition = np.isnan(masterFrame['QUANTITY'])
        masterFrame.loc[masterFrame['QUANTITY'].isnull(),'QUANTITY'] = 0.0

        masterFrame = masterFrame.dropna()
        masterFrame.to_csv(directory+datasetname+"\BarChartAndMapData.csv", encoding='utf-8', index=False,columns=['ZONE','COUNTY','TRAVEL OPTIONS BENEFIT','QUANTITY'])

def chordData(od_districts_benefits_file,regionfileloc,datasetname):
    agg_od = pd.read_csv(od_districts_benefits_file)
    directory = regionfileloc.replace('region.json', '')
    masterFrame = agg_od[["orig","dest","travel_time_benefit"]]
    masterFrame.columns = ["FROM","TO","Travel Time Savings"]
    masterFrame.to_csv(directory+datasetname+"\\ChordData.csv", encoding='utf-8', index=False)
    
def runConvertData(benefitsFile,zoneBenefitsFile,county_file,od_districts_benefits_file,ithim_file,regionfileloc,datasetname):
    buildBarChartFile(benefits_file,ithim_file,regionfileloc,datasetname)
    animatedMapData(zoneBenefitsFile,regionfileloc,datasetname)
    barchartMap(zoneBenefitsFile,county_file,regionfileloc,datasetname)
    chordData(od_districts_benefits_file,regionfileloc,datasetname)

def editRegionFile(regionfileloc, datasetname,county_file):
    jsonfile = open(regionfileloc,"r")
    data = json.load(jsonfile,object_pairs_hook=OrderedDict)
    tmp = data["scenarios"]
    tmp[datasetname] = "- " + datasetname
    jsonfile = open(regionfileloc,"w+")
    jsonfile.write(json.dumps(data, indent=4))
    jsonfile.close()
    directory = regionfileloc.replace('region.json', '')

    if not os.path.exists(directory+datasetname):
        os.makedirs(directory+datasetname)
    copyfile(county_file,directory+datasetname+"\\"+county_file)


if __name__ == "__main__":
    # set argument inputs
    benefits_file = sys.argv[1]
    zone_benefits_file = sys.argv[2]
    county_file = sys.argv[3]
    od_districts_benefits_file = sys.argv[4]
    ithim_file = sys.argv[5]
    regionfileloc = sys.argv[6]
    datasetname = sys.argv[7]
    editRegionFile(regionfileloc,datasetname,county_file)
    runConvertData(benefits_file,zone_benefits_file,county_file,od_districts_benefits_file,ithim_file,regionfileloc,datasetname)