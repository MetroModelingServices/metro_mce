#Convert Metro demand model matrices to OMX
#Ben Stabler, ben.stabler@rsginc.com, 12/12/16
#Requires R OMX code - https://github.com/osPlanning/omx/tree/dev/api/r
#Which requires rhdf5 package from bioconductor

#Settings
folder = "M:\\plan\\trms\\projects\\LCP\\Phase1\\reliability\\2040NB_emmebank\\iter13\\model\\"
omxFileName = "Base_mode_choice_pa_part1.omx"
matNames = c("mf.hwda.lowinc.dat",
             "mf.hwda.medinc.dat",
             "mf.hwda.highinc.dat",
             "mf.hwprtr.highinc.dat",
             "mf.hwprtr.medinc.dat",
             "mf.hwprtr.lowinc.dat",
             "mf.hwdp.highinc.dat",
             "mf.hwdp.medinc.dat",
             "mf.hwdp.lowinc.dat",
             "mf.hwbike.highinc.dat",
             "mf.hwbike.medinc.dat",
             "mf.hwbike.lowinc.dat",
             "mf.hwwalk.highinc.dat",
             "mf.hwwalk.medinc.dat",
             "mf.hwwalk.lowinc.dat",
             "mf.hwtr.highinc.dat",
             "mf.hwtr.medinc.dat",
             "mf.hwtr.lowinc.dat",
             "mf.hwpa.highinc.dat",
             "mf.hwpa.medinc.dat",
             "mf.hwpa.lowinc.dat",
             "mf.nhnwwalk.highinc.dat",
             "mf.nhnwwalk.medinc.dat",
             "mf.nhnwwalk.lowinc.dat",
             "mf.nhwwalk.highinc.dat",
             "mf.nhwwalk.medinc.dat",
             "mf.nhwwalk.lowinc.dat",
             "mf.nhnwbike.highinc.dat",
             "mf.nhnwbike.medinc.dat",
             "mf.nhnwbike.lowinc.dat",
             "mf.nhwbike.highinc.dat",
             "mf.nhwbike.medinc.dat",
             "mf.nhwbike.lowinc.dat",
             "mf.nhnwtr.highinc.dat",
             "mf.nhnwtr.medinc.dat",
             "mf.nhnwtr.lowinc.dat",
             "mf.nhwtr.highinc.dat",
             "mf.nhwtr.medinc.dat",
             "mf.nhwtr.lowinc.dat",
             "mf.nhnwpa.highinc.dat",
             "mf.nhnwpa.medinc.dat",
             "mf.nhnwpa.lowinc.dat",
             "mf.nhwpa.highinc.dat",
             "mf.nhwpa.medinc.dat",
             "mf.nhwpa.lowinc.dat",
             "mf.nhnwdp.highinc.dat",
             "mf.nhnwdp.medinc.dat",
             "mf.nhnwdp.lowinc.dat",
             "mf.nhwdp.highinc.dat",
             "mf.nhwdp.medinc.dat",
             "mf.nhwdp.lowinc.dat",
             "mf.nhnwda.highinc.dat",
             "mf.nhnwda.medinc.dat",
             "mf.nhnwda.lowinc.dat",
             "mf.nhwda.highinc.dat",
             "mf.nhwda.medinc.dat",
             "mf.nhwda.lowinc.dat",
             "mf.hoprtr.highinc.dat",
             "mf.hoprtr.medinc.dat",
             "mf.hoprtr.lowinc.dat"
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
