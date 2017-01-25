#Convert Metro demand model matrices to OMX
#Ben Stabler, ben.stabler@rsginc.com, 12/12/16
#Requires R OMX code - https://github.com/osPlanning/omx/tree/dev/api/r
#Which requires rhdf5 package from bioconductor

#Settings
folder = "M:\\plan\\trms\\projects\\LCP\\Phase1\\reliability\\2040NB_emmebank\\iter13\\model\\"
omxFileName = "Base_mode_choice_pa_part2.omx"
matNames = c("mf.hodp.highinc.dat",
             "mf.hodp.medinc.dat",
             "mf.hodp.lowinc.dat",
             "mf.hoda.highinc.dat",
             "mf.hoda.medinc.dat",
             "mf.hoda.lowinc.dat",
             "mf.howalk.highinc.dat",
             "mf.howalk.medinc.dat",
             "mf.howalk.lowinc.dat",
             "mf.hobike.highinc.dat",
             "mf.hobike.medinc.dat",
             "mf.hobike.lowinc.dat",
             "mf.hotr.highinc.dat",
             "mf.hotr.medinc.dat",
             "mf.hotr.lowinc.dat",
             "mf.hopa.highinc.dat",
             "mf.hopa.medinc.dat",
             "mf.hopa.lowinc.dat",
             "mf.hrprtr.highinc.dat",
             "mf.hrprtr.medinc.dat",
             "mf.hrprtr.lowinc.dat",
             "mf.hrdp.highinc.dat",
             "mf.hrdp.medinc.dat",
             "mf.hrdp.lowinc.dat",
             "mf.hrda.highinc.dat",
             "mf.hrda.medinc.dat",
             "mf.hrda.lowinc.dat",
             "mf.hrwalk.highinc.dat",
             "mf.hrwalk.medinc.dat",
             "mf.hrwalk.lowinc.dat",
             "mf.hrbike.highinc.dat",
             "mf.hrbike.medinc.dat",
             "mf.hrbike.lowinc.dat",
             "mf.hsprtr.highinc.dat",
             "mf.hsprtr.medinc.dat",
             "mf.hsprtr.lowinc.dat",
             "mf.hsdp.highinc.dat",
             "mf.hsdp.medinc.dat",
             "mf.hsdp.lowinc.dat",
             "mf.hrtr.highinc.dat",
             "mf.hrtr.medinc.dat",
             "mf.hrtr.lowinc.dat",
             "mf.hrpa.highinc.dat",
             "mf.hrpa.medinc.dat",
             "mf.hrpa.lowinc.dat",
             "mf.hsda.highinc.dat",
             "mf.hsda.medinc.dat",
             "mf.hsda.lowinc.dat",
             "mf.hswalk.highinc.dat",
             "mf.hswalk.medinc.dat",
             "mf.hswalk.lowinc.dat",
             "mf.hsbike.highinc.dat",
             "mf.hsbike.medinc.dat",
             "mf.hsbike.lowinc.dat",
             "mf.hstr.highinc.dat",
             "mf.hstr.medinc.dat",
             "mf.hstr.lowinc.dat",
             "mf.hspa.highinc.dat",
             "mf.hspa.medinc.dat",
             "mf.hspa.lowinc.dat"    
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
