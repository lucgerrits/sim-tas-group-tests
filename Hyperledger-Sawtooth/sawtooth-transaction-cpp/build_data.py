#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
@author: luc
"""

import os
import pandas as pd
import numpy as np
import glob
import pylab as pl
from matplotlib import cm
from scipy.ndimage.filters import gaussian_filter1d

#%%
#global variables:
data_path = "./datas"
final_df = None
#detect_benchmarks_on="commits"
#initialization_threshold=1000 #500*2 tx commits for init in our case
#detect_benchmark_threshold=3000 #commits jump N tx = change of test
detect_benchmarks_on="block_num"

#5~300 tx blocks for init in our considered_councase:
initialization_threshold=300

#benchmark ended if consecutive elements are equal.
#Delete all data between start of detected consecutive element and jump of detect_benchmark_threshold
#Using 2, stop detected when 2 consecutive elements are strictly equal
#Note: minimum=2, recommended=4
detect_benchmark_stop_elements=4
detect_benchmark_stop_elements_std=0.1 #use something low (<0.5)

#blocks jump of N detect_benchmarks_on (= change of test)
detect_benchmark_threshold=50

#fields (= csv filename) with their corresponding column name:
fields = {
    "sawtooth_validator.chain.ChainController.block_num": "block_num",
    "sawtooth_validator.chain.ChainController.committed_transactions_gauge": "commits",
    "sawtooth_validator.executor.TransactionExecutorThread.tp_process_response_count": "tx_exec_rate",
    "sawtooth_validator.publisher.BlockPublisher.pending_batch_gauge": "pending_tx",
    "sawtooth_validator.chain.ChainController.blocks_considered_count": "blocks_count",
    "sawtooth_validator.back_pressure_handlers.ClientBatchSubmitBackpressureHandler.backpressure_batches_rejected_gauge": "reject_rate",
    "sawtooth_rest_api.post_batches_count": "rest_api_batch_rate",
    "sawtooth_validator.interconnect.Interconnect.send_response_time": "msg_sent_rate",
    "sawtooth_validator.interconnect._SendReceive.received_message_count": "msg_receive_rate"
}

#%%
#
# Get all CSV files and put it inside dataframes
#
all_files = glob.glob(data_path + "/*.csv")
tmp_df = {}
for filename in all_files:
    df = pd.read_csv(filename, index_col=None, header=0, usecols=["time", "mean"],)
    field_name = os.path.basename(filename)[:-4]
    try:#test if field exists
        test=fields[field_name]
    except:
        print("Missing CSV file for field: {}".format(field_name))
        exit(1)

    tmp_df[fields[field_name]] = df
    #rename columns
    tmp_df[fields[field_name]].columns = ["time", fields[field_name]]
#%%
#
# Merge data into one table
#
final_df = tmp_df[detect_benchmarks_on] #init with commits
for field_key in tmp_df.keys():
    #skip first because already in final_df
    if field_key == detect_benchmarks_on:
        continue
    #merge tables
    #help, see https://pandas.pydata.org/docs/user_guide/merging.html#brief-primer-on-merge-methods-relational-algebra
    final_df = final_df.merge(tmp_df[field_key], on="time", how="left")

#fill NaN with previous value
final_df = final_df.fillna(method='ffill').fillna(0)
#%%
#
# Print available columns
#
print("Columns available are:")
final_df_cols=[] #contains the columns in the same order then final_df columns
for col in final_df.columns:
    print("{}, ".format(col), end='') #print the columns to know whats available
    final_df_cols.append(col)
print("")
#%%
#
# Filter out initialization of the test: only keep data where commits>1000
#
#thanks to https://stackoverflow.com/a/27360130/13187605
final_df = final_df.drop(final_df[(final_df[detect_benchmarks_on] >= 0) & (final_df[detect_benchmarks_on] < initialization_threshold)].index)
final_df = final_df.reset_index(drop=True)

#detect benchmark stop
col_detect_index=final_df_cols.index(detect_benchmarks_on)
#def remove_consecutive_elements(mydf):
start_at_index=-1
previous_elements=[] #previous value to compare to
previous=0 #previous value to compare to
for index, row in final_df.iterrows():
    if len(previous_elements) > detect_benchmark_stop_elements:
        previous_elements.pop(0)
    
    previous_elements.append(round(row[col_detect_index]))
    
    if index > detect_benchmark_stop_elements:
        #print("{} {} => {}".format(index,previous_elements,np.array(previous_elements).std()))
        if np.array(previous_elements).std() < detect_benchmark_stop_elements_std and start_at_index == -1:
            #found same consecutive elements !
            start_at_index=index
            
            
        if abs(row[col_detect_index] - (previous)) > detect_benchmark_threshold and start_at_index != -1:
            #found jump !
            final_df = final_df.drop(final_df.index[start_at_index:index])
            print("Detect benchmark stop from {} to {}".format(start_at_index,index))
            start_at_index = -1 #can start deleting delete again
            
    previous=row[col_detect_index]
    
final_df = final_df.reset_index(drop=True)
#%%
#
# Benchmark detection: use to distinguish multiple test in the dataframe
#
final_df["test#"]=1
#detect_benchmark_threshold if commits jump N tx = change of test (VERIFY ALLWAYS IF TESTS MATCH ACTUAL TESTS)
previous=0 #previous value to compare to
number_of_benchmarks=1 #this is will be the nb of tests at the end of the for loop
col_detect_index=final_df_cols.index(detect_benchmarks_on)
for index, row in final_df.iterrows():
    if index == 0:
        previous=row[col_detect_index]
        continue #init first value
    if abs(row[col_detect_index] - (previous)) > detect_benchmark_threshold:
        number_of_benchmarks = number_of_benchmarks + col_detect_index
    previous=row[col_detect_index]
    final_df.loc[index, "test#"] = number_of_benchmarks
print("Benchmark detected = {}".format(number_of_benchmarks))
#end benchmark detection

#%%
#
# Plot function
# (auto color and auto benchmark detection based on "test#" column)
#
#color map here:
cm_subsection = np.linspace(0.0, 1.0, number_of_benchmarks+1)
colors = [ cm.jet(x) for x in cm_subsection ]
#self inc on each myplot() call:
total_plots=0
#general plot fct to make it simple:
def myplot(plot_type, X_colomn_name, Y_colomn_name, title, smooth = False):
    global total_plots
    #help on legend placement here: https://stackoverflow.com/a/4701285/13187605
    pl.figure(total_plots)
    ax = pl.subplot(111)
    for i in range(1, number_of_benchmarks+1):
        #print lines for each test, using diff colors
        X_values=final_df.loc[final_df['test#'] == i].values[:,final_df_cols.index(X_colomn_name)]
        Y_values=final_df.loc[final_df['test#'] == i].values[:,final_df_cols.index(Y_colomn_name)]
        if smooth:
            Y_values= gaussian_filter1d(Y_values, sigma=1) # make more smooth: BE CARFUL
        if plot_type == "line":
            ax.plot(X_values,Y_values, color=colors[i], label="Test#{}".format(i))
        elif plot_type == "scatter":
            ax.scatter(X_values,Y_values, color=colors[i], label="Test#{}".format(i))
        elif plot_type == "bar":
            if len(X_values) == 0: #fix an value error create by "bar" if empty data
                X_values= [0]
                Y_values= [0]
            ax.bar(X_values, Y_values, color=colors[i], alpha=0.5, label="Test#{}".format(i))
            # pl.hist(Y_values, color=colors[i], label="Test#{} ({})".format(i, Y_colomn_name))
        else:
            print("ERROR: Unknown plot type: {}".format(plot_type))
            exit(1)
    pl.title(title)
    pl.xlabel(X_colomn_name)
    pl.ylabel(Y_colomn_name)
    box = ax.get_position()
    ax.set_position([box.x0, box.y0, box.width * 0.8, box.height])
    ax.legend(loc='center left', bbox_to_anchor=(1, 0.5))
    total_plots+=1


def myplot_merged(X_colomn_name, Y_colomn_name):
    global total_plots
    
    #Note: X_colomn_name should be time !!
    
    # info on axis selection: https://stackoverflow.com/a/46223968/13187605
    #Axis 1 will act on all the COLUMNS in each ROW
    
    #Some results of:
    #Variance: describes how much a random variable differs from its expected value. 
    #Standard deviation is the measure of dispersion of a set of data from its mean.
    
    merged_array = merge_data(X_colomn_name, Y_colomn_name).values
    merged_array_mean = merged_array.mean(axis=1)
    
    #show some data
    pl.figure(total_plots)
    total_plots+=1
    ax = pl.subplot(111)
    i=1
    for col_arr in merged_array.T:
        ax.plot(col_arr, label="Test {}".format(i))
        i+=1
    ax.plot(merged_array_mean, label="Mean of all tests")
    ax.plot([], [], ' ', label="Variance={:.2f} (Not ok)".format(merged_array.var(axis=0,ddof=1).mean()))
    ax.legend()
    pl.title("Tests with mean ({})".format(Y_colomn_name))
    ax.legend()

#%%
#
# Merge function of multiple signals
#

def merge_data(X_colomn_name, Y_colomn_name):
    tmp={}
    for i in range(1, number_of_benchmarks+1):
        Y_values=final_df.loc[final_df['test#'] == i].values[:,final_df_cols.index(Y_colomn_name)]
        tmp2= {}
        tmp2[i]=Y_values
        tmp[i]=pd.DataFrame(tmp2)
    #for help, see https://pandas.pydata.org/docs/user_guide/merging.html
    temp_elements = pd.concat(tmp, axis=1, join="outer")
    temp_elements = temp_elements.fillna(method='ffill')
    return temp_elements


#print(final_df)
# exit() #for debug
#%%
#
# Start plotting from here
#

#myplot("bar","rest_api_batch_rate", "tx_exec_rate", "Title")
#myplot("line", "time", "block_num", "commits in time")
#myplot_merged("time", "block_num")
myplot_merged("time", "commits")


pl.show()