
#Prepare assigned network for MCE reliability skimming
#Ben Stabler, ben.stabler@rsginc.com, 09/06/16
#Arguments: emme_project scenario
#SET EMMEPY="C:\Program Files\INRO\Emme\Emme 4\Emme-4.2.5\Python27\python.exe"
#Example: %EMMEPY% mce_reliability_prep.py "C:\projects\metromce\benefits\reliability\Metro\Metro.emp" 4043
##############################################################################

#load libraries
import inro.modeller as m
import inro.emme.desktop.app as d
import sys, os.path, os

#run command line version
if __name__ == "__main__":

    #start EMME desktop 
    empFile = sys.argv[1]
    scenarioNum = sys.argv[2]
    desktop = d.start_dedicated(False, "bts", empFile)
    
    #open a database if needed and attach a modeller session
    if desktop.data_explorer().active_database() is None:
      desktop.data_explorer().databases()[0].open()
      print("open first project database: " + desktop.data_explorer().active_database().name())
    else:
      print("using active database: " + desktop.data_explorer().active_database().name())
    m = m.Modeller(desktop)

    #create reliability extra attributes
    extraAttrs = dict()
    extraAttrs["@intch"] = "NODE"   #interchange
    extraAttrs["@losc"] = "LINK"    #LOS C+
    extraAttrs["@losd"] = "LINK"    #LOS D+
    extraAttrs["@lose"] = "LINK"    #LOS E+
    extraAttrs["@losfl"] = "LINK"   #LOS F low +
    extraAttrs["@losfh"] = "LINK"   #LOS F high + 
    extraAttrs["@spd70"] = "LINK"   #speed 70
    extraAttrs["@updist"] = "LINK"  #upstream interchange distance
    extraAttrs["@dwdist"] = "LINK"  #downstream interchange distance  
    extraAttrs["@lanes2"] = "LINK"  #lanes = 2
    extraAttrs["@lanes3"] = "LINK"  #lanes = 3
    extraAttrs["@lanes4"] = "LINK"  #lanes = 4
    extraAttrs["@loscart"] = "LINK" #LOS C+ arterial
    extraAttrs["@losflart"] = "LINK"#LOS F low + arterial
    extraAttrs["@spd35"] = "LINK"   #speed 35
    extraAttrs["@spd40"] = "LINK"   #speed 40
    extraAttrs["@spd45"] = "LINK"   #speed 45
    extraAttrs["@spd50"] = "LINK"   #speed 50
    extraAttrs["@spd50p"] = "LINK"  #speed 50+
    extraAttrs["@signal"] = "LINK"  #signal
    extraAttrs["@stop"] = "LINK"    #stop 
    extraAttrs["@relvar"] = "LINK"  #reliability travel time variance
    for key, value in extraAttrs.iteritems():
      if m.emmebank.scenario(scenarioNum).extra_attribute(key) != None:
        m.emmebank.scenario(scenarioNum).delete_extra_attribute(key)
      m.emmebank.scenario(scenarioNum).create_extra_attribute(value,key)
      print("reliability link attribute " + key + " created")

    #get scenario network
    net = m.emmebank.scenario(scenarioNum).get_network()
    
    #code freeway interchange nodes
    freeway_vdf = 1
    nodes = net.regular_nodes()
    for node in nodes:
      in_vdfs = map(lambda x: x.volume_delay_func, node.incoming_links())
      out_vdfs = map(lambda x: x.volume_delay_func, node.outgoing_links())
      node["@intch"] = 0
      
      if len(in_vdfs) > 1 and ((freeway_vdf in in_vdfs) or (freeway_vdf in out_vdfs)):
        print("interchange node: " + str(node.id))
        node["@intch"] = 1
    
    #build list of freeway links for later calculations
    f_links = []
    for link in net.links():
      if link.volume_delay_func == freeway_vdf:
        f_links.append(link)
    
    #loop through freeway links nodes and code upstream distance to interchange
    for link in f_links:
      
      #run shortest path based on distance
      sp_tree = net.shortest_path_tree(link.i_node, "length")
      r_nodes = sp_tree.reachable_nodes()
      
      #loop over reachable nodes and if interchange set distance
      upstream_distance = 999999
      for r_node in r_nodes:
        cost_to_node = sp_tree.cost_to_node(r_node.id)
        if r_node["@intch"] == 1 and cost_to_node < upstream_distance:
          upstream_distance = cost_to_node
       
      print("upstream dist freeway link: " + str(link.i_node) + " " + str(link.j_node) + " " + str(upstream_distance))
      link["@updist"] = upstream_distance

    #loop through freeway links nodes and code downsteam distance to interchange
    for link in f_links:
      link["@dwdist"] = 999999
    for link in f_links:
      
      #run shortest path based on distance from all interchanges
      if link.i_node["@intch"] == 1:
        sp_tree = net.shortest_path_tree(link.i_node, "length")
        r_links = sp_tree.reachable_links()
    
        #loop over reachable links to set distance if better
        for r_link in r_links:
          if r_link in f_links:
            
            #set distance at destination 
            cost_to_node = sp_tree.cost_to_node(r_link.j_node.id)
            if cost_to_node < r_link["@dwdist"]:
              print("downstream dist freeway link: " + str(r_link.i_node) + " " + str(r_link.j_node) + " " + str(cost_to_node))
              r_link["@dwdist"] = cost_to_node
    
    #code variables and apply regression equations to calculate answer
    for link in net.links():
      
      if link.volume_delay_func == freeway_vdf: #freeway
        
        vc = link["auto_volume"] / link["@mb"]
        link["@losc"] = 1 if ( vc >= 0.7 ) else 0
        link["@losd"] = 1 if ( vc >= 0.8 ) else 0
        link["@lose"] = 1 if ( vc >= 0.9 ) else 0
        link["@losfl"] = 1 if ( vc >= 1.0 ) else 0
        link["@losfh"] = 1 if ( vc >= 1.1 ) else 0
        link["@spd70"] = 1 if ( link["@speed"] == 70 ) else 0
        link["@updist"] = 0.0001 if ( link["@updist"] == 0 ) else link["@updist"]
        link["@dwdist"] = 0.0001 if ( link["@dwdist"] == 0 ) else link["@dwdist"]
        
        link["@relvar"] = ( 0.10780 + 0.24290 * link["@losc"] + 0.17050 * link["@losd"] + -0.22780 * link["@lose"] + -0.19830 * link["@losfl"]  + 
          1.02200 * link["@losfh"] + 0.01393 * link["@spd70"] + 0.00110 * (1/link["@updist"]) + 0.00054 * (1/link["@dwdist"]) )
      
      elif link.volume_delay_func in [2,4,9]: #arterial
        
        vc = link["auto_volume"] / link["@mb"]
        link["@loscart"] = 1 if ( vc >= 0.7 ) else 0
        link["@losflart"] = 1 if ( vc >= 1.0 ) else 0
        link["@lanes2"] = 1 if ( link["num_lanes"] == 2 ) else 0
        link["@lanes3"] = 1 if ( link["num_lanes"] == 3 ) else 0
        link["@lanes4"] = 1 if ( link["num_lanes"] == 4 ) else 0
        link["@spd35"] = 1 if ( link["@speed"] == 35 ) else 0
        link["@spd40"] = 1 if ( link["@speed"] == 40 ) else 0
        link["@spd45"] = 1 if ( link["@speed"] == 45 ) else 0
        link["@spd50"] = 1 if ( link["@speed"] == 50 ) else 0
        link["@spd50p"] = 1 if ( link["@speed"] > 50 ) else 0
        link["@signal"] = 1 if ( link.j_node["@ctype"] == 3 ) else 0
        link["@stop"] = 1 if ( link.j_node["@ctype"] == 2 ) or ( link.j_node["@ctype"] == 4 ) else 0
    
        link["@relvar"] = ( 0.05466 + 0.15611 * link["@loscart"] + -0.14492 * link["@losflart"] + 0.01036 * link["@lanes2"] +  0.03612 * link["@lanes3"] + 
          0.04470 * link["@lanes4"] + 0.00757 * link["@spd35"] + 0.00910 * link["@spd40"] + 0.00810 * link["@spd45"] + -0.00229 * link["@spd50"] + 
          -0.00462 * link["@spd50p"] + 0.00310 * link["@signal"] + -0.00633 * link["@stop"] )

      #regression answer is unreliability as std dev per mile per mean travel time
      #so multiply by the link travel time and length and then square-it to get total unreliability variance for the whole link
      #then skim it since variance is additive and then take the sqrt(skim) at the end to get unreliability in units of travel time 
      link["@relvar"] = (link["@relvar"] * link["auto_time"] * link["length"])**2
    
    print("reliability link attribute @relvar calculated")
      
    #publish network
    m.emmebank.scenario(scenarioNum).publish_network(net)
    