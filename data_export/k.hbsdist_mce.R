#k.hbsdist.R

# Weighted Average Logsum
mf.hsls <- HBS.lsLowWeight*mf.hslsl + HBS.lsMidWeight*mf.hslsm + HBS.lsHighWeight*mf.hslsh

east2westhill<-as.matrix(array(0,c(numzones,numzones)))
east2westhill[ensemble.gw==2,ensemble.gw==1]<-1

westhill2east<-as.matrix(array(0,c(numzones,numzones)))
westhill2east[ensemble.gw==1,ensemble.gw==2]<-1

east2westriv<-as.matrix(array(0,c(numzones,numzones)))
east2westriv[ensemble.gr==2,ensemble.gr==1]<-1

westriv2east<-as.matrix(array(0,c(numzones,numzones)))
westriv2east[ensemble.gr==1,ensemble.gr==2]<-1

#############################################################
#  Raw HBS Utility                                          #
#############################################################
mf.util <- exp(sweep(HBS.lsCoeff * mf.hsls
                   + HBS.logdistXorwaCoeff * mf.orwa * log (mf.tdist + 1)
                   + HBS.logdistXwaorCoeff * mf.waor * log (mf.tdist + 1)
                   + HBS.logdistXnoXingCoeff * ((mf.orwa + mf.waor)==0) * log (mf.tdist + 1)
                   + HBS.logdistXewWestHillsCoeff * east2westhill * log (mf.tdist + 1)
                   + HBS.logdistXweWestHillsCoeff * westhill2east * log (mf.tdist + 1)
                   + HBS.logdistXewWillRiverCoeff * east2westriv * log (mf.tdist + 1)
                   + HBS.logdistXweWillRiverCoeff * westriv2east * log (mf.tdist + 1)
                   , 2, log (HBS.aerCoeff * ma.aer
                   + HBS.amfCoeff * ma.amf + HBS.conCoeff * ma.con
                   + HBS.eduCoeff * ma.edu + HBS.fsdCoeff * ma.fsd
                   + HBS.govCoeff * ma.gov + HBS.hssCoeff * ma.hss
                   + HBS.mfgCoeff * ma.mfg + HBS.mhtCoeff * ma.mht
                   + HBS.osvCoeff * ma.osv + HBS.pbsCoeff * ma.pbs
                   + HBS.rcsCoeff * ma.rcs + HBS.twuCoeff * ma.twu
                   + HBS.wtCoeff * ma.wt + 1), "+"))

ma.utsum <- apply(mf.util,1,sum)
mf.utsum <- matrix(ma.utsum,length(ma.utsum),length(ma.utsum))

# Low Income Distribution
mf.hbsdtl <- matrix(0,numzones,numzones)
mf.hbsdtl[mf.utsum!=0] <- mf.util[mf.utsum!=0]/mf.utsum[mf.utsum!=0]
mf.hbsdtl <- sweep(mf.hbsdtl,1,ma.hbsprl,"*")
ma.hbsldcls <- log(ma.utsum)
save (ma.hbsldcls, file="ma.hbsldcls.dat")
if (file.access("../_mceInputs", mode=0) < 0) { dir.create("../_mceInputs") }
write.table(ma.hbsldcls, sep=",", row.names=F, file="../_mceInputs/ma.hbsldcls.csv", col.names=c("hbsldcls"))
write.table(ma.hbsprl, sep=",", row.names=F, file="../_mceInputs/ma.hbsprl.csv", col.names=c("hbsprl"))


# Middle Income Distribution
mf.hbsdtm <- matrix(0,numzones,numzones)
mf.hbsdtm[mf.utsum!=0] <- mf.util[mf.utsum!=0]/mf.utsum[mf.utsum!=0]
mf.hbsdtm <- sweep(mf.hbsdtm,1,ma.hbsprm,"*")
ma.hbsmdcls <- log(ma.utsum)
save (ma.hbsmdcls, file="ma.hbsmdcls.dat")
write.table(ma.hbsmdcls, sep=",", row.names=F, file="../_mceInputs/ma.hbsmdcls.csv", col.names=c("hbsmdcls"))
write.table(ma.hbsprm, sep=",", row.names=F, file="../_mceInputs/ma.hbsprm.csv", col.names=c("hbsprm"))


# High Income Distribution
mf.hbsdth <- matrix(0,numzones,numzones)
mf.hbsdth[mf.utsum!=0] <- mf.util[mf.utsum!=0]/mf.utsum[mf.utsum!=0]
mf.hbsdth <- sweep(mf.hbsdth,1,ma.hbsprh,"*")
ma.hbshdcls <- log(ma.utsum)
save (ma.hbshdcls, file="ma.hbshdcls.dat")
write.table(ma.hbshdcls, sep=",", row.names=F, file="../_mceInputs/ma.hbshdcls.csv", col.names=c("hbshdcls"))
write.table(ma.hbsprh, sep=",", row.names=F, file="../_mceInputs/ma.hbsprh.csv", col.names=c("hbsprh"))


#############################################################
#  Total HBS Distribution                                   #
#############################################################
mf.hbsdt <- mf.hbsdtl + mf.hbsdtm + mf.hbsdth

# Remove temporary matrices 
rm(ma.utsum,mf.utsum,mf.util)

# 8-district summaries
if (file.access("hbsdist.rpt", mode=0) == 0) {system ("rm hbsdist.rpt")}

distsum("mf.hbsdt", "HBshop Distribution - Total", "ga", 3, "hbsdist", project, initials)
distsum("mf.hbsdtl", "HBshop Distribution - LowInc", "ga", 3, "hbsdist", project, initials)
distsum("mf.hbsdtm", "HBshop Distribution - MidInc", "ga", 3, "hbsdist", project, initials)
distsum("mf.hbsdth", "HBshop Distribution - HighInc", "ga", 3, "hbsdist", project, initials)

