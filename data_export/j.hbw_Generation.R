#j.hbw_Generation.R

source(commandArgs()[length(commandArgs())])

stage <- 'Generation'
source(paste(R.path, "j.matrices_in_stage.R", sep='/'))

#  Pre Generation
source(paste(R.path, "access.R", sep='/'))
save(ma.mixrhm,file="ma.mixrhm.dat")
save(ma.mixthm,file="ma.mixthm.dat")

source(paste(R.path, "j.whia.R", sep='/'))
   save (mf.w0hia, file="mf.w0hia.dat")
   save (mf.w1hia, file="mf.w1hia.dat")
   save (mf.w2hia, file="mf.w2hia.dat")
   save (mf.w3hia, file="mf.w3hia.dat")

source(paste(R.path, "j.chwi.R", sep='/'))
   save (mf.cval, file="mf.cval.dat")
# mf.cval column order, by hia: c <# cars> w <# workers>
# CVAL0 (mf.cval[,1:256]) = c0w0, c0w1, c0w2, c0w3
# CVAL1 (mf.cval[,257:448]) = c1w2, c1w3, c2w3
# CVAL2 (mf.cval[,449:640]) = c1w1, c2w2, c3w3 
# CVAL3 (mf.cval[,641:1024])= c1w0, c2w0, c2w1, c3w0, c3w1, c3w2
write.table(mf.cval, sep=",", row.names=F, file="mf.cval.csv")

####  Calculate auto and transit composite skims for lot choice later
###source(paste(R.path, "j.hbwpnrSkims.R", sep='/'))
###
####  Likely Lots for Lot Choice
###source(paste(R.path, "j.likelyLots.R", sep='/'))

#  Generation
source(paste(R.path, "j.hbwgen.R", sep='/'))

source(paste(R.path, "j.GenerationCleanup.R", sep='/'))

memory.size(max=TRUE)
