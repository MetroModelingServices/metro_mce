import shutil, os
import pandas as pd
import numpy as np

# Define time periods
time_periods = [str(i).zfill(2) + str(i + 1).zfill(2) for i in range(24)]

pk_periods = ['0708', '0809', '1617', '1718']

# Copy all files from 0001 time period to output folder
copy_folder = 'output_0001'
for file_name in os.listdir(copy_folder):
    full_name = os.path.join(os.getcwd(), copy_folder, file_name)
    if os.path.isfile(full_name):
        shutil.copy(full_name, os.path.join(os.getcwd(), 'output'))

final_aggregate_od_district_summary_file = 'final_aggregate_od_district_summary.csv'
final_aggregate_od_district_summary_agg_file = 'final_aggregate_od_district_summary_agg.csv'
final_aggregate_od_zone_summary_file = 'final_aggregate_od_zone_summary.csv'
final_aggregate_od_zone_summary_agg_file = 'final_aggregate_od_zone_summary_agg.csv'
trace_aggregate_od_file = 'trace.aggregate_od.csv'
final_aggregate_results_file = 'final_aggregate_results.csv'

final_aggregate_od_district_summary_df = pd.DataFrame()
final_aggregate_od_zone_summary_df = pd.DataFrame()
trace_aggregate_od_df = pd.DataFrame()
final_aggregate_results_df = pd.DataFrame()
final_agg_results_pk = pd.DataFrame()
final_agg_results_op = pd.DataFrame()
agg_variables = ['aggregate_od']
final_results_variables = pd.read_csv(os.path.join(os.getcwd(), copy_folder,
							final_aggregate_results_file), usecols=['Processor', 'Target'])
agg_od_results = final_results_variables[final_results_variables.Processor=='aggregate_od'].Target.values.tolist()
annual_trip_variables = pd.read_csv(os.path.join(os.getcwd(), copy_folder,
							final_aggregate_od_district_summary_file), nrows=0).columns.tolist()
annual_trip_variables = [temp_var for temp_var in annual_trip_variables if 'annual' in temp_var]
# agg_od_results = agg_od_results + annual_trip_variables

idx = pd.IndexSlice

for time_period in time_periods:
    print('Time period {}'.format(time_period))
    if final_aggregate_od_district_summary_df.shape[0] == 0:
        final_aggregate_od_district_summary_df = pd.read_csv(os.path.join(os.getcwd(),
                                                                          'output_' + time_period,
                                                                          final_aggregate_od_district_summary_file))
        final_aggregate_od_district_summary_df['time_period'] = time_period
    else:
        s_final_aggregate_od_district_summary_df = pd.read_csv(os.path.join(os.getcwd(),
                                                                            'output_' + time_period,
                                                                            final_aggregate_od_district_summary_file))
        s_final_aggregate_od_district_summary_df['time_period'] = time_period
        final_aggregate_od_district_summary_df = pd.concat([final_aggregate_od_district_summary_df,
                                                            s_final_aggregate_od_district_summary_df],
                                                           axis=0)

    if final_aggregate_od_zone_summary_df.shape[0] == 0:
        final_aggregate_od_zone_summary_df = pd.read_csv(os.path.join(os.getcwd(),
                                                                      'output_' + time_period,
                                                                      final_aggregate_od_zone_summary_file))
        final_aggregate_od_zone_summary_df['time_period'] = time_period

    else:
        s_final_aggregate_od_zone_summary_df = pd.read_csv(os.path.join(os.getcwd(),
                                                                        'output_' + time_period,
                                                                        final_aggregate_od_zone_summary_file))
        s_final_aggregate_od_zone_summary_df['time_period'] = time_period
        final_aggregate_od_zone_summary_df = pd.concat([final_aggregate_od_zone_summary_df,
                                                        s_final_aggregate_od_zone_summary_df],
                                                       axis=0)

    if trace_aggregate_od_df.shape[0] == 0:
        trace_aggregate_od_df = pd.read_csv(os.path.join(os.getcwd(),
                                                         'output_' + time_period,
                                                         trace_aggregate_od_file))
        idxFrom = np.max(trace_aggregate_od_df[trace_aggregate_od_df.label == 'index'].index)
        idxTo = trace_aggregate_od_df.shape[0]
        trace_aggregate_od_df = trace_aggregate_od_df.loc[idxFrom:idxTo, ]
        trace_aggregate_od_df = trace_aggregate_od_df.set_index('label')
        trace_aggregate_od_df.columns = trace_aggregate_od_df.columns+'_'+time_period

    else:
        s_trace_aggregate_od_df = pd.read_csv(os.path.join(os.getcwd(),
                                                           'output_' + time_period,
                                                           trace_aggregate_od_file))
        idxFrom = np.max(s_trace_aggregate_od_df[s_trace_aggregate_od_df.label == 'index'].index)
        idxTo = s_trace_aggregate_od_df.shape[0]
        s_trace_aggregate_od_df = s_trace_aggregate_od_df.loc[idxFrom:idxTo, ]
        s_trace_aggregate_od_df = s_trace_aggregate_od_df.set_index('label')
        s_trace_aggregate_od_df.columns = s_trace_aggregate_od_df.columns+'_'+time_period
        # trace_aggregate_od_df = pd.concat([trace_aggregate_od_df,
        #                                    s_trace_aggregate_od_df],
        #                                   axis=1, ignore_index=False)
        trace_aggregate_od_df = pd.merge(trace_aggregate_od_df, s_trace_aggregate_od_df,
                                         left_index=True, right_index=True, how='outer')
    if final_aggregate_results_df.shape[0] == 0:
        final_aggregate_results_df = pd.read_csv(os.path.join(os.getcwd(),
                                                              'output_' + time_period,
                                                              final_aggregate_results_file))
        agg_var = [var for var in agg_variables if var in final_aggregate_results_df.Processor.unique()]
        final_aggregate_results_df = final_aggregate_results_df.set_index(['Processor', 'Target', 'Description'])

        if time_period in pk_periods:
            final_agg_results_pk = final_aggregate_results_df.loc[idx[agg_var, :, :], ]
            final_agg_results_op = final_agg_results_pk.copy()
            for col in final_agg_results_op.columns:
                final_agg_results_op[col].values[:] = 0
        else:
            final_agg_results_op = final_aggregate_results_df.loc[idx[agg_var, :, :], ]
            final_agg_results_pk = final_agg_results_op.copy()
            for col in final_agg_results_pk.columns:
                final_agg_results_pk[col].values[:] = 0

    else:
        s_final_aggregate_results_df = pd.read_csv(os.path.join(os.getcwd(),
                                                                'output_' + time_period,
                                                                final_aggregate_results_file))
        s_final_aggregate_results_df = s_final_aggregate_results_df.set_index(['Processor', 'Target', 'Description'])
        result_df = final_aggregate_results_df.loc[idx[agg_var, :, :], ] + \
                    s_final_aggregate_results_df.loc[idx[agg_var, :, :], ]
        final_aggregate_results_df.loc[idx[agg_var, :, :]] = result_df
        if time_period in pk_periods:
            final_agg_results_pk = final_agg_results_pk.loc[idx[agg_var, :, :], ] + \
                    s_final_aggregate_results_df.loc[idx[agg_var, :, :], ]
        else:
            final_agg_results_op = final_agg_results_op.loc[idx[agg_var, :, :], ] + \
                    s_final_aggregate_results_df.loc[idx[agg_var, :, :], ]


# Combine the peak and offpeak results with total results
final_aggregate_results_df = pd.merge(final_aggregate_results_df,
                                      final_agg_results_pk,
                                      left_index=True, right_index=True,
                                      how='left', suffixes=("", "_pk"))
final_aggregate_results_df = pd.merge(final_aggregate_results_df,
                                      final_agg_results_op,
                                      left_index=True, right_index=True,
                                      how='left', suffixes=("", "_op"))

final_aggregate_od_district_summary_df.to_csv(os.path.join(os.getcwd(), 'output',
                                                           final_aggregate_od_district_summary_file),
                                              index=False,
                                              chunksize=1E6)

final_aggregate_od_district_summary_agg_df = final_aggregate_od_district_summary_df.groupby(['orig','dest'])[agg_od_results].agg(sum)
final_aggregate_od_district_summary_agg_df = final_aggregate_od_district_summary_df[final_aggregate_od_district_summary_df.time_period.isin(['0001','0708'])].\
                                                groupby(['orig','dest'])[annual_trip_variables].agg(sum).\
                                                join(final_aggregate_od_district_summary_agg_df, how='outer').reset_index()

final_aggregate_od_district_summary_agg_df.to_csv(os.path.join(os.getcwd(), 'output',
                                                           final_aggregate_od_district_summary_agg_file),
                                              index=False,
                                              chunksize=1E6)

final_aggregate_od_zone_summary_df.to_csv(os.path.join(os.getcwd(), 'output',
                                                       final_aggregate_od_zone_summary_file),
                                          index=False,
                                          chunksize=1E6)

final_aggregate_od_zone_summary_agg_df = final_aggregate_od_zone_summary_df.groupby(['orig'])[agg_od_results].agg(sum)
final_aggregate_od_zone_summary_agg_df = final_aggregate_od_zone_summary_df[final_aggregate_od_zone_summary_df.time_period.isin(['0001','0708'])].\
                                                groupby(['orig'])[annual_trip_variables].agg(sum).\
                                                join(final_aggregate_od_zone_summary_agg_df, how='outer').reset_index()

final_aggregate_od_zone_summary_agg_df.to_csv(os.path.join(os.getcwd(), 'output',
                                                           final_aggregate_od_zone_summary_agg_file),
                                              index=False,
                                              chunksize=1E6)

trace_aggregate_od_df.to_csv(os.path.join(os.getcwd(), 'output',
                                          trace_aggregate_od_file),
                             index=True,
                             chunksize=1E6)

final_aggregate_results_df.to_csv(os.path.join(os.getcwd(), 'output',
                                               final_aggregate_results_file),
                                  index=True,
                                  chunksize=1E6)

