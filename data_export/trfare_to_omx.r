#Convert Metro trfare matrix to OMX
#Ben Stabler, ben.stabler@rsginc.com, 12/12/16
#Requires R OMX code - https://github.com/osPlanning/omx/tree/dev/api/r
#Which requires rhdf5 package from bioconductor

#Settings
folder = "V:\\tbm\\kate\\_LCPtests\\updated\\2040_FC\\iter0_markets\\model\\"
matFileName = "mf.2040NB_trfares.dat"
omxFileName = "trfare.omx"

#Create OMX matrix
source("V:/tbm/kate/_LCPtests/updated/2040_FC/iter0_markets/model/omx.r") #Requires rhdf5 package from bioconductor
setwd(folder)
load(matFileName)
createFileOMX(omxFileName, nrow(mf.trfare), ncol(mf.trfare), 7)
writeMatrixOMX(omxFileName, mf.trfare, "trfare")

