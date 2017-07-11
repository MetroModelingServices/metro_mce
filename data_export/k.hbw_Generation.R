#k.hbw_Generation.R

if (length(commandArgs(TRUE)) > 0) { source(commandArgs()[length(commandArgs())]) }

stage <- 'Generation'
source(paste(R.path, "k.matrices_in_stage.R", sep='/'))

#  Pre Generation
source(paste(R.path, "access.R", sep='/'))
save(ma.mixrhm,file="ma.mixrhm.dat")
save(ma.mixthm,file="ma.mixthm.dat")
save(ma.tot30t,file="ma.tot30t.dat")

source(paste(R.path, "k.whia.R", sep='/'))
   save (mf.w0hia, file="mf.w0hia.dat")
   save (mf.w1hia, file="mf.w1hia.dat")
   save (mf.w2hia, file="mf.w2hia.dat")
   save (mf.w3hia, file="mf.w3hia.dat")

source(paste(R.path, "k.chwi.R", sep='/'))
   save (mf.cval, file="mf.cval.dat")

### write mce cval file
colnames = expand.grid(paste("a",seq(1:4),sep=""), paste("i",seq(1:4),sep=""), paste("h",seq(1:4),sep=""), paste("w",seq(1:4),sep=""), paste("c",seq(1:4),sep=""))
colnames = apply(colnames, 1, function(x) paste(x, collapse=""))
colnames(mf.cval) = colnames
write.table(mf.cval, sep=",", row.names=F, file="mf.cval.csv")

####  Calculate auto and transit composite skims for lot choice later
###source(paste(R.path, "k.hbwpnrSkims.R", sep='/'))
###
####  Likely Lots for Lot Choice
###source(paste(R.path, "k.likelyLots.R", sep='/'))

#  Generation
source(paste(R.path, "k.hbwgen.R", sep='/'))

source(paste(R.path, "k.GenerationCleanup.R", sep='/'))

memory.size(max=TRUE)
