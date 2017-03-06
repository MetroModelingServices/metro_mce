
#Export links results to CSV
#Ben Stabler, ben.stabler@rsginc.com, 07/19/16
#Arguments: emme_project scenario link_file_name
#SET EMMEPY="C:\Program Files\INRO\Emme\Emme 4\Emme-4.2.5\Python27\python.exe"
#Example export: %EMMEPY% ExportLinkResultsToCSV.py myproj.emp 4782 c:/projects/linksPM2.csv
######################################################################

#load libraries
import inro.modeller as m
import inro.emme.desktop.app as d
import sys, os.path, os

#run command line version
if __name__ == "__main__":

    #start EMME desktop and attach a modeller session
    empFile = sys.argv[1]
    scenarioNum = sys.argv[2]
    fileName = sys.argv[3]
    desktop = d.start_dedicated(False, "bts", empFile)
    m = m.Modeller(desktop)
    
    #get network
    network = m.emmebank.scenario(scenarioNum).get_network()
    links = network.links()
    linkAttributes = network.attributes("LINK")
    
    #remove link shaping points attribute
    linkAttributes.remove("vertices")
    
    outFile = file(fileName, "w")
    outFile.write("i,j," + ",".join(linkAttributes) + "\n")
    for aLink in links:
      values = str(aLink.i_node.number) + "," + str(aLink.j_node.number)
      for aAttr in linkAttributes:
        values = values + "," + str(aLink[aAttr])
      outFile.write(values + "\n")
    print("links for scenario " + scenarioNum + " -> " + fileName)
