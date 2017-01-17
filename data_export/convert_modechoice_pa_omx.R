#Convert Metro demand model matrices to OMX
#Ben Stabler, ben.stabler@rsginc.com, 12/12/16
#Requires R OMX code - https://github.com/osPlanning/omx/tree/dev/api/r
#Which requires rhdf5 package from bioconductor

#Settings
folder = "C:\\Users\\ben.stabler\\Desktop\\"
omxFileName = "mode_choice_pa.omx"
matNames = c("mf.hwda.lowinc.dat",
             "mf.hwda.medinc.dat",
             "mf.hwda.highinc.dat"
             )
numZones = 2162

#Create OMX matrix
setwd(folder)
source("omx.r") #Requires rhdf5 package from bioconductor
createFileOMX(omxFileName, numZones, numZones, 7)

for(m in matNames) {
  load(m)
  outName = gsub(".dat","",m)
  writeMatrixOMX(omxFileName, get(outName), outName)
}
