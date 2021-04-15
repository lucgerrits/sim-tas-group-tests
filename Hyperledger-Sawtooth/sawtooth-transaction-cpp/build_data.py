#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
@author: luc
"""

# import os
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

data_path = "./datas"
fields = [
    # "sawtooth_validator.chain.ChainController.block_num", 
    "sawtooth_validator.chain.ChainController.committed_transactions_gauge",
    "sawtooth_validator.executor.TransactionExecutorThread.tp_process_response_count",
    "sawtooth_validator.publisher.BlockPublisher.pending_batch_gauge"]

final_data_frame = {}

#%%

#https://stackoverflow.com/a/62941534/13187605
file_pattern = re.compile(r'.*?(\d+).*?')
def get_order(file):
    match = file_pattern.match(Path(file).name)
    if not match:
        return math.inf
    return int(match.groups()[0])

#get all CSV files and put it inside dataframes
for field in fields:
    filename = data_path + "/" + field + ".csv"
    df = pd.read_csv(filename, index_col=None, header=0, usecols=["time", "mean"],)
    final_data_frame[field] = df
    print("Field {} shape: {}".format(field, df.shape))

    #useless code from before:
    # current_field_path = data_path + "/" + field
    # #combine all csv files of one field:
    # all_files = glob.glob(current_field_path + "/*.csv")
    # li = []
    # for filename in sorted(all_files, key=get_order):
    #     try:
    #         df = pd.read_csv(filename, index_col=None, header=0)
    #         li.append(df)
    #     except:
    #         print("ERROR file: {}".format(filename))
    # final_data_frame[field] = pd.concat(li, axis=0, ignore_index=True)
    # # final_data_frame.to_csv( field + ".csv", index=False, encoding='utf-8')
    # print("Field {} shape: {}".format(field, final_data_frame[field].shape))

#%%

#define vars to simply life
df1 = final_data_frame["sawtooth_validator.chain.ChainController.committed_transactions_gauge"]
df2 = final_data_frame["sawtooth_validator.executor.TransactionExecutorThread.tp_process_response_count"]
df3 = final_data_frame["sawtooth_validator.publisher.BlockPublisher.pending_batch_gauge"]
#change the columns name to distinguish data type
df1.columns = ["time", "commits"]
df2.columns = ["time", "tx_exec_rate"]
df3.columns = ["time", "pending_tx"]

#merge the dataframes
df = df1.merge(df2, on="time", how="left").merge(df3, on="time", how="left").fillna(method='ffill')
# df = df1.join(df2, how="outer") #fonctionne pas
# df = pd.concat([df1, df2]).fillna(0) #fonctionne pas

# add benchmark detection: use to distinguish multiple test in the dataframe
df["test#"]=0

threshold=3000 #if commits jump N tx = change of test (VERIFY ALLWAYS IF TESTS MATCH ACTUAL TESTS)
previous=0 #previous value to compare to
current_test_index=0 #this is will be the nb of tests at the end of the for loop
for index, row in df.iterrows():
    if abs(row[1] - previous) > threshold:
        current_test_index = current_test_index +1
        df.loc[index, "test#"] = current_test_index
    else:
        df.loc[index, "test#"] = current_test_index
    previous = row[1]

print(df)

# exit()
#######################################################
#Start plotting from here


#X values for the graphs
Test_values = df.values[:,4]
total_plots=0 #self inc on each myplot() call
#%%

#color map here:
cm_subsection = np.linspace(0.0, 1.0, current_test_index+1) 
colors = [ cm.jet(x) for x in cm_subsection ]

#general plot fct to make it simple
def myplot(X_colomn_index, Y_colomn_index, title, xlabel, ylabel, smooth = False):
    global total_plots
    pl.figure(total_plots)
    for i in range(0, current_test_index+1):
        #print lines for each test, using diff colors
        X_values=df.loc[df['test#'] == i].values[:,X_colomn_index]
        Y_values=df.loc[df['test#'] == i].values[:,Y_colomn_index]
        if smooth:
            Y_values= gaussian_filter1d(Y_values, sigma=1) # make more smooth: BE CARFUL
        pl.plot(X_values,Y_values, color=colors[i], label="Test#{}".format(i))
    pl.title(title)
    pl.xlabel(xlabel)
    pl.ylabel(ylabel)
    pl.legend()
    total_plots = total_plots+1

myplot(1, 2, "commits vs tx rate", "commits", "tx rate", True)
# pl.figure(0)
# for i in range(0, current_test_index+1):
#     #print lines for each test, using diff colors
#     X_values=df.loc[df['test#'] == i].values[:,1]
#     Y_values=df.loc[df['test#'] == i].values[:,2]
#     Y_values= gaussian_filter1d(Y_values, sigma=1) # make more smooth: BE CARFUL
#     pl.plot(X_values,Y_values, color=colors[i], label="Test#{}".format(i))
# pl.title("commits vs tx rate")
# pl.xlabel("commits")
# pl.ylabel("tx rate")
# pl.legend()

#%%




X_values = df.values[:,1]
Y_values = df.values[:,0]
myplot(0, 1, "commits in time", "time", "commits")
# pl.figure(1)
# pl.plot(X_values,Y_values, c=Test_values, label="Block vs commits")
# pl.title("commits vs tx rate")
# pl.xlabel("commits")
# pl.ylabel("tx rate")
# pl.legend()

# #%%

# X_values = df.values[:,1]
# Y_values = df.values[:,3]
# pl.figure(2)
# pl.scatter(X_values,Y_values, c=Test_values, label="Block vs commits")
# pl.title("commits vs pending tx")
# pl.xlabel("commits")
# pl.ylabel("pending tx")
# pl.legend()


pl.show()
