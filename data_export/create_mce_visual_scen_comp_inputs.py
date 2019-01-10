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
    benefits_out = benefits_out.append(benefits[benefits["CHART"] == "Benefits Per Household-everybody"])
    
    benefits_out = benefits_out.append(benefits[benefits["CHART"] == "Benefits-minority"])
    benefits_out = benefits_out.append(benefits[benefits["CHART"] == "Benefits-low english proficiency"])
    benefits_out = benefits_out.append(benefits[benefits["CHART"] == "Benefits-children and seniors"])
    benefits_out = benefits_out.append(benefits[benefits["CHART"] == "Benefits-low income"])
    
    benefits_out = benefits_out.append(benefits[benefits["CHART"] == "Benefits Per Household-minority"])
    benefits_out = benefits_out.append(benefits[benefits["CHART"] == "Benefits Per Household-low english proficiency"])
    benefits_out = benefits_out.append(benefits[benefits["CHART"] == "Benefits Per Household-children and seniors"])
    benefits_out = benefits_out.append(benefits[benefits["CHART"] == "Benefits Per Household-low income"])
    
    #add benefits share of everyone for each COC
    benefits_m = benefits[benefits["CHART"] == "Benefits-minority"]
    benefits_m["CHART"] = "Benefits Share-minority"
    benefits_l = benefits[benefits["CHART"] == "Benefits-low english proficiency"]
    benefits_l["CHART"] = "Benefits Share-low english proficiency"
    benefits_c = benefits[benefits["CHART"] == "Benefits-children and seniors"]
    benefits_c["CHART"] = "Benefits Share-children and seniors"
    benefits_i = benefits[benefits["CHART"] == "Benefits-low income"]
    benefits_i["CHART"] = "Benefits Share-low income"
    benefits_out = benefits_out.append(benefits_m).append(benefits_l).append(benefits_c).append(benefits_i)
      
    benefits_m = benefits[benefits["CHART"] == "Benefits Per Household-minority"]
    benefits_m["CHART"] = "Benefits Per Household Share-minority"
    benefits_l = benefits[benefits["CHART"] == "Benefits Per Household-low english proficiency"]
    benefits_l["CHART"] = "Benefits Per Household Share-low english proficiency"
    benefits_c = benefits[benefits["CHART"] == "Benefits Per Household-children and seniors"]
    benefits_c["CHART"] = "Benefits Per Household Share-children and seniors"
    benefits_i = benefits[benefits["CHART"] == "Benefits Per Household-low income"]
    benefits_i["CHART"] = "Benefits Per Household Share-low income"
    benefits_out = benefits_out.append(benefits_m).append(benefits_l).append(benefits_c).append(benefits_i)

    benefits_out = benefits_out.reset_index()
    benefits_out = benefits_out.drop("index", axis=1)
    
    benefits_out["VALUE"].loc[benefits_out["CHART"] == "Benefits Share-minority"] = ((pd.Series(benefits_out["VALUE"][benefits_out["CHART"] == "Benefits Share-minority"].tolist()) / pd.Series(benefits_out["VALUE"][benefits_out["CHART"] == "Benefits-everybody"].tolist())) * 100 ).tolist()
    benefits_out["VALUE"].loc[benefits_out["CHART"] == "Benefits Share-low english proficiency"] = ((pd.Series(benefits_out["VALUE"][benefits_out["CHART"] == "Benefits Share-low english proficiency"].tolist()) / pd.Series(benefits_out["VALUE"][benefits_out["CHART"] == "Benefits-everybody"].tolist())) * 100 ).tolist()
    benefits_out["VALUE"].loc[benefits_out["CHART"] == "Benefits Share-children and seniors"] = ((pd.Series(benefits_out["VALUE"][benefits_out["CHART"] == "Benefits Share-children and seniors"].tolist()) / pd.Series(benefits_out["VALUE"][benefits_out["CHART"] == "Benefits-everybody"].tolist())) * 100 ).tolist()
    benefits_out["VALUE"].loc[benefits_out["CHART"] == "Benefits Share-low income"] = ((pd.Series(benefits_out["VALUE"][benefits_out["CHART"] == "Benefits Share-low income"].tolist()) / pd.Series(benefits_out["VALUE"][benefits_out["CHART"] == "Benefits-everybody"].tolist())) * 100 ).tolist()

    benefits_out["VALUE"].loc[benefits_out["CHART"] == "Benefits Per Household Share-minority"] = ((pd.Series(benefits_out["VALUE"][benefits_out["CHART"] == "Benefits Per Household Share-minority"].tolist()) / pd.Series(benefits_out["VALUE"][benefits_out["CHART"] == "Benefits Per Household-everybody"].tolist())) * 100 ).tolist()
    benefits_out["VALUE"].loc[benefits_out["CHART"] == "Benefits Per Household Share-low english proficiency"] = ((pd.Series(benefits_out["VALUE"][benefits_out["CHART"] == "Benefits Per Household Share-low english proficiency"].tolist()) / pd.Series(benefits_out["VALUE"][benefits_out["CHART"] == "Benefits Per Household-everybody"].tolist())) * 100 ).tolist()
    benefits_out["VALUE"].loc[benefits_out["CHART"] == "Benefits Per Household Share-children and seniors"] = ((pd.Series(benefits_out["VALUE"][benefits_out["CHART"] == "Benefits Per Household Share-children and seniors"].tolist()) / pd.Series(benefits_out["VALUE"][benefits_out["CHART"] == "Benefits Per Household-everybody"].tolist())) * 100 ).tolist()
    benefits_out["VALUE"].loc[benefits_out["CHART"] == "Benefits Per Household Share-low income"] = ((pd.Series(benefits_out["VALUE"][benefits_out["CHART"] == "Benefits Per Household Share-low income"].tolist()) / pd.Series(benefits_out["VALUE"][benefits_out["CHART"] == "Benefits Per Household-everybody"].tolist())) * 100 ).tolist()
    
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
