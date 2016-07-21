#j.hbrdist.R
# HBR Destination Choice 
# LOGSUMS WITH ONLY TRAVEL TIMES coeff from orig ms. NO constants.

#Needs the following input files from Emme2
# 1.  mf.waor
# 2.  mf.orwa  
# 3.  mf.ew
# 4.  mf.we 
# 5.  ma.shsqft

#Needs the following matrices from generation
# 6.  ma.hbrprl
# 7.  ma.hbrprm
# 8.  ma.hbrprh

#Needs the following matrices from log sum
# 9.  mf.hrlsl
#10.  mf.hrlsm
#11.  mf.hrlsh 

westhill2east<-as.matrix(array(0,c(numzones,numzones)))
westhill2east[ensemble.gw==1,ensemble.gw==2]<-1
westhill2east[ensemble.gw==1,ensemble.gw==2]<-1
westhill2east[ensemble.gw==1,ensemble.gw==2]<-1
westhill2east[ensemble.gw==1,ensemble.gw==2]<-1

east2westhill<-as.matrix(array(0,c(numzones,numzones)))
east2westhill[ensemble.gw==2,ensemble.gw==1]<-1
east2westhill[ensemble.gw==2,ensemble.gw==1]<-1
east2westhill[ensemble.gw==2,ensemble.gw==1]<-1
east2westhill[ensemble.gw==2,ensemble.gw==1]<-1

#Calculate Shopping Center Employment
ma.shemp<-ma.shsqft/1000*3

#Compare Shopping Center Employment w/ Retail Employment; use greater of the two
ma.retail<-(ma.ret*(ma.ret >= ma.shemp))+(ma.shemp*(ma.ret< ma.shemp))

# Calculate Total Employment
ma.total <- ma.retail + ma.ser + ma.gov + ma.afm + ma.con + ma.fi + ma.mfg + ma.tpu + ma.wt
 
#############################################################
#  Low Income Raw Distribution                              #
#############################################################
# Original Logsum coeff(linear, sq, cu) = 5.616, -1.793, 0.1907
mf.util<-exp(sweep(5.546*((mf.hrlsl + mf.hrlsm + mf.hrlsh)/3) - 1.801*(((mf.hrlsl + mf.hrlsm + mf.hrlsh)/3)^2)
                   + 0.1907*(((mf.hrlsl + mf.hrlsm + mf.hrlsh)/3)^3)
                   - 1.209*mf.waor - 1.539*mf.orwa - 0.2962*mf.we - (0.2962*0.625)*westhill2east - 0.1703*mf.ew - (0.1703*0.625)*east2westhill,
                   2,log(ma.total + 1.2780*ma.hh + 4.6833*ma.parka),"+"))
ma.utsum<-apply(mf.util,1,sum)
mf.utsum<-matrix(ma.utsum,length(ma.utsum),length(ma.utsum))
mf.hbrdtl<-matrix(0,numzones,numzones)
mf.hbrdtl[mf.utsum!=0]<-mf.util[mf.utsum!=0]/mf.utsum[mf.utsum!=0]
mf.hbrdtl<-sweep(mf.hbrdtl,1,ma.hbrprl,"*")


#############################################################
#  Middle Income Raw Distribution                           #
#############################################################
# Original Logsum coeff(linear, sq, cu) = 5.616, -1.793, 0.1907
mf.util<-exp(sweep(5.546*((mf.hrlsl + mf.hrlsm + mf.hrlsh)/3) - 1.801*(((mf.hrlsl + mf.hrlsm + mf.hrlsh)/3)^2)
                   + 0.1907*(((mf.hrlsl + mf.hrlsm + mf.hrlsh)/3)^3)
                   - 1.209*mf.waor - 1.539*mf.orwa - 0.2962*mf.we - (0.2962*0.625)*westhill2east - 0.1703*mf.ew - (0.1703*0.625)*east2westhill,
                   2,log(ma.total + 1.2780*ma.hh + 4.6833*ma.parka),"+"))
ma.utsum<-apply(mf.util,1,sum)
mf.utsum<-matrix(ma.utsum,length(ma.utsum),length(ma.utsum))
mf.hbrdtm<-matrix(0,numzones,numzones)
mf.hbrdtm[mf.utsum!=0]<-mf.util[mf.utsum!=0]/mf.utsum[mf.utsum!=0]
mf.hbrdtm<-sweep(mf.hbrdtm,1,ma.hbrprm,"*")


#############################################################
#  High Income Raw Distribution                             #
#############################################################
# Original Logsum coeff(linear, sq, cu) = 5.616, -1.793, 0.1907
mf.util<-exp(sweep(5.546*((mf.hrlsl + mf.hrlsm + mf.hrlsh)/3) - 1.801*(((mf.hrlsl + mf.hrlsm + mf.hrlsh)/3)^2)
                   + 0.1907*(((mf.hrlsl + mf.hrlsm + mf.hrlsh)/3)^3)
                   - 1.209*mf.waor - 1.539*mf.orwa - 0.2962*mf.we - (0.2962*0.625)*westhill2east - 0.1703*mf.ew - (0.1703*0.625)*east2westhill,
                   2,log(ma.total + 1.2780*ma.hh + 4.6833*ma.parka),"+"))
ma.utsum<-apply(mf.util,1,sum)
mf.utsum<-matrix(ma.utsum,length(ma.utsum),length(ma.utsum))
mf.hbrdth<-matrix(0,numzones,numzones)
mf.hbrdth[mf.utsum!=0]<-mf.util[mf.utsum!=0]/mf.utsum[mf.utsum!=0]
mf.hbrdth<-sweep(mf.hbrdth,1,ma.hbrprh,"*")


#############################################################
#  Calculate Total HBW Distributions                        #
#############################################################
mf.hbrdt<- mf.hbrdtl + mf.hbrdtm + mf.hbrdth

#############################################################
# Remove temporary matrices 
rm(ma.utsum,mf.utsum,mf.util)

### 8-district summaries

if (file.access("hbrdist.rpt", mode=0) == 0) {system ("rm hbrdist.rpt")}

distsum ("mf.hbrdt", "HBrec Distribution - Total", "ga", 3,
  "hbrdist", project, initials)
distsum ("mf.hbrdtl", "HBrec Distribution - LowInc", "ga", 3,
  "hbrdist", project, initials)
distsum ("mf.hbrdtm", "HBrec Distribution - MidInc", "ga", 3,
  "hbrdist", project, initials)
distsum ("mf.hbrdth", "HBrec Distribution - HighInc", "ga", 3,
  "hbrdist", project, initials)

