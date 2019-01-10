# Create MCE Visualization Dashboard Input Tables
# Mike Dailey, Ben Stabler, RSG, 02/02/18
# python create_mce_visual_inputs.py benefits_file zone_benefits_file counties_and_cocs_file od_districts_benefits_file ithim_file zoneFile ABMViz_Region.json_File_Local_Location New_Scenario_Name
# python create_mce_visual_inputs.py final_aggregate_results.csv final_aggregate_zone_summary.csv cocs.csv final_aggregate_od_district_summary.csv dalys.csv final_zone_demographics.csv C:\projects\development\ActivityViz\data\portland\region.json I205test
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
    
    #benefits
    benefits = pd.read_csv(fileName)
    benefitsToKeep = ["hhs_for_the_coc","travel_options_benefit","veh_ownership_cost_benefit","travel_time_reliability_benefit","travel_time_benefit","veh_operating_cost_benefit","emissions_cost_benefit","noise_pollution_cost_benefit","surface_water_pollution_cost_benefit","safety_cost_benefit"]
    benefits = benefits.drop(['Processor','Description','coc_lowinc','coc_medinc','coc_highinc','coc_veryhighinc'], axis=1)
    benefits.columns = ["Target","minority","low english proficiency","children and seniors","low income","everybody"]
    benefits = benefits[benefits["Target"].isin(benefitsToKeep)]
    benefits["Target"] = benefits["Target"].str.replace("_benefit", "")
    df = pd.melt(benefits, id_vars=["Target"],value_name="VALUE", var_name="BENEFIT GROUP")
    df.columns.values[0] = 'BENEFIT'
    df["CHART"] = "Benefits"
    df["VALUE"] = df["VALUE"].fillna(0)
    
    #ithim benefits
    ithim_benefit = pd.read_csv(ithim_file)['dollars'][0]
    ithim_rec = pd.DataFrame({"BENEFIT":"active_transportation", "BENEFIT GROUP":"everybody", "VALUE":ithim_benefit, "CHART":"Benefits"}, index=[0])
    ithim_rec_m = pd.DataFrame({"BENEFIT":"active_transportation", "BENEFIT GROUP":"minority", "VALUE":0, "CHART":"Benefits"}, index=[0])
    ithim_rec_l = pd.DataFrame({"BENEFIT":"active_transportation", "BENEFIT GROUP":"low english proficiency", "VALUE":0, "CHART":"Benefits"}, index=[0])
    ithim_rec_c = pd.DataFrame({"BENEFIT":"active_transportation", "BENEFIT GROUP":"children and seniors", "VALUE":0, "CHART":"Benefits"}, index=[0])
    ithim_rec_i = pd.DataFrame({"BENEFIT":"active_transportation", "BENEFIT GROUP":"low income", "VALUE":0, "CHART":"Benefits"}, index=[0])
    ithim_rec = ithim_rec.append(ithim_rec_m).append(ithim_rec_l).append(ithim_rec_c).append(ithim_rec_i)
    ithim_rec = ithim_rec[["BENEFIT","BENEFIT GROUP","VALUE","CHART"]]
    df = df.append(ithim_rec)
    
    #total households
    hh_count_recs = df[df["BENEFIT"] == "hhs_for_the_coc"]
    hh_count_recs = hh_count_recs.set_index("BENEFIT GROUP", drop=False)
    df = df[df["BENEFIT"] != "hhs_for_the_coc"]

    #benefits per hh
    df_per_hh = df.copy()
    df_per_hh["CHART"] = "Benefits Per Household"
    df_per_hh = df_per_hh.set_index("BENEFIT GROUP", drop=False)
    df_per_hh = df_per_hh.join(hh_count_recs["VALUE"], rsuffix="_HH")
    df_per_hh["VALUE"] = df_per_hh["VALUE"] / df_per_hh["VALUE_HH"]
    df_per_hh = df_per_hh[["BENEFIT","BENEFIT GROUP","VALUE","CHART"]]
    
    #write results
    df = df.append(df_per_hh)
    df = df.sort_values(["CHART","BENEFIT GROUP","BENEFIT"])
    df.to_csv(directory+datasetname+"\BarChartData.csv", encoding='utf-8', index=False)

def animatedMapData(fileName,zoneFile,regionfileloc,datasetname):
    directory = regionfileloc.replace('region.json', '')
    animated, outputFields = codeDataFields(zoneFile, fileName)
    
    tempdf = pd.DataFrame(columns=['ZONE','PER','TRAVEL OPTIONS BENEFIT'])
    animated = animated.fillna(0)
    animated = animated.loc[~(animated == 0).all(axis=1)]

    masterFrame =pd.DataFrame(columns=['ZONE','PER','TRAVEL OPTIONS BENEFIT'])
    for key in outputFields:
        tempdf['ZONE'] = range(1,len(animated))
        tempdf['PER'] = key
        tempdf['TRAVEL OPTIONS BENEFIT'] = animated.loc[:,[key]]
        masterFrame = masterFrame.append(tempdf,ignore_index=True)
    masterFrame = masterFrame.fillna(0)
    masterFrame.to_csv(directory+datasetname+"\\3DAnimatedMapData.csv", encoding='utf-8', index=False)

def barchartMap(fileName,countyFile,zoneFile,regionfileloc,datasetname):
    directory = regionfileloc.replace('region.json', '')
    countys = []
    getcntys = pd.read_csv(countyFile, usecols=['County'])
    countys = getcntys.dropna()
    totaldf = pd.DataFrame(['Total'],[countys.shape[0]],columns=['County'])
    countys = countys.append(totaldf)
    
    animated, outputFields = codeDataFields(zoneFile, fileName)

    tempdf = pd.DataFrame(columns=['ZONE','QUANTITY','TRAVEL OPTIONS BENEFIT','COUNTY'])
    masterFrame =pd.DataFrame(columns=['ZONE','COUNTY','TRAVEL OPTIONS BENEFIT','QUANTITY'])
    for key in outputFields:
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
    animatedMapData(zoneBenefitsFile,zoneFile,regionfileloc,datasetname)
    barchartMap(zoneBenefitsFile,county_file,zoneFile,regionfileloc,datasetname)
    chordData(od_districts_benefits_file,regionfileloc,datasetname)

def codeDataFields(zoneFile, fileName):
    
    zone_demo = pd.read_csv(zoneFile) #total households and percent of hhs by coc
    zone_demo = zone_demo[["households","coc_ext_minority","coc_ext_lowengpro","coc_ext_age18or65","coc_lowinc_ext"]]
    
    animated = pd.read_csv(fileName)
    animated = animated[animated['ZONE'] < 2148] #internal zones only
    
    #benefits 
    animated['all'] = animated['travel_options_benefit'] 
    animated['mandatory'] = animated['access_benefit_hbw'] + animated['access_benefit_sch'] + animated['access_benefit_hbc']
    animated['other'] = animated['access_benefit_hbs'] + animated['access_benefit_hbr'] + animated['access_benefit_hbo'] + animated['access_benefit_nhbw'] + animated['access_benefit_nhbnw']

    animated['all-minority'] = animated["all"] * zone_demo["coc_ext_minority"]
    animated['all-low eng prof'] = animated["all"] * zone_demo["coc_ext_lowengpro"]
    animated['all-child or senior'] = animated["all"] * zone_demo["coc_ext_age18or65"]
    animated['all-low income'] = animated["all"] * zone_demo["coc_lowinc_ext"]

    animated['mandatory-minority'] = animated["mandatory"] * zone_demo["coc_ext_minority"]
    animated['mandatory-low eng prof'] = animated["mandatory"] * zone_demo["coc_ext_lowengpro"]
    animated['mandatory-child or senior'] = animated["mandatory"] * zone_demo["coc_ext_age18or65"]
    animated['mandatory-low income'] = animated["mandatory"] * zone_demo["coc_lowinc_ext"]
    
    animated['other-minority'] = animated["other"] * zone_demo["coc_ext_minority"]
    animated['other-low eng prof'] = animated["other"] * zone_demo["coc_ext_lowengpro"]
    animated['other-child or senior'] = animated["other"] * zone_demo["coc_ext_age18or65"]
    animated['other-low income'] = animated["other"] * zone_demo["coc_lowinc_ext"]
    
    #total hhs
    #animated['HHs-all'] = zone_demo["households"]
    #animated['HHs-minority'] = zone_demo["households"] * zone_demo["coc_ext_minority"]
    #animated['HHs-low eng prof'] = zone_demo["households"] * zone_demo["coc_ext_lowengpro"]
    #animated['HHs-child or senior'] = zone_demo["households"] * zone_demo["coc_ext_age18or65"]
    #animated['HHs-low income'] = zone_demo["households"] * zone_demo["coc_lowinc_ext"]

    outputFields = animated.columns.values[pd.Series(animated.columns.values).str.contains('all-') + pd.Series(animated.columns.values).str.contains('mandatory-') + pd.Series(animated.columns.values).str.contains('other-')]
    
    return animated, outputFields


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
    runConvertData(benefits_file,zone_benefits_file,county_file,od_districts_benefits_file,ithim_file,zoneFile,regionfileloc,datasetname)