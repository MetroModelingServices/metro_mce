#j.hbsdist.R 
# HBS Destination Choice
# LOGSUMS WITH ONLY TRAVEL TIMES coeff from orig ms. NO constants.

#Needs the following input files from Emme2
# 1.  mf.waor
# 2.  mf.orwa  
# 3.  mf.ew
# 4.  mf.we 
# 5.  ma.shsqft
# 6.  employment files (ma.*)

#Needs the following matrices from generation
# 6.  ma.hbsprl
# 7.  ma.hbsprm
# 8.  ma.hbsprh

#Needs the following matrices from log sum
# 9.  mf.hslsl
#10.  mf.hslsm
#11.  mf.hslsh 

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


#############################################################
#  Low Income Raw Distribution                              #
#############################################################
#  Calculate Rest Employment for All Incomes' Utility     

ma.rest<-ma.afm + ma.mfg + ma.con + ma.fi + ma.gov + ma.tpu + ma.wt + ma.ser

# Original Logsum Coeff (linear, sq, cu) = (7.765, -2.801, 0.3179)
mf.util<-exp(sweep(7.595*((mf.hslsl + mf.hslsm + mf.hslsh)/3) -2.839*(((mf.hslsl + mf.hslsm + mf.hslsh)/3)^2)
                   + 0.3125*(((mf.hslsl + mf.hslsm + mf.hslsh)/3)^3)
                   - 0.6980*mf.waor - 1.873*mf.orwa - 0.4855*mf.we - (0.4855*0.625)*westhill2east - 0.2656*mf.ew -(0.2656*0.625)*east2westhill,
                   2,log(ma.retail + 0.008396*ma.rest + 0.022126*ma.hh),"+"))
ma.utsum<-apply(mf.util,1,sum)
mf.utsum<-matrix(ma.utsum,length(ma.utsum),length(ma.utsum))
mf.hbsdtl<-matrix(0,numzones,numzones)
mf.hbsdtl[mf.utsum!=0]<-mf.util[mf.utsum!=0]/mf.utsum[mf.utsum!=0]
mf.hbsdtl<-sweep(mf.hbsdtl,1,ma.hbsprl,"*")


#############################################################
#  Middle Income Raw Distribution                           #
#############################################################
ma.rest<-ma.afm + ma.mfg + ma.con + ma.fi + ma.gov + ma.tpu + ma.wt

# Original Logsum Coeff (linear, sq, cu) = (7.765, -2.801, 0.3179)
mf.util<-exp(sweep(7.595*((mf.hslsl + mf.hslsm + mf.hslsh)/3) -2.839*(((mf.hslsl + mf.hslsm + mf.hslsh)/3)^2)
                   + 0.3125*(((mf.hslsl + mf.hslsm + mf.hslsh)/3)^3)
                   - 0.6980*mf.waor - 1.873*mf.orwa - 0.4855*mf.we  - (0.4855*0.625)*westhill2east - 0.2656*mf.ew -(0.2656*0.625)*east2westhill,
                   2,log(ma.retail + 0.008396*ma.rest + 0.022126*ma.hh),"+"))
ma.utsum<-apply(mf.util,1,sum)
mf.utsum<-matrix(ma.utsum,length(ma.utsum),length(ma.utsum))
mf.hbsdtm<-matrix(0,numzones,numzones)
mf.hbsdtm[mf.utsum!=0]<-mf.util[mf.utsum!=0]/mf.utsum[mf.utsum!=0]
mf.hbsdtm<-sweep(mf.hbsdtm,1,ma.hbsprm,"*")


#############################################################
#  High Income Raw Distribution                             #
#############################################################
ma.rest<-ma.afm + ma.mfg + ma.con + ma.fi + ma.gov + ma.tpu + ma.wt

# Original Logsum Coeff (linear, sq, cu) = (7.765, -2.801, 0.3179)
mf.util<-exp(sweep(7.595*((mf.hslsl + mf.hslsm + mf.hslsh)/3) -2.839*(((mf.hslsl + mf.hslsm + mf.hslsh)/3)^2)
                   + 0.3125*(((mf.hslsl + mf.hslsm + mf.hslsh)/3)^3)
                   - 0.6980*mf.waor - 1.873*mf.orwa - 0.4855*mf.we - (0.4855*0.625)*westhill2east - 0.2656*mf.ew -(0.2656*0.625)*east2westhill,
                   2,log(ma.retail + 0.008396*ma.rest + 0.022126*ma.hh),"+"))
ma.utsum<-apply(mf.util,1,sum)
mf.utsum<-matrix(ma.utsum,length(ma.utsum),length(ma.utsum))
mf.hbsdth<-matrix(0,numzones,numzones)
mf.hbsdth[mf.utsum!=0]<-mf.util[mf.utsum!=0]/mf.utsum[mf.utsum!=0]
mf.hbsdth<-sweep(mf.hbsdth,1,ma.hbsprh,"*")


#############################################################
#  Calculate Total HBshop Distributions                        #
#############################################################
mf.hbsdt<- mf.hbsdtl + mf.hbsdtm + mf.hbsdth

#############################################################
# Remove temporary matrices 
rm(ma.rest,ma.utsum,mf.utsum,mf.util,numzones)

### 8-district summaries

if (file.access("hbsdist.rpt", mode=0) == 0) {system ("rm hbsdist.rpt")}

distsum ("mf.hbsdt", "HBshop Distribution - Total", "ga", 3,
  "hbsdist", project, initials)
distsum ("mf.hbsdtl", "HBshop Distribution - LowInc", "ga", 3,
  "hbsdist", project, initials)
distsum ("mf.hbsdtm", "HBshop Distribution - MidInc", "ga", 3,
  "hbsdist", project, initials)
distsum ("mf.hbsdth", "HBshop Distribution - HighInc", "ga", 3,
  "hbsdist", project, initials)

