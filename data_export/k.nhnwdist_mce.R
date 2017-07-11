#k.nhnwdist.R 

east2westhill<-as.matrix(array(0,c(numzones,numzones)))
east2westhill[ensemble.gw==2,ensemble.gw==1]<-1

westhill2east<-as.matrix(array(0,c(numzones,numzones)))
westhill2east[ensemble.gw==1,ensemble.gw==2]<-1

east2westriv<-as.matrix(array(0,c(numzones,numzones)))
east2westriv[ensemble.gr==2,ensemble.gr==1]<-1

westriv2east<-as.matrix(array(0,c(numzones,numzones)))
westriv2east[ensemble.gr==1,ensemble.gr==2]<-1

# NHNW Total Productions
ms.nhnwpr <- sum(ma.nhnwpr)

# NHNW Production Utility
ma.nhnwpu <- exp(log(NHNW.aerCoeff * ma.aer + NHNW.amfCoeff * ma.amf + NHNW.conCoeff * ma.con + NHNW.eduCoeff * ma.edu + NHNW.fsdCoeff * ma.fsd
                   + NHNW.govCoeff * ma.gov + NHNW.hssCoeff * ma.hss + NHNW.mfgCoeff * ma.mfg + NHNW.mhtCoeff * ma.mht + NHNW.osvCoeff * ma.osv
                   + NHNW.pbsCoeff * ma.pbs + NHNW.rcsCoeff * ma.rcs + NHNW.twuCoeff * ma.twu + NHNW.wtCoeff * ma.wt + 1))

ma.nhnwpu[ma.nhnwpu==1] <- 0

# NHNW Production Utility Summary
ms.nhnws <- sum(ma.nhnwpu)

# NHNW Productions (allocate trips produced by households to production locations)
ma.nhnwpu <- (ma.nhnwpu/ms.nhnws)*(ms.nhnwpr)
if (file.access("../_mceInputs", mode=0) < 0) { dir.create("../_mceInputs") }
write.table(ma.nhnwpu, sep=",", row.names=F, file="../_mceInputs/ma.nhnwpu.csv", col.names=c("nhnwpu"))


# NHNW Distribution Utility
mf.util <- exp(sweep(NHNW.lsCoeff * mf.nhnwls
                   + NHNW.logdistXorwaCoeff * mf.orwa * log (mf.tdist + 1)
                   + NHNW.logdistXwaorCoeff * mf.waor * log (mf.tdist + 1)
                   + NHNW.logdistXnoXingCoeff * ((mf.orwa + mf.waor)==0) * log (mf.tdist + 1)
                   + NHNW.logdistXewWestHillsCoeff * east2westhill * log (mf.tdist + 1)
                   + NHNW.logdistXweWestHillsCoeff * westhill2east * log (mf.tdist + 1)
                   + NHNW.logdistXewWillRiverCoeff * east2westriv * log (mf.tdist + 1)
                   + NHNW.logdistXweWillRiverCoeff * westriv2east * log (mf.tdist + 1)
                   , 2, log (NHNW.aerCoeff * ma.aer
                   + NHNW.amfCoeff * ma.amf + NHNW.conCoeff * ma.con
                   + NHNW.eduCoeff * ma.edu + NHNW.fsdCoeff * ma.fsd
                   + NHNW.govCoeff * ma.gov + NHNW.hssCoeff * ma.hss
                   + NHNW.mfgCoeff * ma.mfg + NHNW.mhtCoeff * ma.mht
                   + NHNW.osvCoeff * ma.osv + NHNW.pbsCoeff * ma.pbs
                   + NHNW.rcsCoeff * ma.rcs + NHNW.twuCoeff * ma.twu
                   + NHNW.wtCoeff * ma.wt + 1), "+"))

mf.util[mf.nhnwls[,]==0] <- 0

# NHNW Distribution Utility Summary
ma.utsum <- apply(mf.util, 1, sum)
ma.nhnwls <- log(ma.utsum)
save (ma.nhnwls, file="ma.nhnwls.dat")
if (file.access("../_mceInputs", mode=0) < 0) { dir.create("../_mceInputs") }
write.table(ma.nhnwls, sep=",", row.names=F, file="../_mceInputs/ma.nhnwls.csv", col.names=c("nhnwdcls"))
write.table(ma.nhnwpr, sep=",", row.names=F, file="../_mceInputs/ma.nhnwpr.csv", col.names=c("nhnwpr"))

# NHNW Raw Distribution Matrix
mf.nhnwdt <- (mf.util / ma.utsum) * ma.nhnwpu
mf.nhnwdt[ma.utsum==0] <- 0

# Delete temporary matrices
# rm (ms.nhnwpr,ms.nhnws,mf.util,ma.utsum)

### 8-district summaries

if (file.access("nhnwdist.rpt", mode=0) == 0) {system ("rm nhnwdist.rpt")}

distsum1 ("mf.nhnwdt", "NHNW Distribution", "ga", 3, "nhnwdist", project, initials)

