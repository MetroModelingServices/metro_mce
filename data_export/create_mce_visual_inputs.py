# Create MCE Visualization Dashboard Input Tables
# Mike Dailey, Ben Stabler, RSG, 02/02/18
# python create_mce_visual_inputs.py benefits_file zone_benefits_file counties_and_cocs_file od_districts_benefits_file ithim_file zoneFile ABMViz_Region.json_File_Local_Location New_Scenario_Name
# python create_mce_visual_inputs.py final_aggregate_results_viz.csv final_aggregate_zone_summary.csv cocs.csv final_aggregate_od_district_summary.csv dalys.csv final_zone_demographics.csv C:\SVN\ABMVIZ\data\portland\region.json I205test
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
    
    ithim_benefit = pd.read_csv(ithim_file)['dollars'][0]
    ithim_rec = pd.DataFrame({"BENEFIT":"active transportation", "BENEFIT GROUP":"everybody", "VALUE":ithim_benefit, "CHART":"Benefits"}, index=[0])
    ithim_rec = ithim_rec[["BENEFIT","BENEFIT GROUP","VALUE","CHART"]]
    
    with open(fileName,'r') as sourcefile:
        benefits = pd.read_csv(sourcefile)
        benefits.pop('Processor')
        benefits.pop('Description')
        df = pd.melt(benefits, id_vars=["Target"],value_name="VALUE", var_name="BENEFIT GROUP")
        df.columns.values[0] = 'BENEFIT'
        df["CHART"] = "Benefits"
        df["VALUE"] = df["VALUE"].fillna(0)
        df = df.append(ithim_rec)
        df.to_csv(directory+datasetname+"\BarChartData.csv", encoding='utf-8', index=False)

def animatedMapData(fileName,regionfileloc,datasetname):
    directory = regionfileloc.replace('region.json', '')

    with open(fileName, 'r') as sourcefile:
        animated = pd.read_csv(sourcefile)
        animated = animated[animated['ZONE'] < 2148] #internal zones only
        animated['ALLPURPOSES'] = animated['travel_options_benefit'] 
        animated['MANDATORY'] = animated['access_benefit_hbw'] + animated['access_benefit_sch'] + animated['access_benefit_hbc']
        animated['OTHER'] = animated['access_benefit_hbs'] + animated['access_benefit_hbr'] + animated['access_benefit_hbo'] + animated['access_benefit_nhbw'] + animated['access_benefit_nhbnw']
        tempdf = pd.DataFrame(columns=['ZONE','PER','TRAVEL OPTIONS BENEFIT'])
        animated = animated.fillna(0)
        animated = animated.loc[~(animated == 0).all(axis=1)]

        masterFrame =pd.DataFrame(columns=['ZONE','PER','TRAVEL OPTIONS BENEFIT'])
        for key in ['ALLPURPOSES','MANDATORY','OTHER']:
            tempdf['ZONE'] = range(1,len(animated))
            tempdf['PER'] = key
            tempdf['TRAVEL OPTIONS BENEFIT'] = animated.loc[:,[key]]
            masterFrame = masterFrame.append(tempdf,ignore_index=True)
        masterFrame = masterFrame.fillna(0)
        masterFrame.to_csv(directory+datasetname+"\\3DAnimatedMapData.csv", encoding='utf-8', index=False)

def barchartMap(fileName,countyFile,zoneFile,regionfileloc,datasetname):
    directory = regionfileloc.replace('region.json', '')
    countys = []
    with open (countyFile,'r') as cntyFile:
        getcntys = pd.read_csv(cntyFile, usecols=['County'])
        countys = getcntys.dropna()
    totaldf = pd.DataFrame(['Total'],[countys.shape[0]],columns=['County'])
    countys = countys.append(totaldf)

    zone_demo = pd.read_csv(zoneFile)
    zone_demo["households"]  ## NEED TO CREATE FOR EACH COC
    
    with open(fileName, 'r') as sourcefile:
        animated = pd.read_csv(sourcefile)
        animated = animated[animated['ZONE'] < 2148] #internal zones only
        animated['ALLPURPOSES'] = animated['travel_options_benefit'] 
        animated['MANDATORY'] = animated['access_benefit_hbw'] + animated['access_benefit_sch'] + animated['access_benefit_hbc']
        animated['OTHER'] = animated['access_benefit_hbs'] + animated['access_benefit_hbr'] + animated['access_benefit_hbo'] + animated['access_benefit_nhbw'] + animated['access_benefit_nhbnw']
        animated['HOUSEHOLDS'] = zone_demo["households"]

        tempdf = pd.DataFrame(columns=['ZONE','QUANTITY','TRAVEL OPTIONS BENEFIT','COUNTY'])
        masterFrame =pd.DataFrame(columns=['ZONE','COUNTY','TRAVEL OPTIONS BENEFIT','QUANTITY'])
        for key in ['ALLPURPOSES','MANDATORY','OTHER','HOUSEHOLDS']:
            tempdf['ZONE'] = range(1,len(animated))
            tempdf['TRAVEL OPTIONS BENEFIT'] = key
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
    
def runConvertData(benefitsFile,zoneBenefitsFile,county_file,od_districts_benefits_file,ithim_file,zoneFile,regionfileloc,datasetname):
    buildBarChartFile(benefits_file,ithim_file,regionfileloc,datasetname)
    animatedMapData(zoneBenefitsFile,regionfileloc,datasetname)
    barchartMap(zoneBenefitsFile,county_file,zoneFile,regionfileloc,datasetname)
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
    zoneFile = sys.argv[6]
    regionfileloc = sys.argv[7]
    datasetname = sys.argv[8]
    editRegionFile(regionfileloc,datasetname,county_file)
    runConvertData(benefits_file,zone_benefits_file,county_file,od_districts_benefits_file,ithim_file,zoneFile,regionfileloc,datasetname)