import shutil, os
import pandas as pd

# Define time periods
time_periods = [str(i).zfill(2) + str(i + 1).zfill(2) for i in range(24)]

# Copy all files from 1617 time period to output folder
copy_folder = 'output_1617'
for file_name in os.listdir(copy_folder):
    full_name = os.path.join(os.getcwd(), copy_folder, file_name)
    if os.path.isfile(full_name):
        shutil.copy(full_name, os.path.join(os.getcwd(), 'output'))


final_aggregate_od_district_summary_file = 'final_aggregate_od_district_summary.csv'
final_aggregate_od_zone_summary_file = 'final_aggregate_od_zone_summary.csv'
trace_aggregate_od_file = 'trace.aggregate_od.csv'
final_aggregate_results_file = 'final_aggregate_results.csv'

final_aggregate_od_district_summary_df = pd.DataFrame()
final_aggregate_od_zone_summary_df = pd.DataFrame()
trace_aggregate_od_df = pd.DataFrame()
final_aggregate_results_df = pd.DataFrame()

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
        trace_aggregate_od_df = trace_aggregate_od_df.set_index('label')
        trace_aggregate_od_df.columns = trace_aggregate_od_df.columns+'_'+time_period

    else:
        s_trace_aggregate_od_df = pd.read_csv(os.path.join(os.getcwd(),
                                                           'output_' + time_period,
                                                           trace_aggregate_od_file))
        s_trace_aggregate_od_df = s_trace_aggregate_od_df.set_index('label')
        s_trace_aggregate_od_df.columns = s_trace_aggregate_od_df.columns+'_'+time_period
        trace_aggregate_od_df = pd.concat([trace_aggregate_od_df,
                                           s_trace_aggregate_od_df],
                                          axis=1, ignore_index=False)
    if final_aggregate_results_df.shape[0] == 0:
        final_aggregate_results_df = pd.read_csv(os.path.join(os.getcwd(),
                                                              'output_' + time_period,
                                                              final_aggregate_results_file))
        final_aggregate_results_df = final_aggregate_results_df.set_index(['Processor', 'Target', 'Description'])

    else:
        s_final_aggregate_results_df = pd.read_csv(os.path.join(os.getcwd(),
                                                                'output_' + time_period,
                                                                final_aggregate_results_file))
        s_final_aggregate_results_df = s_final_aggregate_results_df.set_index(['Processor', 'Target', 'Description'])
        result_df = final_aggregate_results_df.loc[idx['aggregate_od', :, :],] + \
                    s_final_aggregate_results_df.loc[idx['aggregate_od', :, :],]
        final_aggregate_results_df.loc[idx['aggregate_od', :, :]] = result_df


final_aggregate_od_district_summary_df.to_csv(os.path.join(os.getcwd(), 'output',
                                                           final_aggregate_od_district_summary_file),
                                              index=False,
                                              chunksize=1E6)
final_aggregate_od_zone_summary_df.to_csv(os.path.join(os.getcwd(), 'output',
                                                       final_aggregate_od_zone_summary_file),
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
