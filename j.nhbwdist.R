#j.nhbwdist.R 
# NHBW Distribution Model
# LOGSUMS WITH ONLY TRAVEL TIMES coeff from orig ms. NO constants.

westhill2east<-as.matrix(array(0,c(numzones,numzones)))
westhill2east[ensemble.gw==1,ensemble.gw==2]<-1
westhill2east[ensemble.gw==1,ensemble.gw==2]<-1
westhill2east[ensemble.gw==1,ensemble.gw==2]<-1
westhill2east[ensemble.gw==1,ensemble.gw==2]<-1

# Calculate Rest Employment Vector
ma.rest <- ma.afm + ma.mfg + ma.con + ma.fi + ma.tpu + ma.wt

# NHBW Total Productions
ms.nhwpr <- sum (ma.nhwpr)

#Calculate Shopping Center Employment
ma.shemp <- ma.shsqft/1000*3

# Calculate Retail Employment with Boosted Shopping Center Employees
ma.retail <- ma.ret*(ma.ret > ma.shemp) + ma.shemp*(ma.ret < ma.shemp)

# NHBW Production Utility
ma.nhwpu <- exp (log
  (ma.retail + 1.2263*ma.rest + 2.3955*ma.ser + 1.7828*ma.gov + 0.1427*ma.hh))

# NHBW Production Utility Summary
ms.nhws <- sum (ma.nhwpu)

# NHBW Productions
ma.nhwpu <- (ma.nhwpu/ms.nhws)*(ms.nhwpr)

# NHBW Distribution Utility
# Original Logsum Coeff(linear,square,cube) = 2.886, -0.3828, none
mf.util <- exp (sweep (2.874*mf.nhwls - 0.3828*(mf.nhwls^2) + 0.003828*(mf.nhwls^3)
                - 1.927*mf.waor - 1.154*mf.orwa - 0.2039*mf.we - (0.2039*0.625)*westhill2east - 0*mf.ew, 2, log (ma.retail 
                + 0.06911*ma.rest + 0.3160*ma.ser + 0.2360*ma.gov + 0.2089*ma.hh),"+"))
mf.util [mf.nhwls[,]==0] <- 0

# NHBW Distribution Utility Summary
ma.utsum <- apply (mf.util, 1, sum)

# NHBW Raw Distribution Matrix
mf.nhbwdt <- (mf.util / ma.utsum) * ma.nhwpu
mf.nhbwdt [ma.utsum==0] <- 0

# Delete temporary matrices
rm (ma.rest,ms.nhwpr,ms.nhws,mf.util,ma.utsum)

### 8-district summaries

if (file.access("nhbwdist.rpt", mode=0) == 0) {system ("rm nhbwdist.rpt")}

distsum ("mf.nhbwdt", "NHW Distribution", "ga", 3, 
  "nhbwdist", project, initials)

