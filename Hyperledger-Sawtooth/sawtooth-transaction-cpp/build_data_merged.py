#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
@author: luc
"""

import os
import sys
import pandas as pd
import numpy as np
import glob
import pylab as pl
from matplotlib import cm
from scipy.ndimage.filters import gaussian_filter1d
from datetime import datetime
pl.style.use('science')
#pl.style.use('ieee')

#%%
#global variables:
data_path = "./datas_csv/"
conf_figsize=(20, 10)
# conf_figsize=(6.4, 4.8)
merge_on="time"
filter_out_all_with_elements=["40tps", "17tps", "25tps"]
filter_out_reverse=False
#%%
#
# Get all CSV files and put it inside dataframes
#
all_files = glob.glob(data_path + "merged_*")
all_df = {}
for filename in all_files:
    df = pd.read_csv(filename, index_col=None, header=0)
    field_name = os.path.basename(filename)[:-4].replace("merged_","") #remove extension
    
    all_df[field_name] = df

print(all_df[next(iter(all_df))].columns.values)
#%%
#
# Merge data into one table
#

all_df_iter=iter(all_df)
tmp=False #next(all_df_iter)
#tmp2={}
for field_key in all_df_iter:
    #https://stackoverflow.com/a/53380374/13187605
    keep_same = {'time'}
    all_df[field_key].columns = ['{}{}'.format(c, '' if c in keep_same else '_' + field_key) for c in df.columns]
    if not tmp:
        final_df = all_df[field_key] #init with commits
        tmp=True
        continue
    #merge tables
    #help, see https://pandas.pydata.org/docs/user_guide/merging.html#brief-primer-on-merge-methods-relational-algebra
    final_df = pd.merge(final_df, all_df[field_key], left_index=True, right_index=True)

#reorder the dict for nice graphs
final_df = final_df.sort_index(axis = 1)


#%%

#Format for latex
def formatStrLatex(text):
    return text.replace('_', '\_')

def filter_out_all_with(text):
    for a in filter_out_all_with_elements:
        if a in text:
            return True if filter_out_reverse else False
    return False if filter_out_reverse else True
#%%

#not ("20tps|12_nodes" in col)

fig, axs = pl.subplots(2,2,figsize=conf_figsize)
show="commits_rate"
for col in final_df.columns:
    if show in col and filter_out_all_with(col):
        axs[0][0].plot(final_df[col].values, label=formatStrLatex("{}".format(col.replace(show+'_',''))))
#        print(final_df[col].shape)
axs[0][0].set_title(formatStrLatex("{}".format(show)))
axs[0][0].legend()


show="pending_tx_rate"
for col in final_df.columns:
    if show in col and filter_out_all_with(col):
        axs[1][0].plot(final_df[col].values, label=formatStrLatex("{}".format(col.replace(show+'_',''))))

#axs[1][0].set_yscale('log')
axs[1][0].set_title(formatStrLatex("{}".format(show)))
axs[1][0].legend()


show="tx_exec_rate"
for col in final_df.columns:
    if show in col and filter_out_all_with(col):
        axs[1][1].plot(final_df[col].values, label=formatStrLatex("{}".format(col.replace(show+'_',''))))
axs[1][1].set_title(formatStrLatex("{}".format(show)))
axs[1][1].legend()

show="reject_rate"
for col in final_df.columns:
    if show in col and filter_out_all_with(col):
        axs[0][1].plot(final_df[col].values, label=formatStrLatex("{}".format(col.replace(show+'_',''))))
axs[0][1].set_title(formatStrLatex("{}".format(show)))
axs[0][1].legend()



fig, axs = pl.subplots(2,2,figsize=conf_figsize)
show="rest_api_batch_rate"
for col in final_df.columns:
    if show in col and filter_out_all_with(col):
        axs[0][0].plot(final_df[col].values, label=formatStrLatex("{}".format(col.replace(show+'_',''))))
#        print(final_df[col].shape)
axs[0][0].set_title(formatStrLatex("{}".format(show)))
axs[0][0].legend()


show="block_num_rate"
for col in final_df.columns:
    if show in col and filter_out_all_with(col):
        axs[0][1].plot(final_df[col].values, label=formatStrLatex("{}".format(col.replace(show+'_',''))))

#axs[1][0].set_yscale('log')
axs[0][1].set_title(formatStrLatex("{}".format(show)))
axs[0][1].legend()

show="tx_in_process_rate"
for col in final_df.columns:
   if show in col and filter_out_all_with(col):
       axs[1][0].plot(final_df[col].values, label=formatStrLatex("{}".format(col.replace(show+'_',''))))
axs[1][0].set_title(formatStrLatex("{}".format(show)))
axs[1][0].legend()


#show="msg_receive_rate"
#for col in final_df.columns:
#    if show in col and filter_out_all_with(col):
#        axs[3][1].plot(final_df[col].values, label=formatStrLatex("{}".format(col.replace(show+'_',''))))
#axs[3][1].set_title(formatStrLatex("{}".format(show)))
#axs[3][1].legend()


#individual plot
#fig, axs = pl.subplots(1,1,figsize=conf_figsize)
#show="msg_"
#for col in final_df.columns:
#    if show in col and filter_out_all_with(col):
#        axs.plot(final_df[col].values, label=formatStrLatex("{}".format(col.replace(show+'_',''))))
#axs.set_title(formatStrLatex("{}".format(show)))
#axs.legend()


pl.show()