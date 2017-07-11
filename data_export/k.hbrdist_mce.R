#k.hbrdist.R

# Weighted Average Logsum
mf.hrls <- HBR.lsLowWeight*mf.hrlsl + HBR.lsMidWeight*mf.hrlsm + HBR.lsHighWeight*mf.hrlsh

east2westhill<-as.matrix(array(0,c(numzones,numzones)))
east2westhill[ensemble.gw==2,ensemble.gw==1]<-1

westhill2east<-as.matrix(array(0,c(numzones,numzones)))
westhill2east[ensemble.gw==1,ensemble.gw==2]<-1

east2westriv<-as.matrix(array(0,c(numzones,numzones)))
east2westriv[ensemble.gr==2,ensemble.gr==1]<-1

westriv2east<-as.matrix(array(0,c(numzones,numzones)))
westriv2east[ensemble.gr==1,ensemble.gr==2]<-1

#############################################################
#  Raw HBR Utility                                          #
#############################################################
mf.util <- exp(sweep(HBR.lsCoeff * mf.hrls
                   + HBR.logdistXorwaCoeff * mf.orwa * log (mf.tdist + 1)
                   + HBR.logdistXwaorCoeff * mf.waor * log (mf.tdist + 1)
                   + HBR.logdistXnoXingCoeff * ((mf.orwa + mf.waor)==0) * log (mf.tdist + 1)
                   + HBR.logdistXewWestHillsCoeff * east2westhill * log (mf.tdist + 1)
                   + HBR.logdistXweWestHillsCoeff * westhill2east * log (mf.tdist + 1)
                   + HBR.logdistXewWillRiverCoeff * east2westriv * log (mf.tdist + 1)
                   + HBR.logdistXweWillRiverCoeff * westriv2east * log (mf.tdist + 1)
                   , 2, log (HBR.aerCoeff * ma.aer
                   + HBR.amfCoeff * ma.amf + HBR.conCoeff * ma.con
                   + HBR.eduCoeff * ma.edu + HBR.fsdCoeff * ma.fsd
                   + HBR.govCoeff * ma.gov + HBR.hssCoeff * ma.hss
                   + HBR.mfgCoeff * ma.mfg + HBR.mhtCoeff * ma.mht
                   + HBR.osvCoeff * ma.osv + HBR.pbsCoeff * ma.pbs
                   + HBR.rcsCoeff * ma.rcs + HBR.twuCoeff * ma.twu
                   + HBR.wtCoeff * ma.wt + HBR.hhCoeff * ma.hh
                   + HBR.activeAcresCoeff * ma.actva + HBR.parkAcresDiv10Coeff * (ma.parka / 10) + 1), "+"))

ma.utsum <- apply(mf.util,1,sum)
mf.utsum <- matrix(ma.utsum,length(ma.utsum),length(ma.utsum))

# Low Income Distribution
mf.hbrdtl <- matrix(0,numzones,numzones)
mf.hbrdtl[mf.utsum!=0] <- mf.util[mf.utsum!=0]/mf.utsum[mf.utsum!=0]
mf.hbrdtl <- sweep(mf.hbrdtl,1,ma.hbrprl,"*")
ma.hbrldcls <- log(ma.utsum)
save (ma.hbrldcls, file="ma.hbrldcls.dat")
write.table(ma.hbrldcls, sep=",", row.names=F, file="../_mceInputs/ma.hbrldcls.csv", col.names=c("hbrldcls"))
write.table(ma.hbrprl, sep=",", row.names=F, file="../_mceInputs/ma.hbrprl.csv", col.names=c("hbrprl"))

# Middle Income Distribution
mf.hbrdtm <- matrix(0,numzones,numzones)
mf.hbrdtm[mf.utsum!=0] <- mf.util[mf.utsum!=0]/mf.utsum[mf.utsum!=0]
mf.hbrdtm <- sweep(mf.hbrdtm,1,ma.hbrprm,"*")
ma.hbrmdcls <- log(ma.utsum)
save (ma.hbrmdcls, file="ma.hbrmdcls.dat")
if (file.access("../_mceInputs", mode=0) < 0) { dir.create("../_mceInputs") }
write.table(ma.hbrmdcls, sep=",", row.names=F, file="../_mceInputs/ma.hbrmdcls.csv", col.names=c("hbrmdcls"))
write.table(ma.hbrprm, sep=",", row.names=F, file="../_mceInputs/ma.hbrprm.csv", col.names=c("hbrprm"))

# High Income Distribution
mf.hbrdth <- matrix(0,numzones,numzones)
mf.hbrdth[mf.utsum!=0] <- mf.util[mf.utsum!=0]/mf.utsum[mf.utsum!=0]
mf.hbrdth <- sweep(mf.hbrdth,1,ma.hbrprh,"*")
ma.hbrhdcls <- log(ma.utsum)
save (ma.hbrhdcls, file="ma.hbrhdcls.dat")
write.table(ma.hbrhdcls, sep=",", row.names=F, file="../_mceInputs/ma.hbrhdcls.csv", col.names=c("hbrhdcls"))
write.table(ma.hbrprh, sep=",", row.names=F, file="../_mceInputs/ma.hbrprh.csv", col.names=c("hbrprh"))

#############################################################
#  Total HBR Distribution                                   #
#############################################################
mf.hbrdt <- mf.hbrdtl + mf.hbrdtm + mf.hbrdth

# Remove temporary matrices 
rm(ma.utsum,mf.utsum,mf.util)

# 8-district summaries
if (file.access("hbrdist.rpt", mode=0) == 0) {system ("rm hbrdist.rpt")}

distsum("mf.hbrdt", "HBrec Distribution - Total", "ga", 3, "hbrdist", project, initials)
distsum("mf.hbrdtl", "HBrec Distribution - LowInc", "ga", 3, "hbrdist", project, initials)
distsum("mf.hbrdtm", "HBrec Distribution - MidInc", "ga", 3, "hbrdist", project, initials)
distsum("mf.hbrdth", "HBrec Distribution - HighInc", "ga", 3, "hbrdist", project, initials)

