#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
@author: luc
"""

import os
import pandas as pd
import numpy as np
# import sys
import glob
import pylab as pl
import re 
from pathlib import Path 
from matplotlib import cm
from scipy.interpolate import make_interp_spline, BSpline
from scipy.ndimage.filters import gaussian_filter1d

#%%
#global variables:
data_path = "./datas"
final_df = None
detect_benchmarks_on="commits"
fields = { #fields (= csv filename) with their corresponding column name
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
        print("Missing CSV file for field: {}".format(field_key))
        exit()

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
    final_df = final_df.merge(tmp_df[field_key], on="time", how="left")

#fill NaN with previous value
final_df = final_df.fillna(method='ffill')
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
# Benchmark detection: use to distinguish multiple test in the dataframe
#
final_df["test#"]=0
threshold=3000 #if commits jump N tx = change of test (VERIFY ALLWAYS IF TESTS MATCH ACTUAL TESTS)
previous=0 #previous value to compare to
current_test_index=0 #this is will be the nb of tests at the end of the for loop
col_detect_index=final_df_cols.index(detect_benchmarks_on)
print(col_detect_index)
for index, row in final_df.iterrows():
    if abs(row[col_detect_index] - previous) > threshold:
        current_test_index = current_test_index +col_detect_index
        final_df.loc[index, "test#"] = current_test_index
    else:
        final_df.loc[index, "test#"] = current_test_index
    previous = row[col_detect_index]
#end benchmark detection

#%%
#
# Plot function
# (auto color and auto benchmark detection based on "test#" column)
#
#color map here:
cm_subsection = np.linspace(0.0, 1.0, current_test_index+1) 
colors = [ cm.jet(x) for x in cm_subsection ]
#self inc on each myplot() call:
total_plots=0 
#general plot fct to make it simple:
def myplot(X_colomn_name, Y_colomn_name, title, xlabel, ylabel, smooth = False):
    global total_plots
    #help on legend placement here: https://stackoverflow.com/a/4701285/13187605
    fig = pl.figure(total_plots)
    ax = pl.subplot(111)
    #temp_tests_list = np.array([])
    for i in range(0, current_test_index+1):
        #print lines for each test, using diff colors
        X_values=final_df.loc[final_df['test#'] == i].values[:,final_df_cols.index(X_colomn_name)]
        Y_values=final_df.loc[final_df['test#'] == i].values[:,final_df_cols.index(Y_colomn_name)]
        #np.append(temp_tests_list, Y_values)
        if smooth:
            Y_values= gaussian_filter1d(Y_values, sigma=1) # make more smooth: BE CARFUL
        pl.plot(X_values,Y_values, color=colors[i], label="Test#{}".format(i))
    pl.title(title)
    pl.xlabel(xlabel)
    pl.ylabel(ylabel)
    #print(temp_tests_list)
    #print("{} => variance={}".format(title, np.var(temp_tests_list)))
    box = ax.get_position()
    ax.set_position([box.x0, box.y0, box.width * 0.8, box.height])
    ax.legend(loc='center left', bbox_to_anchor=(1, 0.5))
    total_plots = total_plots+1

print(final_df)
# exit() #for debug
#%%
#
# Start plotting from here
#

# myplot(1, 2, "commits vs tx rate", "commits", "tx rate", True)
# myplot(0, 1, "commits in time", "time", "commits")
# myplot(1, 3, "commits vs pending tx", "commits", "pending tx")
# myplot(1, 4, "commits vs blocks count", "commits", "blocks count")
# myplot(1, 5, "commits vs reject rate", "commits", "reject rate")
# myplot(1, 6, "commits vs rest-api batch rate", "commits", "rest-api batch rate")
# myplot(1, 7, "commits vs msg sent rate", "commits", "msg sent rate")
# myplot(1, 8, "commits vs msg receive rate", "commits", "msg receive rate")

myplot("commits", "tx_exec_rate", "Title", "x", "y", True)


pl.show()