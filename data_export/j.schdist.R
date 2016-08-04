#j.schdist.R
# SCHOOL Destination Choice

#Needs the following input files from Emme2
# 1.  mf.mdhtt

#Needs the following matrices from generation
# 2.  ma.schpr
# 3.  ma.schat

#############################################################
#  Bring in ga ensemble: 8 district Lookup                  #
#############################################################

zones <- vector()
for (i in 1:numzones) {
  zones [i] <- i
}

dist157zones <- zones [ensemble.ga==1 | ensemble.ga==5 | ensemble.ga==7]
dist23zones <- zones [ensemble.ga==2 | ensemble.ga==3]
dist46zones <- zones [ensemble.ga==4 | ensemble.ga==6]
dist8zones <- zones [ensemble.ga==8]


#############################################################
#  Raw Distribution                                         #
#############################################################

# Initialize Utility matrix
numzones <- length(ma.schpr)
mf.util <- matrix(0,numzones,numzones)

# SCHOOL Distribution Utility For "City" area
mf.util[dist157zones,dist157zones] <- exp (sweep ( -0.60*mf.mdhtt[dist157zones,dist157zones] + 0.012*
                                                         mf.mdhtt[dist157zones,dist157zones]^2, 2,  
                                                         log(ma.schat[dist157zones]), "+"))

# SCHOOL Distribution Utility For "West Suburb" Area
mf.util[dist23zones,dist23zones] <- exp (sweep ( -0.60*mf.mdhtt[dist23zones,dist23zones] + 0.012*
                                                         mf.mdhtt[dist23zones,dist23zones]^2, 2,
                                                         log(ma.schat[dist23zones]), "+"))

# SCHOOL Distribution Utility For "East Suburb" Area
mf.util[dist46zones,dist46zones] <- exp (sweep ( -0.60*mf.mdhtt[dist46zones,dist46zones] + 0.012*
                                                         mf.mdhtt[dist46zones,dist46zones]^2, 2,
                                                         log(ma.schat[dist46zones]), "+"))

# SCHOOL Distribution Utility For "Clark County" Area
mf.util[dist8zones,dist8zones] <- exp (sweep ( -0.60*mf.mdhtt[dist8zones,dist8zones] + 0.012*
                                                         mf.mdhtt[dist8zones,dist8zones]^2, 2,
                                                         log(ma.schat[dist8zones]), "+"))





# Replace NaN's with zeros...These are the cases where ma.schat = 0 (Cannot nat. log 0)
#mf.util[mf.util[,]=="NaN"] <- 0
mf.util[!is.finite(mf.util[])]<-0

# Replace utility with 0 if Travel Time > 30 minutes
mf.util[mf.mdhtt[,]>30]<-0

# Distribution Utility Summary
ma.utsum <- apply (mf.util, 1, sum)

ma.schdcls <- log(ma.utsum)
save (ma.schdcls, file="ma.schdcls.dat")
write.table(ma.schdcls, sep=",", row.names=F, file="ma.schdcls.csv", col.names=c("schdcls"))

mf.utsum <- matrix(ma.utsum,length(ma.utsum),length(ma.utsum))

# SCHOOL Raw Distribution Matrix
mf.schdt <- matrix(0,numzones,numzones)
mf.schdt[mf.utsum!=0] <- mf.util[mf.utsum!=0]/mf.utsum[mf.utsum!=0] 
mf.schdt<-sweep(mf.schdt,1,ma.schpr,"*")


# Remove temporary matrices
rm(mf.util,mf.utsum,ma.utsum,dist157zones,dist23zones,dist46zones,dist8zones)

if (file.access("schdist.rpt", mode=0) == 0) {system ("rm schdist.rpt")}

distsum ("mf.schdt", "School Distribution", "ga", 3, 
  "schdist", project, initials)

