# metro_mce
Metro MCE

# Data Export Scripts 

## R scripts

The R scripts are revisions to the demand model in order to write out 
destination choice logsums and the CVAL array - HIAs by car ownership for each TAZ

```
mf.cval column order, by hia: c <# cars> w <# workers>
CVAL0 (mf.cval[,1:256]) = c0w0, c0w1, c0w2, c0w3
CVAL1 (mf.cval[,257:448]) = c1w2, c1w3, c2w3
CVAL2 (mf.cval[,449:640]) = c1w1, c2w2, c3w3 
CVAL3 (mf.cval[,641:1024])= c1w0, c2w0, c2w1, c3w0, c3w1, c3w2
```

## Python

ExportLinkResultsToCSV.py writes out EMME link assignment results to a CSV file

## Batch 

bca_EMME_Export.bat exports all the required full matrices and also calls 
ExportLinkResultsToCSV.py.  This script requires [EMXtoOMX.py](https://github.com/bstabler/EMXtoOMX)
