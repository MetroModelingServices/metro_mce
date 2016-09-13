
#Prepare network for MCE reliability
#Codes interchange ramp as node data3
#Codes freeway ramp upstream and downstream distance in link data2 and data3
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

    #get scenario network
    net = m.emmebank.scenario(scenarioNum).get_network()
    
    #code freeway interchange nodes in ui3
    freeway_vdf = 1
    nodes = net.regular_nodes()
    for node in nodes:
      in_vdfs = map(lambda x: x.volume_delay_func, node.incoming_links())
      out_vdfs = map(lambda x: x.volume_delay_func, node.outgoing_links())
      node.data3 = 0
      
      if len(in_vdfs) > 1 and ((freeway_vdf in in_vdfs) or (freeway_vdf in out_vdfs)):
        print("interchange node: " + str(node.id))
        node.data3 = 1
    
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
        if r_node.data3 == 1 and cost_to_node < upstream_distance:
          upstream_distance = cost_to_node
       
      print("upstream dist freeway link: " + str(link.i_node) + " " + str(link.j_node) + " " + str(upstream_distance))
      link.data2 = upstream_distance

    #loop through freeway links nodes and code downsteam distance to interchange
    for link in f_links:
      link.data3 = 999999
    for link in f_links:
      
      #run shortest path based on distance from all interchanges
      if link.i_node.data3 == 1:
        sp_tree = net.shortest_path_tree(link.i_node, "length")
        r_links = sp_tree.reachable_links()
    
        #loop over reachable links to set distance if better
        for r_link in r_links:
          if r_link in f_links:
            
            #set distance at destination 
            cost_to_node = sp_tree.cost_to_node(r_link.j_node.id)
            if cost_to_node < r_link.data3:
              print("downstream dist freeway link: " + str(r_link.i_node) + " " + str(r_link.j_node) + " " + str(cost_to_node))
              r_link.data3 = cost_to_node

    #publish network
    m.emmebank.scenario(scenarioNum).publish_network(net)
    