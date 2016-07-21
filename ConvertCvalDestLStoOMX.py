
#Convert Cval and Destination Choice Logsums to OMX
#Ben Stabler, ben.stabler@rsginc.com, 07/18/16
#Arguments: proj_dir cval_mfnum dcls_mostartnum
#SET EMMEPY="C:\Program Files\INRO\Emme\Emme 4\Emme-4.2.5\Python27\python.exe"
#Example call: %EMMEPY% ConvertCvalDestLStoOMX.py C:\projects\metromce\testing\2040NB_Base 100 100
######################################################################

#load libraries
import sys, os.path, os, omx, pandas, numpy

#run command line version
if __name__ == "__main__":

    #get command line arguments
    proj_dir = sys.argv[1]
    cval_mfnum = sys.argv[2]
    dcls_mostartnum = sys.argv[3]
    cval_filename = "model_hbw/mf.cval.csv"
    dcls_filenames = ["model_hbw/ma.hbwldcls.csv",
      "model_hbw/ma.hbwmdcls.csv",
      "model_hbw/ma.hbwhdcls.csv",
      "model_hbs/ma.hbsldcls.csv",
      "model_hbs/ma.hbsmdcls.csv",
      "model_hbs/ma.hbshdcls.csv",
      "model_hbr/ma.hbrldcls.csv",
      "model_hbr/ma.hbrmdcls.csv",
      "model_hbr/ma.hbrhdcls.csv",
      "model_hbo/ma.hboldcls.csv",
      "model_hbo/ma.hbomdcls.csv",
      "model_hbo/ma.hbohdcls.csv",
      "model_sc/ma.hbcdcls.csv",
      "model_sc/ma.schdcls.csv",
      "model_nh/ma.nhbnwdcls.csv",
      "model_nh/ma.nhbwdcls.csv"]
    omx_mf_filename = "model_hbw/mfs.omx"
    omx_mo_filename = "model_hbw/mos.omx"
    
    #create cval matrix
    cval_filename = os.path.join(proj_dir, cval_filename)
    cvalTable = pandas.read_csv(cval_filename)
    cvalMat = cvalTable.as_matrix()
    nrow,ncol = cvalTable.shape
    extra_zeros_mat = numpy.zeros([nrow,nrow-ncol])
    cvalMat = numpy.append(cvalMat, extra_zeros_mat, 1)
    
    omx_mf_filename = os.path.join(proj_dir, omx_mf_filename)
    omxFile = omx.openFile(omx_mf_filename,"a")
    omxFile["mf" + cval_mfnum + "_cval"] = cvalMat
    
    zones = range(1,nrow+1)
    omxFile.createMapping('zone_number', zones)
    
    omxFile.close()
    print(cval_filename + " -> " + omx_mf_filename)
    
    #create destination choice logsums mos
    omx_mo_filename = os.path.join(proj_dir, omx_mo_filename)
    omxFile = omx.openFile(omx_mo_filename,"a")
    for aDCLS in dcls_filenames:
      aDCLS  = os.path.join(proj_dir, aDCLS )
      dcls = pandas.read_csv(aDCLS)
      mo_name = os.path.basename(aDCLS).replace(".csv","").replace("ma.","").replace("dc","")
      omxFile["mo" + dcls_mostartnum + "_" + mo_name] = dcls.as_matrix()
      dcls_mostartnum = str(int(dcls_mostartnum) + 1)
      print(aDCLS + " -> " + omx_mo_filename)
      
    zones = range(1,nrow+1)
    omxFile.createMapping('zone_number', zones)
    
    omxFile.close()