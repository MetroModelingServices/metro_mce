#Convert Metro demand model matrices to OMX
#Ben Stabler, ben.stabler@rsginc.com, 12/12/16
#Requires R OMX code - https://github.com/osPlanning/omx/tree/dev/api/r
#Which requires rhdf5 package from bioconductor

#Settings
#folder = "M:\\plan\\trms\\projects\\LCP\\Phase1\\reliability\\2040_FGBRT_new\\iter18\\model\\"
folder = "V:\\tbm\\kate\\_LCPtests\\updated\\2040_FC\\iter0_markets\\model\\"
omxFileName = "Kate_base_mode_choice_pa_nhw.omx"
matNames = c("mf.nhwwalk.cv23.m.pk.dat",
             "mf.nhwwalk.cv23.m.op.dat",
             "mf.nhwwalk.cv23.l.pk.dat",
             "mf.nhwwalk.cv23.l.op.dat",
             "mf.nhwwalk.cv23.h.pk.dat",
             "mf.nhwwalk.cv23.h.op.dat",
             "mf.nhwwalk.cv1.m.pk.dat",
             "mf.nhwwalk.cv1.m.op.dat",
             "mf.nhwwalk.cv1.l.pk.dat",
             "mf.nhwwalk.cv1.l.op.dat",
             "mf.nhwwalk.cv1.h.pk.dat",
             "mf.nhwwalk.cv1.h.op.dat",
             "mf.nhwwalk.cv0.m.pk.dat",
             "mf.nhwwalk.cv0.m.op.dat",
             "mf.nhwwalk.cv0.l.pk.dat",
             "mf.nhwwalk.cv0.l.op.dat",
             "mf.nhwwalk.cv0.h.pk.dat",
             "mf.nhwwalk.cv0.h.op.dat",
             "mf.nhwtr.cv23.m.pk.dat",
             "mf.nhwtr.cv23.m.op.dat",
             "mf.nhwtr.cv23.l.pk.dat",
             "mf.nhwtr.cv23.l.op.dat",
             "mf.nhwtr.cv23.h.pk.dat",
             "mf.nhwtr.cv23.h.op.dat",
             "mf.nhwtr.cv1.m.pk.dat",
             "mf.nhwtr.cv1.m.op.dat",
             "mf.nhwtr.cv1.l.pk.dat",
             "mf.nhwtr.cv1.l.op.dat",
             "mf.nhwtr.cv1.h.pk.dat",
             "mf.nhwtr.cv1.h.op.dat",
             "mf.nhwtr.cv0.m.pk.dat",
             "mf.nhwtr.cv0.m.op.dat",
             "mf.nhwtr.cv0.l.pk.dat",
             "mf.nhwtr.cv0.l.op.dat",
             "mf.nhwtr.cv0.h.pk.dat",
             "mf.nhwtr.cv0.h.op.dat",
             "mf.nhwpa.cv23.m.pk.dat",
             "mf.nhwpa.cv23.m.op.dat",
             "mf.nhwpa.cv23.l.pk.dat",
             "mf.nhwpa.cv23.l.op.dat",
             "mf.nhwpa.cv23.h.pk.dat",
             "mf.nhwpa.cv23.h.op.dat",
             "mf.nhwpa.cv1.m.pk.dat",
             "mf.nhwpa.cv1.m.op.dat",
             "mf.nhwpa.cv1.l.pk.dat",
             "mf.nhwpa.cv1.l.op.dat",
             "mf.nhwpa.cv1.h.pk.dat",
             "mf.nhwpa.cv1.h.op.dat",
             "mf.nhwpa.cv0.m.pk.dat",
             "mf.nhwpa.cv0.m.op.dat",
             "mf.nhwpa.cv0.l.pk.dat",
             "mf.nhwpa.cv0.l.op.dat",
             "mf.nhwpa.cv0.h.pk.dat",
             "mf.nhwpa.cv0.h.op.dat",
             "mf.nhwdp.cv23.m.pk.dat",
             "mf.nhwdp.cv23.m.op.dat",
             "mf.nhwdp.cv23.l.pk.dat",
             "mf.nhwdp.cv23.l.op.dat",
             "mf.nhwdp.cv23.h.pk.dat",
             "mf.nhwdp.cv23.h.op.dat",
             "mf.nhwdp.cv1.m.pk.dat",
             "mf.nhwdp.cv1.m.op.dat",
             "mf.nhwdp.cv1.l.pk.dat",
             "mf.nhwdp.cv1.l.op.dat",
             "mf.nhwdp.cv1.h.pk.dat",
             "mf.nhwdp.cv1.h.op.dat",
             "mf.nhwdp.cv0.m.pk.dat",
             "mf.nhwdp.cv0.m.op.dat",
             "mf.nhwdp.cv0.l.pk.dat",
             "mf.nhwdp.cv0.l.op.dat",
             "mf.nhwdp.cv0.h.pk.dat",
             "mf.nhwdp.cv0.h.op.dat",
             "mf.nhwda.cv23.m.pk.dat",
             "mf.nhwda.cv23.m.op.dat",
             "mf.nhwda.cv23.l.pk.dat",
             "mf.nhwda.cv23.l.op.dat",
             "mf.nhwda.cv23.h.pk.dat",
             "mf.nhwda.cv23.h.op.dat",
             "mf.nhwda.cv1.m.pk.dat",
             "mf.nhwda.cv1.m.op.dat",
             "mf.nhwda.cv1.l.pk.dat",
             "mf.nhwda.cv1.l.op.dat",
             "mf.nhwda.cv1.h.pk.dat",
             "mf.nhwda.cv1.h.op.dat",
             "mf.nhwda.cv0.m.pk.dat",
             "mf.nhwda.cv0.m.op.dat",
             "mf.nhwda.cv0.l.pk.dat",
             "mf.nhwda.cv0.l.op.dat",
             "mf.nhwda.cv0.h.pk.dat",
             "mf.nhwda.cv0.h.op.dat",
             "mf.nhwbike.cv23.m.pk.dat",
             "mf.nhwbike.cv23.m.op.dat",
             "mf.nhwbike.cv23.l.pk.dat",
             "mf.nhwbike.cv23.l.op.dat",
             "mf.nhwbike.cv23.h.pk.dat",
             "mf.nhwbike.cv23.h.op.dat",
             "mf.nhwbike.cv1.m.pk.dat",
             "mf.nhwbike.cv1.m.op.dat",
             "mf.nhwbike.cv1.l.pk.dat",
             "mf.nhwbike.cv1.l.op.dat",
             "mf.nhwbike.cv1.h.pk.dat",
             "mf.nhwbike.cv1.h.op.dat",
             "mf.nhwbike.cv0.m.pk.dat",
             "mf.nhwbike.cv0.m.op.dat",
             "mf.nhwbike.cv0.l.pk.dat",
             "mf.nhwbike.cv0.l.op.dat",
             "mf.nhwbike.cv0.h.pk.dat",
             "mf.nhwbike.cv0.h.op.dat"        
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