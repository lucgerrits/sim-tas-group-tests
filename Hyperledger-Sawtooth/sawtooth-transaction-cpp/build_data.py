#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
@author: luc
"""

import os
import pandas as pd
import numpy as np
import sys
import glob
import pylab as pl
import re 
from pathlib import Path 

data_path = "./datas"
fields = [
    # "sawtooth_validator.chain.ChainController.block_num", 
    "sawtooth_validator.chain.ChainController.committed_transactions_gauge",
    "sawtooth_validator.executor.TransactionExecutorThread.tp_process_response_count"]

final_data_frame = {}

#%%

#https://stackoverflow.com/a/62941534/13187605
file_pattern = re.compile(r'.*?(\d+).*?')
def get_order(file):
    match = file_pattern.match(Path(file).name)
    if not match:
        return math.inf
    return int(match.groups()[0])


for field in fields:
    filename = data_path + "/" + field + ".csv"
    df = pd.read_csv(filename, index_col=None, header=0, usecols=["time", "mean"],)
    final_data_frame[field] = df
    print("Field {} shape: {}".format(field, df.shape))


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
df1 = final_data_frame["sawtooth_validator.chain.ChainController.committed_transactions_gauge"]
df2 = final_data_frame["sawtooth_validator.executor.TransactionExecutorThread.tp_process_response_count"]
df1.columns = ["time", "commits"]
df2.columns = ["time", "tx_exec_rate"]

print(df1)
print(df2)

df = df1.merge(df2, on="time", how="left")
# df = df1.join(df2, how="outer") #fonctionne pas
# df = pd.concat([df1, df2]).fillna(0) #fonctionne pas

print(df)

X_values = df.values[:,1]

Y_values = df.values[:,2]

#%%
pl.figure(1)
pl.scatter(X_values,Y_values, label="Block vs commits")
pl.title("commits vs tx rate")
pl.xlabel("commits")
pl.ylabel("tx rate")
pl.legend()


pl.show()