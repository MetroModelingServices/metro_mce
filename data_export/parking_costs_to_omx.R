#Convert Metro demand model parking costs to OMX
#Ben Stabler, ben.stabler@rsginc.com, 12/12/16
#Requires R OMX code - https://github.com/osPlanning/omx/tree/dev/api/r
#Which requires rhdf5 package from bioconductor

#Settings
folder = "C:\\Users\\ben.stabler\\Desktop\\"
omxFileName = "parking_cost.omx"
parkingCostFile = "parking_costs.csv" #parking cost by taz, columns stpkg, ltpkg required

#Create OMX matrix
setwd(folder)
source("omx.r") #Requires rhdf5 package from bioconductor
parkingCosts = read.csv(parkingCostFile)
numZones = nrow(parkingCosts)
createFileOMX(omxFileName, numZones, numZones, 7)
writeMatrixOMX(omxFileName, matrix(parkingCosts$stpkg,numZones,numZones, TRUE), "stpkg")
writeMatrixOMX(omxFileName, matrix(parkingCosts$ltpkg,numZones,numZones, TRUE), "ltpkg")
