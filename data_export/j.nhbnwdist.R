#j.nhbnwdist.R 
# NHBNW Distribution Model
# LOGSUMS WITH ONLY TRAVEL TIMES coeff from orig ms. NO constants.

westhill2east<-as.matrix(array(0,c(numzones,numzones)))
westhill2east[ensemble.gw==1,ensemble.gw==2]<-1
westhill2east[ensemble.gw==1,ensemble.gw==2]<-1
westhill2east[ensemble.gw==1,ensemble.gw==2]<-1
westhill2east[ensemble.gw==1,ensemble.gw==2]<-1

# Calculate Rest Employment Vector
ma.rest <- ma.afm + ma.mfg + ma.con + ma.fi + ma.tpu + ma.wt

# NHBNW Total Productions
ms.nhnwpr <- sum (ma.nhnwpr)

#Calculate Shopping Center Employment
ma.shemp <- ma.shsqft/1000*3

# Calculate Retail Employment with Boosted Shopping Center Employees
ma.retail <- ma.ret*(ma.ret > ma.shemp) + ma.shemp*(ma.ret < ma.shemp)

# NHBNW Production Utility
ma.nhnwpu <- exp (log
  (ma.retail + 0.05239*ma.rest + 0.5086*ma.ser + 0.3880*ma.gov))

# NHBNW Production Utility Summary
ms.nhnws <- sum (ma.nhnwpu)

# NHBNW Productions
ma.nhnwpu <- (ma.nhnwpu/ms.nhnws)*(ms.nhnwpr)

# NHBNW Distribution Utility
# Original Logsum Coeff(linear,square,cube) = 3.841, -0.7402, none
mf.util <- exp (sweep (3.741*mf.nhnwls - 0.8652*(mf.nhnwls^2) + 0.003402*(mf.nhnwls^3)
                - 1.796*mf.waor - 0.2155*mf.orwa - 0.2080*mf.we - (0.208*0.625)*westhill2east, 2,
                log(ma.retail + 0.01555*ma.rest +0.1125*ma.ser + 0.1877*ma.gov + 0.1722*ma.hh),"+"))
mf.util [mf.nhnwls[,]==0] <- 0

# NHBNW Distribution Utility Summary
ma.utsum <- apply (mf.util, 1, sum)

ma.nhbnwdcls <- log(ma.utsum)
save (ma.nhbnwdcls, file="ma.nhbnwdcls.dat")
write.table(ma.nhbnwdcls, sep=",", row.names=F, file="ma.nhbnwdcls.csv", col.names=c("nhbnwdcls"))
write.table(ma.nhnwpr, sep=",", row.names=F, file="ma.nhnwpr.csv", col.names=c("nhnwpr"))

# NHBNW Raw Distribution Matrix
mf.nhnwdt <- (mf.util / ma.utsum) * ma.nhnwpu
mf.nhnwdt [ma.utsum==0] <- 0

# Delete temporary matrices
rm (ma.rest,ms.nhnwpr,ms.nhnws,mf.util,ma.utsum)

### 8-district summaries

if (file.access("nhbnwdist.rpt", mode=0) == 0) {system ("rm nhbnwdist.rpt")}

distsum1 ("mf.nhnwdt", "NHNW Distribution", "ga", 3, 
  "nhbnwdist", project, initials)

