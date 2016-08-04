# j.colldist.R
# College Distribution Model
# no change from EDNA
# LOGSUMS WITH ONLY TRAVEL TIMES coeff from orig ms. NO constants.

# College Distribution Utility
mf.collat <- matrix (ma.collat, length(ma.collat), length(ma.collat), byrow=T)
mf.util <- exp (2.50*mf.hbcls - 0.6*(mf.hbcls^2) + 0.004*(mf.hbcls^3) + log(mf.collat))
mf.util [mf.collat[,]==0] <- 0
rm (mf.collat)

# College Distribution Utility Summary
ma.utsum <- apply (mf.util, 1, sum)
ma.hbcdcls <- log(ma.utsum)
save (ma.hbcdcls, file="ma.hbcdcls.dat")
write.table(ma.hbcdcls, sep=",", row.names=F, file="ma.hbcdcls.csv", col.names=c("hbcdcls"))

# College Raw Distribution Matrix
mf.colldt <- (mf.util / ma.utsum) * ma.collpr
mf.colldt [mf.util[,]==0] <- 0

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
source(paste(R.path, "j.balance.R", sep='/'))
mf.colldt <- balance (mf.colldt,ma.collpr,ma.collat,100)

# Delete temporary matrices
rm (mf.util, ma.utsum)

if (file.access("hbcdist.rpt", mode=0) == 0) {system ("rm hbcdist.rpt")}

distsum ("mf.colldt", "College Distribution", "ga", 3, "hbcdist", 
  project, initials)

