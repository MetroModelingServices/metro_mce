#k.hbcdist.R

# Weighted Average Logsum
mf.hcls <- HBC.lsLowWeight*mf.hclsl + HBC.lsMidWeight*mf.hclsm + HBC.lsHighWeight*mf.hclsh

east2westhill<-as.matrix(array(0,c(numzones,numzones)))
east2westhill[ensemble.gw==2,ensemble.gw==1]<-1

westhill2east<-as.matrix(array(0,c(numzones,numzones)))
westhill2east[ensemble.gw==1,ensemble.gw==2]<-1

east2westriv<-as.matrix(array(0,c(numzones,numzones)))
east2westriv[ensemble.gr==2,ensemble.gr==1]<-1

westriv2east<-as.matrix(array(0,c(numzones,numzones)))
westriv2east[ensemble.gr==1,ensemble.gr==2]<-1

#############################################################
#  Raw HBC Utility                                          #
#############################################################
mf.collat <- matrix (ma.collat, length(ma.collat), length(ma.collat), byrow=T)

mf.util <- exp(sweep(HBC.lsCoeff * mf.hcls
                   + HBC.logdistXorwaCoeff * mf.orwa * log (mf.tdist + 1)
                   + HBC.logdistXwaorCoeff * mf.waor * log (mf.tdist + 1)
                   + HBC.logdistXnoXingCoeff * ((mf.orwa + mf.waor)==0) * log (mf.tdist + 1)
                   + HBC.logdistXewWestHillsCoeff * east2westhill * log (mf.tdist + 1)
                   + HBC.logdistXweWestHillsCoeff * westhill2east * log (mf.tdist + 1)
                   + HBC.logdistXewWillRiverCoeff * east2westriv * log (mf.tdist + 1)
                   + HBC.logdistXweWillRiverCoeff * westriv2east * log (mf.tdist + 1)
                   , 2, log(HBC.enrollCoeff * ma.enroll + 1), "+"))

mf.util[mf.collat[,]==0] <- 0

ma.utsum <- apply(mf.util,1,sum)
mf.utsum <- matrix(ma.utsum,length(ma.utsum),length(ma.utsum))

# Low Income Distribution
mf.hbcdtl <- matrix(0,numzones,numzones)
mf.hbcdtl[mf.utsum!=0] <- mf.util[mf.utsum!=0]/mf.utsum[mf.utsum!=0]
mf.hbcdtl <- sweep(mf.hbcdtl,1,ma.collprl,"*")
ma.hbcldcls <- log(ma.utsum)
save (ma.hbcldcls, file="ma.hbcldcls.dat")
if (file.access("../_mceInputs", mode=0) < 0) { dir.create("../_mceInputs") }
write.table(ma.hbcldcls, sep=",", row.names=F, file="../_mceInputs/ma.hbcldcls.csv", col.names=c("hbcldcls"))
write.table(ma.collprl, sep=",", row.names=F, file="../_mceInputs/ma.collprl.csv", col.names=c("hbcprl"))

# Middle Income Distribution
mf.hbcdtm <- matrix(0,numzones,numzones)
mf.hbcdtm[mf.utsum!=0] <- mf.util[mf.utsum!=0]/mf.utsum[mf.utsum!=0]
mf.hbcdtm <- sweep(mf.hbcdtm,1,ma.collprm,"*")
ma.hbcmdcls <- log(ma.utsum)
save (ma.hbcmdcls, file="ma.hbcmdcls.dat")
write.table(ma.hbcmdcls, sep=",", row.names=F, file="../_mceInputs/ma.hbcmdcls.csv", col.names=c("hbcmdcls"))
write.table(ma.collprm, sep=",", row.names=F, file="../_mceInputs/ma.collprm.csv", col.names=c("hbcprm"))

# High Income Distribution
mf.hbcdth <- matrix(0,numzones,numzones)
mf.hbcdth[mf.utsum!=0] <- mf.util[mf.utsum!=0]/mf.utsum[mf.utsum!=0]
mf.hbcdth <- sweep(mf.hbcdth,1,ma.collprh,"*")
ma.hbchdcls <- log(ma.utsum)
save (ma.hbchdcls, file="ma.hbchdcls.dat")
write.table(ma.hbchdcls, sep=",", row.names=F, file="../_mceInputs/ma.hbchdcls.csv", col.names=c("hbchdcls"))
write.table(ma.collprh, sep=",", row.names=F, file="../_mceInputs/ma.collprh.csv", col.names=c("hbcprh"))

#############################################################
# Output productions and attractions - WRS 11/28/06
#############################################################
if (file.access("panda_coll.rpt", mode=0) == 0) {system ("rm panda_coll.rpt")}
panda <- matrix (0,8,2)
panda[1,1] <- round (sum (ma.collpr[ensemble.ga==1]),0)
panda[2,1] <- round (sum (ma.collpr[ensemble.ga==2]),0)
panda[3,1] <- round (sum (ma.collpr[ensemble.ga==3]),0)
panda[4,1] <- round (sum (ma.collpr[ensemble.ga==4]),0)
panda[5,1] <- round (sum (ma.collpr[ensemble.ga==5]),0)
panda[6,1] <- round (sum (ma.collpr[ensemble.ga==6]),0)
panda[7,1] <- round (sum (ma.collpr[ensemble.ga==7]),0)
panda[8,1] <- round (sum (ma.collpr[ensemble.ga==8]),0)
panda[1,2] <- round (sum (ma.collat[ensemble.ga==1]),0)
panda[2,2] <- round (sum (ma.collat[ensemble.ga==2]),0)
panda[3,2] <- round (sum (ma.collat[ensemble.ga==3]),0)
panda[4,2] <- round (sum (ma.collat[ensemble.ga==4]),0)
panda[5,2] <- round (sum (ma.collat[ensemble.ga==5]),0)
panda[6,2] <- round (sum (ma.collat[ensemble.ga==6]),0)
panda[7,2] <- round (sum (ma.collat[ensemble.ga==7]),0)
panda[8,2] <- round (sum (ma.collat[ensemble.ga==8]),0)
rownames (panda) <- c("ga1","ga2","ga3","ga4","ga5","ga6","ga7","ga8")
colnames (panda) <- c("collpr","collat")
outfile <- file ("panda_hbc.rpt", "w")
  writeLines (project, con=outfile, sep="\n")
  writeLines (paste ("Metro (", toupper (initials), ") - ", date(), sep=''),
    con=outfile, sep="\n")
  writeLines ("ens\tcollpr\tcollat", con=outfile,sep="\n")
close (outfile)
write.table (panda,"panda_hbc.rpt",append=T,row.names=T,col.names=F,quote=F,sep="\t")

# Balance Distribution Matrix
source(paste(R.path, "k.balance.R", sep='/'))
mf.colldtl <- balance (mf.hbcdtl,ma.collprl,ma.collatl,100)
mf.colldtm <- balance (mf.hbcdtm,ma.collprm,ma.collatm,100)
mf.colldth <- balance (mf.hbcdth,ma.collprh,ma.collath,100)

#############################################################
#  Total HBC Distribution                                   #
#############################################################
mf.colldt <- mf.colldtl + mf.colldtm + mf.colldth

# Remove temporary matrices 
rm(ma.utsum,mf.util,mf.collat)

# 8-district summaries
if (file.access("hbcdist.rpt", mode=0) == 0) {system ("rm hbcdist.rpt")}

distsum("mf.colldt", "College Distribution - Total", "ga", 3, "hbcdist", project, initials)
distsum("mf.colldtl", "College Distribution - LowInc", "ga", 3, "hbcdist", project, initials)
distsum("mf.colldtm", "College Distribution - MidInc", "ga", 3, "hbcdist", project, initials)
distsum("mf.colldth", "College Distribution - HighInc", "ga", 3, "hbcdist", project, initials)

