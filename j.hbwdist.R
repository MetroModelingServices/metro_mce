#j.hbwdist.R
# HBW Destination Choice
# LOGSUMS WITH ONLY TRAVEL TIMES coeff from orig ms. NO constants.& NO BDFLAG..........

#Needs the following input files from Emme2
# 1.  mf.waor
# 2.  mf.orwa  
# 3.  mf.ew
# 4.  mf.we 

#Needs the following matrices from generation
# 6.  ma.hbwprl
# 7.  ma.hbwprm
# 8.  ma.hbwprh

#Needs the following matrices from log sum
# 9.  mf.hwlsl
#10.  mf.hwlsm
#11.  mf.hwlsh 

westhill2east<-as.matrix(array(0,c(numzones,numzones)))
westhill2east[ensemble.gw==1,ensemble.gw==2]<-1
westhill2east[ensemble.gw==1,ensemble.gw==2]<-1
westhill2east[ensemble.gw==1,ensemble.gw==2]<-1
westhill2east[ensemble.gw==1,ensemble.gw==2]<-1


# Calculate Shopping Center Employment
ma.shemp <- ma.shsqft / 1000 * 3

# Boost Retail Employment to Shopping Center Employment (if necessary)
ma.retail <- (ma.ret * (ma.ret >= ma.shemp) + ma.shemp * (ma.ret < ma.shemp))

#############################################################
#  Low Income Raw Distribution                              #
#############################################################

# Total Employment for Low Income Utility 
ma.totemp <- (ma.afm + ma.con + ma.fi + ma.gov + ma.mfg + ma.retail+ ma.ser
             + ma.tpu + ma.wt)

# HBW Low Income Distribution Utility # Original Logsum Coeff(linear, sq, cu) = 2.203, -0.3701, 0.01899
mf.util <- exp (sweep (2.235*mf.hwlsl - 0.4198*(mf.hwlsl^2) + 0.02220*(mf.hwlsl^3)
                - 1.502*mf.waor - 1.378*mf.orwa - 0.4949*mf.we -(0.4949*0.625)*westhill2east, 2,
                + log(ma.totemp), "+"))

# Distribution Utility Summary
ma.utsum <- apply (mf.util, 1, sum)

ma.hwldcls <- log(ma.utsum)
save (ma.hbwldcls, file="ma.hbwldcls.dat")
write.table(ma.hbwldcls, sep=",", row.names=F, file="ma.hbwldcls.csv", col.names=c("hbwldcls"))

mf.utsum<-matrix(ma.utsum,length(ma.utsum),length(ma.utsum))

# HBW Low Income Raw Distribution Matrix
mf.hwdtl<-matrix(0,numzones,numzones)
mf.hwdtl[mf.utsum!=0]<-mf.util[mf.utsum!=0]/mf.utsum[mf.utsum!=0]
mf.hwdtl<-sweep(mf.hwdtl,1,ma.hbwprl,"*")


#############################################################
#  Middle Income Raw Distribution                           #
#############################################################

# Rest Employment for Middle Income Utility
ma.rest <- ma.afm + ma.con + ma.fi + ma.gov + ma.mfg + ma.ser + ma.tpu + ma.wt

# HBW Middle Income Distribution Utility # Original Logsum Coeff(linear, sq, cu) = 1.891, -0.3614, 0.02154
mf.util <-exp (sweep (2.097*mf.hwlsm - 0.3995*(mf.hwlsm^2) + 0.02524*(mf.hwlsm^3)
                - 0.8209*mf.waor - 1.635*mf.orwa - 0.3138*mf.we + 0.000*mf.ew -(0.3138*0.625)*westhill2east, 2,
                + log(ma.retail+ 1.6005*ma.rest), "+"))

# Distribution Utility Summary
ma.utsum <- apply (mf.util, 1, sum)

ma.hwmdcls <- log(ma.utsum)
save (ma.hbwmdcls, file="ma.hbwmdcls.dat")
write.table(ma.hbwmdcls, sep=",", row.names=F, file="ma.hbwmdcls.csv", col.names=c("hbwmdcls"))

mf.utsum<-matrix(ma.utsum,length(ma.utsum),length(ma.utsum))

# HBW Middle Income Raw Distribution Matrix
mf.hwdtm<-matrix(0,numzones,numzones)
mf.hwdtm[mf.utsum!=0]<-mf.util[mf.utsum!=0]/mf.utsum[mf.utsum!=0]
mf.hwdtm<-sweep(mf.hwdtm,1,ma.hbwprm,"*")


#############################################################
#  High Income Raw Distribution                             #
#############################################################

# Rest Employment for High Income Utility
ma.rest <- ma.afm + ma.con + ma.gov + ma.mfg + ma.tpu + ma.wt

# HBW High Income Distribution Utility # Original Logsum Coeff(linear, sq, cu) = 1.562, -0.3164, 0.02195
mf.util <-exp (sweep (1.777*mf.hwlsh  - 0.3908*(mf.hwlsh^2) + 0.02555*(mf.hwlsh^3)
               - 1.139*mf.waor - 1.429*mf.orwa - 0.4325*mf.we -(0.4325*0.625)*westhill2east, 2,
               + log(ma.retail+ 2.8605*ma.ser + 5.6013*ma.fi + 2.4312*ma.rest), "+"))

# Distribution Utility Summary
ma.utsum <- apply (mf.util, 1, sum)

ma.hwhdcls <- log(ma.utsum)
save (ma.hbwhdcls, file="ma.hbwhdcls.dat")
write.table(ma.hbwhdcls, sep=",", row.names=F, file="ma.hbwhdcls.csv", col.names=c("hbwhdcls"))

mf.utsum<-matrix(ma.utsum,length(ma.utsum),length(ma.utsum))

# HBW High Income Raw Distribution Matrix
mf.hwdth<-matrix(0,numzones,numzones)
mf.hwdth[mf.utsum!=0]<-mf.util[mf.utsum!=0]/mf.utsum[mf.utsum!=0]
mf.hwdth<-sweep(mf.hwdth,1,ma.hbwprh,"*")


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
source(paste(R.path, "j.balance.R", sep='/'))
mf.hbwdtl <- balance (mf.hwdtl,ma.hbwprl,ma.hbwatl,100)
mf.hbwdtm <- balance (mf.hwdtm,ma.hbwprm,ma.hbwatm,100)
mf.hbwdth <- balance (mf.hwdth,ma.hbwprh,ma.hbwath,100)

#############################################################
#  Recalculate Total HBW Distributions from Balancing       #
#############################################################
mf.hbwdt <- mf.hbwdtl + mf.hbwdtm + mf.hbwdth

#############################################################
# Remove temporary matrices 
rm (ma.rest,mf.util,ma.utsum,ma.atl,ma.atm,ma.ath,ma.newat,
  ma.hbwatl,ma.hbwatm,ma.hbwath,mf.utsum,ma.totemp)

#rm(ms.aveHbwTripRate,ms.hbwat,ms.hbwEmpGoal,ms.hbwFactor,
#   ms.TotalHbwTrips)


### 8-district summaries

if (file.access("hbwdist.rpt", mode=0) == 0) {system ("rm hbwdist.rpt")}

distsum ("mf.hbwdt", "HBW Distribution - Total", "ga", 3, 
  "hbwdist", project, initials)
distsum ("mf.hbwdtl", "HBW Distribution - LowInc", "ga", 3, 
  "hbwdist", project, initials)
distsum ("mf.hbwdtm", "HBW Distribution - MidInc", "ga", 3, 
  "hbwdist", project, initials)
distsum ("mf.hbwdth", "HBW Distribution - HighInc", "ga", 3, 
  "hbwdist", project, initials)

