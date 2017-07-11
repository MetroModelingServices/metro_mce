#k.hbwdist.R

east2westhill<-as.matrix(array(0,c(numzones,numzones)))
east2westhill[ensemble.gw==2,ensemble.gw==1]<-1

westhill2east<-as.matrix(array(0,c(numzones,numzones)))
westhill2east[ensemble.gw==1,ensemble.gw==2]<-1

east2westriv<-as.matrix(array(0,c(numzones,numzones)))
east2westriv[ensemble.gr==2,ensemble.gr==1]<-1

westriv2east<-as.matrix(array(0,c(numzones,numzones)))
westriv2east[ensemble.gr==1,ensemble.gr==2]<-1

#############################################################
#  Low Income Raw Distribution                              #
#############################################################

# HBW Low Income Distribution Utility
mf.util <- exp(sweep(HBW.low.lsCoeff * mf.hwlsl
                   + HBW.low.logdistXorwaCoeff * mf.orwa * log (mf.tdist + 1)
                   + HBW.low.logdistXwaorCoeff * mf.waor * log (mf.tdist + 1)
                   + HBW.low.logdistXnoXingCoeff * ((mf.orwa + mf.waor)==0) * log (mf.tdist + 1)
                   + HBW.low.logdistXewWestHillsCoeff * east2westhill * log (mf.tdist + 1)
                   + HBW.low.logdistXweWestHillsCoeff * westhill2east * log (mf.tdist + 1)
                   + HBW.low.logdistXewWillRiverCoeff * east2westriv * log (mf.tdist + 1)
                   + HBW.low.logdistXweWillRiverCoeff * westriv2east * log (mf.tdist + 1)
                   , 2, log (HBW.low.aerCoeff * ma.aer
                   + HBW.low.amfCoeff * ma.amf + HBW.low.conCoeff * ma.con
                   + HBW.low.eduCoeff * ma.edu + HBW.low.fsdCoeff * ma.fsd
                   + HBW.low.govCoeff * ma.gov + HBW.low.hssCoeff * ma.hss
                   + HBW.low.mfgCoeff * ma.mfg + HBW.low.mhtCoeff * ma.mht
                   + HBW.low.osvCoeff * ma.osv + HBW.low.pbsCoeff * ma.pbs
                   + HBW.low.rcsCoeff * ma.rcs + HBW.low.twuCoeff * ma.twu
                   + HBW.low.wtCoeff * ma.wt + 1), "+"))

# Distribution Utility Summary
ma.utsum <- apply(mf.util,1,sum)
mf.utsum <- matrix(ma.utsum,length(ma.utsum),length(ma.utsum))

# HBW Low Income Raw Distribution Matrix
mf.hwdtl <- matrix(0,numzones,numzones)
mf.hwdtl[mf.utsum!=0] <- mf.util[mf.utsum!=0]/mf.utsum[mf.utsum!=0]
mf.hwdtl <- sweep(mf.hwdtl,1,ma.hbwprl,"*")
ma.hbwldcls <- log(ma.utsum)
save (ma.hbwldcls, file="ma.hbwldcls.dat")
if (file.access("../_mceInputs", mode=0) < 0) { dir.create("../_mceInputs") }
write.table(ma.hbwldcls, sep=",", row.names=F, file="../_mceInputs/ma.hbwldcls.csv", col.names=c("hbwldcls"))
write.table(ma.hbwprl, sep=",", row.names=F, file="../_mceInputs/ma.hbwprl.csv", col.names=c("hbwprl"))


#############################################################
#  Middle Income Raw Distribution                           #
#############################################################

# HBW Middle Income Distribution Utility
mf.util <- exp(sweep(HBW.mid.lsCoeff * mf.hwlsm
                   + HBW.mid.logdistXorwaCoeff * mf.orwa * log (mf.tdist + 1)
                   + HBW.mid.logdistXwaorCoeff * mf.waor * log (mf.tdist + 1)
                   + HBW.mid.logdistXnoXingCoeff * ((mf.orwa + mf.waor)==0) * log (mf.tdist + 1)
                   + HBW.mid.logdistXewWestHillsCoeff * east2westhill * log (mf.tdist + 1)
                   + HBW.mid.logdistXweWestHillsCoeff * westhill2east * log (mf.tdist + 1)
                   + HBW.mid.logdistXewWillRiverCoeff * east2westriv * log (mf.tdist + 1)
                   + HBW.mid.logdistXweWillRiverCoeff * westriv2east * log (mf.tdist + 1)
                   , 2, log (HBW.mid.aerCoeff * ma.aer
                   + HBW.mid.amfCoeff * ma.amf + HBW.mid.conCoeff * ma.con
                   + HBW.mid.eduCoeff * ma.edu + HBW.mid.fsdCoeff * ma.fsd
                   + HBW.mid.govCoeff * ma.gov + HBW.mid.hssCoeff * ma.hss
                   + HBW.mid.mfgCoeff * ma.mfg + HBW.mid.mhtCoeff * ma.mht
                   + HBW.mid.osvCoeff * ma.osv + HBW.mid.pbsCoeff * ma.pbs
                   + HBW.mid.rcsCoeff * ma.rcs + HBW.mid.twuCoeff * ma.twu
                   + HBW.mid.wtCoeff * ma.wt + 1), "+"))

# Distribution Utility Summary
ma.utsum <- apply (mf.util, 1, sum)
mf.utsum <- matrix(ma.utsum,length(ma.utsum),length(ma.utsum))

# HBW Middle Income Raw Distribution Matrix
mf.hwdtm <- matrix(0,numzones,numzones)
mf.hwdtm[mf.utsum!=0] <- mf.util[mf.utsum!=0]/mf.utsum[mf.utsum!=0]
mf.hwdtm <- sweep(mf.hwdtm,1,ma.hbwprm,"*")
ma.hbwmdcls <- log(ma.utsum)
save (ma.hbwmdcls, file="ma.hbwmdcls.dat")
write.table(ma.hbwmdcls, sep=",", row.names=F, file="ma.hbwmdcls.csv", col.names=c("hbwmdcls"))
write.table(ma.hbwprm, sep=",", row.names=F, file="ma.hbwprm.csv", col.names=c("hbwprm"))


#############################################################
#  High Income Raw Distribution                             #
#############################################################

# HBW High Income Distribution Utility
mf.util <- exp(sweep(HBW.high.lsCoeff * mf.hwlsh
                   + HBW.high.logdistXorwaCoeff * mf.orwa * log (mf.tdist + 1)
                   + HBW.high.logdistXwaorCoeff * mf.waor * log (mf.tdist + 1)
                   + HBW.high.logdistXnoXingCoeff * ((mf.orwa + mf.waor)==0) * log (mf.tdist + 1)
                   + HBW.high.logdistXewWestHillsCoeff * east2westhill * log (mf.tdist + 1)
                   + HBW.high.logdistXweWestHillsCoeff * westhill2east * log (mf.tdist + 1)
                   + HBW.high.logdistXewWillRiverCoeff * east2westriv * log (mf.tdist + 1)
                   + HBW.high.logdistXweWillRiverCoeff * westriv2east * log (mf.tdist + 1)
                   , 2, log (HBW.high.aerCoeff * ma.aer
                   + HBW.high.amfCoeff * ma.amf + HBW.high.conCoeff * ma.con
                   + HBW.high.eduCoeff * ma.edu + HBW.high.fsdCoeff * ma.fsd
                   + HBW.high.govCoeff * ma.gov + HBW.high.hssCoeff * ma.hss
                   + HBW.high.mfgCoeff * ma.mfg + HBW.high.mhtCoeff * ma.mht
                   + HBW.high.osvCoeff * ma.osv + HBW.high.pbsCoeff * ma.pbs
                   + HBW.high.rcsCoeff * ma.rcs + HBW.high.twuCoeff * ma.twu
                   + HBW.high.wtCoeff * ma.wt + 1), "+"))

# Distribution Utility Summary
ma.utsum <- apply (mf.util, 1, sum)
mf.utsum <- matrix(ma.utsum,length(ma.utsum),length(ma.utsum))

# HBW High Income Raw Distribution Matrix
mf.hwdth <- matrix(0,numzones,numzones)
mf.hwdth[mf.utsum!=0] <- mf.util[mf.utsum!=0]/mf.utsum[mf.utsum!=0]
mf.hwdth <- sweep(mf.hwdth,1,ma.hbwprh,"*")
ma.hbwhdcls <- log(ma.utsum)
save (ma.hbwhdcls, file="ma.hbwhdcls.dat")
write.table(ma.hbwhdcls, sep=",", row.names=F, file="ma.hbwhdcls.csv", col.names=c("hbwhdcls"))
write.table(ma.hbwprh, sep=",", row.names=F, file="ma.hbwprh.csv", col.names=c("hbwprh"))


#############################################################
#  Calculate Target Attractions                             #
#############################################################
ma.atl <- apply(mf.hwdtl,2,sum)
ma.atm <- apply(mf.hwdtm,2,sum)
ma.ath <- apply(mf.hwdth,2,sum)
ma.newat <- ma.atl + ma.atm + ma.ath
ma.hbwatl <- ma.atl * (ma.hbwat/ma.newat)
ma.hbwatl [ma.newat==0] <- 0
ma.hbwatm <- ma.atm * (ma.hbwat/ma.newat)
ma.hbwatm [ma.newat==0] <- 0
ma.hbwath <- ma.ath * (ma.hbwat/ma.newat)
ma.hbwath [ma.newat==0] <- 0

#############################################################
# Scale attractions to productions - WRS 11/22/06
#############################################################
ms.hbwprl <- sum (ma.hbwprl)
ms.hbwatl <- sum (ma.hbwatl)
ma.hbwatl <- ma.hbwatl * (ms.hbwprl / ms.hbwatl)
ms.hbwprm <- sum (ma.hbwprm)
ms.hbwatm <- sum (ma.hbwatm)
ma.hbwatm <- ma.hbwatm * (ms.hbwprm / ms.hbwatm)
ms.hbwprh <- sum (ma.hbwprh)
ms.hbwath <- sum (ma.hbwath)
ma.hbwath <- ma.hbwath * (ms.hbwprh / ms.hbwath)

#############################################################
# Output productions and attractions - WRS 11/28/06
#############################################################
if (file.access("panda_hbw.rpt", mode=0) == 0) {system ("rm panda_hbw.rpt")}
panda <- matrix (0,8,6)
panda[1,1] <- round (sum (ma.hbwprl[ensemble.ga==1]),0) 
panda[2,1] <- round (sum (ma.hbwprl[ensemble.ga==2]),0) 
panda[3,1] <- round (sum (ma.hbwprl[ensemble.ga==3]),0) 
panda[4,1] <- round (sum (ma.hbwprl[ensemble.ga==4]),0) 
panda[5,1] <- round (sum (ma.hbwprl[ensemble.ga==5]),0) 
panda[6,1] <- round (sum (ma.hbwprl[ensemble.ga==6]),0) 
panda[7,1] <- round (sum (ma.hbwprl[ensemble.ga==7]),0) 
panda[8,1] <- round (sum (ma.hbwprl[ensemble.ga==8]),0) 
panda[1,2] <- round (sum (ma.hbwatl[ensemble.ga==1]),0) 
panda[2,2] <- round (sum (ma.hbwatl[ensemble.ga==2]),0) 
panda[3,2] <- round (sum (ma.hbwatl[ensemble.ga==3]),0) 
panda[4,2] <- round (sum (ma.hbwatl[ensemble.ga==4]),0) 
panda[5,2] <- round (sum (ma.hbwatl[ensemble.ga==5]),0) 
panda[6,2] <- round (sum (ma.hbwatl[ensemble.ga==6]),0) 
panda[7,2] <- round (sum (ma.hbwatl[ensemble.ga==7]),0) 
panda[8,2] <- round (sum (ma.hbwatl[ensemble.ga==8]),0) 
panda[1,3] <- round (sum (ma.hbwprm[ensemble.ga==1]),0) 
panda[2,3] <- round (sum (ma.hbwprm[ensemble.ga==2]),0) 
panda[3,3] <- round (sum (ma.hbwprm[ensemble.ga==3]),0) 
panda[4,3] <- round (sum (ma.hbwprm[ensemble.ga==4]),0) 
panda[5,3] <- round (sum (ma.hbwprm[ensemble.ga==5]),0) 
panda[6,3] <- round (sum (ma.hbwprm[ensemble.ga==6]),0) 
panda[7,3] <- round (sum (ma.hbwprm[ensemble.ga==7]),0) 
panda[8,3] <- round (sum (ma.hbwprm[ensemble.ga==8]),0) 
panda[1,4] <- round (sum (ma.hbwatm[ensemble.ga==1]),0) 
panda[2,4] <- round (sum (ma.hbwatm[ensemble.ga==2]),0) 
panda[3,4] <- round (sum (ma.hbwatm[ensemble.ga==3]),0) 
panda[4,4] <- round (sum (ma.hbwatm[ensemble.ga==4]),0) 
panda[5,4] <- round (sum (ma.hbwatm[ensemble.ga==5]),0) 
panda[6,4] <- round (sum (ma.hbwatm[ensemble.ga==6]),0) 
panda[7,4] <- round (sum (ma.hbwatm[ensemble.ga==7]),0) 
panda[8,4] <- round (sum (ma.hbwatm[ensemble.ga==8]),0) 
panda[1,5] <- round (sum (ma.hbwprh[ensemble.ga==1]),0) 
panda[2,5] <- round (sum (ma.hbwprh[ensemble.ga==2]),0) 
panda[3,5] <- round (sum (ma.hbwprh[ensemble.ga==3]),0) 
panda[4,5] <- round (sum (ma.hbwprh[ensemble.ga==4]),0) 
panda[5,5] <- round (sum (ma.hbwprh[ensemble.ga==5]),0) 
panda[6,5] <- round (sum (ma.hbwprh[ensemble.ga==6]),0) 
panda[7,5] <- round (sum (ma.hbwprh[ensemble.ga==7]),0) 
panda[8,5] <- round (sum (ma.hbwprh[ensemble.ga==8]),0) 
panda[1,6] <- round (sum (ma.hbwath[ensemble.ga==1]),0) 
panda[2,6] <- round (sum (ma.hbwath[ensemble.ga==2]),0) 
panda[3,6] <- round (sum (ma.hbwath[ensemble.ga==3]),0) 
panda[4,6] <- round (sum (ma.hbwath[ensemble.ga==4]),0) 
panda[5,6] <- round (sum (ma.hbwath[ensemble.ga==5]),0) 
panda[6,6] <- round (sum (ma.hbwath[ensemble.ga==6]),0) 
panda[7,6] <- round (sum (ma.hbwath[ensemble.ga==7]),0) 
panda[8,6] <- round (sum (ma.hbwath[ensemble.ga==8]),0) 
rownames (panda) <- c("ga1","ga2","ga3","ga4","ga5","ga6","ga7","ga8")
colnames (panda) <- c("hbwprl","hbwatl","hbwprm","hbwatm","hbwprh","hbwath")
outfile <- file ("panda_hbw.rpt", "w")
  writeLines (project, con=outfile, sep="\n")
  writeLines (paste ("Metro (", toupper (initials), ") - ", date(), sep=''),
    con=outfile, sep="\n")
  writeLines ("ens\thbwprl\thbwatl\thbwprm\thbwatm\thbwprh\thbwath", con=outfile,sep="\n")
close (outfile)
write.table (panda,"panda_hbw.rpt",append=T,row.names=T,col.names=F,quote=F,sep="\t")

#############################################################
#  Calculate Total HBW Distributions                        #
#############################################################
mf.hbwdt <- mf.hwdtl + mf.hwdtm + mf.hwdth

#############################################################
#  Balance HBW Distributions with new Attraction mds        #
#############################################################
#  Source in HBW Balancing Function - edited by WRS 11/22/06
source(paste(R.path, "k.balance.R", sep='/'))
mf.hbwdtl <- balance (mf.hwdtl,ma.hbwprl,ma.hbwatl,100)
mf.hbwdtm <- balance (mf.hwdtm,ma.hbwprm,ma.hbwatm,100)
mf.hbwdth <- balance (mf.hwdth,ma.hbwprh,ma.hbwath,100)

#############################################################
#  Recalculate Total HBW Distributions from Balancing       #
#############################################################
mf.hbwdt <- mf.hbwdtl + mf.hbwdtm + mf.hbwdth

#############################################################
# Remove temporary matrices 
rm (mf.util,ma.utsum,ma.atl,ma.atm,ma.ath,ma.newat,
  ma.hbwatl,ma.hbwatm,ma.hbwath,mf.utsum,ma.totemp)

#rm(ms.aveHbwTripRate,ms.hbwat,ms.hbwEmpGoal,ms.hbwFactor,
#   ms.TotalHbwTrips)


### 8-district summaries

if (file.access("hbwdist.rpt", mode=0) == 0) {system ("rm hbwdist.rpt")}

distsum ("mf.hbwdt", "HBW Distribution - Total", "ga", 3, "hbwdist", project, initials)
distsum ("mf.hbwdtl", "HBW Distribution - LowInc", "ga", 3, "hbwdist", project, initials)
distsum ("mf.hbwdtm", "HBW Distribution - MidInc", "ga", 3, "hbwdist", project, initials)
distsum ("mf.hbwdth", "HBW Distribution - HighInc", "ga", 3, "hbwdist", project, initials)

