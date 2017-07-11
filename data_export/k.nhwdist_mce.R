#k.nhwdist.R 

east2westhill<-as.matrix(array(0,c(numzones,numzones)))
east2westhill[ensemble.gw==2,ensemble.gw==1]<-1

westhill2east<-as.matrix(array(0,c(numzones,numzones)))
westhill2east[ensemble.gw==1,ensemble.gw==2]<-1

east2westriv<-as.matrix(array(0,c(numzones,numzones)))
east2westriv[ensemble.gr==2,ensemble.gr==1]<-1

westriv2east<-as.matrix(array(0,c(numzones,numzones)))
westriv2east[ensemble.gr==1,ensemble.gr==2]<-1

# NHW Total Productions
ms.nhwpr <- sum(ma.nhwpr)

# NHW Production Utility (coefficients from separate workplace location model)
ma.nhwpu <- exp(log(NHW.aerProdCoeff * ma.aer + NHW.amfProdCoeff * ma.amf + NHW.conProdCoeff * ma.con + NHW.eduProdCoeff * ma.edu + NHW.fsdProdCoeff * ma.fsd
                  + NHW.govProdCoeff * ma.gov + NHW.hssProdCoeff * ma.hss + NHW.mfgProdCoeff * ma.mfg + NHW.mhtProdCoeff * ma.mht + NHW.osvProdCoeff * ma.osv
                  + NHW.pbsProdCoeff * ma.pbs + NHW.rcsProdCoeff * ma.rcs + NHW.twuProdCoeff * ma.twu + NHW.wtProdCoeff * ma.wt
                  + NHW.hhProdCoeff * ma.hh + 1))

ma.nhwpu[ma.nhwpu==1] <- 0

# NHW Production Utility Summary
ms.nhws <- sum(ma.nhwpu)

# NHW Productions (allocate trips produced by households to workplace locations)
ma.nhwpu <- (ma.nhwpu/ms.nhws)*(ms.nhwpr)
write.table(ma.nhwpu, sep=",", row.names=F, file="../_mceInputs/ma.nhwpu.csv", col.names=c("nhwpu"))

# NHW Distribution Utility
mf.util <- exp(sweep(NHW.lsCoeff * mf.nhwls
                   + NHW.logdistXorwaCoeff * mf.orwa * log (mf.tdist + 1)
                   + NHW.logdistXwaorCoeff * mf.waor * log (mf.tdist + 1)
                   + NHW.logdistXnoXingCoeff * ((mf.orwa + mf.waor)==0) * log (mf.tdist + 1)
                   + NHW.logdistXewWestHillsCoeff * east2westhill * log (mf.tdist + 1)
                   + NHW.logdistXweWestHillsCoeff * westhill2east * log (mf.tdist + 1)
                   + NHW.logdistXewWillRiverCoeff * east2westriv * log (mf.tdist + 1)
                   + NHW.logdistXweWillRiverCoeff * westriv2east * log (mf.tdist + 1)
                   , 2, log (NHW.aerCoeff * ma.aer
                   + NHW.amfCoeff * ma.amf + NHW.conCoeff * ma.con
                   + NHW.eduCoeff * ma.edu + NHW.fsdCoeff * ma.fsd
                   + NHW.govCoeff * ma.gov + NHW.hssCoeff * ma.hss
                   + NHW.mfgCoeff * ma.mfg + NHW.mhtCoeff * ma.mht
                   + NHW.osvCoeff * ma.osv + NHW.pbsCoeff * ma.pbs
                   + NHW.rcsCoeff * ma.rcs + NHW.twuCoeff * ma.twu
                   + NHW.wtCoeff * ma.wt + NHW.hhCoeff * ma.hh + 1), "+"))

mf.util[mf.nhwls[,]==0] <- 0

# NHW Distribution Utility Summary
ma.utsum <- apply(mf.util, 1, sum)
ma.nhbwdcls <- log(ma.utsum)
save (ma.nhbwdcls, file="ma.nhbwdcls.dat")
if (file.access("../_mceInputs", mode=0) < 0) { dir.create("../_mceInputs") }
write.table(ma.nhbwdcls, sep=",", row.names=F, file="../_mceInputs/ma.nhbwdcls.csv", col.names=c("nhbwdcls"))
write.table(ma.nhwpr, sep=",", row.names=F, file="../_mceInputs/ma.nhwpr.csv", col.names=c("nhwpr"))

# NHW Raw Distribution Matrix
mf.nhwdt <- (mf.util / ma.utsum) * ma.nhwpu
mf.nhwdt[ma.utsum==0] <- 0

# Delete temporary matrices
#rm (ms.nhwpr,ms.nhws,mf.util,ma.utsum)

### 8-district summaries

if (file.access("nhwdist.rpt", mode=0) == 0) {system ("rm nhwdist.rpt")}

distsum("mf.nhwdt", "NHW Distribution", "ga", 3, "nhwdist", project, initials)

