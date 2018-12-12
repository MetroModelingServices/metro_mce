# Create MCE Visualization Dashboard Scenario Comparison Input Tables
# Mike Dailey, Ben Stabler, RSG, 02/02/18
# python create_mce_visual_scen_comp_inputs.py benefits_a benefits_b cost_a cost_b years_of_benefit New_Scenario_Name
# python create_mce_visual_scen_comp_inputs.py I205\BarChartData.csv DivisionBRT\BarChartData.csv 260000000 160000000 10 Scenarios
# Run from the VIZ tool Portland data folder
# Outputs BarChartData.csv, Scatter.csv

import pandas as pd
import sys
import numpy as np

if __name__ == "__main__":
    
    # set argument inputs
    benefits_a_file = sys.argv[1]
    benefits_b_file = sys.argv[2]
    cost_a = int(sys.argv[3])
    cost_b = int(sys.argv[4])
    years_of_benefit = int(sys.argv[5])
    dataset_name = sys.argv[6]
    
    #read benefit data
    scen_a = benefits_a_file.replace("\\BarChartData.csv","")
    scen_b = benefits_b_file.replace("\\BarChartData.csv","")
    benefits_a = pd.read_csv(benefits_a_file)
    benefits_a["SCENARIO"] = scen_a
    benefits_b = pd.read_csv(benefits_b_file)
    benefits_b["SCENARIO"] = scen_b
    benefits = benefits_a.append(benefits_b)
    
    #transform and put in order for display
    benefits = benefits[["BENEFIT","SCENARIO","VALUE","CHART","BENEFIT GROUP"]]
    benefits["CHART"] = benefits["CHART"] + "-" + benefits["BENEFIT GROUP"]
    benefits = benefits.drop(["BENEFIT GROUP"], axis=1)
    
    benefits_out = benefits[benefits["CHART"] == "Benefits-everybody"]
    benefits_out = benefits_out.append(benefits[benefits["CHART"] == "BenefitsPerHousehold-everybody"])
    
    benefits_out = benefits_out.append(benefits[benefits["CHART"] == "Benefits-minority"])
    benefits_out = benefits_out.append(benefits[benefits["CHART"] == "Benefits-low english proficiency"])
    benefits_out = benefits_out.append(benefits[benefits["CHART"] == "Benefits-children and seniors"])
    benefits_out = benefits_out.append(benefits[benefits["CHART"] == "Benefits-low income"])
    
    benefits_out = benefits_out.append(benefits[benefits["CHART"] == "BenefitsPerHousehold-minority"])
    benefits_out = benefits_out.append(benefits[benefits["CHART"] == "BenefitsPerHousehold-low english proficiency"])
    benefits_out = benefits_out.append(benefits[benefits["CHART"] == "BenefitsPerHousehold-children and seniors"])
    benefits_out = benefits_out.append(benefits[benefits["CHART"] == "BenefitsPerHousehold-low income"])
    
    benefits_out.to_csv(dataset_name + "\BarChartData.csv", encoding='utf-8', index=False)

    #create scatter data
    scen_a = benefits_a_file.replace("\\BarChartData.csv","")
    scen_b = benefits_b_file.replace("\\BarChartData.csv","")
    ben_a = benefits_a[np.logical_and(benefits_a["BENEFIT GROUP"]=="everybody",benefits_a["CHART"]=="Benefits")]["VALUE"].sum()
    ben_b = benefits_b[np.logical_and(benefits_b["BENEFIT GROUP"]=="everybody",benefits_b["CHART"]=="Benefits")]["VALUE"].sum()
    scatter = pd.DataFrame({"Label":[scen_a, scen_b], 
                            "Cost (Initial)":[cost_a, cost_b], 
                            "Benefit (" + str(years_of_benefit) + " years)":[int(ben_a * years_of_benefit), int(ben_b * years_of_benefit)], 
                            "Size":[(ben_a * years_of_benefit)/cost_a, (ben_b * years_of_benefit)/cost_b]})
    scatter = scatter[["Label","Cost (Initial)","Benefit (" + str(years_of_benefit) + " years)","Size"]]
    scatter.to_csv(dataset_name + "\Scatter.csv", encoding='utf-8', index=False)
