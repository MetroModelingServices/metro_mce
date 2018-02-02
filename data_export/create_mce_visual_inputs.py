
# Create MCE Visualization Dashboard Input Tables
# Mike Dailey, Ben Stabler, RSG, 02/02/18
# python create_mce_visual_inputs.py benefits_file zone_benefits_file counties_and_cocs_file
# python create_mce_visual_inputs.py aggregate_results.csv kate_aggregate_zone_benefits.csv cocs.csv
# Outputs 3DAnimatedMapData.csv, BarChartAndMapData.csv, and BarChartData.csv

import os, sys, shutil
import pandas as pd
import csv
import numpy as np
sys.path.append(os.getcwd())
sys.path.append(os.path.join(os.getcwd(),"inputs"))

def buildBarChartFile(fileName):
    BENEFIT_GROUPS = {'travel_options_benefit': 'Social Goods','physical_activity_benefit': 'Social Goods','safety_cost_benefit': 'Social Goods', 'hhs_for_the_coc': 'Social Goods',
                        'veh_ownership_cost_benefit': 'Economic Vitality', 'travel_time_reliability_benefit': 'Economic Vitality', 'travel_time_benefit': 'Economic Vitality',
                        'trk_travel_time_benefit': 'Economic Vitality', 'dtransit_travel_time_benefit': 'Economic Vitality', 'sch_travel_time_benefit': 'Economic Vitality',
                        'hbc_travel_time_benefit': 'Economic Vitality','hbr_travel_time_benefit': 'Economic Vitality','hbs_travel_time_benefit': 'Economic Vitality',
                        'hbo_travel_time_benefit': 'Economic Vitality','nhbnw_travel_time_benefit': 'Economic Vitality','nhbw_travel_time_benefit': 'Economic Vitality',
                        'hbw_travel_time_benefit': 'Economic Vitality','veh_operating_cost_benefit': 'Economic Vitality',
                        'emissions_cost_benefit': 'Environmental Stewardship', 'noise_pollution_cost_benefit': 'Environmental Stewardship', 'surface_water_pollution_cost_benefit': 'Environmental Stewardship'
                      }
    RENAME_BENEFITS = [
        'sch_travel_time_benefit',    'hbc_travel_time_benefit', 'hbr_travel_time_benefit',
        'hbs_travel_time_benefit',
        'hbo_travel_time_benefit', 'nhbnw_travel_time_benefit',
        'nhbw_travel_time_benefit',
        'hbw_travel_time_benefit'
    ]
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
        df.to_csv("BarChartData.csv", encoding='utf-8', index=False)

def animatedMapData(fileName):
    BENEFIT_COLUMNS = {'travel_options_benefit': 'ALL PURPOSES','access_benefit_hbc': 'HBC','access_benefit_hbo': 'HBO','access_benefit_hbr': 'HBR','access_benefit_hbs': 'HBS',
                       'access_benefit_hbw': 'HBW', 'access_benefit_hbwl': 'HBWL',	'access_benefit_hbwm': 'HBWM','access_benefit_hbwh': 'HBWH','access_benefit_nhbnw': 'NHBNW',
                       'access_benefit_nhbw': 'NHBW', 'access_benefit_sch': 'SCH'
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
        masterFrame.to_csv("3DAnimatedMapData.csv", encoding='utf-8', index=False)

def barchartMap(fileName, countyFile):
    BENEFIT_COLUMNS = {'access_benefit_hbc':'HBC','access_benefit_hbo':'HBO','access_benefit_hbr':'HBR','access_benefit_hbs':'HBS',
                       'access_benefit_hbw':'HBW','access_benefit_hbwl':'HBWL',	'access_benefit_hbwm':'HBWM','access_benefit_hbwh':'HBWH','access_benefit_nhbnw':'NHBNW',
                       'access_benefit_nhbw':'NHBW','access_benefit_sch':'SCH'
    }
    countys = []
    with open (countyFile,'r') as cntyFile:
        getcntys = pd.read_csv(cntyFile, usecols=['County'])
        countys = getcntys.dropna()

    with open(fileName, 'r') as sourcefile:
        animated = pd.read_csv(sourcefile, usecols=list(BENEFIT_COLUMNS))
        tempdf = pd.DataFrame(columns=['ZONE','QUANTITY','TRAVEL OPTIONS BENEFIT','COUNTY'])
        masterFrame =pd.DataFrame(columns=['ZONE','COUNTY','TRAVEL OPTIONS BENEFIT','QUANTITY'])
        for key, value in BENEFIT_COLUMNS.items():
            tempdf['ZONE'] = range(1,len(animated))
            tempdf['TRAVEL OPTIONS BENEFIT'] = value
            tempdf['QUANTITY'] = animated.loc[:,[key]]
            tempdf['COUNTY'] = countys;
            masterFrame = masterFrame.append(tempdf,ignore_index=True)
        ##newdf = animated[]
        condition = np.isnan(masterFrame['QUANTITY'])
        masterFrame.loc[masterFrame['QUANTITY'].isnull(),'QUANTITY'] = 0.0

        masterFrame = masterFrame.dropna()
        masterFrame.to_csv("BarChartAndMapData.csv", encoding='utf-8', index=False,columns=['ZONE','COUNTY','TRAVEL OPTIONS BENEFIT','QUANTITY'])



def runConvertData(benefitsFile, zoneBenefitsFile,county_file):
    buildBarChartFile(benefits_file)
    animatedMapData(zoneBenefitsFile)
    barchartMap(zoneBenefitsFile,county_file)

if __name__ == "__main__":
    # set argument inputs
    benefits_file = sys.argv[1]
    zone_benefits_file = sys.argv[2]
    county_file = sys.argv[3]
    runConvertData(benefits_file,zone_benefits_file,county_file)