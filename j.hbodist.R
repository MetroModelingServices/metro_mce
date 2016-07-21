#j.hbodist.R
# HBO Destination Choice
# LOGSUMS WITH ONLY TRAVEL TIMES coeff from orig ms. NO constants.

#Needs the following input files from Emme2
# 1.  mf.waor
# 2.  mf.orwa  
# 3.  mf.ew
# 4.  mf.we 
# 5.  ma.shsqft

#Needs the following matrices from generation
# 6.  ma.hboprl
# 7.  ma.hboprm
# 8.  ma.hboprh

#Needs the following matrices from log sum
# 9.  mf.holsl
#10.  mf.holsm
#11.  mf.holsh 

westhill2east<-as.matrix(array(0,c(numzones,numzones)))
westhill2east[ensemble.gw==1,ensemble.gw==2]<-1
westhill2east[ensemble.gw==1,ensemble.gw==2]<-1
westhill2east[ensemble.gw==1,ensemble.gw==2]<-1
westhill2east[ensemble.gw==1,ensemble.gw==2]<-1

#Calculate Shopping Center Employment
ma.shemp<-ma.shsqft/1000*3

#Compare Shopping Center Employment w/ Retail Employment; use greater of the two
ma.retail<-(ma.ret*(ma.ret >= ma.shemp))+(ma.shemp*(ma.ret< ma.shemp))


#############################################################
#  Low Income Raw Distribution                              #
#############################################################
ma.rest<-ma.afm+ma.mfg+ma.con+ma.fi+ma.tpu+ma.wt
# Original Logsum coeff(linear, sq, cu) = 6.586, -2.274, 0.2505
mf.util<-exp(sweep(6.476*((mf.holsl + mf.holsm + mf.holsh)/3) - 2.284*(((mf.holsl + mf.holsm + mf.holsh)/3)^2)
                   + 0.2505*(((mf.holsl + mf.holsm + mf.holsh)/3)^3)
                   - 1.360*mf.waor - 1.546*mf.orwa - 0.4560*mf.we - (0.456*0.625)*westhill2east - 0.0000*mf.ew, 
                   2,log(ma.retail + 0.6419*ma.ser + 0.6109*ma.gov + 0.2393*ma.hh + 0.06802*ma.rest),"+"))
ma.utsum<-apply(mf.util,1,sum)
mf.utsum<-matrix(ma.utsum,length(ma.utsum),length(ma.utsum))
mf.hbodtl<-matrix(0,numzones,numzones)
mf.hbodtl[mf.utsum!=0]<-mf.util[mf.utsum!=0]/mf.utsum[mf.utsum!=0]
mf.hbodtl<-sweep(mf.hbodtl,1,ma.hboprl,"*")


#############################################################
#  Middle Income Raw Distribution                           #
#############################################################
ma.rest<-ma.afm+ma.mfg+ma.con+ma.fi+ma.tpu+ma.wt
# Original Logsum coeff(linear, sq, cu) = 6.586, -2.274, 0.2505
mf.util<-exp(sweep(6.476*((mf.holsl + mf.holsm + mf.holsh)/3) - 2.284*(((mf.holsl + mf.holsm + mf.holsh)/3)^2)
                   + 0.2505*(((mf.holsl + mf.holsm + mf.holsh)/3)^3)
                   - 1.360*mf.waor - 1.546*mf.orwa - 0.4560*mf.we  - (0.456*0.625)*westhill2east - 0.0000*mf.ew, 
                   2,log(ma.retail + 0.6419*ma.ser + 0.6109*ma.gov + 0.2393*ma.hh + 0.06802*ma.rest),"+"))
ma.utsum<-apply(mf.util,1,sum)
mf.utsum<-matrix(ma.utsum,length(ma.utsum),length(ma.utsum))
mf.hbodtm<-matrix(0,numzones,numzones)
mf.hbodtm[mf.utsum!=0]<-mf.util[mf.utsum!=0]/mf.utsum[mf.utsum!=0]
mf.hbodtm<-sweep(mf.hbodtm,1,ma.hboprm,"*")


#############################################################
#  High Income Raw Distribution                             #
#############################################################
ma.rest<-ma.afm+ma.mfg+ma.con+ma.fi+ma.tpu+ma.wt
# Original Logsum coeff(linear, sq, cu) = 6.586, -2.274, 0.2505
mf.util<-exp(sweep(6.476*((mf.holsl + mf.holsm + mf.holsh)/3) - 2.284*(((mf.holsl + mf.holsm + mf.holsh)/3)^2)
                   + 0.2505*(((mf.holsl + mf.holsm + mf.holsh)/3)^3)
                   - 1.360*mf.waor - 1.546*mf.orwa - 0.4560*mf.we  - (0.456*0.625)*westhill2east - 0.0000*mf.ew, 
                   2,log(ma.retail + 0.6419*ma.ser + 0.6109*ma.gov + 0.2393*ma.hh + 0.06802*ma.rest),"+"))
ma.utsum<-apply(mf.util,1,sum)
mf.utsum<-matrix(ma.utsum,length(ma.utsum),length(ma.utsum))
mf.hbodth<-matrix(0,numzones,numzones)
mf.hbodth[mf.utsum!=0]<-mf.util[mf.utsum!=0]/mf.utsum[mf.utsum!=0]
mf.hbodth<-sweep(mf.hbodth,1,ma.hboprh,"*")


#############################################################
#  Calculate Total HBO Distributions                        #
#############################################################
mf.hbodt<- mf.hbodtl + mf.hbodtm + mf.hbodth

#############################################################
# Remove temporary matrices 
rm(ma.rest,ma.utsum,mf.utsum,mf.util)

### 8-district summaries

if (file.access("hbodist.rpt", mode=0) == 0) {system ("rm hbodist.rpt")}

distsum ("mf.hbodt", "HBoth Distribution - Total", "ga", 3,
  "hbodist", project, initials)
distsum ("mf.hbodtl", "HBoth Distribution - LowInc", "ga", 3,
  "hbodist", project, initials)
distsum ("mf.hbodtm", "HBoth Distribution - MidInc", "ga", 3,
  "hbodist", project, initials)
distsum ("mf.hbodth", "HBoth Distribution - HighInc", "ga", 3,
  "hbodist", project, initials)

