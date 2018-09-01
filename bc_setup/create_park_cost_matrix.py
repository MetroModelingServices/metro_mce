
#convert parking vectors to destination matrices for aggregate od processor

import pandas as pd
import numpy as np
import openmatrix as omx

base_filename = "data/base-data/mce_zone_vectors.csv"
base_matname = "data/base-data/mce_input_parking_costs.omx"
base_data = pd.read_csv(base_filename)
base_omx_file = omx.open_file(base_matname,'w')
base_omx_file['ltpkg'] = np.tile(base_data.ltpkg, len(base_data)).reshape((len(base_data),len(base_data)))
base_omx_file['stpkg'] = np.tile(base_data.stpkg, len(base_data)).reshape((len(base_data),len(base_data)))
base_omx_file.close()

build_filename = "data/build-data/mce_zone_vectors.csv"
build_matname = "data/build-data/mce_input_parking_costs.omx"
build_data = pd.read_csv(build_filename)
build_omx_file = omx.open_file(build_matname,'w')
build_omx_file['ltpkg'] = np.tile(build_data.ltpkg, len(build_data)).reshape((len(build_data),len(build_data)))
build_omx_file['stpkg'] = np.tile(build_data.stpkg, len(build_data)).reshape((len(build_data),len(build_data)))
build_omx_file.close()
